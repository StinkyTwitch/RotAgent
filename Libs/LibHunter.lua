--[[------------------------------------------------------------------------------------------------
    LibHunter.lua

    RotAgent (Rotation Agent) License
    This work is licensed under the Creative Commons Attribution-NonCommercial 4.0 International
    License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc/4.0/.

--------------------------------------------------------------------------------------------------]]
local RotAgentName, RotAgent = ...
RotAgent.version = GetAddOnMetadata(RotAgentName, "Version")
ProbablyEngine.library.register('RotAgent', RotAgent)

RotAgent.QueueSpell = nil
RotAgent.QueueTime = 0

--[[------------------------------------------------------------------------------------------------
HUNTER JUMP
--------------------------------------------------------------------------------------------------]]
-- Slash Command
SLASH_HUNTERJUMPCMD1 = "/hunterjump"

-- Slash Command List
function SlashCmdList.HUNTERJUMPCMD(msg, editbox)
    if msg == "" then
        RotAgent.DisengageForward()
        return
    else
        return
    end
end

-- Verify Vector
function RotAgent.VerifyDisengage(vector)
    if FireHack then
        local playerFacing = ObjectFacing("player")

        if playerFacing ~= vector then
            FaceDirection(vector)
            CastSpellByName("Disengage")
        else
            CastSpellByName("Disengage")
        end
    end
end

