--[[------------------------------------------------------------------------------------------------
	PE.lua (PE Overrides/Extensions)

	RotAgent (Rotation Agent) License
	This work is licensed under the Creative Commons Attribution-NonCommercial 4.0 International
	License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc/4.0/.

--------------------------------------------------------------------------------------------------]]
local RotAgentName, RotAgent = ...
RotAgent.drawParsedTarget = nil

ProbablyEngine.condition.register("cc", function(target)
	--[[--------------------------------------------------------------------------------------------
	UnitExists is a sanity check.
	If the unit exists then check if it has a Special Aura (cc). If it does we return true,
	otherwise return false.
	--------------------------------------------------------------------------------------------]]--
	if not UnitExists(target) then
		return false
	else
		if RotAgent.SpecialAurasCheck(target) then
			--RotAgent.Debug(5, ""..target..".cc found a special aura.")
			return true
		else
			--RotAgent.Debug(5, ""..target..".cc did not find a special aura.")
			return false
		end
	end
end)

ProbablyEngine.condition.register("ccinarea", function(target, radius)
	--[[--------------------------------------------------------------------------------------------
	If not using FireHack return false.
	Verify unit exists.
	If unit exists then get the 'targets' GUID.
	Loop through the unit cache table. This is the table that includes all units not just the ones
	we are in combat with. CC'd units do not get put into the combat unit cache.
	For each entry in the unit cache get the GUID.
	If the units GUID and the target's GUID do not match then we can get the distance between
	the target and the unit. We also then check if the unit is cc'd.
	If the distance between our 'target' and the current unit we are checking is less than the
	splash damage radius and the unit is cc'd we can return true.
	Otherwise if after going through the table we did not find any cc'd units within the splash
	damage radius return false, there is no cc in the area.
	--------------------------------------------------------------------------------------------]]--
	if FireHack then
		if not UnitExists(target) then
			return false
		end

		local targetGUID = UnitGUID(target)

		for i=1, #RotAgent.unitCache do
			local unitGUIDString = UnitGUID(RotAgent.unitCache[i].object)
			local _,_,_,_,_,unitGUID,_ = strsplit("-",unitGUIDString)

			if unitGUID ~= targetGUID then
				local splashRadius = tonumber(radius)
				local distance = RotAgent.Distance(target, RotAgent.unitCache[i].object)
				local ccdUnit = RotAgent.SpecialAurasCheck(RotAgent.unitCache[i].object)
				if distance <= splashRadius and ccdUnit then
					--RotAgent.Debug(5, "ccinarea "..distance..", "..RotAgent.unitCache[i].object.."("..tostring(ccdUnit)..")")
					return true
				end
			end
		end
		--RotAgent.Debug(5, ""..target..".ccinarea did not find a cc unit in splash range.")
		return false
	else
		-- If not using Firehack then .ccinarea(radius) is always false
		--RotAgent.Debug(5, "Not using FH. ccinarea defaulting to false.")
		return false
	end
end)

ProbablyEngine.condition.register("cluster", function(target, radius)
	if ProbablyEngine.module.player.casting == true then
		return false
	end

	local radius = tonumber(radius)
	local clusterTarget = nil
	local largestCluster = 0
	local unitsInCluster = 0

	for i=1, #RotAgent.unitCacheCombat do
		local distance = RotAgent.Distance("player", RotAgent.unitCacheCombat[i].object, 2, "reach")
		if distance <= 40 then
			local unitsInCluster = 0

			for j=1, #RotAgent.unitCacheCombat do
				local clusterDistance = RotAgent.Distance(RotAgent.unitCacheCombat[i].object, RotAgent.unitCacheCombat[j].object, 2, "reach")

				if clusterDistance <= radius then
					unitsInCluster = unitsInCluster + 1
				end
			end
			if unitsInCluster >= largestCluster then
				largestCluster = unitsInCluster
				clusterTarget = i
			end
		end
	end
	if clusterTarget ~= nil then
		RotAgent.drawParsedTarget = RotAgent.unitCacheCombat[clusterTarget].object
		if target == "ground" then
			ProbablyEngine.dsl.parsedTarget = RotAgent.unitCacheCombat[clusterTarget].object..".ground"
			return true
		else
			ProbablyEngine.dsl.parsedTarget = RotAgent.unitCacheCombat[clusterTarget].object
			return true
		end
	else
		return false
	end
end)

ProbablyEngine.condition.register("distancetotarget", function(target)
	if not UnitExists(target) or not UnitExists("target") then
		return false
	end

	local isAttackable = UnitCanAttack(target, "target")
	local isDead = UnitIsDead("target")

	if isAttackable and not isDead then
		if FireHack then
			return RotAgent.Distance(target, "target", 2, "reach")
		else
			return 0
		end
	else
		return 0
	end
end)

ProbablyEngine.condition.register("focus.deficit", function(target)
	return UnitPowerMax(target) - UnitPower(target)
end)

