--[[------------------------------------------------------------------------------------------------
	UnitCacheManager.lua

	RotAgent (Rotation Agent) License
	This work is licensed under the Creative Commons Attribution-NonCommercial 4.0 International
	License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc/4.0/.

--------------------------------------------------------------------------------------------------]]
local RotAgentName, RotAgent = ...
RotAgent.cacheAlgorithm = "lowest"
RotAgent.lowestUnit = nil
RotAgent.lowestUnitHealth = nil
RotAgent.highestUnit = nil
RotAgent.highestUnitHealth = nil
RotAgent.nearestUnit = nil
RotAgent.nearestUnitDistance = nil
RotAgent.unitCacheAll = { }
RotAgent.unitCacheCombat = { }

local tableShedAll = { }  -- Create a table that will store unused table memory addresses
local tableShedCombat = { }  -- Create a table that will store unused table memory addresses

local function clearCacheAll()
	--[[--------------------------------------------------------------------------------------------
	When clearCache is called we start off by begining to loop through the current unitCacheAll table.
	Each table in the table gets removed and put in the tableAddressShed. This is to done to reuse
	table memory addresses rather than sending them to garbage collection. As we remove from tables
	from unitCacheAll it by definition gets cleared.
	--------------------------------------------------------------------------------------------]]--
	for i = #RotAgent.unitCacheAll, 1, -1 do
		tinsert(tableShedAll, tremove(RotAgent.unitCacheAll))
	end
end

local function clearCacheCombat()
	--[[--------------------------------------------------------------------------------------------
	clearCacheCombat is used to clear out our Combat Units only table, while reusing the memory
	addresses.
	--------------------------------------------------------------------------------------------]]--
	for i = #RotAgent.unitCacheCombat, 1, -1 do
		tinsert(tableShedCombat, tremove(RotAgent.unitCacheCombat))
	end
end

local function getTableAll()
	--[[--------------------------------------------------------------------------------------------
	When getTable is called we start off grabbing a table address from our talbeAddressShed.
	If we able to get a 'used' table from the shed we send the table off to whoever needed it.
	If we were unable to get a 'used' table we create a new one. Insert it into the unit cache
	table and return it to whoever needed it.
	--------------------------------------------------------------------------------------------]]--
	local t = tremove(tableShedAll)
	if t ~= nil then
		tinsert(RotAgent.unitCacheAll, t)
		return t
	else
		t = { }
		tinsert(RotAgent.unitCacheAll, t)
		return t
	end
end

local function getTableCombat()
	--[[--------------------------------------------------------------------------------------------
	getTableCombat is used for our Combat Only cache building.
	--------------------------------------------------------------------------------------------]]--
	local t = tremove(tableShedCombat)
	if t ~= nil then
		tinsert(RotAgent.unitCacheCombat, t)
		return t
	else
		t = { }
		tinsert(RotAgent.unitCacheCombat, t)
		return t
	end
end

