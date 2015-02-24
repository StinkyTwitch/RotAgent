
local StoredStringArray = { 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20 }
for i=1, 20 do

    local StoredStringArray[i][1] = tostring(CACHEUNITSTABLE[i][1])
    local StoredStringArray[i][2] = tostring(CACHEUNITSTABLE[i][2])
    local StoredStringArray[i][3] = tostring(CACHEUNITSTABLE[i][3])
    local StoredStringArray[i][4] = tostring(GetRound(CACHEUNITSTABLE[i][4], 2))

end

if StoredStringArray[1][1] ~= nil then
    liveunitcachetable_gui.elements.unitcacheindex1key:SetText("\124cffFFFFFF[01] \124cff666666"..StoredStringArray[1][1])
    liveunitcachetable_gui.elements.unitcacheindex1name:SetText("\124cff4e7300"..StoredStringArray[1][2])
    liveunitcachetable_gui.elements.unitcacheindex1value:SetText("\124cffFFFFFFdistance \124cff666666= \124cff4e7300"..StoredStringArray[1][4].." \124cffFFFFFFhealth \124cff666666= \124cff4e7300"..StoredStringArray[1][3])
else
    liveunitcachetable_gui.elements.unitcacheindex1key:SetText("")
    liveunitcachetable_gui.elements.unitcacheindex1name:SetText("")
    liveunitcachetable_gui.elements.unitcacheindex1value:SetText("")
end
if StoredStringArray[2][1] ~= nil then
    liveunitcachetable_gui.elements.unitcacheindex1key:SetText("\124cffFFFFFF[01] \124cff666666"..StoredStringArray[2][1])
    liveunitcachetable_gui.elements.unitcacheindex1name:SetText("\124cff4e7300"..StoredStringArray[2][2])
    liveunitcachetable_gui.elements.unitcacheindex1value:SetText("\124cffFFFFFFdistance \124cff666666= \124cff4e7300"..StoredStringArray[2][4].." \124cffFFFFFFhealth \124cff666666= \124cff4e7300"..StoredStringArray[2][3])
else
    liveunitcachetable_gui.elements.unitcacheindex1key:SetText("")
    liveunitcachetable_gui.elements.unitcacheindex1name:SetText("")
    liveunitcachetable_gui.elements.unitcacheindex1value:SetText("")
end