--[[------------------------------------------------------------------------------------------------
    SpellTables.lua

    RotAgent (Rotation Agent) License
    This work is licensed under the Creative Commons Attribution-NonCommercial 4.0 International
    License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc/4.0/.

--------------------------------------------------------------------------------------------------]]
local RotAgentName, RotAgent = ...

RotAgent.HunterSpellsStrings = {
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
    CheetahGlyph = "119462",
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

RotAgent.MonkSpellsStrings = {

}