function RotAgent.UnitCacheManager(range)
	--[[--------------------------------------------------------------------------------------------
	1. Each time UnitCacheManager is called we clear the current unitCacheAll table. See above for what
	we do inside of clearCache. Its nifty. It reuses table addresses instead of sending them off to
	garbage collection.
	2. Next check that FireHack is running and that we are in combat. If we are then get the current
	object count from FireHack.
	3. Begin to loop through the Object Table. For each index in the table set the pointer to be our
	'object'. Our first pcall is used here to determine the existance of the object. Without the
	pcall this can and has crashed WoW.
	4. If the object exists then get its Type.
	5. Take the object's type and perform a bitwise AND operation on it with value for ObjectType
	Unit. If the result is greater than 0 then this object is a Unit. Get the distance from the
	'player' to the object.
	6. If the object is less than 40 yards away then get the objects health in hitpoints.
	7. If the objects health is greater than 0 (not dead) get the objects max health and calculate
	its health percentage at this point in time. Get the object's name. Get the reaction of the
	object to the player.
	8. If the reaction of the object is 4 or lower (neutral, unfriendly, hostile or hated) then
	check if it's a Special Enemy target, check if it's a Special Aura (cc) target, check if it the
	object is tapped by the player or if the player is on the objects Tapped By All Threat List
	(basically faction type tagged mobs, i.e. World Bosses, Rares).
	9. If the object isn't a Special Aura target and is either tapped by the player or tapped by all
	on its threat list or is a Special Enemy target we can drop into the actual inserting of the
	object into the unit cache table.
	10. First we grab a table from the table Shed with getTable. If there aren't any tables that
	we can reuse we create a new table. Then set the indexes for object, name, health and distance
	for this object into the unit cache.
	11. Depending on our sorting algorithm, lowest or nearest, we sort the table.
	Start a new loop or end it if we have no more objects.
	--------------------------------------------------------------------------------------------]]--
	-- 1
	clearCacheAll()
	clearCacheCombat()

	-- 2
	if FireHack and ProbablyEngine.module.player.combat then
		local totalObjects = ObjectCount()

		-- 3
		for i=1, totalObjects do
			local object = ObjectWithIndex(i)
			local _, objectExists = pcall(ObjectExists, object)

			-- 4
			if objectExists then
				local _, objectType = pcall(ObjectType, object)

				-- 5
				if bit.band(objectType, ObjectTypes.Unit) > 0 then
					local objectDistance = RotAgent.Distance("player", object, 2, "reach")

					-- 6
					if objectDistance <= range then
						local objectHealth = UnitHealth(object)

						-- 7
						if objectHealth > 0 then
							local objectHealthMax = UnitHealthMax(object)
							local objectHealthPercentage = math.floor((objectHealth / objectHealthMax) * 100)
							local objectName = UnitName(object)
							local reaction = UnitReaction("player", object)

							-- 8
							if reaction and reaction <= 4 then
								local specialEnemyTarget = RotAgent.SpecialEnemyTargetsCheck(object)
								local specialAuraTarget = RotAgent.SpecialAurasCheck(object)
								local tappedByPlayer = UnitIsTappedByPlayer(object)
								local tappedByAllThreatList = UnitIsTappedByAllThreatList(object)

								local tAll = getTableAll()
								tAll.object = object

								-- 9
								if not specialAuraTarget and (tappedByPlayer or tappedByAllThreatList or specialEnemyTarget) then
									-- 10
									local tCombat = getTableCombat()
									tCombat.object = object
									tCombat.name = objectName
									tCombat.health = objectHealthPercentage
									tCombat.distance = objectDistance

									-- 11
									if RotAgent.cacheAlgorithm == "lowest" then
										if RotAgent.lowestUnitHealth == nil then
											RotAgent.lowestUnitHealth = objectHealth
											RotAgent.lowestUnit = object
										elseif  objectHealth < RotAgent.lowestUnitHealth then
											RotAgent.lowestUnitHealth = objectHealth
											RotAgent.lowestUnit = object
										end
									elseif RotAgent.cacheAlgorithm == "highest" then
										if RotAgent.highestUnitHealth == nil then
											RotAgent.highestUnitHealth = objectHealth
											RotAgent.highestUnit = object
										elseif  objectHealth < RotAgent.highestUnitHealth then
											RotAgent.highestUnitHealth = objectHealth
											RotAgent.highestUnit = object
										end
									elseif RotAgent.cacheAlgorithm == "nearest" then
										if RotAgent.nearestUnitDistance == nil then
											RotAgent.nearestUnitDistance = objectDistance
											RotAgent.nearestUnit = object
										elseif  objectDistance < RotAgent.nearestUnitDistance then
											RotAgent.nearestUnitDistance = objectDistance
											RotAgent.nearestUnit = object
										end

									end
								end
							end
						end
					end
				end
			end
		end

	end
	-- Offspring
	-- oLua
	-- Caelus
	-- Generic
end


--[[------------------------------------------------------------------------------------------------
How to use:

Loop through the combat unit cache.

for i=1, #RotAgent.unitCacheCombat do
	if RotAgent.unitCacheCombat[i].health > 0 then
		print("Unit is alive!")
	end
end
------------------------------------------------------------------------------------------------]]--