--[[------------------------------------------------------------------------------------------------
	Firehack.lua

	RotAgent (Rotation Agent) License
	This work is licensed under the Creative Commons Attribution-NonCommercial 4.0 International
	License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc/4.0/.

	------------------------------------------------------------------------------------------------
	ProbablyEngine Rotations
	Released under modified BSD, see attached LICENSE.

	Functions that require FireHack
	------------------------------------------------------------------------------------------------

	This file is an override of the core Probably Engine file firehack.lua
--]]------------------------------------------------------------------------------------------------

local L = ProbablyEngine.locale.get

function ProbablyEngine.protected.FireHack()

	if FireHack then

		ProbablyEngine.faceroll.rolling = false
		ProbablyEngine.pmethod = "FireHack"

		local stickyValue = GetCVar("deselectOnClick")

		--[[
		local SpecialEnemyTargets = {
			-- TRAINING DUMMIES
			[31144] = "31144",		-- Training Dummy - Lvl 80
			[31146] = "31146",		-- Raider's Training Dummy - Lvl ??
			[32541] = "32541",		-- Initiate's Training Dummy - Lvl 55 (Scarlet Enclave)
			[32542] = "32542",		-- Disciple's Training Dummy - Lvl 65
			[32545] = "32545",		-- Initiate's Training Dummy - Lvl 55
			[32546] = "32546",		-- Ebon Knight's Training Dummy - Lvl 80
			[32666] = "32666",		-- Training Dummy - Lvl 60
			[32667] = "32667",		-- Training Dummy - Lvl 70
			[46647] = "46647",		-- Training Dummy - Lvl 85
			[60197] = "60197",		-- Scarlet Monastery Dummy
			[67127] = "67127",		-- Training Dummy - Lvl 90
			[87318] = "87318",		-- Dungeoneer's Training Dummy <Damage> ALLIANCE GARRISON
			[87761] = "87761",		-- Dungeoneer's Training Dummy <Damage> HORDE GARRISON
			[87322] = "87322",		-- Dungeoneer's Training Dummy <Tanking> ALLIANCE ASHRAN BASE
			[88314] = "88314",		-- Dungeoneer's Training Dummy <Tanking> ALLIANCE GARRISON
			[88836] = "88836",		-- Dungeoneer's Training Dummy <Tanking> HORDE ASHRAN BASE
			[88288] = "88288",		-- Dunteoneer's Training Dummy <Tanking> HORDE GARRISON
			-- WOD DUNGEONS/RAIDS
			[75966] = "75966",		-- Defiled Spirit (Shadowmoon Burial Grounds)
			[76220] = "76220",		-- Blazing Trickster (Auchindoun Normal)
			[76267] = "76267",		-- Solar Zealot (Skyreach)
			[76518] = "76518",		-- Ritual of Bones (Shadowmoon Burial Grounds)
			[77252] = "77252",		-- Ore Crate (BRF Oregorger)
			[77665] = "77665",		-- Iron Bomber (BRF Blackhand)
			[79504] = "79504",		-- Ore Crate (BRF Oregorger)
			[79511] = "79511",		-- Blazing Trickster (Auchindoun Heroic)
			[81638] = "81638",		-- Aqueous Globule (The Everbloom)
			[86644] = "86644",		-- Ore Crate (BRF Oregorger)
			[153792] = "153792",	-- Rallying Banner (UBRS Black Iron Grunt)
		}

		-- THANK YOU TO MIRAKURU!
		local function SpecialTargetCheck(unit)
			local unit = unit
			local _,_,_,_,_,unit_id,_ = strsplit("-",UnitGUID(unit))

			if not UnitExists(unit) then
				return false
			end
			if SpecialEnemyTargets[tonumber(unit_id)] ~= nil then
				return true
			end
			return false
		end
		]]

		function IterateObjects(callback, ...)
			local totalObjects = ObjectCount()
			for i = 1, totalObjects do
				local object = ObjectWithIndex(i)
				local _, oType = pcall(ObjectType, object)
				if bit.band(oType, ...) > 0 then
					callback(object)
				end
			end
		end

		function ObjectFromUnitID(unit)
			local unitGUID = UnitGUID(unit)
			local totalObjects = ObjectCount()
			for i = 1, totalObjects do
				local object = ObjectWithIndex(i)
				if UnitExists(object) and UnitGUID(object) == unitGUID then
					return object
				end
			end
			return false
		end

		function Distance(a, b)
			if UnitExists(a) and UnitIsVisible(a) and UnitExists(b) and UnitIsVisible(b) then
				local _, ax, ay, az = pcall(ObjectPosition, a)
				local _, bx, by, bz = pcall(ObjectPosition, b)
				return math.sqrt(((bx-ax)^2) + ((by-ay)^2) + ((bz-az)^2)) - ((UnitCombatReach(a)) + (UnitCombatReach(b)))
			end
			return 0
		end

		local uau_cache_time = { }
		local uau_cache_count = { }
		local uau_cache_dura = 0.1
		function UnitsAroundUnit(unit, distance, ignoreCombat)
			local uau_cache_time_c = uau_cache_time[unit..distance..tostring(ignoreCombat)]
			if uau_cache_time_c and ((uau_cache_time_c + uau_cache_dura) > GetTime()) then
				return uau_cache_count[unit..distance..tostring(ignoreCombat)]
			end
			if UnitExists(unit) then
				local total = 0
				local totalObjects = ObjectCount()
				for i = 1, totalObjects do
					local object = ObjectWithIndex(i)
					local _, oType = pcall(ObjectType, object)
					if bit.band(oType, ObjectTypes.Unit) > 0 then
						local _, reaction = pcall(UnitReaction, "player", object)
						local _, combat = pcall(UnitAffectingCombat, object)
						local _, special_enemy_target = pcall(SpecialEnemyTargetsCheck, object)
						local _, special_aura_target = pcall(SpecialAurasCheck, object)
						if reaction and reaction <= 4 and not special_aura_target and (ignoreCombat or combat or special_enemy_target) then
							if Distance(object, unit) <= distance then
								total = total + 1
							end
						end
					end
				end
				uau_cache_count[unit..distance..tostring(ignoreCombat)] = total
				uau_cache_time[unit..distance..tostring(ignoreCombat)] = GetTime()
				DEBUG(1, "Total Enemies ("..total..")")
				return total
			else
				DEBUG(1, "Total Enemies (0)")
				return 0
			end
		end

		function FriendlyUnitsAroundUnit(unit, distance, ignoreCombat)
			local uau_cache_time_c = uau_cache_time[unit..distance..tostring(ignoreCombat)..'f']
			if uau_cache_time_c and ((uau_cache_time_c + uau_cache_dura) > GetTime()) then
				return uau_cache_count[unit..distance..tostring(ignoreCombat)..'f']
			end
			if UnitExists(unit) then
				local total = 0
				local totalObjects = ObjectCount()
				for i = 1, totalObjects do
					local object = ObjectWithIndex(i)
					local _, oType = pcall(ObjectType, object)
					if bit.band(oType, ObjectTypes.Unit) > 0 then
						local reaction = UnitReaction("player", object)
						local combat = UnitAffectingCombat(object)
						if reaction and reaction >= 5 and (ignoreCombat or combat) then
							if Distance(object, unit) <= distance then
								total = total + 1
							end
						end
					end
				end
				uau_cache_count[unit..distance..tostring(ignoreCombat)..'f'] = total
				uau_cache_time[unit..distance..tostring(ignoreCombat)..'f'] = GetTime()
				return total
			else
				return 0
			end
		end

		function FaceUnit(unit)
			if UnitExists(unit) and UnitIsVisible(unit) then
				local _, ax, ay, az = pcall(ObjectPosition, 'player')
				local _, bx, by, bz = pcall(ObjectPosition, unit)
				local angle = rad(atan2(by - ay, bx - ax))
				if angle < 0 then
					return FaceDirection(rad(atan2(by - ay, bx - ax) + 360))
				else
					return FaceDirection(angle)
				end
			end
		end

		local losFlags =  bit.bor(0x10, 0x100)
		function LineOfSight(a, b)
			local _, ax, ay, az = pcall(ObjectPosition, a)
			local _, bx, by, bz = pcall(ObjectPosition, b)
			if TraceLine(ax, ay, az+2.25, bx, by, bz+2.25, losFlags) then
				return false
			end
			return true
		end

		--[[
		function UnitInfront(unit)
			local aX, aY, aZ = ObjectPosition(unit)
			local bX, bY, bZ = ObjectPosition('player')
			local playerFacing = GetPlayerFacing()
			local facing = math.atan2(bY - aY, bX - aX) % 6.2831853071796
			return math.abs( math.abs(playerFacing - facing) - 180 ) < 1.5707963267949
		end
		]]

		function UnitInfront(unit1, unit2)
			if not (UnitExists(unit1) and UnitExists(unit2)) then return end
			local _, x1, y1, _ = pcall(ObjectPosition, unit1)
			local _, x2, y2, _ = pcall(ObjectPosition, unit2)
			local facing = ObjectFacing(unit1)
			local angle = atan2(y1 - y2, x1 - x2) - deg(facing)
			if angle < 0 then
				angle = angle + 360
			end
			return (angle > 120 and angle < 240)
		end

		function CastGround(spell, target)
			if UnitExists(target) then
				local _, x1, y1, z1 = pcall(ObjectPosition, target)
				CastSpellByName(spell)
				CastAtPosition(x1, y1, z1)
				CancelPendingSpell()
				return
			end
			if not ProbablyEngine.timeout.check('groundCast') then
				ProbablyEngine.timeout.set('groundCast', 0.05, function()
					Cast(spell)
					if IsAoEPending() then
						SetCVar("deselectOnClick", "0")
						CameraOrSelectOrMoveStart(1)
						CameraOrSelectOrMoveStop(1)
						SetCVar("deselectOnClick", "1")
						SetCVar("deselectOnClick", stickyValue)
						CancelPendingSpell()
					end
				end)
			end
		end

		function Macro(text)
			return RunMacroText(text)
		end

		function UseItem(name, target)
			return UseItemByName(name, target)
		end

		function UseInvItem(slot)
				return UseInventoryItem(slot)
			end

		function Cast(spell, target)
			if type(spell) == "number" then
				CastSpellByID(spell, target)
			else
				CastSpellByName(spell, target)
			end
		end

		ProbablyEngine.protected.unlocked = true
		ProbablyEngine.protected.method = "firehack"
		ProbablyEngine.timer.unregister('detectUnlock')
		ProbablyEngine.print(L('unlock_firehack'))

	end

end