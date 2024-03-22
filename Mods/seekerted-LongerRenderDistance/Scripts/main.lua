local Utils = require("utils")
local UEHelpers = require("UEHelpers")

Utils.Init("seekerted", "LongerRenderDistance", "1.0.0")

local RENDER_DISTANCE_ENEMY = 20000

-- Enemies now show up much farther
NotifyOnNewObject("/Script/MadeInAbyss.MIAEnemyBase", function(New_MIAEnemyBase)
	New_MIAEnemyBase.UseSignificance = true
	New_MIAEnemyBase.SignificanceDistance = RENDER_DISTANCE_ENEMY
	New_MIAEnemyBase.AttentionPoint = RENDER_DISTANCE_ENEMY
end)

-- Function to simplify executing Unreal commands to the PIE ConsoleCommand
local function ConsoleCommand(Command)
	UEHelpers:GetKismetSystemLibrary():ExecuteConsoleCommand(UEHelpers:GetWorldContextObject(), Command,
			UEHelpers:GetPlayerController())
end

-- You can technically just paste these into Engine.ini but these are for convenience
Utils.RegisterEasyUnregisterHook("/Script/Engine.PlayerController:ClientRestart", function(Unregister)
	-- I am actually unsure of my descriptions of these commands, these are my best guesses

	-- Increase the distance as where foliage starts getting rendered, to prevent it just popping on your face
	ConsoleCommand("foliage.LODDistanceScale 10")

	-- The scale of the distance as to when LOD starts appearing. Set to 0 so it just appears immediately
	ConsoleCommand("r.StaticMeshLODDistanceScale 0")

	-- Increase the scale so that far away shadows are still rendered
	ConsoleCommand("r.Shadow.DistanceScale 5")

	Utils.Log("Applied graphics changes")

	Unregister()
end)