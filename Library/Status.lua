--[[------------------------------------------------------------------------------------------------
    Draw.lua

    Rotation Agent (Probably_RotAgent) License
    This work is licensed under the Creative Commons Attribution-NonCommercial 4.0 International
    License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc/4.0/.

    !IN OTHER WORDS FUCK OFF SOAPBOX!
--]]------------------------------------------------------------------------------------------------

local TargetTable = {
    key = "targettablekey",
    title = "Target Information",
    width = 300,
    height = 430,
    resize = true,
    config = {
        {
            type = "text",
            text = "GUID: ",
            size = 12,
            offset = 0
        },
        {
            key = 'guid',
            type = "text",
            text = "random",
            size = 13,
            align = "left",
            offset = 0
        },
        {
            type = "text",
            text = "Name: ",
            size = 12,
            offset = 0
        },
        {
            key = 'name',
            type = "text",
            text = "random",
            size = 13,
            align = "left",
            offset = 0
        },
        {
            type = "text",
            text = "Distance: ",
            size = 12,
            offset = 0
        },
        {
            key = 'distance',
            type = "text",
            text = "random",
            size = 13,
            align = "left",
            offset = 0
        },
        {
            type = "text",
            text = "Combat Reach: ",
            size = 12,
            offset = 0
        },
        {
            key = 'reach',
            type = "text",
            text = "random",
            size = 13,
            align = "left",
            offset = 0
        },
        {
            type = "text",
            text = "Health (Actual): ",
            size = 12,
            offset = 0
        },
        {
            key = 'healthact',
            type = "text",
            text = "random",
            size = 13,
            align = "left",
            offset = 0
        },
        {
            type = "text",
            text = "Health (Max): ",
            size = 12,
            offset = 0
        },
        {
            key = 'healthmax',
            type = "text",
            text = "random",
            size = 13,
            align = "left",
            offset = 0
        },
        {
            type = "text",
            text = "Health (Percent): ",
            size = 12,
            offset = 0
        },
        {
            key = 'healthpct',
            type = "text",
            text = "random",
            size = 13,
            align = "left",
            offset = 0
        },
        {
            type = "text",
            text = "Target Affecting Combat: ",
            size = 12,
            offset = 0
        },
        {
            key = 'combat',
            type = "text",
            text = "random",
            size = 13,
            align = "left",
            offset = 0
        },
        {
            type = "text",
            text = "Reaction: ",
            size = 12,
            offset = 0
        },
        {
            key = 'reaction',
            type = "text",
            text = "random",
            size = 13,
            align = "left",
            offset = 0
        },
        {
            type = "text",
            text = "Special Aura: ",
            size = 12,
            offset = 0
        },
        {
            key = 'specialaura',
            type = "text",
            text = "random",
            size = 13,
            align = "left",
            offset = 0
        },
        {
            type = "text",
            text = "Special Target: ",
            size = 12,
            offset = 0
        },
        {
            key = 'specialtarget',
            type = "text",
            text = "random",
            size = 13,
            align = "left",
            offset = 0
        },
        {
            type = "text",
            text = "Tapped By Player: ",
            size = 12,
            offset = 0
        },
        {
            key = 'tappedbyme',
            type = "text",
            text = "random",
            size = 13,
            align = "left",
            offset = 0
        },
        {
            type = "text",
            text = "Tapped By All On Threat List: ",
            size = 12,
            offset = 0
        },
        {
            key = 'tappedbyall',
            type = "text",
            text = "random",
            size = 13,
            align = "left",
            offset = 0
        },
        {
            type = "text",
            text = "Attack (Player -> Target): ",
            size = 12,
            offset = 0
        },
        {
            key = 'attackp2t',
            type = "text",
            text = "random",
            size = 13,
            align = "left",
            offset = 0
        },
        {
            type = "text",
            text = "Attack (Target to Player): ",
            size = 12,
            offset = 0
        },
        {
            key = 'attackt2p',
            type = "text",
            text = "random",
            size = 13,
            align = "left",
            offset = 0
        },
        {
            type = "text",
            text = "Deathin: ",
            size = 12,
            offset = 0
        },
        {
            key = 'deathin',
            type = "text",
            text = "random",
            size = 13,
            align = "left",
            offset = 0
        },
    }
}

local ShowTable = false
local WindowCache
local WindowTarget = ProbablyEngine.interface.buildGUI(TargetTable)

function ShowLiveCacheTable()
    print("Dummy function! :)")
end

function ShowLiveTargetTable()
    ShowTable = not ShowTable

    if ShowTable then
        WindowTarget.parent:Show()
    else
        WindowTarget.parent:Hide()
    end

end

function updateWindowTarget()
    WindowTarget.elements.guid:SetText(CURRENTTARGETINFOTABLE["01 guid"])
    WindowTarget.elements.name:SetText(CURRENTTARGETINFOTABLE["02 name"])
    WindowTarget.elements.distance:SetText(CURRENTTARGETINFOTABLE["03 distance"])
    WindowTarget.elements.reach:SetText(CURRENTTARGETINFOTABLE["04 reach"])
    WindowTarget.elements.healthact:SetText(CURRENTTARGETINFOTABLE["05 health act"])
    WindowTarget.elements.healthmax:SetText(CURRENTTARGETINFOTABLE["06 health max"])
    WindowTarget.elements.healthpct:SetText(CURRENTTARGETINFOTABLE["07 health pct"])
    WindowTarget.elements.combat:SetText(CURRENTTARGETINFOTABLE["08 combat"])
    WindowTarget.elements.reaction:SetText(CURRENTTARGETINFOTABLE["09 reaction"])
    WindowTarget.elements.specialaura:SetText(CURRENTTARGETINFOTABLE["10 special aura"])
    WindowTarget.elements.specialtarget:SetText(CURRENTTARGETINFOTABLE["11 special target"])
    WindowTarget.elements.tappedbyme:SetText(CURRENTTARGETINFOTABLE["12 tapped me"])
    WindowTarget.elements.tappedbyall:SetText(CURRENTTARGETINFOTABLE["13 tapped all"])
    WindowTarget.elements.attackp2t:SetText(CURRENTTARGETINFOTABLE["14 attack->"])
    WindowTarget.elements.attackt2p:SetText(CURRENTTARGETINFOTABLE["15 <-attack"])
    WindowTarget.elements.deathin:SetText(CURRENTTARGETINFOTABLE["16 deathin"])
end

-- a simple Timer that will update the frame for us
C_Timer.NewTicker(0.5, (function() updateWindowTarget() end), nil)
