--[[------------------------------------------------------------------------------------------------
	Globals.lua

	RotAgent (Rotation Agent) License
	This work is licensed under the Creative Commons Attribution-NonCommercial 4.0 International
	License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc/4.0/.

--------------------------------------------------------------------------------------------------]]
local RotAgentName, RotAgent = ...



--[[------------------------------------------------------------------------------------------------
TABLES/VARIABLES
--------------------------------------------------------------------------------------------------]]
RotAgent.autoTargetAlgorithm = "lowest"
RotAgent.baseStatsTable = { }
RotAgent.deathTrack = { }
RotAgent.debugToggle = true
RotAgent.debugLogLevel = 1

RotAgent.specialAuras = {
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

RotAgent.specialEnemyTargets = {
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
	[76222]     = "76222",      -- Rallying Banner (UBRS Black Iron Grunt)
	[76267]     = "76267",      -- Solar Zealot (Skyreach)
	[76518]     = "76518",      -- Ritual of Bones (Shadowmoon Burial Grounds)
	[77252]     = "77252",      -- Ore Crate (BRF Oregorger)
	[77665]     = "77665",      -- Iron Bomber (BRF Blackhand)
	[77891]     = "77891",      -- Grasping Earth (BRF Kromog)
	[77893]     = "77893",      -- Grasping Earth (BRF Kromog)
	[78583]     = "78583",      -- Dominator Turret (BRF Iron Maidens)
    [78584]     = "78584",      -- Dominator Turret (BRF Iron Maidens)
	[79504]     = "79504",      -- Ore Crate (BRF Oregorger)
	[79511]     = "79511",      -- Blazing Trickster (Auchindoun Heroic)
	[81638]     = "81638",      -- Aqueous Globule (The Everbloom)
	[86644]     = "86644",      -- Ore Crate (BRF Oregorger)
}

RotAgent.specialHealingTargets = {
	-- TRAINING DUMMIES
	[88289]     = "88289",      -- Training Dummy <Healing> HORDE GARRISON
	[88316]     = "88316",      -- Training Dummy <Healing> ALLIANCE GARRISON
	-- WOD DUNGEONS/RAIDS
	[78868]     = "78868",      -- Rejuvinating Mushroom (HM Brackenspore)
	[78884]     = "78884",      -- Living Mushroom (HM Brackenspore)
}



--[[------------------------------------------------------------------------------------------------
FUNCTIONS
--------------------------------------------------------------------------------------------------]]
function RotAgent.AutoTargetEnemy()
	if UnitExists("target") and not UnitIsDeadOrGhost("target") then
		return false
	end

	if RotAgent.autoTargetAlgorithm == "lowest" then
		return TargetUnit(RotAgent.lowestUnit)
	elseif RotAgent.autoTargetAlgorithm == "nearest" then
		return TargetUnit(RotAgent.nearestUnit)
	else
		for i=1, #RotAgent.unitCacheCombat do
			if GetRaidTargetIndex(RotAgent.unitCacheCombat[i].object) == 8 then
				return TargetUnit(RotAgent.unitCacheCombat[i].object)
			end
		end
		if UnitExists("focustarget") then
			return TargetUnit("focustarget")
		else
			if RotAgent.autoTargetAlgorithm == "lowest" then
				return TargetUnit(RotAgent.lowestUnit)
			elseif RotAgent.autoTargetAlgorithm == "nearest" then
				return TargetUnit(RotAgent.nearestUnit)
			end
		end
	end
	return false
end

function RotAgent.Debug(level, string)
	--[[--------------------------------------------------------------------------------------------
	Debug is used mainly for testing/beta development phases.
	If debug is currently true (debugToggle) then drop into the logic.
	Basically a level for each message is passed. If the current log level is that high or higher
	debug will print out the string supplied.
	--------------------------------------------------------------------------------------------]]--
	if RotAgent.debugToggle then
		if level == 5 and RotAgent.debugLogLevel >= 5 then
			print(string)
		elseif level == 4 and RotAgent.debugLogLevel >= 4 then
			print(string)
		elseif level == 3 and RotAgent.debugLogLevel >= 3 then
			print(string)
		elseif level == 2 and RotAgent.debugLogLevel >= 2 then
			print(string)
		elseif level == 1 and RotAgent.debugLogLevel >= 1 then
			print(string)
		else
			return
		end
	end
end

function RotAgent.GetCombatReach(unit)
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


function RotAgent.onUpdate(self, elapsed)
    --[[--------------------------------------------------------------------------------------------
    Each onUpdate checks if the frame is older than 2 seconds.
    If it is check if the alpha is 0, fully invisibile.
    If its invisible then Hide the frame.
    Else we slowly start to fade the frame out 0.05 at a time.
    --------------------------------------------------------------------------------------------]]--
    if RotAgent.notificationFrame.time < GetTime() - 2.0 then
        if RotAgent.notificationFrame:GetAlpha() == 0 then
            RotAgent.notificationFrame:Hide()
        else
            RotAgent.notificationFrame:SetAlpha(RotAgent.notificationFrame:GetAlpha() - .05)
        end
    end
end
RotAgent.notificationFrame = CreateFrame("Frame",nil,UIParent)
RotAgent.notificationFrame:SetSize(500,50)
RotAgent.notificationFrame:Hide()
RotAgent.notificationFrame:SetScript("onUpdate", RotAgent.onUpdate)
RotAgent.notificationFrame:SetPoint("CENTER", 0, -240)
RotAgent.notificationFrame.text = RotAgent.notificationFrame:CreateFontString(nil,"OVERLAY","MovieSubtitleFont")
RotAgent.notificationFrame.text:SetTextHeight(24)
RotAgent.notificationFrame.text:SetAllPoints()
RotAgent.notificationFrame.texture = RotAgent.notificationFrame:CreateTexture()
RotAgent.notificationFrame.texture:SetAllPoints()
RotAgent.notificationFrame.texture:SetTexture(0,0,0,.50)
RotAgent.notificationFrame.time = 0
function RotAgent.notificationFrame:message(message)
    --[[--------------------------------------------------------------------------------------------
    Set the text for the frame with 'message'. Then set the alpha for the frame to 1, fully visible.
    Next set the timer for the start of the message to now, GetTime. Lastly show the frame.
    --------------------------------------------------------------------------------------------]]--
    self.text:SetText(message)
    self:SetAlpha(1)
    self.time = GetTime()
    self:Show()
end

function RotAgent.BaseStatsTableInit()
	--[[--------------------------------------------------------------------------------------------
	Only run this once, as we load a rotation. These become the base values.
	--------------------------------------------------------------------------------------------]]--
	RotAgent.baseStatsTable.strength = UnitStat("player", 1)
	RotAgent.baseStatsTable.agility = UnitStat("player", 2)
	RotAgent.baseStatsTable.stamina = UnitStat("player", 3)
	RotAgent.baseStatsTable.intellect = UnitStat("player", 4)
	RotAgent.baseStatsTable.spirit = UnitStat("player", 5)
	RotAgent.baseStatsTable.crit = GetCritChance()
	RotAgent.baseStatsTable.haste = GetHaste()
	RotAgent.baseStatsTable.mastery = GetMastery()
	RotAgent.baseStatsTable.multistrike = GetMultistrike()
	RotAgent.baseStatsTable.versatility = GetCombatRating(29)
end

function RotAgent.BaseStatsTablePrint()
	print("Strength: "..RotAgent.baseStatsTable.strength)
	print("Agility: "..RotAgent.baseStatsTable.agility)
	print("Stamina: "..RotAgent.baseStatsTable.stamina)
	print("Intellect: "..RotAgent.baseStatsTable.intellect)
	print("Spirit: "..RotAgent.baseStatsTable.spirit)
	print("Crit: "..RotAgent.baseStatsTable.crit)
	print("Haste: "..RotAgent.baseStatsTable.haste)
	print("Mastery: "..RotAgent.baseStatsTable.mastery)
	print("Multistrike: "..RotAgent.baseStatsTable.multistrike)
	print("Versatility: "..RotAgent.baseStatsTable.versatility)
end

function RotAgent.BaseStatsTableUpdate()
	--[[--------------------------------------------------------------------------------------------
	If the base stats change we want to update them. This could be because of gear changes, food,
	flasks, buffs, etc. We want to update the base table prior to combat. Once in combat this table
	is what we check against to see if we have a buff proc.
	--------------------------------------------------------------------------------------------]]--
	if not UnitAffectingCombat("player") then
		if RotAgent.baseStatsTable.strength ~= UnitStat("player", 1) then
			RotAgent.baseStatsTable.strength = UnitStat("player", 1)
		end
		if RotAgent.baseStatsTable.agility ~= UnitStat("player", 2) then
			RotAgent.baseStatsTable.agility = UnitStat("player", 2)
		end
		if RotAgent.baseStatsTable.stamina ~= UnitStat("player", 3) then
			RotAgent.baseStatsTable.stamina = UnitStat("player", 3)
		end
		if RotAgent.baseStatsTable.intellect ~= UnitStat("player", 4) then
			RotAgent.baseStatsTable.intellect = UnitStat("player", 4)
		end
		if RotAgent.baseStatsTable.spirit ~= UnitStat("player", 5) then
			RotAgent.baseStatsTable.spirit = UnitStat("player", 5)
		end
		if RotAgent.baseStatsTable.crit ~= GetCritChance() then
			RotAgent.baseStatsTable.crit = GetCritChance()
		end
		if RotAgent.baseStatsTable.haste ~= GetHaste() then
			RotAgent.baseStatsTable.haste = GetHaste()
		end
		if RotAgent.baseStatsTable.mastery ~= GetMastery() then
			RotAgent.baseStatsTable.mastery = GetMastery()
		end
		if RotAgent.baseStatsTable.multistrike ~= GetMultistrike() then
			RotAgent.baseStatsTable.multistrike = GetMultistrike()
		end
		if RotAgent.baseStatsTable.versatility ~= GetCombatRating(29) then
			RotAgent.baseStatsTable.versatility = GetCombatRating(29)
		end
	end
end

--[[------------------------------------------------------------------------------------------------
QUEUE
If the current time is greater than 4 seconds then reset the queue timer and queued spell variables
and return false.
Otherwise if the queued spell called by a macro is the same as the spell we are checking for in the
rotation then:
    If the player's last casted spell is the spell we are trying to queue reset the queue timer
    and queued spell variables.
    Otherwise send a notification message to the screen and return true to the rotation line that
    called this function.
Otherwise return false.
--------------------------------------------------------------------------------------------------]]
function RotAgent.Queue(spellID)
    if (GetTime() - RotAgent.QueueTime) > 4 then
        RotAgent.QueueTime = 0
        RotAgent.QueueSpell = nil
        return false
    else
        if RotAgent.QueueSpell then
            if RotAgent.QueueSpell == spellID then
                if ProbablyEngine.parser.lastCast == GetSpellName(spellID) then
                    RotAgent.QueueSpell = nil
                    RotAgent.QueueTime = 0
                end
                RotAgent.notificationFrame:message(GetSpellName(spellID).." Queued")
                return true
            else
                return false
            end
        end
    end
end

function RotAgent.SpecialAurasCheck(unit)
	--[[--------------------------------------------------------------------------------------------
	UnitExists is a sanity check.
	Loop through the number of possible debuffs, 1-40.
	If we encounter a spellID (select 11) that is nil then we've reached the end of the debuffs for
	this particular Unit. No need to continue.
	Each debuff found, check against the Special Auras table. If a match is found return True.
	--------------------------------------------------------------------------------------------]]--
	if not UnitExists(unit) then
		return false
	end
	for i = 1, 40 do
		local debuff = select(11, UnitDebuff(unit, i))
		if debuff == nil then
			break
		end
		if RotAgent.specialAuras[tonumber(debuff)] ~= nil then
			return true
		end
	end
	return false
end

function RotAgent.SpecialEnemyTargetsCheck(unit)
	--[[--------------------------------------------------------------------------------------------
	Unit Exists is a sanity check. If unit is valid get the UnitID from UnitGUID, using strsplit.
	If the UnitID matches a Special Enemy Unit in the table then return true. Otherwise the unit
	is not a Special Enemy.
	--------------------------------------------------------------------------------------------]]--
	if not UnitExists(unit) then
		return false
	end
	local _,_,_,_,_,unitID = strsplit("-", UnitGUID(unit))
	if RotAgent.specialEnemyTargets[tonumber(unitID)] ~= nil then
		return true
	else
		return false
	end
end

function RotAgent.TargetIsImmuneCheck(unit)
	if not UnitExists(unit) then
		return false
	end

	if RotAgent.SpecialAurasCheck(unit) then
		return true
	elseif not UnitCanAttack("player", unit) then
		return true
	elseif not UnitAffectingCombat(unit) and not RotAgent.SpecialEnemyTargetsCheck(unit) then
		return true
	else
		return false
	end
end

function RotAgent.TargetIsInFrontCheck(unit)
	if not UnitExists(unit) then
		return false
	end

	if FireHack then
		local x1, y1, z1 = ObjectPosition(unit)
		local x2, y2, z2 = ObjectPosition("player")
		local playerFacing = GetPlayerFacing()
		local facing = math.atan2(y2 - y1, x2 - x1) % 6.2831853071796
		return math.abs(math.deg(math.abs(playerFacing - (facing))) - 180) < 90
	else
		return true
	end
end

function RotAgent.TimeToDeath(target)
	local guid = UnitGUID(target)
	if RotAgent.deathTrack[target] and RotAgent.deathTrack[target].guid == guid then
		local start = RotAgent.deathTrack[target].time
		local currentHP = UnitHealth(target)
		local maxHP = RotAgent.deathTrack[target].start
		local diff = maxHP - currentHP
		local dura = GetTime() - start
		local hpps = diff / dura
		local death = currentHP / hpps
		local roundedDeath =  math.floor( (death * 10^2) + 0.5) / (10^2)
		if death == math.huge then
			return "Infinity"
		elseif death < 0 then
			return 0
		else
			return roundedDeath
		end
	elseif RotAgent.deathTrack[target] then
		table.empty(RotAgent.deathTrack[target])
	else
		RotAgent.deathTrack[target] = { }
	end
	RotAgent.deathTrack[target].guid = guid
	RotAgent.deathTrack[target].time = GetTime()
	RotAgent.deathTrack[target].start = UnitHealth(target)
	return "Infinity"
end