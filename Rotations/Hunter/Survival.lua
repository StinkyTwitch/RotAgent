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

-- Retruns the key for the supplied configuration table
local function conf(key, default)
	return ProbablyEngine.interface.fetchKey('rasurvival', key, default)
end

local s = {
	-- CORE
	ArcaneShot = "3044",
	AspectoftheCheetah = "5118",
	AspectoftheCheetahCancel = "/script local p='player' for i=1,40 do local _,_,_,_,_,_,_,u,_,_,s=UnitBuff(p,i) if u==p and s==5118 then CancelUnitBuff(p,i) break end end",
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
	AgilityPotionID = "109217",
	HealthStone = "#5512",
	HealthPotion = "#109223",
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
local bosshelp = {
	-- BOSS DEBUFFS
	{ s.ExtraActionButton, {
		"player.buff("..s.Flamethrower..")",
		function() return conf("brackflamethrower", true) == true end,
	}, },
	{ s.FeignDeath, {
		function() return dynamicEval("player.debuff("..s.InfestingSpores..").count >= "..conf('fdinfestingsporestacks', 6).."") end,
	}, },
}
local defensives = {
	{ s.HealthPotion, {
		(function() return conf("consumables", true) == true end),
		(function() return (dynamicEval("player.health") < conf("healthpot", 40)) end),
	}, },
	{ s.HealthStone, {
		(function() return conf("consumables", true) == true end),
		(function() return (dynamicEval("player.health") < conf("healthpot", 40)) end),
	}, },
	{ s.Exhilaration, {
		(function() return (dynamicEval("player.health") < conf("exhilaration", 50)) end),
	}, },
	{ s.Deterrence, {
		(function() return (dynamicEval("player.health") < conf("deterrence", 10)) end),
	}, },
	{ s.MastersCall, { "pet.exists", "player.state.disorient", }, },
	{ s.MastersCall, { "pet.exists", "player.state.stun",  }, },
	{ s.MastersCall, { "pet.exists", "player.state.root",  }, },
	{ s.MastersCall, { "pet.exists", "player.state.snare", "!player.debuff("..s.Dazed..")", }, },
}
local interrupts = {
	{ s.CounterShot, {
		"!player.casting",
		function() return dynamicEval("target.interruptAt("..conf('countershot', 50)..")") end,
	}, },
	{ s.Intimidation, {
		"!player.casting",
		function() return dynamicEval("target.interruptAt("..conf('intimidation', 25)..")") end,
	 }, },
	{ s.WyvernSting, {
		"!player.casting",
		function() return dynamicEval("target.interruptAt("..conf('wyvernsting', 25)..")") end,
	 }, },
}
local miscellaneous = {
	{ s.ConcussiveShot, { "target.moving", "!target.immune.snare", function() return conf("concussiveshot", true) == true end, }, },
	{ s.TranquilizingShot, { "target.dispellable("..s.TranquilizingShot..")", function() return conf("tranqshot", false) == true end, }, },
}
local misdirects = {
	{ s.Misdirection, { "focus.exists", "!focus.dead", "!focus.buff("..s.Misdirection..")", "modifier.lalt", function() return conf('mdkeybind', 'lalt') == 'lalt' end,	}, "focus", },
	{ s.Misdirection, { "focus.exists", "!focus.dead", "!focus.buff("..s.Misdirection..")", "modifier.lcontrol", function() return conf('mdkeybind', 'lalt') == 'lcontrol' end,	}, "focus", },
	{ s.Misdirection, { "focus.exists", "!focus.dead", "!focus.buff("..s.Misdirection..")", "modifier.lshift", function() return conf('mdkeybind', 'lalt') == 'lshift' end,	}, "focus", },
	{ s.Misdirection, { "focus.exists", "!focus.dead", "!focus.buff("..s.Misdirection..")", "modifier.ralt", function() return conf('mdkeybind', 'lalt') == 'ralt' end,	}, "focus", },
	{ s.Misdirection, { "focus.exists", "!focus.dead", "!focus.buff("..s.Misdirection..")", "modifier.rcontrol", function() return conf('mdkeybind', 'lalt') == 'rcontrol' end,	}, "focus", },
	{ s.Misdirection, { "focus.exists", "!focus.dead", "!focus.buff("..s.Misdirection..")", "modifier.rshift", function() return conf('mdkeybind', 'lalt') == 'rshift' end,	}, "focus", },

	{ s.Misdirection, { "!focus.exists", "!mouseovers.dead", "!mouseover.buff("..s.Misdirection..")", "modifier.lalt", function() return conf('mdkeybind', 'lalt') == 'lalt' end, }, "mouseover", },
	{ s.Misdirection, { "!focus.exists", "!mouseovers.dead", "!mouseover.buff("..s.Misdirection..")", "modifier.lcontrol", function() return conf('mdkeybind', 'lalt') == 'lcontrol' end, }, "mouseover", },
	{ s.Misdirection, { "!focus.exists", "!mouseovers.dead", "!mouseover.buff("..s.Misdirection..")", "modifier.lshift", function() return conf('mdkeybind', 'lalt') == 'lshift' end, }, "mouseover", },
	{ s.Misdirection, { "!focus.exists", "!mouseovers.dead", "!mouseover.buff("..s.Misdirection..")", "modifier.ralt", function() return conf('mdkeybind', 'lalt') == 'ralt' end, }, "mouseover", },
	{ s.Misdirection, { "!focus.exists", "!mouseovers.dead", "!mouseover.buff("..s.Misdirection..")", "modifier.rcontrol", function() return conf('mdkeybind', 'lalt') == 'rcontrol' end, }, "mouseover", },
	{ s.Misdirection, { "!focus.exists", "!mouseovers.dead", "!mouseover.buff("..s.Misdirection..")", "modifier.rshift", function() return conf('mdkeybind', 'lalt') == 'rshift' end, }, "mouseover", },

	{ s.Misdirection, { "focus.exists", "!focus.dead", "!focus.buff("..s.Misdirection..")", function() return dynamicEval("player.threat > "..conf('mdfocusagro', 50)) end,	}, "focus", },
}
local mouseovers = {
	{ s.MultiShot, {
		"modifier.multitarget",
		"!mouseover.debuff("..s.SerpentSting..")",
		"!mouseover.cc",
		"!mouseover.ccinarea(8)",
		"mouseover.alive",
		"mouseover.enemy",
		function() return dynamicEval("mouseover.area(8).enemies >= "..conf('msmouseovernumber', 3)) end,
		function() return conf("msmouseover", true) == true end,
		function() return conf("nocleave", false) == false end,
	}, "mouseover", },
	{ s.ArcaneShot, {
		"!mouseover.debuff("..s.SerpentSting..")",
		"!mouseover.cc",
		"mouseover.alive",
		"mouseover.enemy",
	}, "mouseover", },
}
local petmanagement = {
	{ s.Misdirection, { "pet.exists", "!pet.dead", "!pet.buff("..s.Misdirection..")", "!focus.exists", }, "pet", },
	{ s.HeartOfThePhoenix, { "!talent(7,3)", "pet.dead", }, },
	{ s.RevivePet, { "!talent(7,3)", "pet.dead", }, },
	{ s.MendPet, { "pet.exists", "!pet.dead", "!pet.buff("..s.MendPet..")",	function() return dynamicEval("pet.health <= "..conf('petmend', 95).."") end, }, "pet", },
	{ s.PetAttack, { "pet.exists", "timeout(petAttack, 1)", }, },
	{ s.PetDash, { "pet.exists", function() return dynamicEval("pet.distancetotarget > "..conf('petdash', 15).."") end,	"timeout(petDash, 1)", }, },
}
local poolfocus = {
	{ s.CobraShot, { "!talent(7,2)", "modifier.lalt", function() return conf('poolfocuskeybind', 'rcontrol') == 'lalt' end, }, },
	{ s.CobraShot, { "!talent(7,2)", "modifier.lcontrol", function() return conf('poolfocuskeybind', 'rcontrol') == 'lcontrol' end, }, },
	{ s.CobraShot, { "!talent(7,2)", "modifier.lshift", function() return conf('poolfocuskeybind', 'rcontrol') == 'lshift' end, }, },
	{ s.CobraShot, { "!talent(7,2)", "modifier.ralt", function() return conf('poolfocuskeybind', 'rcontrol') == 'ralt' end, }, },
	{ s.CobraShot, { "!talent(7,2)", "modifier.rcontrol", function() return conf('poolfocuskeybind', 'rcontrol') == 'rcontrol' end, }, },
	{ s.CobraShot, { "!talent(7,2)", "modifier.rshift", function() return conf('poolfocuskeybind', 'rcontrol') == 'rshift' end, }, },
	{ s.FocusingShot, { "talent(7,2)", "modifier.lalt", function() return conf('poolfocuskeybind', 'rcontrol') == 'lalt' end, }, },
	{ s.FocusingShot, { "talent(7,2)", "modifier.lcontrol", function() return conf('poolfocuskeybind', 'rcontrol') == 'lcontrol' end, }, },
	{ s.FocusingShot, { "talent(7,2)", "modifier.lshift", function() return conf('poolfocuskeybind', 'rcontrol') == 'lshift' end, }, },
	{ s.FocusingShot, { "talent(7,2)", "modifier.ralt", function() return conf('poolfocuskeybind', 'rcontrol') == 'ralt' end, }, },
	{ s.FocusingShot, { "talent(7,2)", "modifier.rcontrol", function() return conf('poolfocuskeybind', 'rcontrol') == 'rcontrol' end, }, },
	{ s.FocusingShot, { "talent(7,2)", "modifier.rshift", function() return conf('poolfocuskeybind', 'rcontrol') == 'rshift' end, }, },
}
local spellqueue = {
	-- HUNTER TRAPS/GROUND SPELLS
	{ s.ExplosiveTrap1, { "@LibHunter.Queue(13813)", "!player.buff("..s.TrapLauncher..")", }, },
	{ s.ExplosiveTrap2, { "@LibHunter.Queue(82939)", "player.buff("..s.TrapLauncher..")", function() return conf("nocleave", false) == false end, }, "mouseover.ground", },
	{ s.FreezingTrap1, { "@LibHunter.Queue(60192)", "!player.buff("..s.TrapLauncher..")", }, },
	{ s.FreezingTrap2, { "@LibHunter.Queue(60192)", "player.buff("..s.TrapLauncher..")", }, "mouseover.ground", },
	{ s.IceTrap1, { "@LibHunter.Queue(82941)", "!player.buff("..s.TrapLauncher..")", }, },
	{ s.IceTrap2, { "@LibHunter.Queue(82941)", "player.buff("..s.TrapLauncher..")", function() return conf("nocleave", false) == false end, }, "mouseover.ground", },
	{ s.BindingShot, "@LibHunter.Queue(109248)", "mouseover.ground", },
	{ s.Flare, "@LibHunter.Queue(1543)", "mouseover.ground", },
	-- HUNTER GENERAL
	{ s.AMurderofCrows, "@LibHunter.Queue(131894)", },
	{ s.ArcaneShot, "@LibHunter.Queue(3044)", },
	{ s.AspectoftheFox, "@LibHunter.Queue(172106)", },
	{ s.Barrage, { "@LibHunter.Queue(120360)", function() return conf("nocleave", false) == false end, }, },
	{ s.Camouflage, "@LibHunter.Queue(51753)", },
	{ s.ConcussiveShot, "@LibHunter.Queue(5116)", },
	{ s.CounterShot, "@LibHunter.Queue(147362)", },
	{ s.Deterrence, "@LibHunter.Queue(148467)", },
	{ s.DistractingShot, "@LibHunter.Queue(20736)", },
	{ s.FeignDeathNow, "@LibHunter.Queue(5384)", },
	{ s.Flare, "@LibHunter.Queue(1543)", },
	{ s.FocusingShot, "@LibHunter.Queue(152245)", },
	{ s.GlaiveToss, { "@LibHunter.Queue(117050)", function() return conf("nocleave", false) == false end, }, },
	{ s.Intimidation, "@LibHunter.Queue(19577)", },
	{ s.MastersCall, "@LibHunter.Queue(53271)", },
	{ s.MultiShot, { "@LibHunter.Queue(2643)", function() return conf("nocleave", false) == false end, }, },
	{ s.Powershot, { "@LibHunter.Queue(109259)", function() return conf("nocleave", false) == false end, }, },
	{ s.Stampede, "@LibHunter.Queue(121818)", },
	{ s.TranquilizingShot, "@LibHunter.Queue(19801)", },
	{ s.WyvernSting, "@LibHunter.Queue(19386)", },
	{ s.HunterJump, { "@LibHunter.Queue(781)", "timeout(HunterJump, 1)", }, },
	-- HUNTER SURVIVAL
	{ s.BlackArrow, "@LibHunter.Queue(3674)", },
	{ s.ExplosiveShot, "@LibHunter.Queue(53301)", },
}






local trivial = {
	{ s.ArcaneShot, { "player.focus > 65", "!target.debuff("..s.SerpentSting..")", } },
	{ s.BlackArrow, { "player.focus > 35", }, },
	{ s.ExplosiveShot, { "player.focus > 50", }, },
	{ s.FocusingShot, { "player.focus < 35", }, },
	{ s.CobraShot, { "player.focus < 35", }, },
}
local opener3plus = {
	{ s.MultiShot, {
		"!target.debuff("..s.SerpentSting..")",
		"!target.ccinarea(10)",
		function() return conf("nocleave", false) == false end,
	}, },
	{ s.Trinket1, { "modifier.cooldowns", }, },
	{ s.Trinket2, { "modifier.cooldowns", }, },
	{ s.BloodFury, { "modifier.cooldowns", }, },
	{ s.Barrage, {function() return conf("nocleave", false) == false end, }, },
	{ s.ExplosiveTrap2, {
		"player.spell("..s.ExplosiveTrap2..").cooldown = 0",
		"player.buff("..s.TrapLauncher..")",
		"!target.ccinarea(10)",
		"ground.cluster(10)",
		function() return conf("nocleave", false) == false end,
	}, },
	{ s.AMurderofCrows, { "modifier.cooldowns", }, },
}
local opener2 = {
	{ s.ArcaneShot, { "!target.debuff("..s.SerpentSting..")" }, },
	{ s.Trinket1, { "modifier.cooldowns", }, },
	{ s.Trinket2, { "modifier.cooldowns", }, },
	{ s.BloodFury, { "modifier.cooldowns", }, },
	{ s.Barrage, { function() return conf("nocleave", false) == false end, }, },
	{ s.ExplosiveTrap2, { "player.spell("..s.ExplosiveTrap2..").cooldown = 0",
		"player.buff("..s.TrapLauncher..")",
		"!target.ccinarea(10)", "ground.cluster(10)",
		function() return conf("nocleave", false) == false end,
	}, },
	{ s.AMurderofCrows, { "modifier.cooldowns", }, },
	{ s.BlackArrow, },
}
local opener = {
	{ s.Trinket1, { "modifier.cooldowns", }, },
	{ s.Trinket2, { "modifier.cooldowns", }, },
	{ s.BloodFury, { "modifier.cooldowns", }, },
	{ s.AMurderofCrows, { "modifier.cooldowns", }, },
	{ s.ExplosiveShot, },
	{ s.BlackArrow, },
	{ s.ArcaneShot, },
	{ s.ExplosiveShot, { "player.buff("..s.LockandLoad..")", }, },
	{ s.Berserking, { "modifier.cooldowns", }, },
	{ s.ArcaneTorrent, { "modifier.cooldowns", }, },
}
local ooc = {
	{ "pause", { "modifier.lalt", function() return conf('pause_keybind', 'lshift') == 'lalt' end, }, },
	{ "pause", { "modifier.lcontrol", function() return conf('pause_keybind', 'lshift') == 'lcontrol' end, }, },
	{ "pause", { "modifier.lshift", function() return conf('pause_keybind', 'lshift') == 'lshift' end, }, },
	{ "pause", { "modifier.ralt", function() return conf('pause_keybind', 'lshift') == 'ralt' end, }, },
	{ "pause", { "modifier.rcontrol", function() return conf('pause_keybind', 'lshift') == 'rcontrol' end, }, },
	{ "pause", { "modifier.rshift", function() return conf('pause_keybind', 'lshift') == 'rshift' end, }, },
	{ "pause", "player.buff("..s.FeignDeath..")", },
	{ "pause", "player.buff("..s.Food..")", },

	{ s.AspectoftheCheetah, {
		"!player.buff(Aspect of the Cheetah)",
		function() return conf('autoaspect', true) == true end,
		function() return dynamicEval("player.movingfor > "..conf('aspectmovingfor', 2)) end,
	}, },
    { s.AspectoftheCheetahCancel, {
    	function() return conf('autoaspect', true) == true end,
    	function() return dynamicEval("player.lastmoved > "..conf('aspectlastmoved', 2)) end,
    }, },
	{ s.DismissPet, { "pet.exists", "talent(7,3)", }, },
	{ s.RevivePet, { "pet.dead", "!talent(7,3)", }, },
	{ s.MendPet, { "pet.exists", "!pet.dead", "!pet.buff("..s.MendPet..")",	function() return dynamicEval("pet.health <= "..conf('petmend', 95).."") end, }, "pet", },
	{ s.TrapLauncher, {
		"!player.buff("..s.TrapLauncher..")",
		function() return conf('autotraplauncher', true) == true end,
	}, },

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
		(function() return conf("consumables", true) == true end),
	}, },

	--(((cooldown.stampede.remains<1)&(cooldown.a_murder_of_crows.remains<1))|buff.archmages_greater_incandescence_agi.up)
	{ s.AgilityPotion, {
		"player.spell("..s.Stampede..").cooldown < 1",
		"player.spell("..s.AMurderofCrows..").cooldown < 1",
		"player.buff("..s.ArchmagesGreaterIncandescence..")",
		(function() return conf("consumables", true) == true end),
	}, },

	--|target.time_to_die<=25
	{ s.AgilityPotion, { "target.deathin <= 25", (function() return conf("consumables", true) == true end), }, },





	------------------------------------------------------------------------------------------------
	--actions+=/call_action_list,name=aoe,if=active_enemies>1
	{{
		--------------------------------------------------------------------------------------------
		--actions.aoe=stampede,if=
			--buff.potion.up
		{ s.Stampede, { "player.buff("..s.AgilityPotionID..")", }, },
			--|cooldown.potion.remains&buff.archmages_greater_incandescence_agi.up
		{ s.Stampede, {
			"player.item("..s.AgilityPotionID..").cooldown > 0",
			"player.buff("..s.ArchmagesGreaterIncandescence..")",
		}, },
			--|cooldown.potion.remains&trinket.stat.any.up
		{ s.Stampede, {
			"player.item("..s.AgilityPotionID..").cooldown > 0",
			(function()
				return(dynamicEval("player.agility.proc") or dynamicEval("player.crit.proc") or dynamicEval("player.multistrike.proc"))
			end),
		}, },
			--|cooldown.potion.remains&buff.archmages_incandescence_agi.up
		{ s.Stampede, {
			"player.item("..s.AgilityPotionID..").cooldown > 0",
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
		{ s.Barrage, { function() return conf("nocleave", false) == false end, }, },

		--------------------------------------------------------------------------------------------
		--actions.aoe+=/black_arrow,if=!ticking
		{ s.BlackArrow, { "player.spell("..s.BlackArrow..").cooldown = 0", "target.deathin > 10", }, },

		--------------------------------------------------------------------------------------------
		--actions.aoe+=/explosive_shot,if=active_enemies<5
		{ s.ExplosiveShot, { "target.area(10).enemies < 5", }, },

		--------------------------------------------------------------------------------------------
		--actions.aoe+=/explosive_trap,if=dot.explosive_trap.remains<=5
		{ s.ExplosiveTrap1, {
			"player.spell("..s.ExplosiveTrap2..").cooldown = 0",
			"!player.buff("..s.TrapLauncher..")",
			"!player.ccinarea(10)",
			function() return conf("nocleave", false) == false end,
		}, },
		{ s.ExplosiveTrap2, {
			"player.spell("..s.ExplosiveTrap2..").cooldown = 0",
			"player.buff("..s.TrapLauncher..")",
			"!target.ccinarea(10)",
			"ground.cluster(10)",
			function() return conf("nocleave", false) == false end,
		}, },


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
			function() return(dynamicEval("player.spell("..s.MultiShot..").regen")<=dynamicEval("player.focus.deficit")) end,
			function() return conf("nocleave", false) == false end,
		}, },

		--------------------------------------------------------------------------------------------
		--actions.aoe+=/glaive_toss
		{ s.GlaiveToss, { "target.deathin > 5", function() return conf("nocleave", false) == false end, }, },

		--------------------------------------------------------------------------------------------
		--actions.aoe+=/powershot
		{ s.Powershot, { "target.deathin > 20", function() return conf("nocleave", false) == false end, }, },

		--------------------------------------------------------------------------------------------
		--actions.aoe+=/cobra_shot,if=buff.pre_steady_focus.up&buff.steady_focus.remains<5&focus+14+cast_regen<80
		{ s.CobraShot, {
			"lastcast("..s.CobraShot..")",
			"player.buff("..s.SteadyFocus..").duration < 5",
			function() return ((dynamicEval("player.focus") + 14 + dynamicEval("player.spell("..s.CobraShot..").regen")) < 80) end,
		}, },
		--------------------------------------------------------------------------------------------
		--actions.aoe+=/multishot,if=focus>=70|talent.focusing_shot.enabled
		{ s.MultiShot, { "player.focus > 70", function() return conf("nocleave", false) == false end, }, },
		{ s.MultiShot, { "talent(7,2)", function() return conf("nocleave", false) == false end, }, },

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
	{ s.Stampede, { "player.buff("..s.AgilityPotionID..")", }, },

		--|(cooldown.potion.remains&(buff.archmages_greater_incandescence_agi.up)
	{ s.Stampede, {
		"player.item("..s.AgilityPotionID..").cooldown > 0",
		"player.buff("..s.ArchmagesGreaterIncandescence..")",
	}, },

		--|(cooldown.potion.remains&trinket.stat.any.up)
	{ s.Stampede, {
		"player.item("..s.AgilityPotionID..").cooldown > 0",
		function()
			return(dynamicEval("player.agility.proc") or dynamicEval("player.crit.proc") or dynamicEval("player.multistrike.proc"))
		end,
	}, },

		--|target.time_to_die<=25
	{ s.Stampede, { "target.deathin <= 25", }, },

	------------------------------------------------------------------------------------------------
	--actions+=/a_murder_of_crows
	{ s.AMurderofCrows, { "target.deathin > 60", "modifier.cooldowns", }, },
	{ s.AMurderofCrows, { "target.deathin < 12", "target.deathin > 1", }, },
	{ s.AMurderofCrows, { "target.health.actual < 200000", }, },

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
		function() return (dynamicEval("player.spell("..s.ArcaneShot..").regen")<=dynamicEval("player.focus.deficit")) end,
	}, },

		--|dot.serpent_sting.remains<=3
	{ s.ArcaneShot, { "target.debuff("..s.SerpentSting..").duration <= 3", }, },

		--|target.time_to_die<4.5
	{ s.ArcaneShot, { "target.deathin < 4.5", }, },

	------------------------------------------------------------------------------------------------
	--actions+=/explosive_trap
	{ s.ExplosiveTrap1, {
		"player.spell("..s.ExplosiveTrap2..").cooldown = 0",
		"!player.buff("..s.TrapLauncher..")", "!player.ccinarea(10)",
		function() return conf("nocleave", false) == false end,
	}, },
	{ s.ExplosiveTrap2, {
		"player.spell("..s.ExplosiveTrap2..").cooldown = 0",
		"player.buff("..s.TrapLauncher..")",
		"target.exists",
		"!target.ccinarea(10)",
		function() return conf("nocleave", false) == false end,
	}, "target.ground", },

	------------------------------------------------------------------------------------------------
	--# Cast a second shot for steady focus if that won't cap us.
	--actions+=/cobra_shot,if=buff.pre_steady_focus.up&buff.steady_focus.remains<5&(14+cast_regen)<=focus.deficit
	{ s.CobraShot, {
		"lastcast("..s.CobraShot..")",
		"player.buff("..s.SteadyFocus..").duration < 5",
		function() return ((14 + dynamicEval("player.spell("..s.CobraShot..").regen")) <= dynamicEval("player.focus.deficit")) end,
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
-- COMBAT
{
	{ s.PauseIncPet, { "pet.exists", "target.cc", }, },
	{ s.Pause, { "!pet.exists", "target.cc", }, },
	{ s.PauseIncPet, { "pet.exists", "lastcast("..s.FeignDeath..")", }, },
	{ s.Pause, { "!pet.exists", "lastcast("..s.FeignDeath.." )", }, },
	{ s.PauseIncPet, { "pet.exists", "player.buff("..s.Food..")", }, },
	{ s.Pause, { "!pet.exists", "player.buff("..s.Food..")", }, },
	{ s.PauseIncPet, { "modifier.lalt", function() return conf('pause_keybind', 'lshift') == 'lalt' end, }, },
	{ s.PauseIncPet, { "modifier.lcontrol", function() return conf('pause_keybind', 'lshift') == 'lcontrol' end, }, },
	{ s.PauseIncPet, { "modifier.lshift", function() return conf('pause_keybind', 'lshift') == 'lshift' end, }, },
	{ s.PauseIncPet, { "modifier.ralt", function() return conf('pause_keybind', 'lshift') == 'ralt' end, }, },
	{ s.PauseIncPet, { "modifier.rcontrol", function() return conf('pause_keybind', 'lshift') == 'rcontrol' end, }, },
	{ s.PauseIncPet, { "modifier.rshift", function() return conf('pause_keybind', 'lshift') == 'rshift' end, }, },

	{ trivial, { "target.health.actual < 100000", }, },
	{ opener3plus, { "target.area(10).enemies >= 3", "modifier.multitarget", "player.time < 4", }, },
	{ opener2, { "target.area(10).enemies >= 2", "modifier.multitarget", "player.time < 4", }, },
	{ opener, { "player.time < 4", }, },

	{ bosshelp, function() return conf("bosslogic", true) == true end, },
	{ defensives, function() return conf("defensives", true) == true end, },
	{ interrupts, },
	{ miscellaneous, },
	{ misdirects, function() return conf("misdirects", true) == true end, },
	{ mouseovers, function() return conf("mouseovers", true) == true end, },
	{ petmanagement, function() return conf("petmanagement", true) == true end, },
	{ poolfocus, },
	{ spellqueue, },

	{ combat, },
},

-- OUT OF COMBAT
{
	{ ooc, },
	{ misdirects, },
	{ spellqueue, },
},

-- CALLBACK
function()
	--[[--------------------------------------------------------------------------------------------
	-- SPLASH LOGO
	--------------------------------------------------------------------------------------------]]--
	local function onUpdate(RotAgentSplash,elapsed)
		if RotAgentSplash.time < GetTime() - 8.0 then
			if RotAgentSplash:GetAlpha() then
				RotAgentSplash:Hide()
			else
				RotAgentSplash:SetAlpha(RotAgentSplash:GetAlpha() - .05)
			end
		end
	end
	local function RotAgentSplashFrame()
		if conf('splash', true) then
		--if fetch('rasurvival', 'splash') then
			RotAgentSplash:SetAlpha(1)
			RotAgentSplash.time = GetTime()
			RotAgentSplash:Show()
		end
	end
	local function RotAgentSplashInitialize()
		if not RotAgentSplash then
			RotAgentSplash = CreateFrame("Frame", nil,UIParent)
			RotAgentSplash:SetPoint("CENTER",UIParent)
			RotAgentSplash:SetWidth(512)
			RotAgentSplash:SetHeight(512)
			RotAgentSplash:SetBackdrop({ bgFile = "Interface\\AddOns\\RotAgent\\Library\\Media\\splash.blp" })
			RotAgentSplash:SetScript("onUpdate",onUpdate)
			RotAgentSplash:Hide()
			RotAgentSplash.time = 0

			RotAgentSplashFrame()
		end
	end
	RotAgentSplashInitialize()


	--[[--------------------------------------------------------------------------------------------
	-- CONFIGURATION
	--------------------------------------------------------------------------------------------]]--
	local rasurvival_gui = ProbablyEngine.interface.buildGUI({
		key = 'rasurvival',
		title = 'RotAgent',
		subtitle = 'Survival Hunter',
		profiles = true,
		width = 275,
		height = 500,
		color = "4e7300",
		config = {
			{ type = 'rule', },
			{ type = 'header', text = 'Basics', },
			{ type = 'rule', },
			{ type = 'checkbox', key = 'autotarget', text = 'Auto Target Logic', default = true, },
			{ type = 'checkbox', key = 'autotraplauncher', text = 'Auto Trap Launcher Logic', default = true, },
			{ type = 'checkbox', key = 'autoaspect', text = 'Auto Aspect of the Cheetah', default = false, },
			{ type = 'checkbox', key = 'bosslogic', text = 'Boss Logic', default = true, },
			{ type = 'checkbox', key = 'consumables', text = 'Consumable Logic', default = false, },
			{ type = 'checkbox', key = 'defensives', text = 'Defensive Logic', default = true, },
			{ type = 'checkbox', key = 'misdirects', text = 'Misdirection Logic', default = true, },
			{ type = 'checkbox', key = 'mouseovers', text = 'Mouseover Logic', default = true, },
			{ type = 'checkbox', key = 'pause', text = 'Pause on Keybind', default = true, },
			{ type = 'checkbox', key = 'petmanagement', text = 'Pet Management', default = true, },
			{ type = 'text', text = '', offset = 20, },

			{ type = 'rule', },
			{ type = 'header', text = 'Advanced',},
			{ type = 'rule', },

			{ type = 'header', text = 'Aspect of the Pack',},
			{ type = 'spinner', key = 'aspectmovingfor', text = 'Aspect after Moving for |cffaaaaaaX seconds|r', min = 0, max = 10, step = 1, default = 2, },
			{ type = 'spinner', key = 'aspectlastmoved', text = 'Cancel after not Moving for |cffaaaaaaX seconds|r', min = 0, max = 10, step = 1, default = 2, desc = 'Aspect of the Pack will be cast if the player has been moving for X seconds. Aspect will be cancelled if player has stopped moving for X seconds. 0 is instantaneous.', },
			{ type = 'rule', },

			{ type = 'header', text = 'Boss Logic' },
			{ type = 'checkbox', key = 'brackflamethrower', text = 'Turn off Flamethrower if activated', default = true },
			{ type = 'checkspin', key = 'fdinfestingsporestacks', text = 'Feign Death Infesting Spores |cffaaaaaaStacks >|r', default_check = true, default_spin = 6, },
			{ type = 'rule', },

			{ type = 'header', text = 'Cleave/Splash Damage',},
			{ type = 'checkbox', key = 'nocleave', text = 'No Cleave (prevent any AoE)', default = false },
			{ type = 'rule', },

			{ type = 'header', text = 'Consumables' },
			{ type = 'spinner', key = 'healthpot', text = 'Health Potion/Stone at |cffaaaaaaHP < %|r', default = 40, },
			{ type = 'rule' },

			{ type = 'header', text = 'Defensive Logic' },
			{ type = 'spinner', key = 'exhilaration', text = 'Exhilaration at |cffaaaaaaHP < %|r', default = 60, },
			{ type = 'spinner', key = 'deterrence', text = 'Deterrence at |cffaaaaaaHP < %|r', default = 10 },
			{ type = 'rule' },

			{ type = 'header', text = 'Interrupt Logic' },
			{ type = 'spinner', key = 'countershot', text = 'Counter Shot at |cffaaaaaaX% of cast|r', min = 30, max = 100, step = 1, default = 50, },
			{ type = 'spinner', key = 'intimidation', text = 'Intimidation at |cffaaaaaaX% of cast|r', min = 30, max = 100, step = 1, default = 25, },
			{ type = 'spinner', key = 'wyvernsting', text = 'Wyvern Sting at |cffaaaaaaX% of cast|r', min = 30, max = 100, step = 1, default = 25, },
			{ type = 'rule' },

			{ type = 'header', text = 'Miscellaneous' },
			{ type = 'checkbox', key = 'concussiveshot', text = 'Concussive Shot moving targets', default = true, },
			{ type = 'checkbox', key = 'tranqshot', text = 'Tranquilize dispellable buffs', default = false, desc = 'Automatically attempt to remove dispellabe Magic or Enrage effects with Tranquilizing Shot.', },
			{ type = 'rule', },

			{ type = 'header', text = 'Misdirection' },
			{ type = 'spinner', key = 'mdfocusagro', text = 'Misdirect to Focus at |cffaaaaaaX% aggro|r', default = 50, },
			{ type = 'dropdown', key = 'mdkeybind', text = 'Misdirection Keybind', list = {
				{ key = 'lalt', text = 'lalt' },
				{ key = 'lcontrol', text = 'lcontrol' },
				{ key = 'lshift', text = 'lshift' },
				{ key = 'ralt', text = 'ralt' },
				{ key = 'rcontrol', text = 'rcontrol' },
				{ key = 'rshift', text = 'rshift' },
			}, default = 'lalt', desc = 'Misdirect to Focus Target, if no Focus Misdirect to Mouseover Target', },
			{ type = 'rule' },

			{ type = 'header', text = 'Mouseovers' },
			{ type = 'checkbox', key = 'asmouseover', text = 'Arcane Shot to Serpent Sting', default = true, },
			{ type = 'checkbox', key = 'msmouseover', text = 'Multi-Shot to Serpent Sting AoE', default = true, },
			{ type = 'spinner', key = 'msmouseovernumber', text = 'Use Multi-Shot if number of Targets |cffaaaaaais >=|r', min = 2, max = 20, step = 1, default = 3 },
			{ type = 'rule' },

			{ type = 'header', text = 'Pause',},
			{ type = 'dropdown', key = 'pause_keybind', text = 'Pause Keybind', list = {
				{ key = 'lalt', text = 'lalt' },
				{ key = 'lcontrol', text = 'lcontrol' },
				{ key = 'lshift', text = 'lshift' },
				{ key = 'ralt', text = 'ralt' },
				{ key = 'rcontrol', text = 'rcontrol' },
				{ key = 'rshift', text = 'rshift' },
			}, default = 'lshift' },
			{ type = 'rule', },

			{ type = 'header', text = 'Pet Management' },
			{ type = 'spinner', key = 'petmend', text = 'Mend Pet at |cffaaaaaaHP < %|r', default = 95, },
			{ type = 'spinner', key = 'petdash', text = 'Use Dash if |cffaaaaaaTarget > Distance|r', min = 1, max = 40, step = 1, default = 15, },
			{ type = 'rule' },

			{ type = 'header', text = 'Pool Focus',},
			{ type = 'dropdown', key = 'poolfocuskeybind', text = 'Focus pooling Keybind', list = {
				{ key = 'lalt', text = 'lalt' },
				{ key = 'lcontrol', text = 'lcontrol' },
				{ key = 'lshift', text = 'lshift' },
				{ key = 'ralt', text = 'ralt' },
				{ key = 'rcontrol', text = 'rcontrol' },
				{ key = 'rshift', text = 'rshift' },
			}, default = 'rcontrol' },
			{ type = 'rule' },

			{ type = 'header', text = 'Extra' },
			{ type = 'checkbox', key = 'autolfg', text = 'Auto LGF Accept', default = false, },
			{ type = "checkbox", key = 'splash', text = "Splash Image", default = true, },
		}
	})
	rasurvival_gui.parent:Hide()


	--[[--------------------------------------------------------------------------------------------
	-- TOGGLE BUTTONS
	--------------------------------------------------------------------------------------------]]--
	ProbablyEngine.buttons.create(
		'config', 'Interface\\ICONS\\Inv_misc_gear_01',
		function(self)
			self.checked = false
			ProbablyEngine.buttons.setInactive('config')
			rasurvival_gui.parent:Show()
		end,
		'Configure', 'Change how the rotation behaves.'
	)
	ProbablyEngine.buttons.create(
		'cacheinfo', 'Interface\\ICONS\\Inv_misc_enggizmos_17',
		function(self)
			self.checked = false
			ProbablyEngine.buttons.setInactive('cacheinfo')
			LiveUnitCacheTableShow()
		end,
		'Live Unit Cache Info', 'Shows live unit cache data.'
	)
	ProbablyEngine.buttons.create(
		'targetinfo', 'Interface\\ICONS\\Ability_hunter_markedfordeath',
		function(self)
			self.checked = false
			ProbablyEngine.buttons.setInactive('targetinfo')
			LiveTargetTableShow()
		end,
		'Live Target Info', 'Shows live target info data.'
	)


	--[[--------------------------------------------------------------------------------------------
	-- INITIALIZATION CODE
	--------------------------------------------------------------------------------------------]]--
	PrimaryStatsTableInit()
	SecondaryStatsTableInit()


	--[[--------------------------------------------------------------------------------------------
	-- ROTATION TIMER
	--------------------------------------------------------------------------------------------]]--
	C_Timer.NewTicker(0.25,
		(function()
			if ProbablyEngine.config.read('button_states', 'MasterToggle', false) then
				-- Run ONLY if the Rotation is toggled ON
				PrimaryStatsTableUpdate()
				SecondaryStatsTableUpdate()
				LiveUnitCacheTableUpdate()
				LiveTargetTableUpdate()

				if FireHack or oexecute then
					CurrentTargetTableInfo("target")
					CacheEnemyUnits()
				end

				-- Run ONLY if in Combat
				if ProbablyEngine.module.player.combat then

					--if ProbablyEngine.config.read('button_states', 'autotarget', false) then
					if conf('autotarget', true) then
						AutoTargetEnemy()
					end
				end
				if conf('autolfg', false) then
					--ProbablyEngine.config.read('autolfg', true)
                    ProbablyEngine.config.write('autolfg', true)
				else
					--ProbablyEngine.config.read('autolfg', false)
                    ProbablyEngine.config.write('autolfg', false)
				end
			end
		end),
	nil)
end
)