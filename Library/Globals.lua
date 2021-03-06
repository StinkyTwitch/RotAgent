--[[------------------------------------------------------------------------------------------------
	Probably_RotAgent.lua

	RotAgent (Rotation Agent) License
	This work is licensed under the Creative Commons Attribution-NonCommercial 4.0 International
	License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc/4.0/.
--]]------------------------------------------------------------------------------------------------
local addonName = ...
local addonVersion = GetAddOnMetadata(addonName, "Version")
local deathTrack = { }




--[[------------------------------------------------------------------------------------------------
GLOBAL TABLES/VARIABLES
--------------------------------------------------------------------------------------------------]]
RotAgent = { }
AUTOTARGETALGORITHM = "lowest"
CACHEUNITSALGORITHM = "lowest"
CACHEUNITSTABLE = {}
CURRENTTARGETINFOTABLE = {}
PRIMARYBASESTATS = {}
SECONDARYBASESTATS = {}
DEBUGLOGLEVEL = 1
DEBUGTOGGLE = true
LIBDRAWPARSEDTARGET = nil

SpecialAuras = {
	-- CROWD CONTROL
	[118]       = "118",        -- Polymorph
	[1513]      = "1513",       -- Scare Beast
	[1776]      = "1776",       -- Gouge
	[2637]      = "2637",       -- Hibernate
	[3355]      = "3355",       -- Freezing Trap
	[6770]      = "6770",       -- Sap
	[9484]      = "9484",       -- Shackle Undead
	[19386]     = "19386",      -- Wyvern Sting
	[20066]     = "20066",      -- Repentance
	[28271]     = "28271",      -- Polymorph (turtle)
	[28272]     = "28272",      -- Polymorph (pig)
	[49203]     = "49203",      -- Hungering Cold
	[51514]     = "51514",      -- Hex
	[61025]     = "61025",      -- Polymorph (serpent) -- FIXME: gone ?
	[61305]     = "61305",      -- Polymorph (black cat)
	[61721]     = "61721",      -- Polymorph (rabbit)
	[61780]     = "61780",      -- Polymorph (turkey)
	[76780]     = "76780",      -- Bind Elemental
	[82676]     = "82676",      -- Ring of Frost
	[90337]     = "90337",      -- Bad Manner (Monkey) -- FIXME: to check
	[115078]    = "115078",     -- Paralysis
	[115268]    = "115268",     -- Mesmerize
	-- MOP DUNGEONS/RAIDS/ELITES
	[106062]    = "106062",     -- Water Bubble (Wise Mari)
	[110945]    = "110945",     -- Charging Soul (Gu Cloudstrike)
	[116994]    = "116994",     -- Unstable Energy (Elegon)
	[122540]    = "122540",     -- Amber Carapace (Amber Monstrosity - Heat of Fear)
	[123250]    = "123250",     -- Protect (Lei Shi)
	[143574]    = "143574",     -- Swelling Corruption (Immerseus)
	[143593]    = "143593",     -- Defensive Stance (General Nazgrim)
	-- WOD DUNGEONS/RAIDS/ELITES
}

