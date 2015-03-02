--[[------------------------------------------------------------------------------------------------
	Firehack.lua (FireHack PE Override)

	RotAgent (Rotation Agent) License
	This work is licensed under the Creative Commons Attribution-NonCommercial 4.0 International
	License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc/4.0/.

--------------------------------------------------------------------------------------------------]]
local RotAgentName, RotAgent = ...
RotAgent.uauCacheSize = 0

function RotAgent.Distance(a, b, precision, reach)
	RotAgent.Debug(2, "RotAgent.Distance("..tostring(a)..", "..tostring(b)..", "..tostring(precision)..", "..tostring(reach)..")")
	if UnitExists(a) and UnitIsVisible(a) and UnitExists(b) and UnitIsVisible(b) then
		local ax, ay, az = ObjectPosition(a)
		local bx, by, bz = ObjectPosition(b)

		if precision then
			if reach then
				local value = math.sqrt(((bx-ax)^2) + ((by-ay)^2) + ((bz-az)^2)) - ((UnitCombatReach(a)) + (UnitCombatReach(b)))
				RotAgent.Debug(2, "precision/reach("..tostring(a)..", "..tostring(b)..", "..tostring(precision)..", "..tostring(reach)..")")
				return math.floor( (value * 10^precision) + 0.5) / (10^precision)
			else
				local value = math.sqrt(((bx-ax)^2) + ((by-ay)^2) + ((bz-az)^2))
				RotAgent.Debug(2, "precision/noreach("..tostring(a)..", "..tostring(b)..", "..tostring(precision)..", "..tostring(reach)..")")
				return math.floor( (value * 10^precision) + 0.5) / (10^precision)
			end
		else
			if reach then
				RotAgent.Debug(2, "noprecision/reach("..tostring(a)..", "..tostring(b)..", "..tostring(precision)..", "..tostring(reach)..")")
				return math.sqrt(((bx-ax)^2) + ((by-ay)^2) + ((bz-az)^2)) - ((UnitCombatReach(a)) + (UnitCombatReach(b)))
			else
				RotAgent.Debug(2, "noprecision/noreach("..tostring(a)..", "..tostring(b)..", "..tostring(precision)..", "..tostring(reach)..")")
				return math.sqrt(((bx-ax)^2) + ((by-ay)^2) + ((bz-az)^2))
			end
		end
	end
	return 0
end


local uauCacheTime = { }
local uauCacheCount = { }
local uauCacheDuration = 0.1
function RotAgent.UnitsAroundUnit(unit, distance, ignoreCombat)
	local uauCacheTime_C = uauCacheTime[unit..distance..tostring(ignoreCombat)]
	if uauCacheTime_C and ((uauCacheTime_C + uauCacheDuration) > GetTime()) then
		return uauCacheCount[unit..distance..tostring(ignoreCombat)]
	end
	if UnitExists(unit) then
		local total = 0
		for i=1, #RotAgent.unitCacheCombat do
			local unitDistance = RotAgent.Distance(RotAgent.unitCacheCombat[i].object, unit)
			--RotAgent.Debug(1, "Distance "..RotAgent.unitCacheCombat[i].name.." to "..unit.." is "..unitDistance)
			if unitDistance <= distance then
				total = total + 1
			end
		end
		uauCacheCount[unit..distance..tostring(ignoreCombat)] = total
		uauCacheTime[unit..distance..tostring(ignoreCombat)] = GetTime()
		RotAgent.uauCacheSize = total
		return total
	else
		RotAgent.uauCacheSize = 0
		return 0
	end
end

--[[
RotAgent.LineofSight =
{ '', (function()
	-- We only want to override this once.
	if not firstRun then
		if FireHack then
			LineOfSight = nil
			function LineOfSight(a, b)
				-- Ignore Line of Sight on these units with very weird combat.
				local ignoreLOS = {
					[76585] = true,		-- Ragewing the Untamed (UBRS)
					[77063] = true,		-- Ragewing the Untamed (UBRS)
					[77182] = true,		-- Oregorger (BRF)
					[77891] = true,		-- Grasping Earth (BRF)
					[77893] = true,		-- Grasping Earth (BRF)
					[78981] = true,		-- Iron Gunnery Sergeant (BRF)
					[81318] = true,		-- Iron Gunnery Sergeant (BRF)
					[83745] = true,		-- Ragewing Whelp (UBRS)
					[86252] = true,		-- Ragewing the Untamed (UBRS)
				}
				local losFlags =  bit.bor(0x10, 0x100)
				local ax, ay, az = ObjectPosition(a)
				local bx, by, bz = ObjectPosition(b)

				-- Variables
				local aCheck = select(6,strsplit('-',UnitGUID(a)))
				local bCheck = select(6,strsplit('-',UnitGUID(b)))

				if ignoreLOS[tonumber(aCheck)] ~= nil then return true end
				if ignoreLOS[tonumber(bCheck)] ~= nil then return true end
				if TraceLine(ax, ay, az+2.25, bx, by, bz+2.25, losFlags) then return false end
				return true
			end
		end
		-- Only load once
		if not not ProbablyEngine.protected.unlocked then firstRun = true end
	end
end)},
]]