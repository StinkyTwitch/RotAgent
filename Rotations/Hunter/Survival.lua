--[[------------------------------------------------------------------------------------------------
	SurvivalTest.lua

	RotAgent (Rotation Agent) License
	This work is licensed under the Creative Commons Attribution-NonCommercial 4.0 International
	License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc/4.0/.
--]]------------------------------------------------------------------------------------------------
local addonName = ...
local addonVersion = GetAddOnMetadata(addonName, "Version")

local function dynamicEval(condition, spell)
	if not condition then return false end
	return ProbablyEngine.dsl.parse(condition, spell or '')
end

local s = {
	-- CORE
	ArcaneShot = "3044",
	AspectoftheCheetah = "5118",
	AspectoftheFox = "172106",
	AspectofthePack = "13159",
	AutoShot = "75",
	CallPet1 = "883",
	CallPet2 = "83242",
	CallPet3 = "83243",
	CallPet4 = "83244",
	CallPet5 = "83245",
	Camouflage = "51753",
	Deterrence = "148467",
	ConcussiveShot = "5116",
	CounterShot = "147362",
	DismissPet = "2641",
	Disengage = "781",
	DistractingShot = "20736",
	EagleEye = "6197",
	ExplosiveTrap1 = "13813",
	ExplosiveTrap2 = "82939",
	FeedPet = "6991",
	FeignDeath = "5384",
	FeignDeathNow = "!5384",
	Flare = "1543",
	FreezingTrap1 = "1499",
	FreezingTrap2 = "60192",
	HeartOfThePhoenix = "55709",
	IceTrap1 = "13809",
	IceTrap2 = "82941",
	MastersCall = "53271",
	MendPet = "136",
	Misdirection = "34477",
	MultiShot = "2643",
	RevivePet = "982",
	SteadyShot = "56641",
	TrapLauncher = "77769",
	TranquilizingShot = "19801",
	-- GLYPHS
	Fetch = "125050",
	Fireworks = "127933",
	SnakeTrap = "82948",
	-- SURVIVAL
	BlackArrow = "3674",
	BlackArrowNow = "!3674",
	CobraShot = "77767",
	ExplosiveShot = "53301",
	ExplosiveShotNow = "!53301",
	-- TALENTS
	AMurderofCrows = "131894",
	Barrage = "120360",
	BindingShot  = "109248",
	DireBeast = "120679",
	Exhilaration = "109304",
	FocusingShot = "152245",
	GlaiveToss = "117050",
	Intimidation = "19577",
	Powershot = "109259",
	Stampede = "121818",
	WyvernSting = "19386",
	-- RACIALS
	ArcaneTorrent = "80483",
	BloodFury = "20572",
	Berserking = "26297",
	-- OBJECTS
	AgilityPotion = "#109217",
	HealthStone = "#5512",
	Trinket1 = "#trinket1",
	Trinket2 = "#trinket2",
	-- BUFFS
    ArchmagesIncandescence = "177161",
	ArchmagesGreaterIncandescence = "177172",
	BalancedFate = "177038",
	Dazed = "15571",
	Food = "160598",
	LockandLoad = "168980",
	SerpentSting = "118253",
	SteadyFocus = "177668",
	ThrilloftheHunt = "34720",
	-- DEBUFFS
	Flamethrower = "163322",
	InfestingSpores = "163242",
	-- STRINGS
    ExtraActionButton = "/click ExtraActionButton1",
    HunterJump = "/stopcasting\n/stopcasting\n/hunterjump",
    Pause = "/stopcasting\n/stopcasting\n/stopattack",
    PauseIncPet = "/stopcasting\n/stopcasting\n/stopattack\n/petfollow",
    PetAttack = "/petattack",
    PetDash = "/cast Dash",
}
local defensive = {
    { s.HealthStone, { "player.health < 40", }, },
    { s.Deterrence, { "player.health <= 10", }, },
    { s.Exhilaration, { "player.health < 50", }, },
    { s.MastersCall, { "pet.exists", "player.state.disorient", }, },
    { s.MastersCall, { "pet.exists", "player.state.stun", }, },
    { s.MastersCall, { "pet.exists", "player.state.root", }, },
    { s.MastersCall, { "pet.exists", "player.state.snare", "!player.debuff("..s.Dazed..")", }, },
    -- BOSS DEBUFFS
    { s.ExtraActionButton, { "player.buff("..s.Flamethrower..")", }, },
    { s.FeignDeath, { "player.debuff("..s.InfestingSpores..").count >= 6", }, },
}
local interrupt = {
    { s.CounterShot, { "target.interruptAt(75)", "modifier.interrupts", "!player.casting", }, "target", },
    { s.Intimidation, { "target.interruptAt(25)", "modifier.interrupts", "!player.casting", }, "target", },
    { s.WyvernSting, { "target.interruptAt(25)", "modifier.interrupts", "!player.casting", }, "target", }
}
local misdirect = {
    { s.Misdirection, { "focus.exists", "!focus.dead", "!focus.buff("..s.Misdirection..")", "modifier.lalt", }, "focus", },
    { s.Misdirection, { "!focus.exists", "!mouseover.buff("..s.Misdirection..")", "modifier.lalt", }, "mouseover", },
    { s.Misdirection, { "focus.exists", "!focus.dead", "!focus.buff("..s.Misdirection..")", "player.threat > 50", }, "focus", },
}
local mouseover = {
    -- CC TRAP
    { s.FreezingTrap1, { "!player.buff("..s.TrapLauncher..")", "modifier.lcontrol", }, },
    { s.FreezingTrap2, { "player.buff("..s.TrapLauncher..")", "modifier.lcontrol", }, "mouseover.ground", },
    -- SERPENT STING (checks: No Debuff, Not Immune, Enemies Around Target)
    { s.MultiShot, { "toggle.mouseovers", "!modifier.lcontrol", "modifier.multitarget", "!mouseover.debuff("..s.SerpentSting..")", "!mouseover.cc", "mouseover.area(8).enemies > 1", }, "mouseover", },
    { s.ArcaneShot, { "toggle.mouseovers", "!modifier.lcontrol", "!mouseover.debuff("..s.SerpentSting..")", "!mouseover.cc", }, "mouseover", },
    -- FORCE SERPENT STING
    { s.MultiShot, { "toggle.mouseovers", "modifier.ralt", "modifier.multitarget", "!mouseover.debuff("..s.SerpentSting..")", "mouseover.area(8).enemies > 1", }, "mouseover", },
    { s.ArcaneShot, { "toggle.mouseovers", "modifier.ralt", "!mouseover.debuff("..s.SerpentSting..")", }, "mouseover", },
}
local petmanagement = {
    { s.Misdirection, { "pet.exists", "!pet.dead", "!pet.buff("..s.Misdirection..")", "!focus.exists", }, "pet", },
    { s.HeartOfThePhoenix, { "!talent(7,3)", "pet.dead", }, },
    { s.RevivePet, { "!talent(7,3)", "pet.dead", }, },
    { s.MendPet, { "pet.exists", "!pet.dead", "!pet.buff("..s.MendPet..")", "pet.health <= 90", }, "pet", },
    { s.PetAttack, { "pet.exists", "timeout(petAttack, 1)", }, },
    { s.PetDash, { "pet.exists", "pet.distancetotarget > 15", "timeout(petDash, 1)", }, },
}
local poolfocus = {
    { s.CobraShot, { "modifier.rcontrol", "!talent(7,2)", }, },
    { s.FocusingShot, { "modifier.rcontrol", "talent(7,2)", }, },
}
local pvp = {
    { s.ConcussiveShot, { "target.moving", "!target.immune.snare", }, },
    { s.TranquilizingShot, { "target.dispellable("..s.TranquilizingShot..")", }, },
}
local spellqueue = {
    -- HUNTER TRAPS/GROUND SPELLS
    { s.ExplosiveTrap1, { "@LibHunter.Queue(13813)", "!player.buff("..s.TrapLauncher..")", }, },
    { s.ExplosiveTrap2, { "@LibHunter.Queue(82939)", "player.buff("..s.TrapLauncher..")", }, "mouseover.ground", },
    { s.FreezingTrap1, { "@LibHunter.Queue(60192)", "!player.buff("..s.TrapLauncher..")", }, },
    { s.FreezingTrap2, { "@LibHunter.Queue(60192)", "player.buff("..s.TrapLauncher..")", }, "mouseover.ground", },
    { s.IceTrap1, { "@LibHunter.Queue(82941)", "!player.buff("..s.TrapLauncher..")", }, },
    { s.IceTrap2, { "@LibHunter.Queue(82941)", "player.buff("..s.TrapLauncher..")", }, "mouseover.ground", },
    { s.BindingShot, "@LibHunter.Queue(109248)", "mouseover.ground", },
    { s.Flare, "@LibHunter.Queue(1543)", "mouseover.ground", },
    -- HUNTER GENERAL
    { s.AMurderofCrows, "@LibHunter.Queue(131894)", },
    { s.ArcaneShot, "@LibHunter.Queue(3044)", },
    { s.AspectoftheFox, "@LibHunter.Queue(172106)", },
    { s.Barrage, "@LibHunter.Queue(120360)", },
    { s.Camouflage, "@LibHunter.Queue(51753)", },
    { s.ConcussiveShot, "@LibHunter.Queue(5116)", },
    { s.CounterShot, "@LibHunter.Queue(147362)", },
    { s.Deterrence, "@LibHunter.Queue(148467)", },
    { s.DistractingShot, "@LibHunter.Queue(20736)", },
    { s.FeignDeathNow, "@LibHunter.Queue(5384)", },
    { s.Flare, "@LibHunter.Queue(1543)", },
    { s.FocusingShot, "@LibHunter.Queue(152245)", },
    { s.GlaiveToss, "@LibHunter.Queue(117050)", },
    { s.Intimidation, "@LibHunter.Queue(19577)", },
    { s.MastersCall, "@LibHunter.Queue(53271)", },
    { s.MultiShot, "@LibHunter.Queue(2643)", },
    { s.Powershot, "@LibHunter.Queue(109259)", },
    { s.Stampede, "@LibHunter.Queue(121818)", },
    { s.TranquilizingShot, "@LibHunter.Queue(19801)", },
    { s.WyvernSting, "@LibHunter.Queue(19386)", },
    { s.HunterJump, { "@LibHunter.Queue(781)", "timeout(HunterJump, 1)", }, },
    -- HUNTER SURVIVAL
    { s.BlackArrow, "@LibHunter.Queue(3674)", },
    { s.ExplosiveShot, "@LibHunter.Queue(53301)", },
}







