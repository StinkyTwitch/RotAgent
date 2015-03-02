--[[------------------------------------------------------------------------------------------------
	HelperNotifications.lua

	RotAgent (Rotation Agent) License
	This work is licensed under the Creative Commons Attribution-NonCommercial 4.0 International
	License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc/4.0/.

--------------------------------------------------------------------------------------------------]]
local RotAgentName, RotAgent = ...
local RotAgentDraw = LibStub("LibDraw-1.0")
RotAgent.visualNotifications = false

function RotAgent.VisualNotificationsToggle()
	RotAgent.visualNotifications = not RotAgent.visualNotifications
	if RotAgent.visualNotifications then
		print("Visual Notifications ON!")
	else
		print("Visual Notifications OFF!")
	end
end




--[[------------------------------------------------------------------------------------------------
RotAgentDraw SYNC
--------------------------------------------------------------------------------------------------]]
RotAgentDraw.Sync(function()
	if FireHack and RotAgent.visualNotifications then
		if ProbablyEngine.module.player.combat then
			if ProbablyEngine.module.player.specID == 253
			or ProbablyEngine.module.player.specID == 254
			or ProbablyEngine.module.player.specID == 255
			then
				for i=1, #RotAgent.unitCacheCombat do
					local serpentStung = UnitDebuff(RotAgent.unitCacheCombat[i].object, "Serpent Sting")
					local unitExists = UnitExists(RotAgent.unitCacheCombat[i].object)
					local dead = UnitIsDead("target")

					if not serpentStung and unitExists and not dead then
						RotAgentDraw.SetColor(255, 0, 0, 255)
						RotAgentDraw.SetWidth(1)

						local targetX, targetY, targetZ = ObjectPosition(RotAgent.unitCacheCombat[i].object)
						local combatReach = UnitCombatReach(RotAgent.unitCacheCombat[i].object)

						RotAgentDraw.Circle(targetX, targetY, targetZ, combatReach)
					end
				end
			end

			if RotAgent.drawParsedTarget ~= nil then
				RotAgentDraw.SetColor(0, 255, 0, 255)
				RotAgentDraw.SetWidth(1)
				local unitExists = UnitExists(RotAgent.drawParsedTarget)
				local playerX, playerY, playerZ = ObjectPosition("player")
				local targetX, targetY, targetZ = ObjectPosition(RotAgent.drawParsedTarget)
				local combatReach = UnitCombatReach(RotAgent.drawParsedTarget)

				if unitExists then
					RotAgentDraw.Circle(targetX, targetY, targetZ, combatReach-0.25)
					RotAgentDraw.Line(playerX, playerY, playerZ, targetX, targetY, targetZ)
					C_Timer.After(1, function() RotAgent.drawParsedTarget = nil end)
				end
			end
		end
	end
end)