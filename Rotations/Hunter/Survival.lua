--[[------------------------------------------------------------------------------------------------
	Survival.lua

	RotAgent (Rotation Agent) License
	This work is licensed under the Creative Commons Attribution-NonCommercial 4.0 International
	License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc/4.0/.

--------------------------------------------------------------------------------------------------]]
local RotAgentName, RotAgent = ...

local function dynamicEval(condition, spell)
	if not condition then return false end
	return ProbablyEngine.dsl.parse(condition, spell or '')
end

-- Retruns the key for the supplied configuration table
local function fetch(key, default)
	return ProbablyEngine.interface.fetchKey('rasurvival', key, default)
end

local s = RotAgent.HunterSpellsStrings

local bosshelp = {
	-- BOSS DEBUFFS
	{ s.ExtraActionButton, {
		"player.buff("..s.Flamethrower..")",
		function() return fetch("brackflamethrower", true) == true end,
	}, },
	{ s.FeignDeath, {
		function() return dynamicEval("player.debuff("..s.InfestingSpores..").count >= "..fetch('fdinfestingsporestacks', 6).."") end,
	}, },
}
local defensives = {
	{ s.HealthPotion, {
		(function() return fetch("consumables", true) == true end),
		(function() return (dynamicEval("player.health") < fetch("healthpot", 40)) end),
	}, },
	{ s.HealthStone, {
		(function() return fetch("consumables", true) == true end),
		(function() return (dynamicEval("player.health") < fetch("healthpot", 40)) end),
	}, },
	{ s.Exhilaration, {
		(function() return (dynamicEval("player.health") < fetch("exhilaration", 50)) end),
	}, },
	{ s.Deterrence, {
		(function() return (dynamicEval("player.health") < fetch("deterrence", 10)) end),
	}, },
	{ s.MastersCall, { "pet.exists", "player.state.disorient", }, },
	{ s.MastersCall, { "pet.exists", "player.state.stun",  }, },
	{ s.MastersCall, { "pet.exists", "player.state.root",  }, },
	{ s.MastersCall, { "pet.exists", "player.state.snare", "!player.debuff("..s.Dazed..")", }, },
}
local interrupts = {
	{ s.CounterShot, {
		"!player.casting",
		"player.spell("..s.CounterShot..").cooldown = 0",
		function() return dynamicEval("target.interruptAt("..fetch('countershot', 50)..")") end,
	}, },
	{ s.Intimidation, {
		"!player.casting",
		"player.spell("..s.Intimidation..").cooldown = 0",
		function() return dynamicEval("target.interruptAt("..fetch('intimidation', 25)..")") end,
	 }, },
	{ s.WyvernSting, {
		"!player.casting",
		"player.spell("..s.WyvernSting..").cooldown = 0",
		function() return dynamicEval("target.interruptAt("..fetch('wyvernsting', 25)..")") end,
	 }, },
}
local miscellaneous = {
	{ s.ConcussiveShot, { "target.moving", "!target.immune.snare", function() return fetch("concussiveshot", true) == true end, }, },
	{ s.TranquilizingShot, { "target.dispellable("..s.TranquilizingShot..")", function() return fetch("tranqshot", false) == true end, }, },
}
local misdirects = {
	{ s.Misdirection, { "focus.exists", "!focus.dead", "!focus.buff("..s.Misdirection..")", "modifier.lalt", function() return fetch('mdkeybind', 'lalt') == 'lalt' end,	}, "focus", },
	{ s.Misdirection, { "focus.exists", "!focus.dead", "!focus.buff("..s.Misdirection..")", "modifier.lcontrol", function() return fetch('mdkeybind', 'lalt') == 'lcontrol' end,	}, "focus", },
	{ s.Misdirection, { "focus.exists", "!focus.dead", "!focus.buff("..s.Misdirection..")", "modifier.lshift", function() return fetch('mdkeybind', 'lalt') == 'lshift' end,	}, "focus", },
	{ s.Misdirection, { "focus.exists", "!focus.dead", "!focus.buff("..s.Misdirection..")", "modifier.ralt", function() return fetch('mdkeybind', 'lalt') == 'ralt' end,	}, "focus", },
	{ s.Misdirection, { "focus.exists", "!focus.dead", "!focus.buff("..s.Misdirection..")", "modifier.rcontrol", function() return fetch('mdkeybind', 'lalt') == 'rcontrol' end,	}, "focus", },
	{ s.Misdirection, { "focus.exists", "!focus.dead", "!focus.buff("..s.Misdirection..")", "modifier.rshift", function() return fetch('mdkeybind', 'lalt') == 'rshift' end,	}, "focus", },

	{ s.Misdirection, { "!focus.exists", "!mouseovers.dead", "!mouseover.buff("..s.Misdirection..")", "modifier.lalt", function() return fetch('mdkeybind', 'lalt') == 'lalt' end, }, "mouseover", },
	{ s.Misdirection, { "!focus.exists", "!mouseovers.dead", "!mouseover.buff("..s.Misdirection..")", "modifier.lcontrol", function() return fetch('mdkeybind', 'lalt') == 'lcontrol' end, }, "mouseover", },
	{ s.Misdirection, { "!focus.exists", "!mouseovers.dead", "!mouseover.buff("..s.Misdirection..")", "modifier.lshift", function() return fetch('mdkeybind', 'lalt') == 'lshift' end, }, "mouseover", },
	{ s.Misdirection, { "!focus.exists", "!mouseovers.dead", "!mouseover.buff("..s.Misdirection..")", "modifier.ralt", function() return fetch('mdkeybind', 'lalt') == 'ralt' end, }, "mouseover", },
	{ s.Misdirection, { "!focus.exists", "!mouseovers.dead", "!mouseover.buff("..s.Misdirection..")", "modifier.rcontrol", function() return fetch('mdkeybind', 'lalt') == 'rcontrol' end, }, "mouseover", },
	{ s.Misdirection, { "!focus.exists", "!mouseovers.dead", "!mouseover.buff("..s.Misdirection..")", "modifier.rshift", function() return fetch('mdkeybind', 'lalt') == 'rshift' end, }, "mouseover", },

	{ s.Misdirection, { "focus.exists", "!focus.dead", "!focus.buff("..s.Misdirection..")", function() return dynamicEval("player.threat > "..fetch('mdfocusagro', 50)) end,	}, "focus", },
}
local mouseovers = {
	{ s.MultiShot, {
		"modifier.multitarget",
		"!mouseover.debuff("..s.SerpentSting..")",
		"!mouseover.cc",
		"!mouseover.ccinarea(8)",
		"mouseover.alive",
		"mouseover.enemy",
		function() return dynamicEval("mouseover.rotagentarea(8).enemies >= "..fetch('msmouseovernumber', 3)) end,
		function() return fetch("msmouseover", true) == true end,
		function() return fetch("nocleave", false) == false end,
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
	{ s.MendPet, { "pet.exists", "!pet.dead", "!pet.buff("..s.MendPet..")",	function() return dynamicEval("pet.health <= "..fetch('petmend', 95).."") end, }, "pet", },
	{ s.PetAttack, { "pet.exists", "timeout(petAttack, 1)", }, },
	{ s.PetDash, { "pet.exists", function() return dynamicEval("pet.distancetotarget > "..fetch('petdash', 15).."") end, "timeout(petDash, 1)", }, },
}
local poolfocus = {
	{ s.CobraShot, { "!talent(7,2)", "modifier.lalt", function() return fetch('poolfocuskeybind', 'rcontrol') == 'lalt' end, }, },
	{ s.CobraShot, { "!talent(7,2)", "modifier.lcontrol", function() return fetch('poolfocuskeybind', 'rcontrol') == 'lcontrol' end, }, },
	{ s.CobraShot, { "!talent(7,2)", "modifier.lshift", function() return fetch('poolfocuskeybind', 'rcontrol') == 'lshift' end, }, },
	{ s.CobraShot, { "!talent(7,2)", "modifier.ralt", function() return fetch('poolfocuskeybind', 'rcontrol') == 'ralt' end, }, },
	{ s.CobraShot, { "!talent(7,2)", "modifier.rcontrol", function() return fetch('poolfocuskeybind', 'rcontrol') == 'rcontrol' end, }, },
	{ s.CobraShot, { "!talent(7,2)", "modifier.rshift", function() return fetch('poolfocuskeybind', 'rcontrol') == 'rshift' end, }, },
	{ s.FocusingShot, { "talent(7,2)", "modifier.lalt", function() return fetch('poolfocuskeybind', 'rcontrol') == 'lalt' end, }, },
	{ s.FocusingShot, { "talent(7,2)", "modifier.lcontrol", function() return fetch('poolfocuskeybind', 'rcontrol') == 'lcontrol' end, }, },
	{ s.FocusingShot, { "talent(7,2)", "modifier.lshift", function() return fetch('poolfocuskeybind', 'rcontrol') == 'lshift' end, }, },
	{ s.FocusingShot, { "talent(7,2)", "modifier.ralt", function() return fetch('poolfocuskeybind', 'rcontrol') == 'ralt' end, }, },
	{ s.FocusingShot, { "talent(7,2)", "modifier.rcontrol", function() return fetch('poolfocuskeybind', 'rcontrol') == 'rcontrol' end, }, },
	{ s.FocusingShot, { "talent(7,2)", "modifier.rshift", function() return fetch('poolfocuskeybind', 'rcontrol') == 'rshift' end, }, },
}
local spellqueue = {
	-- HUNTER TRAPS/GROUND SPELLS
	{ s.ExplosiveTrap1, { "@RotAgent.Queue(13813)", "!player.buff("..s.TrapLauncher..")", }, },
	{ s.ExplosiveTrap2, { "@RotAgent.Queue(82939)", "player.buff("..s.TrapLauncher..")", }, "mouseover.ground", },
	{ s.FreezingTrap1, { "@RotAgent.Queue(60192)", "!player.buff("..s.TrapLauncher..")", }, },
	{ s.FreezingTrap2, { "@RotAgent.Queue(60192)", "player.buff("..s.TrapLauncher..")", }, "mouseover.ground", },
	{ s.IceTrap1, { "@RotAgent.Queue(82941)", "!player.buff("..s.TrapLauncher..")", }, },
	{ s.IceTrap2, { "@RotAgent.Queue(82941)", "player.buff("..s.TrapLauncher..")", }, "mouseover.ground", },
	{ s.BindingShot, "@RotAgent.Queue(109248)", "mouseover.ground", },
	{ s.Flare, "@RotAgent.Queue(1543)", "mouseover.ground", },
	-- HUNTER GENERAL
	{ s.AMurderofCrows, "@RotAgent.Queue(131894)", },
	{ s.ArcaneShot, "@RotAgent.Queue(3044)", },
	{ s.AspectoftheFox, "@RotAgent.Queue(172106)", },
	{ s.Barrage, { "@RotAgent.Queue(120360)", }, },
	{ s.Camouflage, "@RotAgent.Queue(51753)", },
	{ s.ConcussiveShot, "@RotAgent.Queue(5116)", },
	{ s.CounterShot, "@RotAgent.Queue(147362)", },
	{ s.Deterrence, "@RotAgent.Queue(148467)", },
	{ s.DistractingShot, "@RotAgent.Queue(20736)", },
	{ s.FeignDeathNow, "@RotAgent.Queue(5384)", },
	{ s.Flare, "@RotAgent.Queue(1543)", },
	{ s.FocusingShot, "@RotAgent.Queue(152245)", },
	{ s.GlaiveToss, { "@RotAgent.Queue(117050)", }, },
	{ s.Intimidation, "@RotAgent.Queue(19577)", },
	{ s.MastersCall, "@RotAgent.Queue(53271)", },
	{ s.MultiShot, { "@RotAgent.Queue(2643)", }, },
	{ s.Powershot, { "@RotAgent.Queue(109259)", }, },
	{ s.Stampede, "@RotAgent.Queue(121818)", },
	{ s.TranquilizingShot, "@RotAgent.Queue(19801)", },
	{ s.WyvernSting, "@RotAgent.Queue(19386)", },
	{ s.HunterJump, { "@RotAgent.Queue(781)", "timeout(HunterJump, 1)", }, },
	-- HUNTER SURVIVAL
	{ s.BlackArrow, "@RotAgent.Queue(3674)", },
	{ s.ExplosiveShot, "@RotAgent.Queue(53301)", },
}





local ooc = {
	{ "", (function()
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
					local aCheck = select(6,strsplit("-",UnitGUID(a)))
					local bCheck = select(6,strsplit("-", UnitGUID(b)))

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
	{ "pause", { "modifier.lalt", function() return fetch('pause_keybind', 'lshift') == 'lalt' end, }, },
	{ "pause", { "modifier.lcontrol", function() return fetch('pause_keybind', 'lshift') == 'lcontrol' end, }, },
	{ "pause", { "modifier.lshift", function() return fetch('pause_keybind', 'lshift') == 'lshift' end, }, },
	{ "pause", { "modifier.ralt", function() return fetch('pause_keybind', 'lshift') == 'ralt' end, }, },
	{ "pause", { "modifier.rcontrol", function() return fetch('pause_keybind', 'lshift') == 'rcontrol' end, }, },
	{ "pause", { "modifier.rshift", function() return fetch('pause_keybind', 'lshift') == 'rshift' end, }, },
	{ "pause", "player.buff("..s.FeignDeath..")", },
	{ "pause", "player.buff("..s.Food..")", },

	{ s.AspectoftheCheetah, {
		"!player.buff("..s.AspectoftheCheetah..")",
		function() return fetch('autoaspect', true) == true end,
		function() return dynamicEval("player.movingfor > "..fetch('aspectmovingfor', 2)) end,
	}, },
	{ s.DismissPet, { "pet.exists", "talent(7,3)", }, },
	{ s.RevivePet, { "pet.dead", "!talent(7,3)", }, },
	{ s.MendPet, { "pet.exists", "!pet.dead", "!pet.buff("..s.MendPet..")",	function() return dynamicEval("pet.health <= "..fetch('petmend', 95).."") end, }, "pet", },
	{ s.TrapLauncher, {
		"!player.buff("..s.TrapLauncher..")",
		function() return fetch('autotraplauncher', true) == true end,
	}, },
}
local opener3plus = {
	{ s.MultiShot, {
		"!target.debuff("..s.SerpentSting..")",
		"!target.ccinarea(10)",
		function() return fetch("nocleave", false) == false end,
	}, },
	{ s.Trinket1, { "modifier.cooldowns", }, },
	{ s.Trinket2, { "modifier.cooldowns", }, },
	{ s.BloodFury, { "modifier.cooldowns", }, },
	{ s.Barrage, {function() return fetch("nocleave", false) == false end, }, },
	{ s.ExplosiveTrap2, {
		"player.spell("..s.ExplosiveTrap2..").cooldown = 0",
		"player.buff("..s.TrapLauncher..")",
		"!target.ccinarea(10)",
		"ground.cluster(10)",
		function() return fetch("nocleave", false) == false end,
	}, },
	{ s.AMurderofCrows, { "modifier.cooldowns", }, },
}
local opener2 = {
	{ s.ArcaneShot, { "!target.debuff("..s.SerpentSting..")" }, },
	{ s.Trinket1, { "modifier.cooldowns", }, },
	{ s.Trinket2, { "modifier.cooldowns", }, },
	{ s.BloodFury, { "modifier.cooldowns", }, },
	{ s.Barrage, { function() return fetch("nocleave", false) == false end, }, },
	{ s.ExplosiveTrap2, { "player.spell("..s.ExplosiveTrap2..").cooldown = 0",
		"player.buff("..s.TrapLauncher..")",
		"!target.ccinarea(10)", "ground.cluster(10)",
		function() return fetch("nocleave", false) == false end,
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
local trivial = {
	{ s.ArcaneShot, { "player.focus > 65", "!target.debuff("..s.SerpentSting..")", } },
	{ s.BlackArrow, { "player.focus > 35", }, },
	{ s.ExplosiveShot, { "player.focus > 50", }, },
	{ s.FocusingShot, { "player.focus < 35", }, },
	{ s.CobraShot, { "player.focus < 35", }, },
}





local azortharion = {
	---------------------------------------------------------
	-- Azortharion SV no T17 6.1
	---------------------------------------------------------
	--actions=auto_shot
	--actions+=/use_item,name=trinkets
	{ s.Trinket1, { "modifier.cooldowns", }, },
	{ s.Trinket2, { "modifier.cooldowns", }, },
	--actions+=/arcane_torrent,if=focus.deficit>=30
	{ s.ArcaneTorrent, { "modifier.cooldowns", "player.focus.deficit >= 30", }, },
	--actions+=/blood_fury
	{ s.BloodFury, { "modifier.cooldowns", }, },
	--actions+=/berserking
	{ s.Berserking, { "modifier.cooldowns", }, },
	--actions+=/potion,name=draenic_agility,if=(((cooldown.stampede.remains<1)&(cooldown.a_murder_of_crows.remains<1))&(trinket.stat.any.up|buff.archmages_greater_incandescence_agi.up))|target.time_to_die<=25
	{ s.AgilityPotion, {
		"player.spell("..s.Stampede..").cooldown < 1",
		"player.spell("..s.AMurderofCrows..").cooldown < 1",
		(function()
			return(dynamicEval("player.proc(agility)") or dynamicEval("player.proc(crit)") or dynamicEval("player.proc(multistrike)"))
		end),
		(function() return fetch("consumables", true) == true end),
	}, },
	{ s.AgilityPotion, {
		"player.spell("..s.Stampede..").cooldown < 1",
		"player.spell("..s.AMurderofCrows..").cooldown < 1",
		"player.buff("..s.ArchmagesGreaterIncandescence..")",
		(function() return fetch("consumables", true) == true end),
	}, },
	{ s.AgilityPotion, { "target.deathin <= 25", (function() return fetch("consumables", true) == true end), }, },


	--actions+=/call_action_list,name=aoe,if=active_enemies>1
	{ {
		--actions.aoe=stampede,if=buff.potion.up|(cooldown.potion.remains&(buff.archmages_greater_incandescence_agi.up|trinket.stat.any.up|buff.archmages_incandescence_agi.up))
		{ s.Stampede, { "player.buff("..s.AgilityPotionID..")", }, },
		{ s.Stampede, {
			"player.item("..s.AgilityPotionID..").cooldown > 1",
			"player.buff("..s.ArchmagesGreaterIncandescence..")",
		}, },
		{ s.Stampede, {
			"player.item("..s.AgilityPotionID..").cooldown > 1",
			(function()
				return(dynamicEval("player.proc(agility)") or dynamicEval("player.proc(crit)") or dynamicEval("player.proc(multistrike)"))
			end),
		}, },
		{ s.Stampede, {
			"player.item("..s.AgilityPotionID..").cooldown > 1",
			"player.buff("..s.ArchmagesIncandescence..")",
		}, },
		--actions.aoe+=/explosive_shot,if=buff.lock_and_load.react&(!talent.barrage.enabled|cooldown.barrage.remains>0)
		{ s.ExplosiveShot, { "player.buff("..s.LockandLoad..")", "talent(6,3)", }, },
		{ s.ExplosiveShot, { "player.buff("..s.LockandLoad..")", "player.spell("..s.Barrage..").cooldown > 1", }, },
		--actions.aoe+=/barrage
		{ s.Barrage, {
			--"!target.ccinarea(20)",
			function() return fetch("nocleave", false) == false end,
		}, },
		--actions.aoe+=/black_arrow,if=!ticking
		{ s.BlackArrow, { "player.spell("..s.BlackArrow..").cooldown = 0", "target.deathin > 10", }, },
		--actions.aoe+=/explosive_shot,if=active_enemies<5
		{ s.ExplosiveShot, { "target.rotagentarea(10).enemies < 5", }, },
		--actions.aoe+=/explosive_trap,if=dot.explosive_trap.remains<=5
		{ s.ExplosiveTrap2, {
			"player.spell("..s.ExplosiveTrap2..").cooldown = 0",
			"player.buff("..s.TrapLauncher..")",
			--"!target.ccinarea(10)",
			"ground.cluster(10)",
			function() return fetch("nocleave", false) == false end,
		}, "target.ground", },
		--actions.aoe+=/a_murder_of_crows
		{ s.AMurderofCrows, { "target.deathin > 60", "modifier.cooldowns", }, },
		{ s.AMurderofCrows, { "target.deathin < 12", }, },
		{ s.AMurderofCrows, { "target.health.actual < 200000", }, },
		--actions.aoe+=/dire_beast
		{ s.DireBeast, },
		--actions.aoe+=/multishot,if=buff.thrill_of_the_hunt.react&focus>50&cast_regen<=focus.deficit|dot.serpent_sting.remains<=5|target.time_to_die<4.5
		{ s.MultiShot, {
			"player.buff("..s.ThrilloftheHunt..")",
			"player.focus > 50",
			function() return (dynamicEval("player.spell("..s.MultiShot..").regen") <= dynamicEval("player.focus.deficit")) end,
			--"!target.ccinarea(8)",
			function() return fetch("nocleave", false) == false end,
		}, },
		{ s.MultiShot, {
			"player.buff("..s.ThrilloftheHunt..")",
			"player.focus > 50",
			"target.debuff("..s.SerpentSting..").duration <= 5",
			--"!target.ccinarea(8)",
			function() return fetch("nocleave", false) == false end,
		}, },
		{ s.MultiShot, {
			"player.buff("..s.ThrilloftheHunt..")",
			"player.focus > 50",
			"target.deathin < 4.5",
			--"!target.ccinarea(8)",
			function() return fetch("nocleave", false) == false end,
		}, },
		--actions.aoe+=/glaive_toss
		{ s.GlaiveToss, {
			--"!target.ccinarea(10)",
			function() return fetch("nocleave", false) == false end,
		}, },
		--actions.aoe+=/powershot
		{ s.Powershot, {
			--"!target.ccinarea(10)",
			function() return fetch("nocleave", false) == false end,
		}, },
		--actions.aoe+=/cobra_shot,if=buff.pre_steady_focus.up&buff.steady_focus.remains<5&focus+14+cast_regen<80
		{ s.CobraShot, {
			"lastcast("..s.CobraShot..")",
			"player.buff("..s.SteadyFocus..").duration < 5",
			function() return ((dynamicEval("player.focus") + 14 + dynamicEval("player.spell("..s.CobraShot..").regen")) < 80) end,
		}, },
		--actions.aoe+=/multishot,if=focus>=70|talent.focusing_shot.enabled
		{ s.MultiShot, {
			"player.focus > 70",
			--"!target.ccinarea(8)",
			function() return fetch("nocleave", false) == false end,
		}, },
		{ s.MultiShot, {
			"talent(7,2)",
			--"!target.ccinarea(8)",
			function() return fetch("nocleave", false) == false end,
		}, },
		--actions.aoe+=/focusing_shot
		{ s.FocusingShot, },
		--actions.aoe+=/cobra_shot
		{ s.CobraShot, },
	}, { "modifier.multitarget", "target.rotagentarea(10).enemies > 1", }, },


	--actions+=/stampede,if=buff.potion.up|(cooldown.potion.remains&(buff.archmages_greater_incandescence_agi.up|trinket.stat.any.up))|target.time_to_die<=25
	{ s.Stampede, { "player.buff("..s.AgilityPotionID..")", }, },
	{ s.Stampede, {
		"player.item("..s.AgilityPotionID..").cooldown > 1",
		"player.buff("..s.ArchmagesGreaterIncandescence..")",
	}, },
	{ s.Stampede, {
		"player.item("..s.AgilityPotionID..").cooldown > 0",
		function()
			return(dynamicEval("player.proc(agility)") or dynamicEval("player.proc(crit)") or dynamicEval("player.proc(multistrike)"))
		end,
	}, },
	{ s.Stampede, { "target.deathin <= 25", }, },
	--actions+=/a_murder_of_crows
	{ s.AMurderofCrows, { "target.deathin > 60", "modifier.cooldowns", }, },
	{ s.AMurderofCrows, { "target.deathin < 12", "target.deathin > 1", }, },
	{ s.AMurderofCrows, { "target.health.actual < 200000", }, },
	--actions+=/black_arrow,if=!ticking
	{ s.BlackArrow, { "player.spell("..s.BlackArrow..").cooldown = 0", "target.deathin > 10", }, },
	--actions+=/explosive_shot
	{ s.ExplosiveShot, },
	--actions+=/dire_beast
	{ s.DireBeast, },
	--actions+=/arcane_shot,if=buff.thrill_of_the_hunt.react&focus>35&cast_regen<=focus.deficit|dot.serpent_sting.remains<=3|target.time_to_die<4.5
	{ s.ArcaneShot, {
		"player.buff("..s.ThrilloftheHunt..")",
		"player.focus > 35",
		function() return (dynamicEval("player.spell("..s.ArcaneShot..").regen") <= dynamicEval("player.focus.deficit")) end,
	}, },
	{ s.ArcaneShot, { "target.debuff("..s.SerpentSting..").duration <= 3", }, },
	{ s.ArcaneShot, { "target.deathin < 4.5", }, },
	--actions+=/explosive_trap
	{ s.ExplosiveTrap2, {
		"player.spell("..s.ExplosiveTrap2..").cooldown = 0",
		"player.buff("..s.TrapLauncher..")",
		--"!target.ccinarea(10)",
		function() return fetch("nocleave", false) == false end,
	}, "target.ground", },
	--actions+=/barrage
	{ s.Barrage, {
		--"!target.ccinarea(20)",
		function() return fetch("nocleave", false) == false end,
	}, },
	--actions+=/glaive_toss
	{ s.GlaiveToss, {
		--"!target.ccinarea(10)",
		function() return fetch("nocleave", false) == false end,
	}, },
	--actions+=/powershot
	{ s.Powershot, {
		--"!target.ccinarea(10)",
		function() return fetch("nocleave", false) == false end,
	}, },
	--actions+=/cobra_shot,if=buff.pre_steady_focus.up&buff.steady_focus.remains<5&(14+cast_regen)<=focus.deficit
	{ s.CobraShot, {
		"lastcast("..s.CobraShot..")",
		"player.buff("..s.SteadyFocus..").duration < 5",
		function() return ((14 + dynamicEval("player.spell("..s.CobraShot..").regen")) <= dynamicEval("player.focus.deficit")) end,
	}, },
	--actions+=/arcane_shot,if=focus>=80|talent.focusing_shot.enabled
	{ s.ArcaneShot, { "player.focus >= 80", }, },
	{ s.ArcaneShot, { "talent(7,2)", }, },
	--actions+=/focusing_shot
	{ s.FocusingShot, },
	--actions+=/cobra_shot
	{ s.CobraShot, },
}
local effinhunter = {
	---------------------------------------------------------
	-- Effinhunter's Simulationcraft APL for SV Hunter 6.1 --
	---------------------------------------------------------
	--actions=auto_shot
	--actions+=/use_item,name=lucky_doublesided_coin
	{ s.Trinket1, { "modifier.cooldowns", }, },
	{ s.Trinket2, { "modifier.cooldowns", }, },
	--actions+=/arcane_torrent,if=focus.deficit>=30
	{ s.ArcaneTorrent, { "modifier.cooldowns", "player.focus.deficit >= 30", }, },
	--actions+=/blood_fury
	{ s.BloodFury, { "modifier.cooldowns", }, },
	--actions+=/berserking
	{ s.Berserking, { "modifier.cooldowns", }, },
	--actions+=/potion,name=draenic_agility,if=(((cooldown.stampede.remains<1)&(cooldown.a_murder_of_crows.remains<1))&(trinket.stat.any.up|buff.archmages_greater_incandescence_agi.up))|target.time_to_die<=25
	{ s.AgilityPotion, {
		"player.spell("..s.Stampede..").cooldown < 1",
		"player.spell("..s.AMurderofCrows..").cooldown < 1",
		(function()
			return(dynamicEval("player.proc(agility)") or dynamicEval("player.proc(crit)") or dynamicEval("player.proc(multistrike)"))
		end),
		(function() return fetch("consumables", true) == true end),
	}, },
	{ s.AgilityPotion, {
		"player.spell("..s.Stampede..").cooldown < 1",
		"player.spell("..s.AMurderofCrows..").cooldown < 1",
		"player.buff("..s.ArchmagesGreaterIncandescence..")",
		(function() return fetch("consumables", true) == true end),
	}, },
	{ s.AgilityPotion, { "target.deathin <= 25", (function() return fetch("consumables", true) == true end), }, },


	--actions+=/call_action_list,name=aoe,if=active_enemies>1
	{ {
		--actions.aoe=/black_arrow,if=!ticking
		{ s.BlackArrow, { "player.spell("..s.BlackArrow..").cooldown = 0", "target.deathin > 10", }, },
		--actions.aoe+=/a_murder_of_crows
		{ s.AMurderofCrows, { "target.deathin > 60", "modifier.cooldowns", }, },
		{ s.AMurderofCrows, { "target.deathin < 12", }, },
		{ s.AMurderofCrows, { "target.health.actual < 200000", }, },
		--actions.aoe+=/barrage
		{ s.Barrage, { "!target.ccinarea(20)", function() return fetch("nocleave", false) == false end, }, },
		--actions.aoe+=/multishot,if=buff.thrill_of_the_hunt.react
		{ s.MultiShot, {
			"player.buff("..s.ThrilloftheHunt..")",
			"!target.ccinarea(8)",
			function() return fetch("nocleave", false) == false end,
		}, },
		--actions.aoe+=/stampede,if=buff.potion.up|(cooldown.potion.remains&(buff.archmages_greater_incandescence_agi.up|trinket.stat.any.up|buff.archmages_incandescence_agi.up))
		{ s.Stampede, { "player.buff("..s.AgilityPotionID..")", }, },
		{ s.Stampede, {
			"player.item("..s.AgilityPotionID..").cooldown > 1",
			"player.buff("..s.ArchmagesGreaterIncandescence..")",
		}, },
		{ s.Stampede, {
			"player.item("..s.AgilityPotionID..").cooldown > 1",
			(function()
				return(dynamicEval("player.proc(agility)") or dynamicEval("player.proc(crit)") or dynamicEval("player.proc(multistrike)"))
			end),
		}, },
		{ s.Stampede, {
			"player.item("..s.AgilityPotionID..").cooldown > 1",
			"player.buff("..s.ArchmagesIncandescence..")",
		}, },
		--actions.aoe+=/explosive_shot,if=active_enemies<3
		{ s.ExplosiveShot, { "target.rotagentarea(10).enemies < 3", }, },
		--actions.aoe+=/explosive_trap,if=dot.explosive_trap.remains<=5
		{ s.ExplosiveTrap2, {
			"player.spell("..s.ExplosiveTrap2..").cooldown = 0",
			"player.buff("..s.TrapLauncher..")",
			"!target.ccinarea(10)",
			"ground.cluster(10)",
			function() return fetch("nocleave", false) == false end,
		}, },
		--actions.aoe+=/dire_beast
		{ s.DireBeast, { "target.deathin > 15", }, },
		--actions.aoe+=/glaive_toss
		{ s.GlaiveToss, { "target.deathin > 5", "!target.ccinarea(10)", function() return fetch("nocleave", false) == false end, }, },
		--actions.aoe+=/powershot
		{ s.Powershot, { "target.deathin > 20", "!target.ccinarea(10)", function() return fetch("nocleave", false) == false end, }, },
		--actions.aoe+=/cobra_shot,if=buff.pre_steady_focus.up&buff.steady_focus.remains<5&focus+14+cast_regen<80
		{ s.CobraShot, {
			"lastcast("..s.CobraShot..")",
			"player.buff("..s.SteadyFocus..").duration < 5",
			function() return ((dynamicEval("player.focus") + 14 + dynamicEval("player.spell("..s.CobraShot..").regen")) < 80) end,
		}, },
		--actions.aoe+=/multishot,if=focus>=70|talent.focusing_shot.enabled
		{ s.MultiShot, { "player.focus > 70", "!target.ccinarea(8)", function() return fetch("nocleave", false) == false end, }, },
		{ s.MultiShot, { "talent(7,2)", "!target.ccinarea(8)", function() return fetch("nocleave", false) == false end, }, },
		--actions.aoe+=/focusing_shot
		{ s.FocusingShot, },
		--actions.aoe+=/cobra_shot
		{ s.CobraShot, },
	}, { "modifier.multitarget", "target.rotagentarea(10).enemies > 1", }, },


	--actions+=/stampede,if=buff.potion.up|(cooldown.potion.remains&(buff.archmages_greater_incandescence_agi.up|trinket.stat.any.up))|target.time_to_die<=25
	{ s.Stampede, { "player.buff("..s.AgilityPotionID..")", }, },
	{ s.Stampede, {
		"player.item("..s.AgilityPotionID..").cooldown > 1",
		"player.buff("..s.ArchmagesGreaterIncandescence..")",
	}, },
	{ s.Stampede, {
		"player.item("..s.AgilityPotionID..").cooldown > 0",
		function()
			return(dynamicEval("player.proc(agility)") or dynamicEval("player.proc(crit)") or dynamicEval("player.proc(multistrike)"))
		end,
	}, },
	{ s.Stampede, { "target.deathin <= 25", }, },
	--actions+=/black_arrow,if=!ticking
	{ s.BlackArrow, { "player.spell("..s.BlackArrow..").cooldown = 0", "target.deathin > 10", }, },
	--actions+=/explosive_shot
	{ s.ExplosiveShot, },
	--actions+=/a_murder_of_crows
	{ s.AMurderofCrows, { "target.deathin > 60", "modifier.cooldowns", }, },
	{ s.AMurderofCrows, { "target.deathin < 12", "target.deathin > 1", }, },
	{ s.AMurderofCrows, { "target.health.actual < 200000", }, },
	--actions+=/dire_beast
	{ s.DireBeast, },
	--actions+=/arcane_shot,if=buff.thrill_of_the_hunt.react&focus>35&cast_regen<=focus.deficit|dot.serpent_sting.remains<=3|target.time_to_die<4.5
	{ s.ArcaneShot, {
		"player.buff("..s.ThrilloftheHunt..")",
		"player.focus > 35",
		function() return (dynamicEval("player.spell("..s.ArcaneShot..").regen") <= dynamicEval("player.focus.deficit")) end,
	}, },
	{ s.ArcaneShot, { "target.debuff("..s.SerpentSting..").duration <= 3", }, },
	{ s.ArcaneShot, { "target.deathin < 4.5", }, },
	--actions+=/glaive_toss
	{ s.GlaiveToss, { "!target.ccinarea(10)", function() return fetch("nocleave", false) == false end, }, },
	--actions+=/powershot
	{ s.Powershot, { "!target.ccinarea(10)", function() return fetch("nocleave", false) == false end, }, },
	--actions+=/barrage
	{ s.Barrage, { "!target.ccinarea(20)", function() return fetch("nocleave", false) == false end, }, },
	--actions+=/explosive_trap,if=dot.explosive_trap.remains<=5
	{ s.ExplosiveTrap2, {
		"player.spell("..s.ExplosiveTrap2..").cooldown = 0",
		"player.buff("..s.TrapLauncher..")",
		"target.exists",
		"!target.ccinarea(10)",
		function() return fetch("nocleave", false) == false end,
	}, "target.ground", },
	--# Cast a second shot for steady focus if that won't cap us.
	--actions+=/cobra_shot,if=buff.pre_steady_focus.up&buff.steady_focus.remains<5&(14+cast_regen)<=focus.deficit<80
	{ s.CobraShot, {
		"lastcast("..s.CobraShot..")",
		"player.buff("..s.SteadyFocus..").duration < 5",
		function() return ((14 + dynamicEval("player.spell("..s.CobraShot..").regen")) <= dynamicEval("player.focus.deficit")) end,
	}, },
	--actions+=/arcane_shot,if=focus>=80|talent.focusing_shot.enabled
	{ s.ArcaneShot, { "player.focus >= 80", }, },
	{ s.ArcaneShot, { "talent(7,2)", }, },
	--actions+=/focusing_shot
	{ s.FocusingShot, },
	--actions+=/cobra_shot
	{ s.CobraShot, },
}
local stocksimc = {
	---------------------------------------------------------
	-- Stock Simulationcraft SV 6.1
	---------------------------------------------------------
	--actions=auto_shot
	--actions+=/use_item,name=trinkets
	{ s.Trinket1, { "modifier.cooldowns", }, },
	{ s.Trinket2, { "modifier.cooldowns", }, },
	--actions+=/arcane_torrent,if=focus.deficit>=30
	{ s.ArcaneTorrent, { "modifier.cooldowns", "player.focus.deficit >= 30", }, },
	--actions+=/blood_fury
	{ s.BloodFury, { "modifier.cooldowns", }, },
	--actions+=/berserking
	{ s.Berserking, { "modifier.cooldowns", }, },
	--actions+=/potion,name=draenic_agility,if=(((cooldown.stampede.remains<1)&(cooldown.a_murder_of_crows.remains<1))&(trinket.stat.any.up|buff.archmages_greater_incandescence_agi.up))|target.time_to_die<=25
	{ s.AgilityPotion, {
		"player.spell("..s.Stampede..").cooldown < 1",
		"player.spell("..s.AMurderofCrows..").cooldown < 1",
		(function()
			return(dynamicEval("player.proc(agility)") or dynamicEval("player.proc(crit)") or dynamicEval("player.proc(multistrike)"))
		end),
		(function() return fetch("consumables", true) == true end),
	}, },
	{ s.AgilityPotion, {
		"player.spell("..s.Stampede..").cooldown < 1",
		"player.spell("..s.AMurderofCrows..").cooldown < 1",
		"player.buff("..s.ArchmagesGreaterIncandescence..")",
		(function() return fetch("consumables", true) == true end),
	}, },
	{ s.AgilityPotion, { "target.deathin <= 25", (function() return fetch("consumables", true) == true end), }, },


	--actions+=/call_action_list,name=aoe,if=active_enemies>1
	{ {
		--actions.aoe=stampede,if=buff.potion.up|(cooldown.potion.remains&(buff.archmages_greater_incandescence_agi.up|trinket.stat.any.up|buff.archmages_incandescence_agi.up))
		{ s.Stampede, { "player.buff("..s.AgilityPotionID..")", }, },
		{ s.Stampede, {
			"player.item("..s.AgilityPotionID..").cooldown > 1",
			"player.buff("..s.ArchmagesGreaterIncandescence..")",
		}, },
		{ s.Stampede, {
			"player.item("..s.AgilityPotionID..").cooldown > 1",
			(function()
				return(dynamicEval("player.proc(agility)") or dynamicEval("player.proc(crit)") or dynamicEval("player.proc(multistrike)"))
			end),
		}, },
		{ s.Stampede, {
			"player.item("..s.AgilityPotionID..").cooldown > 1",
			"player.buff("..s.ArchmagesIncandescence..")",
		}, },
		--actions.aoe+=/explosive_shot,if=buff.lock_and_load.react&(!talent.barrage.enabled|cooldown.barrage.remains>0)
		{ s.ExplosiveShot, { "player.buff("..s.LockandLoad..")", "talent(6,3)", }, },
		{ s.ExplosiveShot, { "player.buff("..s.LockandLoad..")", "player.spell("..s.Barrage..").cooldown > 1", }, },
		--actions.aoe+=/barrage
		{ s.Barrage, { "!target.ccinarea(20)", function() return fetch("nocleave", false) == false end, }, },
		--actions.aoe+=/black_arrow,if=!ticking
		{ s.BlackArrow, { "player.spell("..s.BlackArrow..").cooldown = 0", "target.deathin > 10", }, },
		--actions.aoe+=/explosive_shot,if=active_enemies<5
		{ s.ExplosiveShot, { "target.rotagentarea(10).enemies < 5", }, },
		--actions.aoe+=/explosive_trap,if=dot.explosive_trap.remains<=5
		{ s.ExplosiveTrap2, {
			"player.spell("..s.ExplosiveTrap2..").cooldown = 0",
			"player.buff("..s.TrapLauncher..")",
			"!target.ccinarea(10)",
			"ground.cluster(10)",
			function() return fetch("nocleave", false) == false end,
		}, },
		--actions.aoe+=/a_murder_of_crows
		{ s.AMurderofCrows, { "target.deathin > 60", "modifier.cooldowns", }, },
		{ s.AMurderofCrows, { "target.deathin < 12", }, },
		{ s.AMurderofCrows, { "target.health.actual < 200000", }, },
		--actions.aoe+=/dire_beast
		{ s.DireBeast, },
		--actions.aoe+=/multishot,if=buff.thrill_of_the_hunt.react&focus>50&cast_regen<=focus.deficit|dot.serpent_sting.remains<=5|target.time_to_die<4.5
		{ s.MultiShot, {
			"player.buff("..s.ThrilloftheHunt..")",
			"player.focus > 50",
			function() return (dynamicEval("player.spell("..s.MultiShot..").regen") <= dynamicEval("player.focus.deficit")) end,
			"!target.ccinarea(8)",
			function() return fetch("nocleave", false) == false end,
		}, },
		{ s.MultiShot, {
			"player.buff("..s.ThrilloftheHunt..")",
			"player.focus > 50",
			"target.debuff("..s.SerpentSting..").duration <= 5",
			"!target.ccinarea(8)",
			function() return fetch("nocleave", false) == false end,
		}, },
		{ s.MultiShot, {
			"player.buff("..s.ThrilloftheHunt..")",
			"player.focus > 50",
			"target.deathin < 4.5",
			"!target.ccinarea(8)",
			function() return fetch("nocleave", false) == false end,
		}, },
		--actions.aoe+=/glaive_toss
		{ s.GlaiveToss, { "!target.ccinarea(10)", function() return fetch("nocleave", false) == false end, }, },
		--actions.aoe+=/powershot
		{ s.Powershot, { "!target.ccinarea(10)", function() return fetch("nocleave", false) == false end, }, },
		--actions.aoe+=/cobra_shot,if=buff.pre_steady_focus.up&buff.steady_focus.remains<5&focus+14+cast_regen<80
		{ s.CobraShot, {
			"lastcast("..s.CobraShot..")",
			"player.buff("..s.SteadyFocus..").duration < 5",
			function() return ((dynamicEval("player.focus") + 14 + dynamicEval("player.spell("..s.CobraShot..").regen")) < 80) end,
		}, },
		--actions.aoe+=/multishot,if=focus>=70|talent.focusing_shot.enabled
		{ s.MultiShot, { "player.focus > 70", "!target.ccinarea(8)", function() return fetch("nocleave", false) == false end, }, },
		{ s.MultiShot, { "talent(7,2)", "!target.ccinarea(8)", function() return fetch("nocleave", false) == false end, }, },
		--actions.aoe+=/focusing_shot
		{ s.FocusingShot, },
		--actions.aoe+=/cobra_shot
		{ s.CobraShot, },
	}, { "modifier.multitarget", "target.rotagentarea(10).enemies > 1", }, },


	--actions+=/stampede,if=buff.potion.up|(cooldown.potion.remains&(buff.archmages_greater_incandescence_agi.up|trinket.stat.any.up))|target.time_to_die<=25
	{ s.Stampede, { "player.buff("..s.AgilityPotionID..")", }, },
	{ s.Stampede, {
		"player.item("..s.AgilityPotionID..").cooldown > 1",
		"player.buff("..s.ArchmagesGreaterIncandescence..")",
	}, },
	{ s.Stampede, {
		"player.item("..s.AgilityPotionID..").cooldown > 0",
		function()
			return(dynamicEval("player.proc(agility)") or dynamicEval("player.proc(crit)") or dynamicEval("player.proc(multistrike)"))
		end,
	}, },
	{ s.Stampede, { "target.deathin <= 25", }, },
	--actions+=/a_murder_of_crows
	{ s.AMurderofCrows, { "target.deathin > 60", "modifier.cooldowns", }, },
	{ s.AMurderofCrows, { "target.deathin < 12", "target.deathin > 1", }, },
	{ s.AMurderofCrows, { "target.health.actual < 200000", }, },
	--actions+=/black_arrow,if=!ticking
	{ s.BlackArrow, { "player.spell("..s.BlackArrow..").cooldown = 0", "target.deathin > 10", }, },
	--actions+=/explosive_shot
	{ s.ExplosiveShot, },
	--actions+=/dire_beast
	{ s.DireBeast, },
	--actions+=/arcane_shot,if=buff.thrill_of_the_hunt.react&focus>35&cast_regen<=focus.deficit|dot.serpent_sting.remains<=3|target.time_to_die<4.5
	{ s.ArcaneShot, {
		"player.buff("..s.ThrilloftheHunt..")",
		"player.focus > 35",
		function() return (dynamicEval("player.spell("..s.ArcaneShot..").regen") <= dynamicEval("player.focus.deficit")) end,
	}, },
	{ s.ArcaneShot, { "target.debuff("..s.SerpentSting..").duration <= 3", }, },
	{ s.ArcaneShot, { "target.deathin < 4.5", }, },
	--actions+=/explosive_trap
	{ s.ExplosiveTrap2, {
		"player.spell("..s.ExplosiveTrap2..").cooldown = 0",
		"player.buff("..s.TrapLauncher..")",
		"target.exists",
		"!target.ccinarea(10)",
		function() return fetch("nocleave", false) == false end,
	}, "target.ground", },
	--# Cast a second shot for steady focus if that won't cap us.
	--actions+=/cobra_shot,if=buff.pre_steady_focus.up&buff.steady_focus.remains<5&(14+cast_regen)<=focus.deficit
	{ s.CobraShot, {
		"lastcast("..s.CobraShot..")",
		"player.buff("..s.SteadyFocus..").duration < 5",
		function() return ((14 + dynamicEval("player.spell("..s.CobraShot..").regen")) <= dynamicEval("player.focus.deficit")) end,
	}, },
	--actions+=/arcane_shot,if=focus>=80|talent.focusing_shot.enabled
	{ s.ArcaneShot, { "player.focus >= 80", }, },
	{ s.ArcaneShot, { "talent(7,2)", }, },
	--actions+=/focusing_shot
	{ s.FocusingShot, },
	--actions+=/cobra_shot
	{ s.CobraShot, },
}





ProbablyEngine.rotation.register_custom(255, "RotAgent - Survival",
----------------------------------------------------------------------------------------------------
-- COMBAT
----------------------------------------------------------------------------------------------------
{
	{ s.AspectoftheCheetahCancel, { "player.buff("..s.AspectoftheCheetah..")", "!player.glyph("..s.CheetahGlyph..")", }, },
	{ s.PauseIncPet, { "pet.exists", "target.cc", }, },
	{ s.Pause, { "!pet.exists", "target.cc", }, },
	{ s.PauseIncPet, { "pet.exists", "lastcast("..s.FeignDeath..")", }, },
	{ s.Pause, { "!pet.exists", "lastcast("..s.FeignDeath.." )", }, },
	{ s.PauseIncPet, { "pet.exists", "player.buff("..s.Food..")", }, },
	{ s.Pause, { "!pet.exists", "player.buff("..s.Food..")", }, },
	{ s.PauseIncPet, { "modifier.lalt", function() return fetch('pause_keybind', 'lshift') == 'lalt' end, }, },
	{ s.PauseIncPet, { "modifier.lcontrol", function() return fetch('pause_keybind', 'lshift') == 'lcontrol' end, }, },
	{ s.PauseIncPet, { "modifier.lshift", function() return fetch('pause_keybind', 'lshift') == 'lshift' end, }, },
	{ s.PauseIncPet, { "modifier.ralt", function() return fetch('pause_keybind', 'lshift') == 'ralt' end, }, },
	{ s.PauseIncPet, { "modifier.rcontrol", function() return fetch('pause_keybind', 'lshift') == 'rcontrol' end, }, },
	{ s.PauseIncPet, { "modifier.rshift", function() return fetch('pause_keybind', 'lshift') == 'rshift' end, }, },

	{ trivial, { "target.health.max < 100000", }, },
	{ opener3plus, { "target.rotagentarea(10).enemies >= 3", "modifier.multitarget", "player.time < 4", }, },
	{ opener2, { "target.rotagentarea(10).enemies >= 2", "modifier.multitarget", "player.time < 4", }, },
	{ opener, { "player.time < 4", }, },

	{ bosshelp, function() return fetch("bosslogic", true) == true end, },
	{ defensives, function() return fetch("defensives", true) == true end, },
	{ interrupts, "modifier.interrupts", },
	{ miscellaneous, },
	{ misdirects, function() return fetch("misdirects", true) == true end, },
	{ mouseovers, function() return fetch("mouseovers", true) == true end, },
	{ petmanagement, function() return fetch("petmanagement", true) == true end, },
	{ poolfocus, },
	{ spellqueue, },

	{ azortharion, function() return fetch('combatrotation', 'stocksimc') == 'azortharion' end, },
	{ effinhunter, function() return fetch('combatrotation', 'stocksimc') == 'effinhunter' end, },
	{ stocksimc, function() return fetch('combatrotation', 'stocksimc') == 'stocksimc' end, },
},

----------------------------------------------------------------------------------------------------
-- OUT OF COMBAT
----------------------------------------------------------------------------------------------------
{
	{ ooc, },
	{ misdirects, },
	{ spellqueue, },
},

----------------------------------------------------------------------------------------------------
-- CALLBACK
----------------------------------------------------------------------------------------------------
function()
	-- Splash Logo
	local function onUpdate(RotAgentSplash,elapsed)
		if RotAgentSplash.time < GetTime() - 6.0 then
			if RotAgentSplash:GetAlpha() then
				RotAgentSplash:Hide()
			else
				RotAgentSplash:SetAlpha(RotAgentSplash:GetAlpha() - .05)
			end
		end
	end
	local function RotAgentSplashFrame()
		if fetch('splash', true) then
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
			RotAgentSplash:SetBackdrop({ bgFile = "Interface\\AddOns\\RotAgent\\Libs\\Media\\splash.blp" })
			RotAgentSplash:SetScript("onUpdate",onUpdate)
			RotAgentSplash:Hide()
			RotAgentSplash.time = 0

			RotAgentSplashFrame()
		end
	end
	RotAgentSplashInitialize()





	-- Config
	RotAgent.ConfigWindow = ProbablyEngine.interface.buildGUI({
		key = 'rasurvival',
		title = 'RotAgent '..RotAgent.version,
		subtitle = 'Survival Hunter',
		profiles = true,
		width = 275,
		height = 500,
		color = "4e7300",
		config = {
			{ type = 'dropdown', key = 'combatrotation', text = 'Combat Rotation Logic', list = {
				{ key = 'azortharion', text = 'Azortharion' },
				{ key = 'effinhunter', text = 'Effinhunter' },
				{ key = 'stocksimc', text = 'Stock Simc' },
			}, default = 'stocksimc', },

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

			{ type = 'header', text = 'Aspect of the Cheetah',},
			{ type = 'spinner', key = 'aspectmovingfor', text = 'Aspect after Moving for |cffaaaaaaX seconds|r', min = 0, max = 10, step = 1, default = 2, desc = 'Aspect of the Cheetah will be cast if the player has been moving for X seconds. If X is 0 the cast will be instant. Aspect will cancel upon entering combat if Glyph of Aspect of the Cheetah is not active.' },
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
	RotAgent.ConfigWindow.parent:Hide()





	-- Toggle Buttons
	ProbablyEngine.buttons.create(
		'config', 'Interface\\ICONS\\Inv_misc_gear_01',
		function(self)
			self.checked = false
			ProbablyEngine.buttons.setInactive('config')
			RotAgent.ConfigWindowShow()
		end,
		'Configure', 'Change how the rotation behaves.'
	)
	ProbablyEngine.buttons.create(
		'cacheinfo', 'Interface\\ICONS\\Inv_misc_enggizmos_17',
		function(self)
			self.checked = false
			ProbablyEngine.buttons.setInactive('cacheinfo')
			RotAgent.HelperWindowCacheShow()
		end,
		'Live Unit Cache Info', 'Shows live unit cache data.'
	)
	ProbablyEngine.buttons.create(
		'targetinfo', 'Interface\\ICONS\\Ability_hunter_markedfordeath',
		function(self)
			self.checked = false
			ProbablyEngine.buttons.setInactive('targetinfo')
			RotAgent.HelperWindowTargetShow()
		end,
		'Live Target Info', 'Shows live target info data.'
	)





	-- Initialization Code (Run once, upon reload or ENTERING_WORLD)
	RotAgent.BaseStatsTableInit()




	-- Main Rotation Timer
	C_Timer.NewTicker(0.25,
		(function()
			if ProbablyEngine.config.read('button_states', 'MasterToggle', false) then
				-- Run ONLY if the Rotation is toggled ON
				RotAgent.BaseStatsTableUpdate()
				RotAgent.HelperWindowCacheUpdate()
				RotAgent.HelperWindowTargetUpdate()

				if FireHack then
					RotAgent.CurrentTargetInfoTable("target")
					RotAgent.UnitCacheManager(40)		-- Range is 50 yards from player
				end
				-- Run ONLY if in Combat
				if ProbablyEngine.module.player.combat then

					--if ProbablyEngine.config.read('button_states', 'autotarget', false) then
					if fetch('autotarget', true) then
						RotAgent.AutoTargetEnemy()
					end
				end
				if fetch('autolfg', false) then
					--ProbablyEngine.config.read('autolfg', true)
					ProbablyEngine.config.write('autolfg', true)
				else
					--ProbablyEngine.config.read('autolfg', false)
					ProbablyEngine.config.write('autolfg', false)
				end
			end
		end),
	nil)
end)