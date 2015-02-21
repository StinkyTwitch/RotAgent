--[[------------------------------------------------------------------------------------------------
	Draw.lua

	Rotation Agent (Probably_RotAgent) License
	This work is licensed under the Creative Commons Attribution-NonCommercial 4.0 International
	License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc/4.0/.
--]]------------------------------------------------------------------------------------------------
local addonName = ...
local addonVersion = GetAddOnMetadata(addonName, "Version")
local ToggleVisualHelpers = false
local LibDraw = LibStub("LibDraw-1.0")

function ToggleVisualHelpers()
	ToggleVisualHelpers = not ToggleVisualHelpers
end




--[[------------------------------------------------------------------------------------------------
LIBDRAW SYNC
--------------------------------------------------------------------------------------------------]]
LibDraw.Sync(function()
	if FireHack and ToggleVisualHelpers then
		if ProbablyEngine.module.player.combat then
			if ProbablyEngine.module.player.specID == 253
				or ProbablyEngine.module.player.specID == 254
				or ProbablyEngine.module.player.specID == 255
			then
				for index=1, #CACHEUNITSTABLE do
					local _, serpent_stung = pcall(UnitDebuff, CACHEUNITSTABLE[index].key, "Serpent Sting")
					local _, unit_exists = pcall(UnitExists, CACHEUNITSTABLE[index].key)
					local dead = UnitIsDead("target")

					if not serpent_stung and unit_exists and not dead then
						LibDraw.SetColor(255, 0, 0, 255)
						LibDraw.SetWidth(1)

						local targetX, targetY, targetZ = ObjectPosition(CACHEUNITSTABLE[index].key)
						local _, combat_reach = pcall(UnitCombatReach,CACHEUNITSTABLE[index].key)

						LibDraw.Circle(targetX, targetY, targetZ, combat_reach)
					end
				end
			end

			if LIBDRAWPARSEDTARGET ~= nil then
				LibDraw.SetColor(0, 255, 0, 255)
				LibDraw.SetWidth(1)
				local _, unit_exists = pcall(UnitExists, LIBDRAWPARSEDTARGET)
				local playerX, playerY, playerZ = ObjectPosition("player")
				local _, targetX, targetY, targetZ = pcall(ObjectPosition, LIBDRAWPARSEDTARGET)
				local _, combat_reach = pcall(UnitCombatReach, LIBDRAWPARSEDTARGET)

				if unit_exists then
					LibDraw.Circle(targetX, targetY, targetZ, combat_reach)
					LibDraw.Line(playerX, playerY, playerZ, targetX, targetY, targetZ)
					C_Timer.After(1, function() LIBDRAWPARSEDTARGET = nil end)
				end
			end
		end
	end
end)