ProbablyEngine.condition.register("gcd", function(target)
	local gcd = (1.5/GetHaste(target))
	if gcd < 1 then
		return 1
	else
		return gcd
	end
end)

ProbablyEngine.condition.register("proc", function(target, stat)
	local stat = string.lower(stat)

	if stat == "strength" then
		if UnitStat("player", 1) > RotAgent.baseStatsTable.strength then
			--RotAgent.Debug(5, "strength proc found!")
			return true
		else
			return false
		end
	end
	if stat == "agility" then
		if UnitStat("player", 2) > RotAgent.baseStatsTable.agility then
			--RotAgent.Debug(1, "agility proc found!")
			return true
		else
			return false
		end
	end
	if stat == "stamina" then
		if UnitStat("player", 3) > RotAgent.baseStatsTable.stamina then
			--RotAgent.Debug(5, "stamina proc found!")
			return true
		else
			return false
		end
	end
	if stat == "intellect" then
		if UnitStat("player", 4) > RotAgent.baseStatsTable.intellect then
			--RotAgent.Debug(5, "intellect proc found!")
			return true
		else
			return false
		end
	end
	if stat == "spirit" then
		if UnitStat("player", 5) > RotAgent.baseStatsTable.spirit then
			--RotAgent.Debug(5, "spirit proc found!")
			return true
		else
			return false
		end
	end
	if stat == "crit" then
		if GetCritChance() > RotAgent.baseStatsTable.crit then
			--RotAgent.Debug(5, "crit proc found!")
			return true
		else
			return false
		end
	end
	if stat == "haste" then
		if GetHaste() > RotAgent.baseStatsTable.haste then
			--RotAgent.Debug(5, "haste proc found!")
			return true
		else
			return false
		end
	end
	if stat == "mastery" then
		if GetMastery() > RotAgent.baseStatsTable.mastery then
			--RotAgent.Debug(5, "mastery proc found!")
			return true
		else
			return false
		end
	end
	if stat == "multistrike" then
		if GetMultistrike() > RotAgent.baseStatsTable.multistrike then
			--RotAgent.Debug(1, "multistrike proc found!")
			return true
		else
			return false
		end
	end
	if stat == "versatility" then
		if GetCombatRating(29) > RotAgent.baseStatsTable.versatility then
			--RotAgent.Debug(5, "versatility proc found!")
			return true
		else
			return false
		end
	end

end)

ProbablyEngine.condition.register("proc.any", function(target)
	if UnitStat("player", 1) > RotAgent.baseStatsTable.strength then
		--RotAgent.Debug(5, "any proc found strength proc!")
		return true
	elseif UnitStat("player", 2) > RotAgent.baseStatsTable.agility then
		--RotAgent.Debug(5, "any proc found agility proc!")
		return true
	elseif UnitStat("player", 3) > RotAgent.baseStatsTable.stamina then
		--RotAgent.Debug(5, "any proc found stamina proc!")
		return true
	elseif UnitStat("player", 4) > RotAgent.baseStatsTable.intellect then
		--RotAgent.Debug(5, "any proc found intellect proc!")
		return true
	elseif UnitStat("player", 5) > RotAgent.baseStatsTable.spirit then
		--RotAgent.Debug(5, "any proc found spirit proc!")
		return true
	elseif GetCritChance() > RotAgent.baseStatsTable.crit then
		--RotAgent.Debug(5, "any proc found crit proc!")
		return true
	elseif GetHaste() > RotAgent.baseStatsTable.haste then
		--RotAgent.Debug(5, "any proc found haste proc!")
		return true
	elseif GetMastery() > RotAgent.baseStatsTable.mastery then
		--RotAgent.Debug(5, "any proc found mastery proc!")
		return true
	elseif GetMultistrike() > RotAgent.baseStatsTable.multistrike then
		--RotAgent.Debug(5, "any proc found multistrike proc!")
		return true
	elseif GetCombatRating(29) > RotAgent.baseStatsTable.versatility then
		--RotAgent.Debug(5, "any proc found versatility proc!")
		return true
	else
		return false
	end
end)

ProbablyEngine.condition.register("energy.regen", function(target)
	return select(2, GetPowerRegen(target))
end)
ProbablyEngine.condition.register("focus.regen", function(target)
	return select(2, GetPowerRegen(target))
end)
ProbablyEngine.condition.register("mana.regen", function(target)
	return select(2, GetPowerRegen(target))
end)

ProbablyEngine.condition.register("spell.regen", function(target, spell)
	local name, rank, icon, cast_time, min_range, max_range = GetSpellInfo(spell)
	if cast_time == 0 then
		cast_time = 1
	end
	local cur_regen = select(2, GetPowerRegen(target))
	local cast_time_in_seconds = cast_time / 1000.0

	return cast_time_in_seconds * cur_regen
end)

ProbablyEngine.condition.register("rotagentarea.enemies", function(target, distance)
    if RotAgent.UnitsAroundUnit then
        local total = RotAgent.UnitsAroundUnit(target, tonumber(distance))
        return total
    end
    return 0
end)