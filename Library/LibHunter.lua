--[[------------------------------------------------------------------------------------------------
    Probably_RotAgent.lua

    Rotation Agent (Probably_RotAgent) License
    This work is licensed under the Creative Commons Attribution-NonCommercial 4.0 International
    License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc/4.0/.
--]]------------------------------------------------------------------------------------------------
local addonName = ...
local addonVersion = GetAddOnMetadata(addonName, "Version")

local LibHunter = {}
LibHunter.QueueSpell = nil
LibHunter.QueueTime = 0

ProbablyEngine.library.register('LibHunter', LibHunter)


--[[------------------------------------------------------------------------------------------------
HUNTER JUMP
--------------------------------------------------------------------------------------------------]]
-- Slash Command
SLASH_HUNTERJUMPCMD1 = "/hunterjump"

-- Slash Command List
function SlashCmdList.HUNTERJUMPCMD(msg, editbox)
    if msg == "" then
        DisengageForward()
    else
        return
    end
end

-- Verify Vector
function VerifyDisengage(vector)
    local _, current_vector = pcall(ObjectFacing, "player")

    if current_vector ~= vector then
        FaceDirection(vector)
        CastSpellByName("Disengage")
    else
        CastSpellByName("Disengage")
    end
end

-- Disengage Forward
function DisengageForward()
    local _, initial_vector = pcall(ObjectFacing, "player")
    local disengage_vector = (mod( initial_vector + math.pi, math.pi * 2 ))

    C_Timer.After(.001, function() FaceDirection(disengage_vector) end)
    C_Timer.After(.35, function() VerifyDisengage(disengage_vector) end)
    C_Timer.After(.50, function () FaceDirection(initial_vector) end)

    DEBUG(1, "Jump: "..initial_vector..", "..disengage_vector.."")
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
function LibHunter.Queue(spell_id)
    if (GetTime() - LibHunter.QueueTime) > 4 then
        LibHunter.QueueTime = 0
        LibHunter.QueueSpell = nil
        return false
    else
        if LibHunter.QueueSpell then
            if LibHunter.QueueSpell == spell_id then
                if ProbablyEngine.parser.lastCast == GetSpellName(spell_id) then
                    LibHunter.QueueSpell = nil
                    LibHunter.QueueTime = 0
                end
                NotificationFrame:message(GetSpellName(spell_id).." Queued")
                return true
            else
                return false
            end
        end
    end
end


--[[------------------------------------------------------------------------------------------------
SLASH COMMANDS
--------------------------------------------------------------------------------------------------]]
SLASH_LIBHUNTERCMD1 = "/rahunter"

