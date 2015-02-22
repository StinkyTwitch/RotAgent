--[[------------------------------------------------------------------------------------------------
    Draw.lua

    Rotation Agent (Probably_RotAgent) License
    This work is licensed under the Creative Commons Attribution-NonCommercial 4.0 International
    License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc/4.0/.

    !IN OTHER WORDS FUCK OFF SOAPBOX!
--]]------------------------------------------------------------------------------------------------

local function onUpdate(mtsSplash,elapsed)
    if mtsSplash.time < GetTime() - 20.0 then
        if mtsSplash:GetAlpha() then
            mtsSplash:Hide()
        else
            mtsSplash:SetAlpha(mtsSplash:GetAlpha() - .05)
        end
    end
end
function RotAgent.Splash()
    mtsSplash:SetAlpha(1)
    mtsSplash.time = GetTime()
    mtsSplash:Show()
end
mtsSplash = CreateFrame("Frame", nil,UIParent)
mtsSplash:SetPoint("CENTER",UIParent)
mtsSplash:SetWidth(512)
mtsSplash:SetHeight(512)
mtsSplash:SetBackdrop({ bgFile = "Interface\\AddOns\\RotAgent\\Library\\Media\\splash.tga" })
mtsSplash:SetScript("OnUpdate",onUpdate)
mtsSplash:Hide()
mtsSplash.time = 0


