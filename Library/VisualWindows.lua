--[[------------------------------------------------------------------------------------------------
	Draw.lua

	Rotation Agent (Probably_RotAgent) License
	This work is licensed under the Creative Commons Attribution-NonCommercial 4.0 International
	License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc/4.0/.

	!IN OTHER WORDS FUCK OFF SOAPBOX!
--]]------------------------------------------------------------------------------------------------

local liveunitcachetableshow = false
local livetargettableshow = false

local liveunitcachetable_gui = ProbablyEngine.interface.buildGUI({
	key = "liveunitcachetable_key",
	title = 'RotAgent',
	subtitle = 'Live Unit Cache',
	width = 225,
	height = 275,
	resize = true,
	color = "4e7300",
	config = {
		{ key = "unitcacheindextotal", type = "text", text = "", size = 12, align = "left", offset = 0, },
		{ key = "unitcacheindex1key", type = "text", text = "", size = 12, align = "left", offset = 0, },
		{ key = "unitcacheindex1name", type = "text", text = "", size = 12, align = "left", offset = 0, },
		{ key = "unitcacheindex1value", type = "text", text = "", size = 12, align = "left", offset = 0, },

		{ key = "unitcacheindex2key", type = "text", text = "", size = 12, align = "left", offset = 0, },
		{ key = "unitcacheindex2name", type = "text", text = "", size = 12, align = "left", offset = 0, },
		{ key = "unitcacheindex2value", type = "text", text = "", size = 12, align = "left", offset = 0, },

		{ key = "unitcacheindex3key", type = "text", text = "", size = 12, align = "left", offset = 0, },
		{ key = "unitcacheindex3name", type = "text", text = "", size = 12, align = "left", offset = 0, },
		{ key = "unitcacheindex3value", type = "text", text = "", size = 12, align = "left", offset = 0, },

		{ key = "unitcacheindex4key", type = "text", text = "", size = 12, align = "left", offset = 0, },
		{ key = "unitcacheindex4name", type = "text", text = "", size = 12, align = "left", offset = 0, },
		{ key = "unitcacheindex4value", type = "text", text = "", size = 12, align = "left", offset = 0, },

		{ key = "unitcacheindex5key", type = "text", text = "", size = 12, align = "left", offset = 0, },
		{ key = "unitcacheindex5name", type = "text", text = "", size = 12, align = "left", offset = 0, },
		{ key = "unitcacheindex5value", type = "text", text = "", size = 12, align = "left", offset = 0, },

		{ key = "unitcacheindex6key", type = "text", text = "", size = 12, align = "left", offset = 0, },
		{ key = "unitcacheindex6name", type = "text", text = "", size = 12, align = "left", offset = 0, },
		{ key = "unitcacheindex6value", type = "text", text = "", size = 12, align = "left", offset = 0, },

		{ key = "unitcacheindex7key", type = "text", text = "", size = 12, align = "left", offset = 0, },
		{ key = "unitcacheindex7name", type = "text", text = "", size = 12, align = "left", offset = 0, },
		{ key = "unitcacheindex7value", type = "text", text = "", size = 12, align = "left", offset = 0, },

		{ key = "unitcacheindex8key", type = "text", text = "", size = 12, align = "left", offset = 0, },
		{ key = "unitcacheindex8name", type = "text", text = "", size = 12, align = "left", offset = 0, },
		{ key = "unitcacheindex8value", type = "text", text = "", size = 12, align = "left", offset = 0, },

		{ key = "unitcacheindex9key", type = "text", text = "", size = 12, align = "left", offset = 0, },
		{ key = "unitcacheindex9name", type = "text", text = "", size = 12, align = "left", offset = 0, },
		{ key = "unitcacheindex9value", type = "text", text = "", size = 12, align = "left", offset = 0, },

		{ key = "unitcacheindex10key", type = "text", text = "", size = 12, align = "left", offset = 0, },
		{ key = "unitcacheindex10name", type = "text", text = "", size = 12, align = "left", offset = 0, },
		{ key = "unitcacheindex10value", type = "text", text = "", size = 12, align = "left", offset = 0, },

		{ key = "unitcacheindex11key", type = "text", text = "", size = 12, align = "left", offset = 0, },
		{ key = "unitcacheindex11name", type = "text", text = "", size = 12, align = "left", offset = 0, },
		{ key = "unitcacheindex11value", type = "text", text = "", size = 12, align = "left", offset = 0, },

		{ key = "unitcacheindex12key", type = "text", text = "", size = 12, align = "left", offset = 0, },
		{ key = "unitcacheindex12name", type = "text", text = "", size = 12, align = "left", offset = 0, },
		{ key = "unitcacheindex12value", type = "text", text = "", size = 12, align = "left", offset = 0, },

		{ key = "unitcacheindex13key", type = "text", text = "", size = 12, align = "left", offset = 0, },
		{ key = "unitcacheindex13name", type = "text", text = "", size = 12, align = "left", offset = 0, },
		{ key = "unitcacheindex13value", type = "text", text = "", size = 12, align = "left", offset = 0, },

		{ key = "unitcacheindex14key", type = "text", text = "", size = 12, align = "left", offset = 0, },
		{ key = "unitcacheindex14name", type = "text", text = "", size = 12, align = "left", offset = 0, },
		{ key = "unitcacheindex14value", type = "text", text = "", size = 12, align = "left", offset = 0, },

		{ key = "unitcacheindex15key", type = "text", text = "", size = 12, align = "left", offset = 0, },
		{ key = "unitcacheindex15name", type = "text", text = "", size = 12, align = "left", offset = 0, },
		{ key = "unitcacheindex15value", type = "text", text = "", size = 12, align = "left", offset = 0, },

		{ key = "unitcacheindex16key", type = "text", text = "", size = 12, align = "left", offset = 0, },
		{ key = "unitcacheindex16name", type = "text", text = "", size = 12, align = "left", offset = 0, },
		{ key = "unitcacheindex16value", type = "text", text = "", size = 12, align = "left", offset = 0, },

		{ key = "unitcacheindex17key", type = "text", text = "", size = 12, align = "left", offset = 0, },
		{ key = "unitcacheindex17name", type = "text", text = "", size = 12, align = "left", offset = 0, },
		{ key = "unitcacheindex17value", type = "text", text = "", size = 12, align = "left", offset = 0, },

		{ key = "unitcacheindex18key", type = "text", text = "", size = 12, align = "left", offset = 0, },
		{ key = "unitcacheindex18name", type = "text", text = "", size = 12, align = "left", offset = 0, },
		{ key = "unitcacheindex18value", type = "text", text = "", size = 12, align = "left", offset = 0, },

		{ key = "unitcacheindex19key", type = "text", text = "", size = 12, align = "left", offset = 0, },
		{ key = "unitcacheindex19name", type = "text", text = "", size = 12, align = "left", offset = 0, },
		{ key = "unitcacheindex19value", type = "text", text = "", size = 12, align = "left", offset = 0, },

		{ key = "unitcacheindex20key", type = "text", text = "", size = 12, align = "left", offset = 0, },
		{ key = "unitcacheindex20name", type = "text", text = "", size = 12, align = "left", offset = 0, },
		{ key = "unitcacheindex20value", type = "text", text = "", size = 12, align = "left", offset = 0, },
	}
})
liveunitcachetable_gui.parent:Hide()