local opener3plus = {

}
local opener2 = {

}
local opener = {

}
local ooc = {
    { s.Pause, { "modifier.lshift", }, },
    { s.Pause, "player.buff("..s.FeignDeath..")", },
    { s.Pause, "player.buff("..s.Food..")", },

    { s.DismissPet, { "pet.exists", "talent(7,3)", }, },
    { s.RevivePet, { "pet.dead", "!talent(7,3)", }, },

    { s.Fetch, { "modifier.lcontrol", "!lastcast("..s.Fetch..")", "!player.moving", "pet.exists", "timeout(timerFetch, 1)", }, },
    { s.TrapLauncher, { "!player.buff("..s.TrapLauncher..")", }, },

}
local combat = {
	{ s.ArcaneShot, { "!target.debuff("..s.SerpentSting..")", }, },

    ------------------------------------------------------------------------------------------------
	--actions=auto_shot

	------------------------------------------------------------------------------------------------
	--actions+=/arcane_torrent,if=focus.deficit>=30
	{ s.ArcaneTorrent, { "modifier.cooldowns", "player.focus.deficit >= 30", }, },

	------------------------------------------------------------------------------------------------
	--actions+=/blood_fury
	{ s.BloodFury, { "modifier.cooldowns", }, },

	------------------------------------------------------------------------------------------------
	--actions+=/berserking
	{ s.Berserking, { "modifier.cooldowns", }, },

	------------------------------------------------------------------------------------------------
	--actions+=/potion,name=draenic_agility,if=
	--(((cooldown.stampede.remains<1)&(cooldown.a_murder_of_crows.remains<1))&trinket.stat.any.up)
	{ s.AgilityPotion, {
		"player.spell("..s.Stampede..").cooldown < 1",
		"player.spell("..s.AMurderofCrows..").cooldown < 1",
		(function()
			return(dynamicEval("player.agility.proc") or dynamicEval("player.crit.proc") or dynamicEval("player.multistrike.proc"))
		end),
		"toggle.consumables",
	}, },

	--(((cooldown.stampede.remains<1)&(cooldown.a_murder_of_crows.remains<1))|buff.archmages_greater_incandescence_agi.up)
	{ s.AgilityPotion, {
		"player.spell("..s.Stampede..").cooldown < 1",
		"player.spell("..s.AMurderofCrows..").cooldown < 1",
		"player.buff("..s.ArchmagesGreaterIncandescence..")",
		"toggle.consumables",
	}, },

	--|target.time_to_die<=25
	{ s.AgilityPotion, { "target.deathin <= 25", "toggle.consumables",  }, },





	------------------------------------------------------------------------------------------------
	--actions+=/call_action_list,name=aoe,if=active_enemies>1
	{{
		--------------------------------------------------------------------------------------------
		--actions.aoe=stampede,if=
			--buff.potion.up
		{ s.Stampede, { "player.buff("..s.AgilityPotion..")", }, },
			--|cooldown.potion.remains&buff.archmages_greater_incandescence_agi.up
		{ s.Stampede, {
			"player.spell("..s.AgilityPotion..").cooldown > 0",
			"player.buff("..s.ArchmagesGreaterIncandescence..")",
		}, },
			--|cooldown.potion.remains&trinket.stat.any.up
		{ s.Stampede, {
			"player.spell("..s.AgilityPotion..").cooldown > 0",
			(function()
				return(dynamicEval("player.agility.proc") or dynamicEval("player.crit.proc") or dynamicEval("player.multistrike.proc"))
			end),
		}, },
			--|cooldown.potion.remains&buff.archmages_incandescence_agi.up
		{ s.Stampede, {
			"player.spell("..s.AgilityPotion..").cooldown > 0",
			"player.buff("..s.ArchmagesIncandescence..")",
		}, },

		--------------------------------------------------------------------------------------------
		--actions.aoe+=/explosive_shot,if=
			--buff.lock_and_load.react&!talent.barrage.enabled
			--buff.lock_and_load.react&cooldown.barrage.remains>0
		{ s.ExplosiveShot, { "player.buff("..s.LockandLoad..")", "!talent(6,3)", }, },
		{ s.ExplosiveShot, { "player.buff("..s.LockandLoad..")", "player.spell("..s.Barrage..").cooldown > 0", }, },

		--------------------------------------------------------------------------------------------
		--actions.aoe+=/barrage
		{ s.Barrage, },

		--------------------------------------------------------------------------------------------
		--actions.aoe+=/black_arrow,if=!ticking
		{ s.BlackArrow, { "player.spell("..s.BlackArrow..").cooldown = 0", "target.deathin > 10", }, },

		--------------------------------------------------------------------------------------------
		--actions.aoe+=/explosive_shot,if=active_enemies<5
		{ s.ExplosiveShot, { "target.area(10).enemies < 5", }, },

		--------------------------------------------------------------------------------------------
		--actions.aoe+=/explosive_trap,if=dot.explosive_trap.remains<=5
        { s.ExplosiveTrap2, { "player.buff("..s.TrapLauncher..")", "!target.ccinarea(10)", }, "target.ground", },

		--------------------------------------------------------------------------------------------
		--actions.aoe+=/a_murder_of_crows
		{ s.AMurderofCrows, { "target.deathin > 60", "modifier.cooldowns", }, },
		{ s.AMurderofCrows, { "target.deathin < 12", }, },
		{ s.AMurderofCrows, { "target.health.actual < 200000", }, },

		--------------------------------------------------------------------------------------------
		--actions.aoe+=/dire_beast
		{ s.DireBeast, { "target.deathin > 15", }, },

		--------------------------------------------------------------------------------------------
		--actions.aoe+=/multishot,if=
			--buff.thrill_of_the_hunt.react&focus>50&cast_regen<=focus.deficit
			--|dot.serpent_sting.remains<=5
			--|target.time_to_die<4.5
		{ s.MultiShot, {
			"player.buff("..s.ThrilloftheHunt..")",
			"player.focus > 50",
			(function()
				return(dynamicEval("player.spell("..s.MultiShot..").regen")<=dynamicEval("player.focus.deficit"))
			end),
		}, },

		--------------------------------------------------------------------------------------------
		--actions.aoe+=/glaive_toss
		{ s.GlaiveToss, { "target.deathin > 5", }, },

		--------------------------------------------------------------------------------------------
		--actions.aoe+=/powershot
		{ s.Powershot, { "target.deathin > 20", }, },

		--------------------------------------------------------------------------------------------
		--actions.aoe+=/cobra_shot,if=buff.pre_steady_focus.up&buff.steady_focus.remains<5&focus+14+cast_regen<80
		{ s.CobraShot, {
			"lastcast("..s.CobraShot..")",
			"player.buff("..s.SteadyFocus..").duration < 5",
			(function()
				return ((dynamicEval("player.focus") + 14 + dynamicEval("player.spell("..s.CobraShot..").regen")) < 80)
			end),
		}, },
		--------------------------------------------------------------------------------------------
		--actions.aoe+=/multishot,if=focus>=70|talent.focusing_shot.enabled
		{ s.MultiShot, { "player.focus > 70", }, },
		{ s.MultiShot, { "talent(7,2)", }, },

		--------------------------------------------------------------------------------------------
		--actions.aoe+=/focusing_shot
		{ s.FocusingShot, },

		--------------------------------------------------------------------------------------------
		--actions.aoe+=/cobra_shot
		{ s.CobraShot, },
	}, { "modifier.multitarget", "target.area(10).enemies > 1", }, },





	------------------------------------------------------------------------------------------------
	--actions+=/stampede,if=
		--buff.potion.up
	{ s.Stampede, { "player.buff("..s.AgilityPotion..")", }, },

		--|(cooldown.potion.remains&(buff.archmages_greater_incandescence_agi.up)
	{ s.Stampede, {
		"player.spell("..s.AgilityPotion..").cooldown > 0",
		"player.buff("..s.ArchmagesGreaterIncandescence..")",
	}, },

		--|(cooldown.potion.remains&trinket.stat.any.up)
	{ s.Stampede, {
		"player.spell("..s.AgilityPotion..").cooldown > 0",
		(function()
			return(dynamicEval("player.agility.proc") or dynamicEval("player.crit.proc") or dynamicEval("player.multistrike.proc"))
		end),
	}, },

		--|target.time_to_die<=25
	{ s.Stampede, { "target.deathin <= 25", }, },

	------------------------------------------------------------------------------------------------
	--actions+=/a_murder_of_crows
	{ s.AMurderofCrows, { "target.deathin > 60", "modifier.cooldowns", }, },
	{ s.AMurderofCrows, { "target.deathin < 12", }, },
	--{ s.AMurderofCrows, { "target.health.actual < 200000", }, },

	------------------------------------------------------------------------------------------------
	--actions+=/black_arrow,if=!ticking
	{ s.BlackArrow, { "player.spell("..s.BlackArrow..").cooldown = 0", "target.deathin > 10", }, },

	------------------------------------------------------------------------------------------------
	--actions+=/explosive_shot
	{ s.ExplosiveShot, {}, },

	------------------------------------------------------------------------------------------------
	--actions+=/dire_beast
	{ s.DireBeast, { "modifier.cooldowns", }, },

	------------------------------------------------------------------------------------------------
	--actions+=/arcane_shot,if=
		--buff.thrill_of_the_hunt.react&focus>35&cast_regen<=focus.deficit
	{ s.ArcaneShot, {
		"player.buff("..s.ThrilloftheHunt..")",
		"player.focus > 35",
		(function()
			return (dynamicEval("player.spell("..s.ArcaneShot..").regen")<=dynamicEval("player.focus.deficit"))
		end),
	}, },

		--|dot.serpent_sting.remains<=3
	{ s.ArcaneShot, { "target.debuff().duration <= 3", }, },

		--|target.time_to_die<4.5
	{ s.ArcaneShot, { "target.deathin < 4.5", }, },

	------------------------------------------------------------------------------------------------
	--actions+=/explosive_trap
	--{ s.ExplosiveTrap1, { "!player.buff("..s.TrapLauncher..")", }, },
	{ s.ExplosiveTrap2, { "player.buff("..s.TrapLauncher..")", "!target.ccinarea(10)", "!modifier.lalt", "target.exists", }, "target.ground", },

	------------------------------------------------------------------------------------------------
	--# Cast a second shot for steady focus if that won't cap us.
	--actions+=/cobra_shot,if=buff.pre_steady_focus.up&buff.steady_focus.remains<5&(14+cast_regen)<=focus.deficit
	{ s.CobraShot, {
		"lastcast("..s.CobraShot..")",
		"player.buff("..s.SteadyFocus..").duration < 5",
		(function()
			return ((14 + dynamicEval("player.spell("..s.CobraShot..").regen")) <= dynamicEval("player.focus.deficit"))
		end),
	}, },

	------------------------------------------------------------------------------------------------
	--actions+=/arcane_shot,if=focus>=80
	{ s.ArcaneShot, { "player.focus >= 80", }, },
	--|talent.focusing_shot.enabled
	{ s.ArcaneShot, { "talent(7,2)", }, },

	------------------------------------------------------------------------------------------------
	--actions+=/focusing_shot
	{ s.FocusingShot, },

	------------------------------------------------------------------------------------------------
	--actions+=/cobra_shot
	{ s.CobraShot, },
}

ProbablyEngine.rotation.register_custom(255, "RotAgent - SurvivalTest",
{
	{ s.PauseIncPet, { "pet.exists", "target.cc", }, },
    { s.Pause, { "!pet.exists", "target.cc", }, },
    { s.PauseIncPet, { "pet.exists", "modifier.lshift", }, },
    { s.Pause, { "!pet.exists", "modifier.lshift", }, },
    { s.PauseIncPet, { "pet.exists", "lastcast("..s.FeignDeath..")", }, },
    { s.Pause, { "!pet.exists", "lastcast("..s.FeignDeath.." )", }, },
    { s.PauseIncPet, { "pet.exists", "player.buff("..s.Food..")", }, },
    { s.Pause, { "!pet.exists", "player.buff("..s.Food..")", }, },

    { opener3plus },
    { opener2 },
    { opener },

	{ defensive },
	{ interrupt },
	{ mouseover },
    { misdirect },
    { petmanagement },
    { poolfocus },
    { pvp },
	{ spellqueue },

	{ combat },
},

{
    { ooc },
    { misdirect },
	{ spellqueue },
},

function()
	ProbablyEngine.toggle.create(
        'autotarget', 'Interface\\Icons\\ability_hunter_snipershot',
        'Auto Target', 'Automatically target the nearest enemy when target dies or does not exist'
    )
    ProbablyEngine.toggle.create(
        'consumables', 'Interface\\Icons\\inv_alchemy_endlessflask_06',
        'Use Consumables', 'Toggle the usage of Flasks/Food/Potions etc..'
    )
    ProbablyEngine.toggle.create(
        'defensives', 'Interface\\Icons\\Ability_warrior_defensivestance',
        'Defensive Abilities', 'Toggle the usage of defensive abilities.'
    )
    ProbablyEngine.toggle.create(
        'md', 'Interface\\Icons\\ability_hunter_misdirection',
        'Misdirect', 'Auto Misdirect to Focus or Pet'
    )
    ProbablyEngine.toggle.create(
        'mouseovers', 'Interface\\Icons\\ability_hunter_quickshot',
        'Mouseover Serpent Sting', 'Automatically apply Arcane Shot/Multi-Shot to mouseover units while in combat'
    )
    ProbablyEngine.toggle.create(
        'nocleave', 'Interface\\Icons\\Warrior_talent_icon_mastercleaver',
        'No Cleave', 'Do not use any cleave/aoe abilities'
    )
    ProbablyEngine.toggle.create(
        'petmgmt', 'Interface\\Icons\\Ability_hunter_beasttraining',
        'Pet Management', 'Pet auto misdirect/attack/heal/revive'
    )
    ProbablyEngine.toggle.create(
        'pvp', 'Interface\\Icons\\Trade_archaeology_troll_voodoodoll',
        'PvP Logic', 'Toggle the usage of basic PvP abilities'
    )

	PrimaryStatsTableInit()
	SecondaryStatsTableInit()

	C_Timer.NewTicker(0.25, (
		function()
			PrimaryStatsTableUpdate()
			SecondaryStatsTableUpdate()
            CurrentTargetInfo()

            if not ProbablyEngine.module.player.combat then
                wipe(CACHEUNITSTABLE)
            end

			-- In Combat Timer Functions
			if ProbablyEngine.config.read('button_states', 'MasterToggle', false)
				and ProbablyEngine.module.player.combat
			then
                CacheEnemyUnits()

                if ProbablyEngine.config.read('button_states', 'autotarget', false)
                then
                    AutoTargetEnemy()
                end
			end
		end),
	nil)
end
)