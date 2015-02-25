--[[------------------------------------------------------------------------------------------------
	Draw.lua

	Rotation Agent (Probably_RotAgent) License
	This work is licensed under the Creative Commons Attribution-NonCommercial 4.0 International
	License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc/4.0/.
--]]------------------------------------------------------------------------------------------------
local addonName = ...
local addonVersion = GetAddOnMetadata(addonName, "Version")
local visualnotifications = false
local LibDraw = LibStub("LibDraw-1.0")

function VisualNotificationsToggle()
	visualnotifications = not visualnotifications
	if visualnotifications then
		print("Visual Notifications ON!")
	else
		print("Visual Notifications OFF!")
	end
end




--[[------------------------------------------------------------------------------------------------
LIBDRAW SYNC
--------------------------------------------------------------------------------------------------]]
LibDraw.Sync(function()
	if FireHack and visualnotifications then
		if ProbablyEngine.module.player.combat then
			if ProbablyEngine.module.player.specID == 253
			or ProbablyEngine.module.player.specID == 254
			or ProbablyEngine.module.player.specID == 255
			then
				for i=1, #CACHEUNITSTABLE do
					local serpent_stung = UnitDebuff(CACHEUNITSTABLE[i].object, "Serpent Sting")
					local unit_exists = UnitExists(CACHEUNITSTABLE[i].object)
					local dead = UnitIsDead("target")

					if not serpent_stung and unit_exists and not dead then
						LibDraw.SetColor(255, 0, 0, 255)
						LibDraw.SetWidth(1)

						local targetX, targetY, targetZ = ObjectPosition(CACHEUNITSTABLE[i].object)
						local combat_reach = UnitCombatReach(CACHEUNITSTABLE[i].object)

						LibDraw.Circle(targetX, targetY, targetZ, combat_reach)
					end
				end
			end

			if LIBDRAWPARSEDTARGET ~= nil then
				LibDraw.SetColor(0, 255, 0, 255)
				LibDraw.SetWidth(1)
				local unit_exists = UnitExists(LIBDRAWPARSEDTARGET)
				local playerX, playerY, playerZ = ObjectPosition("player")
				local targetX, targetY, targetZ = ObjectPosition(LIBDRAWPARSEDTARGET)
				local combat_reach = UnitCombatReach(LIBDRAWPARSEDTARGET)

				if unit_exists then
					LibDraw.Circle(targetX, targetY, targetZ, combat_reach)
					LibDraw.Line(playerX, playerY, playerZ, targetX, targetY, targetZ)
					C_Timer.After(1, function() LIBDRAWPARSEDTARGET = nil end)
				end
			end
		end
	end
end)