function SlashCmdList.LIBHUNTERCMD(msg, editbox)
    local command, moretext = msg:match("^(%S*)%s*(.-)$")
    command = string.lower(command)
    moretext = string.lower(moretext)

    if msg == "" then
        -- Help listing.
        print("Rotation Agent version "..addonVersion)
    elseif command == "autotarget" then
        if moretext == "lowest" then
            print("Autotargetting changed to: lowest")
            AUTOTARGETALGORITHM = "lowest"
            CACHEUNITSALGORITHM = "lowest"
        elseif moretext == "nearest" then
            print("Autotargetting changed to: nearest")
            AUTOTARGETALGORITHM = "nearest"
            CACHEUNITSALGORITHM = "nearest"
        elseif moretext == "cascade" then
            print("Autotargetting changed to: cascade")
            AUTOTARGETALGORITHM = "cascade"
            CACHEUNITSALGORITHM = "lowest"
        else
            print("Current Autotarget settings: "..AUTOTARGETALGORITHM.."")
            print("Usage: /rahunter autotarget lowest \124 nearest \124 cascade")
        end
    elseif command == "config" then
        --ProbablyEngine.interface.buildGUI()
        -- ?
    elseif command == "debug" then
        if moretext == "on" then
            print("DEBUG on")
            DEBUGTOGGLE = true
        elseif moretext == "off" then
            print("DEBUG off")
            DEBUGTOGGLE = false
        elseif moretext == "1" then
            print("DEBUG Log Level 1")
            DEBUGLOGLEVEL = 1
        elseif moretext == "2" then
            print("DEBUG Log Level 2")
            DEBUGLOGLEVEL = 2
        elseif moretext == "3" then
            print("DEBUG Log Level 3")
            DEBUGLOGLEVEL = 3
        elseif moretext == "4" then
            print("DEBUG Log Level 4")
            DEBUGLOGLEVEL = 4
        elseif moretext == "5" then
            print("DEBUG Log Level 5")
            DEBUGLOGLEVEL = 5
        else
            print("Usage: /rahunter debug on \124 off \124 1 \124 2 \124 3 \124 4 \124 5")
        end
    elseif command == "cast" then
        if moretext == "aimed shot" then                -- MM
            LibHunter.QueueSpell =  19434
        elseif moretext == "amoc" then                  -- ALL Talent
            LibHunter.QueueSpell = 131894
        elseif moretext == "aotf" then                  -- ALL
            LibHunter.QueueSpell = 172106
        elseif moretext == "arcane shot" then           -- SV
            LibHunter.QueueSpell = 3044
        elseif moretext == "arcane torrent" then        -- RACIAL
            LibHunter.QueueSpell = 80483
        elseif moretext == "barrage" then               -- ALL Talent
            LibHunter.QueueSpell = 120360
        elseif moretext == "beastial wrath" then        -- BM
            LibHunter.QueueSpell = 19574
        elseif moretext == "berserking" then            -- RACIAL
            LibHunter.QueueSpell = 26297
        elseif moretext == "binding shot" then          -- ALL Talent
            LibHunter.QueueSpell = 109248
        elseif moretext == "black arrow" then           -- SV
            LibHunter.QueueSpell = 3674
        elseif moretext == "blood fury" then            -- RACIAL
            LibHunter.QueueSpell = 20572
        elseif moretext == "camouflage" then            -- ALL
            LibHunter.QueueSpell = 51753
        elseif moretext == "chimaera shot" then         -- MM
            LibHunter.QueueSpell = 53209
        elseif moretext == "cobra shot" then            -- BM
            LibHunter.QueueSpell = 77767
        elseif moretext == "concussive shot" then       -- ALL
            LibHunter.QueueSpell = 5116
        elseif moretext == "counter shot" then          -- ALL
            LibHunter.QueueSpell = 147362
        elseif moretext == "deterrence" then            -- ALL
            LibHunter.QueueSpell = 148467
        elseif moretext == "disengage" then             -- ALL
            LibHunter.QueueSpell = 781
        elseif moretext == "distracting shot" then      -- ALL
            LibHunter.QueueSpell = 20736
        elseif moretext == "explosive shot" then        -- SV
            LibHunter.QueueSpell = 53301
        elseif moretext == "explosive trap" then        -- ALL
            if UnitAura("player", "Trap Launcher") then
                LibHunter.QueueSpell = 82939
            else
                LibHunter.QueueSpell = 13813
            end
        elseif moretext == "feign death" then           -- ALL
            LibHunter.QueueSpell = 5384
        elseif moretext == "flare" then                 -- ALL
            LibHunter.QueueSpell = 1543
        elseif moretext == "focus fire" then            -- BM
            LibHunter.QueueSpell = 82692
        elseif moretext == "focusing shot" then         -- ALL Talent
            LibHunter.QueueSpell = 152245
        elseif moretext == "freezing trap" then         -- ALL
            if UnitAura("player", "Trap Launcher") then
                LibHunter.QueueSpell = 60192
            else
                LibHunter.QueueSpell = 1499
            end
        elseif moretext == "glaive toss" then           -- ALL Talent
            LibHunter.QueueSpell = 117050
        elseif moretext == "ice trap" then
            if UnitAura("player", "Trap Launcher") then -- ALL
                LibHunter.QueueSpell = 82941
            else
                LibHunter.QueueSpell = 13809
            end
        elseif moretext == "intimidation" then          -- ALL Talent
            LibHunter.QueueSpell = 19577
        elseif moretext == "kill command" then          -- BM
            LibHunter.QueueSpell = 34026
        elseif moretext == "kill shot" then             -- MM
            LibHunter.QueueSpell = 157708
        elseif moretext == "masters call" then          -- ALL
            LibHunter.QueueSpell = 53271
        elseif moretext == "mend pet" then              -- ALL
            LibHunter.QueueSpell = 136
        elseif moretext == "multi-shot" then            -- ALL
            LibHunter.QueueSpell = 2643
        elseif moretext == "powershot" then             -- ALL Talent
            LibHunter.QueueSpell = 109259
        elseif moretext == "rapid fire" then            -- MM
            LibHunter.QueueSpell = 3045
        elseif moretext == "stampede" then              -- ALL Talent
            LibHunter.QueueSpell = 121818
        elseif moretext == "steady shot" then           -- MM
            LibHunter.QueueSpell = 56641
        elseif moretext == "tranquilizing shot" then    -- ALL
            LibHunter.QueueSpell = 19801
        elseif moretext == "wyvern sting" then          -- ALL Talent
            LibHunter.QueueSpell = 19386
        else
            print("Unknown 'cast' command.")
        end
    elseif command == "stats" then
        BaseStatsPrint()
    elseif command == "tables" then
        CacheUnitsShow()
    else
        LibHunter.QueueSpell = nil
    end

    if LibHunter.QueueSpell ~= nil then
        LibHunter.QueueTime = GetTime()
    end
end