-- Disengage Forward
function RotAgent.DisengageForward()
    if FireHack then
        local initialVector = ObjectFacing("player")
        local disengageVector = (mod( initialVector + math.pi, math.pi * 2 ))

        C_Timer.After(.001, function() FaceDirection(disengageVector) end)
        C_Timer.After(.35, function() RotAgent.VerifyDisengage(disengageVector) end)
        C_Timer.After(.50, function () FaceDirection(initialVector) end)

        RotAgent.Debug(1, "Jump: "..initialVector..", "..disengageVector.."")
    else
        RotAgent.Debug(1, "Hunter Jump not supported.")
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
        print("RotAgent "..RotAgent.version)
    elseif command == "config" then
        --ProbablyEngine.interface.buildGUI()
        -- ?
    elseif command == "debug" then
        if moretext == "on" then
            print("DEBUG on")
            RotAgent.debugToggle = true
        elseif moretext == "off" then
            print("DEBUG off")
            RotAgent.debugToggle = false
        elseif moretext == "1" then
            print("DEBUG Log Level 1")
            RotAgent.debugToggle = 1
        elseif moretext == "2" then
            print("DEBUG Log Level 2")
            RotAgent.debugToggle = 2
        elseif moretext == "3" then
            print("DEBUG Log Level 3")
            RotAgent.debugToggle = 3
        elseif moretext == "4" then
            print("DEBUG Log Level 4")
            RotAgent.debugToggle = 4
        elseif moretext == "5" then
            print("DEBUG Log Level 5")
            RotAgent.debugToggle = 5
        else
            print("Usage: /rahunter debug on \124 off \124 1 \124 2 \124 3 \124 4 \124 5")
        end
    elseif command == "cast" then
        if moretext == "aimed shot" then                -- MM
            RotAgent.QueueSpell =  19434
        elseif moretext == "amoc" then                  -- ALL Talent
            RotAgent.QueueSpell = 131894
        elseif moretext == "aotf" then                  -- ALL
            RotAgent.QueueSpell = 172106
        elseif moretext == "arcane shot" then           -- SV
            RotAgent.QueueSpell = 3044
        elseif moretext == "arcane torrent" then        -- RACIAL
            RotAgent.QueueSpell = 80483
        elseif moretext == "barrage" then               -- ALL Talent
            RotAgent.QueueSpell = 120360
        elseif moretext == "beastial wrath" then        -- BM
            RotAgent.QueueSpell = 19574
        elseif moretext == "berserking" then            -- RACIAL
            RotAgent.QueueSpell = 26297
        elseif moretext == "binding shot" then          -- ALL Talent
            RotAgent.QueueSpell = 109248
        elseif moretext == "black arrow" then           -- SV
            RotAgent.QueueSpell = 3674
        elseif moretext == "blood fury" then            -- RACIAL
            RotAgent.QueueSpell = 20572
        elseif moretext == "camouflage" then            -- ALL
            RotAgent.QueueSpell = 51753
        elseif moretext == "chimaera shot" then         -- MM
            RotAgent.QueueSpell = 53209
        elseif moretext == "cobra shot" then            -- BM
            RotAgent.QueueSpell = 77767
        elseif moretext == "concussive shot" then       -- ALL
            RotAgent.QueueSpell = 5116
        elseif moretext == "counter shot" then          -- ALL
            RotAgent.QueueSpell = 147362
        elseif moretext == "deterrence" then            -- ALL
            RotAgent.QueueSpell = 148467
        elseif moretext == "disengage" then             -- ALL
            RotAgent.QueueSpell = 781
        elseif moretext == "distracting shot" then      -- ALL
            RotAgent.QueueSpell = 20736
        elseif moretext == "explosive shot" then        -- SV
            RotAgent.QueueSpell = 53301
        elseif moretext == "explosive trap" then        -- ALL
            if UnitAura("player", "Trap Launcher") then
                RotAgent.QueueSpell = 82939
            else
                RotAgent.QueueSpell = 13813
            end
        elseif moretext == "feign death" then           -- ALL
            RotAgent.QueueSpell = 5384
        elseif moretext == "flare" then                 -- ALL
            RotAgent.QueueSpell = 1543
        elseif moretext == "focus fire" then            -- BM
            RotAgent.QueueSpell = 82692
        elseif moretext == "focusing shot" then         -- ALL Talent
            RotAgent.QueueSpell = 152245
        elseif moretext == "freezing trap" then         -- ALL
            if UnitAura("player", "Trap Launcher") then
                RotAgent.QueueSpell = 60192
            else
                RotAgent.QueueSpell = 1499
            end
        elseif moretext == "glaive toss" then           -- ALL Talent
            RotAgent.QueueSpell = 117050
        elseif moretext == "ice trap" then
            if UnitAura("player", "Trap Launcher") then -- ALL
                RotAgent.QueueSpell = 82941
            else
                RotAgent.QueueSpell = 13809
            end
        elseif moretext == "intimidation" then          -- ALL Talent
            RotAgent.QueueSpell = 19577
        elseif moretext == "kill command" then          -- BM
            RotAgent.QueueSpell = 34026
        elseif moretext == "kill shot" then             -- MM
            RotAgent.QueueSpell = 157708
        elseif moretext == "masters call" then          -- ALL
            RotAgent.QueueSpell = 53271
        elseif moretext == "mend pet" then              -- ALL
            RotAgent.QueueSpell = 136
        elseif moretext == "multi-shot" then            -- ALL
            RotAgent.QueueSpell = 2643
        elseif moretext == "powershot" then             -- ALL Talent
            RotAgent.QueueSpell = 109259
        elseif moretext == "rapid fire" then            -- MM
            RotAgent.QueueSpell = 3045
        elseif moretext == "stampede" then              -- ALL Talent
            RotAgent.QueueSpell = 121818
        elseif moretext == "steady shot" then           -- MM
            RotAgent.QueueSpell = 56641
        elseif moretext == "tranquilizing shot" then    -- ALL
            RotAgent.QueueSpell = 19801
        elseif moretext == "wyvern sting" then          -- ALL Talent
            RotAgent.QueueSpell = 19386
        else
            print("Unknown 'cast' command.")
        end
    elseif command == "stats" then
        RotAgent.BaseStatsTablePrint()
    elseif command == "vn" then
        RotAgent.VisualNotificationsToggle()
    elseif command == "buildtree" then
        BuildTreeUnitCache()
    else
        RotAgent.QueueSpell = nil
    end

    if RotAgent.QueueSpell ~= nil then
        RotAgent.QueueTime = GetTime()
    end
end