local TargetTable = {
    key = "targettablekey",
    title = 'RotAgent',
    subtitle = 'Target Information',
    width = 200,
    height = 265,
    resize = true,
    color = "6d6c2c",
    config = {
        --{ type = "text", text = "\124cffFFFFFFguid", size = 12, offset = 0 },
        { key = 'guid', type = "text", text = "random", size = 12, align = "left", offset = 14 },
        { type = 'rule', },
        { key = 'name', type = "text", text = "random", size = 12, align = "left", offset = 14 },
        { key = 'distance', type = "text", text = "random", size = 12, align = "left", offset = 0 },
        { key = 'reach', type = "text", text = "random", size = 12, align = "left", offset = 0 },
        { key = 'healthact', type = "text", text = "random", size = 12, align = "left", offset = 0 },
        { key = 'healthmax', type = "text", text = "random", size = 12, align = "left", offset = 0 },
        { key = 'healthpct', type = "text", text = "random", size = 12, align = "left", offset = 0 },
        { key = 'combat', type = "text", text = "random", size = 12, align = "left", offset = 0 },
        { key = 'reaction', type = "text", text = "random", size = 12, align = "left", offset = 0 },
        { key = 'specialaura', type = "text", text = "random", size = 12, align = "left", offset = 0 },
        { key = 'specialtarget', type = "text", text = "random", size = 12, align = "left", offset = 0 },
        { key = 'tappedbyme', type = "text", text = "random", size = 12, align = "left", offset = 0 },
        { key = 'tappedbyall', type = "text", text = "random", size = 12, align = "left", offset = 0 },
        { key = 'attackp2t', type = "text", text = "random", size = 12, align = "left", offset = 0 },
        { key = 'attackt2p', type = "text", text = "random", size = 12, align = "left", offset = 0 },
        { key = 'deathin', type = "text", text = "random", size = 12, align = "left", offset = 0 },
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
    local name_index = tostring(CURRENTTARGETINFOTABLE["name"])
    local name_element = ("\124cffFFFFFFname \124cffFFFF00= \124cff00FF00"..name_index)
    local distance_index = tostring(CURRENTTARGETINFOTABLE["distance"])
    local distance_element = ("\124cffFFFFFFdistance \124cffFFFF00= \124cff00FF00"..distance_index)
    local reach_index = tostring(CURRENTTARGETINFOTABLE["reach"])
    local reach_element = ("\124cffFFFFFFreach \124cffFFFF00= \124cff00FF00"..reach_index)
    local healthact_index = tostring(CURRENTTARGETINFOTABLE["healthact"])
    local healthact_element = ("\124cffFFFFFFhealth actual \124cffFFFF00= \124cff00FF00"..healthact_index)
    local healthmax_index = tostring(CURRENTTARGETINFOTABLE["healthmax"])
    local healthmax_element = ("\124cffFFFFFFhealth max \124cffFFFF00= \124cff00FF00"..healthmax_index)
    local healthpct_index = tostring(CURRENTTARGETINFOTABLE["healthpct"])
    local healthpct_element = ("\124cffFFFFFFhealth pct \124cffFFFF00= \124cff00FF00"..healthpct_index)
    local combat_index = tostring(CURRENTTARGETINFOTABLE["combat"])
    local combat_element = ("\124cffFFFFFFcombat \124cffFFFF00= \124cff00FF00"..combat_index)
    local reaction_index = tostring(CURRENTTARGETINFOTABLE["reaction"])
    local reaction_element = ("\124cffFFFFFFreaction \124cffFFFF00= \124cff00FF00"..reaction_index)
    local specialaura_index = tostring(CURRENTTARGETINFOTABLE["specialaura"])
    local specialaura_element = ("\124cffFFFFFFspecial aura \124cffFFFF00= \124cff00FF00"..specialaura_index)
    local specialtarget_index = tostring(CURRENTTARGETINFOTABLE["specialtarget"])
    local specialtarget_element = ("\124cffFFFFFFspecial target \124cffFFFF00= \124cff00FF00"..specialtarget_index)
    local tappedbyme_index = tostring(CURRENTTARGETINFOTABLE["tappedbyme"])
    local tappedbyme_element = ("\124cffFFFFFFtapped by me \124cffFFFF00= \124cff00FF00"..tappedbyme_index)
    local tappedbyall_index = tostring(CURRENTTARGETINFOTABLE["tappedbyall"])
    local tappedbyall_element = ("\124cffFFFFFFtapped by all \124cffFFFF00= \124cff00FF00"..tappedbyall_index)
    local attackp2t_index = tostring(CURRENTTARGETINFOTABLE["attackp2t"])
    local attackp2t_element = ("\124cffFFFFFFattack \124cffFFFF00-> \124cff00FF00"..attackp2t_index)
    local attackt2p_index = tostring(CURRENTTARGETINFOTABLE["attackt2p"])
    local attackt2p_element = ("\124cffFFFF00<- \124cffFFFFFFattack \124cff00FF00"..attackt2p_index)
    local deathin_index = tostring(CURRENTTARGETINFOTABLE["deathin"])
    local deathin_element = ("\124cffFFFFFFdeath in \124cffFFFF00= \124cff00FF00"..deathin_index)

    WindowTarget.elements.guid:SetText(CURRENTTARGETINFOTABLE["guid"])
    WindowTarget.elements.guid:SetTextColor(255,255,0,255)
    WindowTarget.elements.name:SetText(name_element)
    WindowTarget.elements.distance:SetText(distance_element)
    WindowTarget.elements.reach:SetText(reach_element)
    WindowTarget.elements.healthact:SetText(healthact_element)
    WindowTarget.elements.healthmax:SetText(healthmax_element)
    WindowTarget.elements.healthpct:SetText(healthpct_element)
    WindowTarget.elements.combat:SetText(combat_element)
    WindowTarget.elements.reaction:SetText(reaction_element)
    WindowTarget.elements.specialaura:SetText(specialaura_element)
    WindowTarget.elements.specialtarget:SetText(specialtarget_element)
    WindowTarget.elements.tappedbyme:SetText(tappedbyme_element)
    WindowTarget.elements.tappedbyall:SetText(tappedbyall_element)
    WindowTarget.elements.attackp2t:SetText(attackp2t_element)
    WindowTarget.elements.attackt2p:SetText(attackt2p_element)
    WindowTarget.elements.deathin:SetText(deathin_element)
end

-- a simple Timer that will update the frame for us
C_Timer.NewTicker(0.1, (function() updateWindowTarget() end), nil)