SpecialEnemyTargets = {
	-- TRAINING DUMMIES
	[31144]     = "31144",      -- Training Dummy - Lvl 80
	[31146]     = "31146",      -- Raider's Training Dummy - Lvl ??
	[32541]     = "32541",      -- Initiate's Training Dummy - Lvl 55 (Scarlet Enclave)
	[32542]     = "32542",      -- Disciple's Training Dummy - Lvl 65
	[32545]     = "32545",      -- Initiate's Training Dummy - Lvl 55
	[32546]     = "32546",      -- Ebon Knight's Training Dummy - Lvl 80
	[32666]     = "32666",      -- Training Dummy - Lvl 60
	[32667]     = "32667",      -- Training Dummy - Lvl 70
	[46647]     = "46647",      -- Training Dummy - Lvl 85
	[60197]     = "60197",      -- Scarlet Monastery Dummy
	[67127]     = "67127",      -- Training Dummy - Lvl 90
	[87318]     = "87318",      -- Dungeoneer's Training Dummy <Damage> ALLIANCE GARRISON
	[87761]     = "87761",      -- Dungeoneer's Training Dummy <Damage> HORDE GARRISON
	[87322]     = "87322",      -- Dungeoneer's Training Dummy <Tanking> ALLIANCE ASHRAN BASE
	[88314]     = "88314",      -- Dungeoneer's Training Dummy <Tanking> ALLIANCE GARRISON
	[88836]     = "88836",      -- Dungeoneer's Training Dummy <Tanking> HORDE ASHRAN BASE
	[88288]     = "88288",      -- Dunteoneer's Training Dummy <Tanking> HORDE GARRISON
	-- WOD DUNGEONS/RAIDS
	[75966]     = "75966",      -- Defiled Spirit (Shadowmoon Burial Grounds)
	[76220]     = "76220",      -- Blazing Trickster (Auchindoun Normal)
	[76267]     = "76267",      -- Solar Zealot (Skyreach)
	[76518]     = "76518",      -- Ritual of Bones (Shadowmoon Burial Grounds)
	[77252]     = "77252",      -- Ore Crate (BRF Oregorger)
	[77665]     = "77665",      -- Iron Bomber (BRF Blackhand)
	[77891]     = "77891",      -- Grasping Earth (BRF Kromog)
	[77893]     = "77893",      -- Grasping Earth (BRF Kromog)
	[79504]     = "79504",      -- Ore Crate (BRF Oregorger)
	[79511]     = "79511",      -- Blazing Trickster (Auchindoun Heroic)
	[81638]     = "81638",      -- Aqueous Globule (The Everbloom)
	[86644]     = "86644",      -- Ore Crate (BRF Oregorger)
	[153792]    = "153792",     -- Rallying Banner (UBRS Black Iron Grunt)
}

SpecialHealingTargets = {
	-- TRAINING DUMMIES
	[88289]     = "88289",      -- Training Dummy <Healing> HORDE GARRISON
	[88316]     = "88316",      -- Training Dummy <Healing> ALLIANCE GARRISON
	-- WOD DUNGEONS/RAIDS
	[78868]     = "78868",      -- Rejuvinating Mushroom (HM Brackenspore)
	[78884]     = "78884",      -- Living Mushroom (HM Brackenspore)
}















--[[------------------------------------------------------------------------------------------------
PE EXTENDED
--------------------------------------------------------------------------------------------------]]
ProbablyEngine.condition.register("cc", function(target)
	if not UnitExists(target) then
		return false
	else
		if SpecialAurasCheck(target) then
			return true
		else
			return false
		end
	end
end)

ProbablyEngine.condition.register("ccinarea", function(target, spell)
	if FireHack then
		if not UnitExists(target) then
			return false
		end
		local splash_radius = tonumber(spell)
		local target = target
		local total_objects = ObjectCount()
		for i=1, total_objects do
			local object = ObjectWithIndex(i)
			local _, object_exists = pcall(ObjectExists, object)
			if object_exists then
				local _, object_type = pcall(ObjectType, object)
				local bitband = bit.band(object_type, ObjectTypes.Unit)
				local target_guid = UnitGUID(target)
				local object_guid_string = UnitGUID(object)
				local _,_,_,_,_,object_guid,_ = strsplit("-",object_guid_string)
				if bitband > 0 then
					if object_guid ~= target_guid then
						local distance = GetDistance(target, object)
						local ccd_unit = SpecialAurasCheck(object)
						if distance <= splash_radius and ccd_unit then
							return true
						end
					end
				end
			end
		end
		return false
	elseif oexecute then
		if not UnitExists(target) then
			return false
		end
		local splash_radius = tonumber(spell)
		local target = target
		local total_objects = ObjectsCount("player", 40)
		for i=1, total_objects do
			local object = ObjectByIndex(i)
			local object_exists = UnitExists(object)
			if object_exists then
				local _, object_type = pcall(ObjectDescriptorInt, object, 0x20)
				local bitband = bit.band(object_type, 0x8)
				local target_guid = UnitGUID(target)
				local object_guid_string = UnitGUID(object)
				local _,_,_,_,_,object_guid,_ = strsplit("-", object_guid_string)
				if bitband > 0 then
					if object_guid ~= target_guid then
						local distance = GetDistance(target, object)
						local ccd_unit = SpecialAurasCheck(object)
						if distance <= splash_radius and ccd_unit then
							return true
						end
					end
				end
			end
		end
		return false
	else
		return true
	end
end)

