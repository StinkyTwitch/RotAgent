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
				--print(a,b)
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
						local _, tapped_by_me = pcall(UnitIsTappedByPlayer, object)
						local _, tapped_by_all = pcall(UnitIsTappedByAllThreatList, object)
						if reaction and reaction <= 4 and not special_aura_target
							and (ignoreCombat or tapped_by_me or tapped_by_all or special_enemy_target)
						then
							if Distance(object, unit) <= distance then
								total = total + 1
							end
						end
					end
				end
				uau_cache_count[unit..distance..tostring(ignoreCombat)] = total
				uau_cache_time[unit..distance..tostring(ignoreCombat)] = GetTime()
				DEBUG(2, "Total Enemies ("..total..")")
				return total
			else
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
			if string.sub(target, 0, 2) == "0x" then
				target = tostring(target)
			end
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