local livetargettable_gui = ProbablyEngine.interface.buildGUI({
	key = "livetargettable_key",
	title = 'RotAgent',
	subtitle = 'Live Target Info',
	width = 175,
	height = 275,
	resize = true,
	color = "4e7300",
	config = {
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
})
livetargettable_gui.parent:Hide()





function LiveUnitCacheTableShow()
	liveunitcachetableshow = not liveunitcachetableshow

	if liveunitcachetableshow then
		liveunitcachetable_gui.parent:Show()
	else
		liveunitcachetable_gui.parent:Hide()
	end
end

function LiveTargetTableShow()
	livetargettableshow = not livetargettableshow

	if livetargettableshow then
		livetargettable_gui.parent:Show()
	else
		livetargettable_gui.parent:Hide()
	end
end





function LiveUnitCacheTableUpdate()
	if liveunitcachetableshow then

		local unitcacheindexcount = table.getn(CACHEUNITSTABLE)
		liveunitcachetable_gui.elements.unitcacheindextotal:SetText("\124cffFFFFFFUnit Count = \124cff666666"..unitcacheindexcount)

		if CACHEUNITSTABLE[1] ~= nil then
		    liveunitcachetable_gui.elements.unitcacheindex1key:SetText("\124cffFFFFFF[01] \124cff666666"..CACHEUNITSTABLE[1].object)
		    liveunitcachetable_gui.elements.unitcacheindex1name:SetText("\124cff4e7300"..CACHEUNITSTABLE[1].name)
		    liveunitcachetable_gui.elements.unitcacheindex1value:SetText("\124cffFFFFFFdistance \124cff666666= \124cff4e7300"..CACHEUNITSTABLE[1].distance.." \124cffFFFFFFhealth \124cff666666= \124cff4e7300"..CACHEUNITSTABLE[1].health)
		else
		    liveunitcachetable_gui.elements.unitcacheindex1key:SetText("")
		    liveunitcachetable_gui.elements.unitcacheindex1name:SetText("")
		    liveunitcachetable_gui.elements.unitcacheindex1value:SetText("")
		end
		if CACHEUNITSTABLE[2] ~= nil then
		    liveunitcachetable_gui.elements.unitcacheindex2key:SetText("\124cffFFFFFF[01] \124cff666666"..CACHEUNITSTABLE[2].object)
		    liveunitcachetable_gui.elements.unitcacheindex2name:SetText("\124cff4e7300"..CACHEUNITSTABLE[2].name)
		    liveunitcachetable_gui.elements.unitcacheindex2value:SetText("\124cffFFFFFFdistance \124cff666666= \124cff4e7300"..CACHEUNITSTABLE[2].distance.." \124cffFFFFFFhealth \124cff666666= \124cff4e7300"..CACHEUNITSTABLE[2].health)
		else
		    liveunitcachetable_gui.elements.unitcacheindex2key:SetText("")
		    liveunitcachetable_gui.elements.unitcacheindex2name:SetText("")
		    liveunitcachetable_gui.elements.unitcacheindex2value:SetText("")
		end
		if CACHEUNITSTABLE[3] ~= nil then
		    liveunitcachetable_gui.elements.unitcacheindex3key:SetText("\124cffFFFFFF[01] \124cff666666"..CACHEUNITSTABLE[3].object)
		    liveunitcachetable_gui.elements.unitcacheindex3name:SetText("\124cff4e7300"..CACHEUNITSTABLE[3].name)
		    liveunitcachetable_gui.elements.unitcacheindex3value:SetText("\124cffFFFFFFdistance \124cff666666= \124cff4e7300"..CACHEUNITSTABLE[3].distance.." \124cffFFFFFFhealth \124cff666666= \124cff4e7300"..CACHEUNITSTABLE[3].health)
		else
		    liveunitcachetable_gui.elements.unitcacheindex3key:SetText("")
		    liveunitcachetable_gui.elements.unitcacheindex3name:SetText("")
		    liveunitcachetable_gui.elements.unitcacheindex3value:SetText("")
		end
		if CACHEUNITSTABLE[4] ~= nil then
		    liveunitcachetable_gui.elements.unitcacheindex4key:SetText("\124cffFFFFFF[01] \124cff666666"..CACHEUNITSTABLE[4].object)
		    liveunitcachetable_gui.elements.unitcacheindex4name:SetText("\124cff4e7300"..CACHEUNITSTABLE[4].name)
		    liveunitcachetable_gui.elements.unitcacheindex4value:SetText("\124cffFFFFFFdistance \124cff666666= \124cff4e7300"..CACHEUNITSTABLE[4].distance.." \124cffFFFFFFhealth \124cff666666= \124cff4e7300"..CACHEUNITSTABLE[4].health)
		else
		    liveunitcachetable_gui.elements.unitcacheindex4key:SetText("")
		    liveunitcachetable_gui.elements.unitcacheindex4name:SetText("")
		    liveunitcachetable_gui.elements.unitcacheindex4value:SetText("")
		end
		if CACHEUNITSTABLE[5] ~= nil then
		    liveunitcachetable_gui.elements.unitcacheindex5key:SetText("\124cffFFFFFF[01] \124cff666666"..CACHEUNITSTABLE[5].object)
		    liveunitcachetable_gui.elements.unitcacheindex5name:SetText("\124cff4e7300"..CACHEUNITSTABLE[5].name)
		    liveunitcachetable_gui.elements.unitcacheindex5value:SetText("\124cffFFFFFFdistance \124cff666666= \124cff4e7300"..CACHEUNITSTABLE[5].distance.." \124cffFFFFFFhealth \124cff666666= \124cff4e7300"..CACHEUNITSTABLE[5].health)
		else
		    liveunitcachetable_gui.elements.unitcacheindex5key:SetText("")
		    liveunitcachetable_gui.elements.unitcacheindex5name:SetText("")
		    liveunitcachetable_gui.elements.unitcacheindex5value:SetText("")
		end
		if CACHEUNITSTABLE[6] ~= nil then
		    liveunitcachetable_gui.elements.unitcacheindex6key:SetText("\124cffFFFFFF[01] \124cff666666"..CACHEUNITSTABLE[6].object)
		    liveunitcachetable_gui.elements.unitcacheindex6name:SetText("\124cff4e7300"..CACHEUNITSTABLE[6].name)
		    liveunitcachetable_gui.elements.unitcacheindex6value:SetText("\124cffFFFFFFdistance \124cff666666= \124cff4e7300"..CACHEUNITSTABLE[6].distance.." \124cffFFFFFFhealth \124cff666666= \124cff4e7300"..CACHEUNITSTABLE[6].health)
		else
		    liveunitcachetable_gui.elements.unitcacheindex6key:SetText("")
		    liveunitcachetable_gui.elements.unitcacheindex6name:SetText("")
		    liveunitcachetable_gui.elements.unitcacheindex6value:SetText("")
		end
		if CACHEUNITSTABLE[7] ~= nil then
		    liveunitcachetable_gui.elements.unitcacheindex7key:SetText("\124cffFFFFFF[01] \124cff666666"..CACHEUNITSTABLE[7].object)
		    liveunitcachetable_gui.elements.unitcacheindex7name:SetText("\124cff4e7300"..CACHEUNITSTABLE[7].name)
		    liveunitcachetable_gui.elements.unitcacheindex7value:SetText("\124cffFFFFFFdistance \124cff666666= \124cff4e7300"..CACHEUNITSTABLE[7].distance.." \124cffFFFFFFhealth \124cff666666= \124cff4e7300"..CACHEUNITSTABLE[7].health)
		else
		    liveunitcachetable_gui.elements.unitcacheindex7key:SetText("")
		    liveunitcachetable_gui.elements.unitcacheindex7name:SetText("")
		    liveunitcachetable_gui.elements.unitcacheindex7value:SetText("")
		end
		if CACHEUNITSTABLE[8] ~= nil then
		    liveunitcachetable_gui.elements.unitcacheindex8key:SetText("\124cffFFFFFF[01] \124cff666666"..CACHEUNITSTABLE[8].object)
		    liveunitcachetable_gui.elements.unitcacheindex8name:SetText("\124cff4e7300"..CACHEUNITSTABLE[8].name)
		    liveunitcachetable_gui.elements.unitcacheindex8value:SetText("\124cffFFFFFFdistance \124cff666666= \124cff4e7300"..CACHEUNITSTABLE[8].distance.." \124cffFFFFFFhealth \124cff666666= \124cff4e7300"..CACHEUNITSTABLE[8].health)
		else
		    liveunitcachetable_gui.elements.unitcacheindex8key:SetText("")
		    liveunitcachetable_gui.elements.unitcacheindex8name:SetText("")
		    liveunitcachetable_gui.elements.unitcacheindex8value:SetText("")
		end
		if CACHEUNITSTABLE[9] ~= nil then
		    liveunitcachetable_gui.elements.unitcacheindex9key:SetText("\124cffFFFFFF[01] \124cff666666"..CACHEUNITSTABLE[9].object)
		    liveunitcachetable_gui.elements.unitcacheindex9name:SetText("\124cff4e7300"..CACHEUNITSTABLE[9].name)
		    liveunitcachetable_gui.elements.unitcacheindex9value:SetText("\124cffFFFFFFdistance \124cff666666= \124cff4e7300"..CACHEUNITSTABLE[9].distance.." \124cffFFFFFFhealth \124cff666666= \124cff4e7300"..CACHEUNITSTABLE[9].health)
		else
		    liveunitcachetable_gui.elements.unitcacheindex9key:SetText("")
		    liveunitcachetable_gui.elements.unitcacheindex9name:SetText("")
		    liveunitcachetable_gui.elements.unitcacheindex9value:SetText("")
		end
		if CACHEUNITSTABLE[10] ~= nil then
		    liveunitcachetable_gui.elements.unitcacheindex10key:SetText("\124cffFFFFFF[01] \124cff666666"..CACHEUNITSTABLE[10].object)
		    liveunitcachetable_gui.elements.unitcacheindex10name:SetText("\124cff4e7300"..CACHEUNITSTABLE[10].name)
		    liveunitcachetable_gui.elements.unitcacheindex10value:SetText("\124cffFFFFFFdistance \124cff666666= \124cff4e7300"..CACHEUNITSTABLE[10].distance.." \124cffFFFFFFhealth \124cff666666= \124cff4e7300"..CACHEUNITSTABLE[10].health)
		else
		    liveunitcachetable_gui.elements.unitcacheindex10key:SetText("")
		    liveunitcachetable_gui.elements.unitcacheindex10name:SetText("")
		    liveunitcachetable_gui.elements.unitcacheindex10value:SetText("")
		end

		if CACHEUNITSTABLE[11] ~= nil then
		    liveunitcachetable_gui.elements.unitcacheindex11key:SetText("\124cffFFFFFF[01] \124cff666666"..CACHEUNITSTABLE[11].object)
		    liveunitcachetable_gui.elements.unitcacheindex11name:SetText("\124cff4e7300"..CACHEUNITSTABLE[11].name)
		    liveunitcachetable_gui.elements.unitcacheindex11value:SetText("\124cffFFFFFFdistance \124cff666666= \124cff4e7300"..CACHEUNITSTABLE[11].distance.." \124cffFFFFFFhealth \124cff666666= \124cff4e7300"..CACHEUNITSTABLE[11].health)
		else
		    liveunitcachetable_gui.elements.unitcacheindex11key:SetText("")
		    liveunitcachetable_gui.elements.unitcacheindex11name:SetText("")
		    liveunitcachetable_gui.elements.unitcacheindex11value:SetText("")
		end
		if CACHEUNITSTABLE[12] ~= nil then
		    liveunitcachetable_gui.elements.unitcacheindex12key:SetText("\124cffFFFFFF[01] \124cff666666"..CACHEUNITSTABLE[12].object)
		    liveunitcachetable_gui.elements.unitcacheindex12name:SetText("\124cff4e7300"..CACHEUNITSTABLE[12].name)
		    liveunitcachetable_gui.elements.unitcacheindex12value:SetText("\124cffFFFFFFdistance \124cff666666= \124cff4e7300"..CACHEUNITSTABLE[12].distance.." \124cffFFFFFFhealth \124cff666666= \124cff4e7300"..CACHEUNITSTABLE[12].health)
		else
		    liveunitcachetable_gui.elements.unitcacheindex12key:SetText("")
		    liveunitcachetable_gui.elements.unitcacheindex12name:SetText("")
		    liveunitcachetable_gui.elements.unitcacheindex12value:SetText("")
		end
		if CACHEUNITSTABLE[13] ~= nil then
		    liveunitcachetable_gui.elements.unitcacheindex13key:SetText("\124cffFFFFFF[01] \124cff666666"..CACHEUNITSTABLE[13].object)
		    liveunitcachetable_gui.elements.unitcacheindex13name:SetText("\124cff4e7300"..CACHEUNITSTABLE[13].name)
		    liveunitcachetable_gui.elements.unitcacheindex13value:SetText("\124cffFFFFFFdistance \124cff666666= \124cff4e7300"..CACHEUNITSTABLE[13].distance.." \124cffFFFFFFhealth \124cff666666= \124cff4e7300"..CACHEUNITSTABLE[13].health)
		else
		    liveunitcachetable_gui.elements.unitcacheindex13key:SetText("")
		    liveunitcachetable_gui.elements.unitcacheindex13name:SetText("")
		    liveunitcachetable_gui.elements.unitcacheindex13value:SetText("")
		end
		if CACHEUNITSTABLE[14] ~= nil then
		    liveunitcachetable_gui.elements.unitcacheindex14key:SetText("\124cffFFFFFF[01] \124cff666666"..CACHEUNITSTABLE[14].object)
		    liveunitcachetable_gui.elements.unitcacheindex14name:SetText("\124cff4e7300"..CACHEUNITSTABLE[14].name)
		    liveunitcachetable_gui.elements.unitcacheindex14value:SetText("\124cffFFFFFFdistance \124cff666666= \124cff4e7300"..CACHEUNITSTABLE[14].distance.." \124cffFFFFFFhealth \124cff666666= \124cff4e7300"..CACHEUNITSTABLE[14].health)
		else
		    liveunitcachetable_gui.elements.unitcacheindex14key:SetText("")
		    liveunitcachetable_gui.elements.unitcacheindex14name:SetText("")
		    liveunitcachetable_gui.elements.unitcacheindex14value:SetText("")
		end
		if CACHEUNITSTABLE[15] ~= nil then
		    liveunitcachetable_gui.elements.unitcacheindex15key:SetText("\124cffFFFFFF[01] \124cff666666"..CACHEUNITSTABLE[15].object)
		    liveunitcachetable_gui.elements.unitcacheindex15name:SetText("\124cff4e7300"..CACHEUNITSTABLE[15].name)
		    liveunitcachetable_gui.elements.unitcacheindex15value:SetText("\124cffFFFFFFdistance \124cff666666= \124cff4e7300"..CACHEUNITSTABLE[15].distance.." \124cffFFFFFFhealth \124cff666666= \124cff4e7300"..CACHEUNITSTABLE[15].health)
		else
		    liveunitcachetable_gui.elements.unitcacheindex15key:SetText("")
		    liveunitcachetable_gui.elements.unitcacheindex15name:SetText("")
		    liveunitcachetable_gui.elements.unitcacheindex15value:SetText("")
		end
		if CACHEUNITSTABLE[16] ~= nil then
		    liveunitcachetable_gui.elements.unitcacheindex16key:SetText("\124cffFFFFFF[01] \124cff666666"..CACHEUNITSTABLE[16].object)
		    liveunitcachetable_gui.elements.unitcacheindex16name:SetText("\124cff4e7300"..CACHEUNITSTABLE[16].name)
		    liveunitcachetable_gui.elements.unitcacheindex16value:SetText("\124cffFFFFFFdistance \124cff666666= \124cff4e7300"..CACHEUNITSTABLE[16].distance.." \124cffFFFFFFhealth \124cff666666= \124cff4e7300"..CACHEUNITSTABLE[16].health)
		else
		    liveunitcachetable_gui.elements.unitcacheindex16key:SetText("")
		    liveunitcachetable_gui.elements.unitcacheindex16name:SetText("")
		    liveunitcachetable_gui.elements.unitcacheindex16value:SetText("")
		end
		if CACHEUNITSTABLE[17] ~= nil then
		    liveunitcachetable_gui.elements.unitcacheindex17key:SetText("\124cffFFFFFF[01] \124cff666666"..CACHEUNITSTABLE[17].object)
		    liveunitcachetable_gui.elements.unitcacheindex17name:SetText("\124cff4e7300"..CACHEUNITSTABLE[17].name)
		    liveunitcachetable_gui.elements.unitcacheindex17value:SetText("\124cffFFFFFFdistance \124cff666666= \124cff4e7300"..CACHEUNITSTABLE[17].distance.." \124cffFFFFFFhealth \124cff666666= \124cff4e7300"..CACHEUNITSTABLE[17].health)
		else
		    liveunitcachetable_gui.elements.unitcacheindex17key:SetText("")
		    liveunitcachetable_gui.elements.unitcacheindex17name:SetText("")
		    liveunitcachetable_gui.elements.unitcacheindex17value:SetText("")
		end
		if CACHEUNITSTABLE[18] ~= nil then
		    liveunitcachetable_gui.elements.unitcacheindex18key:SetText("\124cffFFFFFF[01] \124cff666666"..CACHEUNITSTABLE[18].object)
		    liveunitcachetable_gui.elements.unitcacheindex18name:SetText("\124cff4e7300"..CACHEUNITSTABLE[18].name)
		    liveunitcachetable_gui.elements.unitcacheindex18value:SetText("\124cffFFFFFFdistance \124cff666666= \124cff4e7300"..CACHEUNITSTABLE[18].distance.." \124cffFFFFFFhealth \124cff666666= \124cff4e7300"..CACHEUNITSTABLE[18].health)
		else
		    liveunitcachetable_gui.elements.unitcacheindex18key:SetText("")
		    liveunitcachetable_gui.elements.unitcacheindex18name:SetText("")
		    liveunitcachetable_gui.elements.unitcacheindex18value:SetText("")
		end
		if CACHEUNITSTABLE[19] ~= nil then
		    liveunitcachetable_gui.elements.unitcacheindex19key:SetText("\124cffFFFFFF[01] \124cff666666"..CACHEUNITSTABLE[19].object)
		    liveunitcachetable_gui.elements.unitcacheindex19name:SetText("\124cff4e7300"..CACHEUNITSTABLE[19].name)
		    liveunitcachetable_gui.elements.unitcacheindex19value:SetText("\124cffFFFFFFdistance \124cff666666= \124cff4e7300"..CACHEUNITSTABLE[19].distance.." \124cffFFFFFFhealth \124cff666666= \124cff4e7300"..CACHEUNITSTABLE[19].health)
		else
		    liveunitcachetable_gui.elements.unitcacheindex19key:SetText("")
		    liveunitcachetable_gui.elements.unitcacheindex19name:SetText("")
		    liveunitcachetable_gui.elements.unitcacheindex19value:SetText("")
		end
		if CACHEUNITSTABLE[20] ~= nil then
		    liveunitcachetable_gui.elements.unitcacheindex20key:SetText("\124cffFFFFFF[01] \124cff666666"..CACHEUNITSTABLE[20].object)
		    liveunitcachetable_gui.elements.unitcacheindex20name:SetText("\124cff4e7300"..CACHEUNITSTABLE[20].name)
		    liveunitcachetable_gui.elements.unitcacheindex20value:SetText("\124cffFFFFFFdistance \124cff666666= \124cff4e7300"..CACHEUNITSTABLE[20].distance.." \124cffFFFFFFhealth \124cff666666= \124cff4e7300"..CACHEUNITSTABLE[20].health)
		else
		    liveunitcachetable_gui.elements.unitcacheindex20key:SetText("")
		    liveunitcachetable_gui.elements.unitcacheindex20name:SetText("")
		    liveunitcachetable_gui.elements.unitcacheindex20value:SetText("")
		end

	end
end

function LiveTargetTableUpdate()
	if livetargettableshow then
		local name_index = tostring(CURRENTTARGETINFOTABLE["name"])
		local name_element = ("\124cffFFFFFFname \124cff666666= \124cff4e7300"..name_index)
		local distance_index = tostring(GetRound((CURRENTTARGETINFOTABLE["distance"]), 4))
		local distance_element = ("\124cffFFFFFFdistance \124cff666666= \124cff4e7300"..distance_index)
		local reach_index = tostring(CURRENTTARGETINFOTABLE["reach"])
		local reach_element = ("\124cffFFFFFFreach \124cff666666= \124cff4e7300"..reach_index)
		local healthact_index = tostring(CURRENTTARGETINFOTABLE["healthact"])
		local healthact_element = ("\124cffFFFFFFhealth actual \124cff666666= \124cff4e7300"..healthact_index)
		local healthmax_index = tostring(CURRENTTARGETINFOTABLE["healthmax"])
		local healthmax_element = ("\124cffFFFFFFhealth max \124cff666666= \124cff4e7300"..healthmax_index)
		local healthpct_index = tostring(CURRENTTARGETINFOTABLE["healthpct"])
		local healthpct_element = ("\124cffFFFFFFhealth pct \124cff666666= \124cff4e7300"..healthpct_index)
		local combat_index = tostring(CURRENTTARGETINFOTABLE["combat"])
		local combat_element = ("\124cffFFFFFFcombat \124cff666666= \124cff4e7300"..combat_index)
		local reaction_index = tostring(CURRENTTARGETINFOTABLE["reaction"])
		local reaction_element = ("\124cffFFFFFFreaction \124cff666666= \124cff4e7300"..reaction_index)
		local specialaura_index = tostring(CURRENTTARGETINFOTABLE["specialaura"])
		local specialaura_element = ("\124cffFFFFFFspecial aura \124cff666666= \124cff4e7300"..specialaura_index)
		local specialtarget_index = tostring(CURRENTTARGETINFOTABLE["specialtarget"])
		local specialtarget_element = ("\124cffFFFFFFspecial target \124cff666666= \124cff4e7300"..specialtarget_index)
		local tappedbyme_index = tostring(CURRENTTARGETINFOTABLE["tappedbyme"])
		local tappedbyme_element = ("\124cffFFFFFFtapped by me \124cff666666= \124cff4e7300"..tappedbyme_index)
		local tappedbyall_index = tostring(CURRENTTARGETINFOTABLE["tappedbyall"])
		local tappedbyall_element = ("\124cffFFFFFFtapped by all \124cff666666= \124cff4e7300"..tappedbyall_index)
		local attackp2t_index = tostring(CURRENTTARGETINFOTABLE["attackp2t"])
		local attackp2t_element = ("\124cffFFFFFFyou can attack \124cff666666= \124cff4e7300"..attackp2t_index)
		local attackt2p_index = tostring(CURRENTTARGETINFOTABLE["attackt2p"])
		local attackt2p_element = ("\124cffFFFFFFcan attack you \124cff666666= \124cff4e7300"..attackt2p_index)
		local deathin_index = tostring(CURRENTTARGETINFOTABLE["deathin"])
		local deathin_element = ("\124cffFFFFFFdeath in \124cff666666= \124cff4e7300"..deathin_index)

		livetargettable_gui.elements.guid:SetText(CURRENTTARGETINFOTABLE["guid"])
		livetargettable_gui.elements.name:SetText(name_element)
		livetargettable_gui.elements.distance:SetText(distance_element)
		livetargettable_gui.elements.reach:SetText(reach_element)
		livetargettable_gui.elements.healthact:SetText(healthact_element)
		livetargettable_gui.elements.healthmax:SetText(healthmax_element)
		livetargettable_gui.elements.healthpct:SetText(healthpct_element)
		livetargettable_gui.elements.combat:SetText(combat_element)
		livetargettable_gui.elements.reaction:SetText(reaction_element)
		livetargettable_gui.elements.specialaura:SetText(specialaura_element)
		livetargettable_gui.elements.specialtarget:SetText(specialtarget_element)
		livetargettable_gui.elements.tappedbyme:SetText(tappedbyme_element)
		livetargettable_gui.elements.tappedbyall:SetText(tappedbyall_element)
		livetargettable_gui.elements.attackp2t:SetText(attackp2t_element)
		livetargettable_gui.elements.attackt2p:SetText(attackt2p_element)
		livetargettable_gui.elements.deathin:SetText(deathin_element)
	end
end