ProbablyEngine.condition.register("distancetotarget", function(target)
	if not UnitExists("target") or not UnitExists(target) then
		return false
	end

	local attackable = UnitCanAttack(target, "target")
	local dead = UnitIsDead("target")

	if attackable and not dead then
		if FireHack then
			local _, x1, y1, z1 = pcall(ObjectPosition, target)
			local x2, y2, z2 = ObjectPosition("target")
			local dx = x2 - x1
			local dy = y2 - y1
			local dz = z2 - z1
			return math.sqrt((dx*dx) + (dy*dy) + (dz*dz))
		elseif oexecute then
			local _, x1, y1, z1, _ = pcall(UnitPosition, target)
			local x2, y2, z2, _ = UnitPosition("target")
			local dx = x2 - x1
			local dy = y2 - y1
			local dz = z2 - z1
			return math.sqrt((dx*dx) + (dy*dy) + (dz*dz))
		else
			return 0
		end
	else
		return 0
	end
end)

ProbablyEngine.condition.register("focus.deficit", function(target)
	local max_power = UnitPowerMax(target)
	local cur_power = UnitPower(target)
	return max_power - cur_power
end)

ProbablyEngine.condition.register("item.cooldown", function(target, item_id)
	local item_id = tonumber(item_id)
	local start, duration, enable = GetItemCooldown(item_id)
	if not start then
		return false
	end
	if start ~= 0 then
		return (start + duration - GetTime())
	end
	return 0
end)

ProbablyEngine.condition.register("anystats.proc", function(target, spell)
	-- Check Primary Stats
	for i=1, 5 do
		local stat = UnitStat("player", i)
		if stat > PRIMARYBASESTATS[i] then
			return true
		end
	end
	-- Check Secondary Stats
	local crit = GetCritChance()
	local haste = GetHaste()
	local mastery = GetMastery()
	local multistrike = GetMultistrike()
	local versatility = GetCombatRating(29)

	if crit > SECONDARYSTATSTABLE[1] then
		return true
	end
	if haste > SECONDARYSTATSTABLE[2] then
		return true
	end
	if mastery > SECONDARYSTATSTABLE[3] then
		return true
	end
	if multistrike > SECONDARYSTATSTABLE[4] then
		return true
	end
	if versatility > SECONDARYSTATSTABLE[5] then
		return true
	end

	return false
end)

ProbablyEngine.condition.register("strength.proc", function(target, spell)
	local stat = UnitStat("player", 1)

	if stat > PRIMARYBASESTATS[1] then
		return true
	else
		return false
	end
end)

ProbablyEngine.condition.register("agility.proc", function(target, spell)
	local stat = UnitStat("player", 2)

	if stat > PRIMARYBASESTATS[2] then
		return true
	else
		return false
	end
end)

ProbablyEngine.condition.register("stamina.proc", function(target, spell)
	local stat = UnitStat("player", 3)

	if stat > PRIMARYBASESTATS[3] then
		return true
	else
		return false
	end
end)

ProbablyEngine.condition.register("intellect.proc", function(target, spell)
	local stat = UnitStat("player", 4)

	if stat > PRIMARYBASESTATS[4] then
		return true
	else
		return false
	end
end)

ProbablyEngine.condition.register("spirit.proc", function(target, spell)
	local stat = UnitStat("player", 5)

	if stat > PRIMARYBASESTATS[5] then
		return true
	else
		return false
	end
end)

ProbablyEngine.condition.register("crit.proc", function(target, spell)
	local crit = GetCritChance()

	if crit > SECONDARYBASESTATS[1] then
		return true
	else
		return false
	end
end)

ProbablyEngine.condition.register("haste.proc", function(target, spell)
	local haste = GetHaste()

	if haste > SECONDARYBASESTATS[2] then
		return true
	else
		return false
	end
end)

ProbablyEngine.condition.register("mastery.proc", function(target, spell)
	local mastery = GetMastery()

	if mastery > SECONDARYBASESTATS[3] then
		return true
	else
		return false
	end
end)

ProbablyEngine.condition.register("multistrike.proc", function(target, spell)
	local multistrike = GetMultistrike()

	if multistrike > SECONDARYBASESTATS[4] then
		return true
	else
		return false
	end
end)

ProbablyEngine.condition.register("versatility.proc", function(target, spell)
	local versatility = GetCombatRating(29)

	if versatility > SECONDARYBASESTATS[5] then
		return true
	else
		return false
	end
end)

ProbablyEngine.condition.register("power.regen", function(target)
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

ProbablyEngine.condition.register("gcd", function(target)
	local gcd = (1.5/GetHaste(target))
	if gcd < 1 then
		return 1
	else
		return gcd
	end
end)

ProbablyEngine.condition.register("cluster", function(target, radius)
	local ground = target
	local radius = tonumber(radius)
	local cluster_target = nil
	local largest_cluster = 0
	local units_in_cluster = 0

	if ProbablyEngine.module.player.casting == true then
		return false
	end
	for i=1, #CACHEUNITSTABLE do
		local distance = GetDistance("player", CACHEUNITSTABLE[i].object)

		if distance <= 40 then
			local units_in_cluster = 0

			for j=1, #CACHEUNITSTABLE do
				local cluster_distance = GetDistance(CACHEUNITSTABLE[i].object, CACHEUNITSTABLE[j].object)

				if cluster_distance <= radius then
					units_in_cluster = units_in_cluster + 1
				end
			end
			if units_in_cluster >= largest_cluster then
				largest_cluster = units_in_cluster
				cluster_target = i
			end
		end
	end
	if cluster_target ~= nil then
		LIBDRAWPARSEDTARGET = CACHEUNITSTABLE[cluster_target].object
		if ground == "ground" then
			ProbablyEngine.dsl.parsedTarget = CACHEUNITSTABLE[cluster_target].object..".ground"
			return true
		else
			ProbablyEngine.dsl.parsedTarget = CACHEUNITSTABLE[cluster_target].object
			return true
		end
	end
	return false

end)















--[[------------------------------------------------------------------------------------------------
GLOBAL FUNCTIONS
--------------------------------------------------------------------------------------------------]]
function AutoTargetEnemy()
	if UnitExists("target") and not UnitIsDeadOrGhost("target") then
		return false
	end

	if AUTOTARGETALGORITHM == "lowest" or AUTOTARGETALGORITHM == "nearest" then
		for i=1, #CACHEUNITSTABLE do
			local object_exists = UnitExists(CACHEUNITSTABLE[i].object)
			local object_attackable = UnitCanAttack("player", CACHEUNITSTABLE[i].object)

			if object_exists then
				if not TargetIsImmuneCheck(5, CACHEUNITSTABLE[i].object) then
					if TargetIsInFrontCheck(5, CACHEUNITSTABLE[i].object) then
						if object_attackable then
							return TargetUnit(CACHEUNITSTABLE[i].object)
						end
					end
				end
			end
		end
	else
		for i=1, #CACHEUNITSTABLE do
			if GetRaidTargetIndex(CACHEUNITSTABLE[i].object) == 8 then
				return TargetUnit(CACHEUNITSTABLE[i].object)
			end
		end
		if UnitExists("focustarget") then
			return TargetUnit("focustarget")
		else
			for i=1, #CACHEUNITSTABLE do
				local object_exists = UnitExists(CACHEUNITSTABLE[i].object)

				if object_exists then
					if not TargetIsImmuneCheck(5, CACHEUNITSTABLE[i].object) then
						if TargetIsInFrontCheck(5, CACHEUNITSTABLE[i].object) then
							if UnitCanAttack("player", CACHEUNITSTABLE[i].object) then
								return TargetUnit(CACHEUNITSTABLE[i].object)
							end
						end
					end
				end
			end
		end
	end
	return false
end

function CacheUnitsTableShow()
	local DiesalGUI = LibStub("DiesalGUI-1.0")
	local explore = DiesalGUI:Create('TableExplorer')
	explore:SetTable("Cache Units Table", CACHEUNITSTABLE)
	explore:BuildTree()
end

function CurrentTargetTableInfo(target)
	local target = target
	if not UnitExists(target) then
		for k in pairs(CURRENTTARGETINFOTABLE) do
			CURRENTTARGETINFOTABLE[k] = nil
		end
	end

	if FireHack then
		local total_objects = ObjectCount()

		for i=1, total_objects do
			local object = ObjectWithIndex(i)
			local _, object_exists = pcall(ObjectExists,object)

			if object_exists then
				local _, object_type = pcall(ObjectType, object)
				local bitband = bit.band(object_type, ObjectTypes.Unit)
				local _,_,_,_,_,object_guid,_ = strsplit("-",UnitGUID(object))
				if bitband > 0 then
					if object_guid == target then
						target = object
					end
				end
			end
		end
	elseif oexecute then
		local total_objects = ObjectsCount("player", 40)

		for i=1, total_objects do
			local object = ObjectByIndex(i)
			local object_exists = UnitExists(object)

			if object_exists then
				local _, object_type = pcall(ObjectDescriptorInt, object, 0x20)
				local bitband = bit.band(object_type, 0x8)
				local target_guid = UnitGUID(target)
				local object_guid_string = UnitGUID(object)
				local _,_,_,_,_,object_guid,_ = strsplit("-", object_guid_string)

				if bitband > 0 then

					if target_guid ~= object_guid then
						local distance = GetDistance(target, object)
						local ccd_unit = SpecialAurasCheck(object)
					end
				end
			end
		end
	else
		for k in pairs(CURRENTTARGETINFOTABLE) do
			CURRENTTARGETINFOTABLE[k] = nil
		end
	end

	if UnitExists(target) and (FireHack or oexecute) then
		local target_guid = tostring(UnitGUID(target))
		local target_name = tostring(UnitName(target))
		local target_distance = Distance("player", target)
		local target_combat_reach = GetCombatReach(target)
		local target_health_act = UnitHealth(target)
		local target_health_max = UnitHealthMax(target)
		local target_health_pct = math.floor((target_health_act / target_health_max) * 100)
		local target_affecting_combat = tostring(UnitAffectingCombat(target))
		local target_reaction = UnitReaction("player", target)
		local target_special_aura = tostring(SpecialAurasCheck(target))
		local target_special_target = tostring(SpecialEnemyTargetsCheck(target))
		local target_tapped_by_me = tostring(UnitIsTappedByPlayer(target))
		local target_tapped_by_all = tostring(UnitIsTappedByAllThreatList(target))
		local target_attackp2t = tostring(UnitCanAttack("player", target))
		local target_attackt2p = tostring(UnitCanAttack(target, "player"))
		local target_deathin = TimeToDeath(target)

		CURRENTTARGETINFOTABLE["guid"] = target_guid
		CURRENTTARGETINFOTABLE["name"] = target_name
		CURRENTTARGETINFOTABLE["distance"] = target_distance
		CURRENTTARGETINFOTABLE["reach"] = target_combat_reach
		CURRENTTARGETINFOTABLE["healthact"] = target_health_act
		CURRENTTARGETINFOTABLE["healthmax"] = target_health_max
		CURRENTTARGETINFOTABLE["healthpct"] = target_health_pct
		CURRENTTARGETINFOTABLE["combat"] = target_affecting_combat
		CURRENTTARGETINFOTABLE["reaction"] = target_reaction
		CURRENTTARGETINFOTABLE["specialaura"] = target_special_aura
		CURRENTTARGETINFOTABLE["specialtarget"] = target_special_target
		CURRENTTARGETINFOTABLE["tappedbyme"] = target_tapped_by_me
		CURRENTTARGETINFOTABLE["tappedbyall"] = target_tapped_by_all
		CURRENTTARGETINFOTABLE["attackp2t"] = target_attackp2t
		CURRENTTARGETINFOTABLE["attackt2p"] = target_attackt2p
		CURRENTTARGETINFOTABLE["deathin"] = target_deathin
	end
end

function CurrentTargetTableShow()
	local DiesalGUI = LibStub("DiesalGUI-1.0")
	local explore = DiesalGUI:Create('TableExplorer')
	explore:SetTable("Current Target", CURRENTTARGETINFOTABLE)
	explore:BuildTree()
end

function DEBUG(level, debug_string)
	if DEBUGTOGGLE then
		if level == 5 and DEBUGLOGLEVEL >= 5 then
			print(debug_string)
		elseif level == 4 and DEBUGLOGLEVEL >= 4 then
			print(debug_string)
		elseif level == 3 and DEBUGLOGLEVEL >= 3 then
			print(debug_string)
		elseif level == 2 and DEBUGLOGLEVEL >= 2 then
			print(debug_string)
		elseif level == 1 and DEBUGLOGLEVEL >= 1 then
			print(debug_string)
		else
			return
		end
	end
end

function GetCombatReach(unit)
	local unit = unit
	if UnitExists(unit) then
		if FireHack then
			return UnitCombatReach(unit)
		elseif oexecute then
			return ObjectDescriptorFloat(unit,0x18C)
		else
			return 0
		end
	else
		return 0
	end
end

function GetDistance(unit1, unit2)
	local unit1, unit2 = unit1, unit2
	local unit1_exists = UnitExists(unit1)
	local unit2_exists = UnitExists(unit2)
	local unit1_visible = UnitIsVisible(unit1)
	local unit2_visible = UnitIsVisible(unit2)

	if unit1_exists and unit1_visible and unit2_exists and unit2_visible then
		if FireHack then
			local _, x1, y1, z1 = pcall(ObjectPosition, unit1)
			local _, x2, y2, z2 = pcall(ObjectPosition, unit2)
			return GetRound(math.sqrt(((x2-x1)^2) + ((y2-y1)^2) + ((z2-z1)^2)), 2)
		elseif oexecute then
			local _, x1, y1, z1, _ = pcall(UnitPosition, unit1)
			local _, x2, y2, z2, _ = pcall(UnitPosition, unit2)
			return math.sqrt(((x2-x1)^2) + ((y2-y1)^2) + ((z2-z1)^2))
		else
			return 0
		end
	end
	return 1
end

function GetRound(value, precision)
	if value == nil then
		return nil
	end
  if (precision) then
    return math.floor( (value * 10^precision) + 0.5) / (10^precision)
  else
    return math.floor(value+0.5)
  end
end

function onUpdate(NotificationFrame, elapsed)
	if NotificationFrame.time < GetTime() - 2.0 then
		if NotificationFrame:GetAlpha() == 0 then
			NotificationFrame:Hide()
		else
			NotificationFrame:SetAlpha(NotificationFrame:GetAlpha() - .05)
		end
	end
end
NotificationFrame = CreateFrame("Frame",nil,UIParent)
NotificationFrame:SetSize(500,50)
NotificationFrame:Hide()
NotificationFrame:SetScript("OnUpdate",onUpdate)
NotificationFrame:SetPoint("CENTER")
NotificationFrame.text = NotificationFrame:CreateFontString(nil,"OVERLAY","MovieSubtitleFont")
NotificationFrame.text:SetTextHeight(24)
NotificationFrame.text:SetAllPoints()
NotificationFrame.texture = NotificationFrame:CreateTexture()
NotificationFrame.texture:SetAllPoints()
NotificationFrame.texture:SetTexture(0,0,0,.50)
NotificationFrame.time = 0
function NotificationFrame:message(message)
	self.text:SetText(message)
	self:SetAlpha(1)
	self.time = GetTime()
	self:Show()
end

function PrimaryStatsTableInit()
	for i=1, 5 do
		PRIMARYBASESTATS[#PRIMARYBASESTATS+1] = UnitStat("player", i)
	end
end

function PrimaryStatsTableUpdate()
	if not UnitAffectingCombat("player") then
		for i=1, 5 do
			local stat = UnitStat("player", i)
			if PRIMARYBASESTATS[i] ~= stat then
				PRIMARYBASESTATS[i] = stat
			end
		end
	end
end

function SecondaryStatsTableInit()
	SECONDARYBASESTATS[1] = GetCritChance()
	SECONDARYBASESTATS[2] = GetHaste()
	SECONDARYBASESTATS[3] = GetMastery()
	SECONDARYBASESTATS[4] = GetMultistrike()
	SECONDARYBASESTATS[5] = GetCombatRating(29)
end

function SecondaryStatsTableUpdate()
	if not UnitAffectingCombat("player") then
		local crit = GetCritChance()
		local haste = GetHaste()
		local mastery = GetMastery()
		local multistrike = GetMultistrike()
		local versatility = GetCombatRating(29)

		if SECONDARYBASESTATS[1] ~= crit then
			SECONDARYBASESTATS[1] = crit
		end
		if SECONDARYBASESTATS[2] ~= haste then
			SECONDARYBASESTATS[2] = haste
		end
		if SECONDARYBASESTATS[3] ~= mastery then
			SECONDARYBASESTATS[3] = mastery
		end
		if SECONDARYBASESTATS[4] ~= multistrike then
			SECONDARYBASESTATS[4] = multistrike
		end
		if SECONDARYBASESTATS[5] ~= versatility then
			SECONDARYBASESTATS[5] = versatility
		end
	end
end

-- May need pcalls here. Keep that in mind
function SpecialAurasCheck(unit)
	local unit = unit
	if not UnitExists(unit) then
		return false
	end

	for i = 1, 40 do
		local debuff = select(11, UnitDebuff(unit, i))
		if debuff == nil then
			break
		end
		if SpecialAuras[tonumber(debuff)] ~= nil then
			return true
		end
	end
	return false
end

-- May need pcalls here. Keep that in mind
function SpecialEnemyTargetsCheck(unit)
	local unit = unit
	local _,_,_,_,_,unitID = strsplit("-", UnitGUID(unit))

	if not UnitExists(unit) then
		return false
	end

	if SpecialEnemyTargets[tonumber(unitID)] ~= nil then
		return true
	else
		return false
	end
end

function TargetIsImmuneCheck(debuglevel, unit)
	local unit = unit

	if not UnitExists(unit) then
		DEBUG(debuglevel, "TargetIsImmuneCheck("..tostring(unit)..") UnitExists?(false)")
		return false
	end

	local has_aura = SpecialAurasCheck(unit)
	local can_attack = UnitCanAttack("player", unit)
	local in_combat = UnitAffectingCombat(unit)
	local special_target = SpecialEnemyTargetsCheck(unit)

	if has_aura then
		DEBUG(debuglevel, "TargetIsImmuneCheck("..unit..") Special Aura?("..tostring(has_aura)..")")
		return true
	elseif not can_attack then
		DEBUG(debuglevel, "TargetIsImmuneCheck("..unit..") Attackable?("..tostring(can_attack)..")")
		return true
	elseif not in_combat and not special_target then
		DEBUG(debuglevel, "TargetIsImmuneCheck Combat?("..tostring(in_combat).."), Special Target?("..tostring(special_target)..")")
		return true
	else
		DEBUG(debuglevel, "TargetIsImmuneCheck("..unit..") is false")
		return false
	end
end

function TargetIsInFrontCheck(debuglevel, unit)
	local unit = unit

	if not UnitExists(unit) then
		return false
	end

	if FireHack then
		local _, x1, y1, z1 = pcall(ObjectPosition, unit)
		local x2, y2, z2 = ObjectPosition("player")
		local player_facing = GetPlayerFacing()
		local facing = math.atan2(y2 - y1, x2 - x1) % 6.2831853071796
		return math.abs(math.deg(math.abs(player_facing - (facing))) - 180) < 90
	elseif oexecute then
		local _, x1, y1, z1, _ = pcall(UnitPosition, unit)
		local x2, y2, z2, player_facing = UnitPosition("player")
		local facing = math.atan2(y2 - y1, x2 - x1) % 6.2831853071796
		return math.abs(math.deg(math.abs(player_facing - (facing))) - 180) < 90
	else
		return true
	end
end

function TimeToDeath(target)
	local guid = UnitGUID(target)
	if deathTrack[target] and deathTrack[target].guid == guid then
		local start = deathTrack[target].time
		local currentHP = UnitHealth(target)
		local maxHP = deathTrack[target].start
		local diff = maxHP - currentHP
		local dura = GetTime() - start
		local hpps = diff / dura
		local death = currentHP / hpps
		if death == math.huge then
			return 8675309
		elseif death < 0 then
			return 0
		else
			return death
		end
	elseif deathTrack[target] then
		table.empty(deathTrack[target])
	else
		deathTrack[target] = { }
	end
	deathTrack[target].guid = guid
	deathTrack[target].time = GetTime()
	deathTrack[target].start = UnitHealth(target)
	return 8675309
end










--[[------------------------------------------------------------------------------------------------
OBJECT MANAGER
--------------------------------------------------------------------------------------------------]]
local cacheunitstable_storage = { }

local function clearCache()
    for i = #CACHEUNITSTABLE, 1, -1 do
        tinsert(cacheunitstable_storage, tremove(CACHEUNITSTABLE))
    end
end

local function getTable()
    local t = tremove(cacheunitstable_storage)
    if t ~= nil then
        tinsert(CACHEUNITSTABLE, t)
        return t
    else
        t = { }
        tinsert(CACHEUNITSTABLE, t)
        return t
    end
end

function CacheEnemyUnits()
    clearCache()

    -- FIREHACK
	if FireHack and ProbablyEngine.module.player.combat then
		local total_objects = ObjectCount()

		for i=1, total_objects do
			local object = ObjectWithIndex(i)
			local _, object_exists = pcall(ObjectExists, object)

			if object_exists then
				local _, object_type = pcall(ObjectType, object)

				if bit.band(object_type, ObjectTypes.Unit) > 0 then
					local object_distance = GetRound(Distance("player", object), 2)
					--local object_distance = 1

					if object_distance <= 40 then
						local object_health = UnitHealth(object)

						if object_health > 0 then
							local object_health_max = UnitHealthMax(object)
							local object_health_percentage = math.floor((object_health / object_health_max) * 100)
							local object_name = UnitName(object)
							local reaction = UnitReaction("player", object)
							local special_enemy_target = SpecialEnemyTargetsCheck(object)
							local special_aura_target = SpecialAurasCheck(object)
							local tapped_by_me = UnitIsTappedByPlayer(object)
							local tapped_by_all = UnitIsTappedByAllThreatList(object)
							local unit_affecting_combat = UnitAffectingCombat(object)

							if reaction	and reaction <= 4 and not special_aura_target
								and (tapped_by_me or tapped_by_all or special_enemy_target)
							then
								local t = getTable()
								t.object = object
								t.name = object_name
								t.health = object_health_percentage
								t.distance = object_distance

								if CACHEUNITSALGORITHM == "lowest" then
									table.sort(CACHEUNITSTABLE, function(a,b) return a.health < b.health end)
								elseif CACHEUNITSALGORITHM == "nearest" then
									table.sort(CACHEUNITSTABLE, function(a,b) return a.distance < b.distance end)
								end
							end
						end
					end
				end
			end
		end
	end
end