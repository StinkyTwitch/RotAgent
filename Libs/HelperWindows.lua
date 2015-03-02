--[[------------------------------------------------------------------------------------------------
	HelperWindows.lua

	RotAgent (Rotation Agent) License
	This work is licensed under the Creative Commons Attribution-NonCommercial 4.0 International
	License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc/4.0/.

--------------------------------------------------------------------------------------------------]]
local RotAgentName, RotAgent = ...

RotAgent.configWindowShow = false
RotAgent.currentTargetInfoTable = { }
RotAgent.helperWindowCacheShow = false
RotAgent.helperWindowTargetShow = false

local helperWindowCache_GUI = ProbablyEngine.interface.buildGUI({
	key = "helperWindowCache_key",
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
helperWindowCache_GUI.parent:Hide()


local helperWindowTarget_GUI = ProbablyEngine.interface.buildGUI({
	key = "helperWindowTarget_key",
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
helperWindowTarget_GUI.parent:Hide()




function RotAgent.ConfigWindowShow()
	RotAgent.configWindowShow = not RotAgent.configWindowShow

	if RotAgent.configWindowShow then
		RotAgent.ConfigWindow.parent:Show()
	else
		RotAgent.ConfigWindow.parent:Hide()
	end
end

function RotAgent.HelperWindowCacheShow()
	RotAgent.helperWindowCacheShow = not RotAgent.helperWindowCacheShow

	if RotAgent.helperWindowCacheShow then
		helperWindowCache_GUI.parent:Show()
	else
		helperWindowCache_GUI.parent:Hide()
	end
end

function RotAgent.HelperWindowTargetShow()
	RotAgent.helperWindowTargetShow = not RotAgent.helperWindowTargetShow

	if RotAgent.helperWindowTargetShow then
		helperWindowTarget_GUI.parent:Show()
	else
		helperWindowTarget_GUI.parent:Hide()
	end
end





function RotAgent.HelperWindowCacheUpdate()
	if RotAgent.helperWindowCacheShow then

		local racachecount = table.getn(RotAgent.unitCacheCombat)
		local fhuaucount = RotAgent.FireHackUAUCount

		helperWindowCache_GUI.elements.unitcacheindextotal:SetText("\124cffFFFFFFCache Count = \124cff666666"..table.getn(RotAgent.unitCacheCombat).." \124cff4e7300 |  \124cffFFFFFFUAU Count = \124cff666666"..RotAgent.uauCacheSize)

		if RotAgent.unitCacheCombat[1] ~= nil then
		    helperWindowCache_GUI.elements.unitcacheindex1key:SetText("\124cffFFFFFF[01] \124cff666666"..RotAgent.unitCacheCombat[1].object)
		    helperWindowCache_GUI.elements.unitcacheindex1name:SetText("\124cff4e7300"..RotAgent.unitCacheCombat[1].name)
		    helperWindowCache_GUI.elements.unitcacheindex1value:SetText("\124cffFFFFFFdistance \124cff666666= \124cff4e7300"..RotAgent.unitCacheCombat[1].distance.." \124cffFFFFFFhealth \124cff666666= \124cff4e7300"..RotAgent.unitCacheCombat[1].health)
		else
		    helperWindowCache_GUI.elements.unitcacheindex1key:SetText("")
		    helperWindowCache_GUI.elements.unitcacheindex1name:SetText("")
		    helperWindowCache_GUI.elements.unitcacheindex1value:SetText("")
		end
		if RotAgent.unitCacheCombat[2] ~= nil then
		    helperWindowCache_GUI.elements.unitcacheindex2key:SetText("\124cffFFFFFF[02] \124cff666666"..RotAgent.unitCacheCombat[2].object)
		    helperWindowCache_GUI.elements.unitcacheindex2name:SetText("\124cff4e7300"..RotAgent.unitCacheCombat[2].name)
		    helperWindowCache_GUI.elements.unitcacheindex2value:SetText("\124cffFFFFFFdistance \124cff666666= \124cff4e7300"..RotAgent.unitCacheCombat[2].distance.." \124cffFFFFFFhealth \124cff666666= \124cff4e7300"..RotAgent.unitCacheCombat[2].health)
		else
		    helperWindowCache_GUI.elements.unitcacheindex2key:SetText("")
		    helperWindowCache_GUI.elements.unitcacheindex2name:SetText("")
		    helperWindowCache_GUI.elements.unitcacheindex2value:SetText("")
		end
		if RotAgent.unitCacheCombat[3] ~= nil then
		    helperWindowCache_GUI.elements.unitcacheindex3key:SetText("\124cffFFFFFF[03] \124cff666666"..RotAgent.unitCacheCombat[3].object)
		    helperWindowCache_GUI.elements.unitcacheindex3name:SetText("\124cff4e7300"..RotAgent.unitCacheCombat[3].name)
		    helperWindowCache_GUI.elements.unitcacheindex3value:SetText("\124cffFFFFFFdistance \124cff666666= \124cff4e7300"..RotAgent.unitCacheCombat[3].distance.." \124cffFFFFFFhealth \124cff666666= \124cff4e7300"..RotAgent.unitCacheCombat[3].health)
		else
		    helperWindowCache_GUI.elements.unitcacheindex3key:SetText("")
		    helperWindowCache_GUI.elements.unitcacheindex3name:SetText("")
		    helperWindowCache_GUI.elements.unitcacheindex3value:SetText("")
		end
		if RotAgent.unitCacheCombat[4] ~= nil then
		    helperWindowCache_GUI.elements.unitcacheindex4key:SetText("\124cffFFFFFF[04] \124cff666666"..RotAgent.unitCacheCombat[4].object)
		    helperWindowCache_GUI.elements.unitcacheindex4name:SetText("\124cff4e7300"..RotAgent.unitCacheCombat[4].name)
		    helperWindowCache_GUI.elements.unitcacheindex4value:SetText("\124cffFFFFFFdistance \124cff666666= \124cff4e7300"..RotAgent.unitCacheCombat[4].distance.." \124cffFFFFFFhealth \124cff666666= \124cff4e7300"..RotAgent.unitCacheCombat[4].health)
		else
		    helperWindowCache_GUI.elements.unitcacheindex4key:SetText("")
		    helperWindowCache_GUI.elements.unitcacheindex4name:SetText("")
		    helperWindowCache_GUI.elements.unitcacheindex4value:SetText("")
		end
		if RotAgent.unitCacheCombat[5] ~= nil then
		    helperWindowCache_GUI.elements.unitcacheindex5key:SetText("\124cffFFFFFF[05] \124cff666666"..RotAgent.unitCacheCombat[5].object)
		    helperWindowCache_GUI.elements.unitcacheindex5name:SetText("\124cff4e7300"..RotAgent.unitCacheCombat[5].name)
		    helperWindowCache_GUI.elements.unitcacheindex5value:SetText("\124cffFFFFFFdistance \124cff666666= \124cff4e7300"..RotAgent.unitCacheCombat[5].distance.." \124cffFFFFFFhealth \124cff666666= \124cff4e7300"..RotAgent.unitCacheCombat[5].health)
		else
		    helperWindowCache_GUI.elements.unitcacheindex5key:SetText("")
		    helperWindowCache_GUI.elements.unitcacheindex5name:SetText("")
		    helperWindowCache_GUI.elements.unitcacheindex5value:SetText("")
		end
		if RotAgent.unitCacheCombat[6] ~= nil then
		    helperWindowCache_GUI.elements.unitcacheindex6key:SetText("\124cffFFFFFF[06] \124cff666666"..RotAgent.unitCacheCombat[6].object)
		    helperWindowCache_GUI.elements.unitcacheindex6name:SetText("\124cff4e7300"..RotAgent.unitCacheCombat[6].name)
		    helperWindowCache_GUI.elements.unitcacheindex6value:SetText("\124cffFFFFFFdistance \124cff666666= \124cff4e7300"..RotAgent.unitCacheCombat[6].distance.." \124cffFFFFFFhealth \124cff666666= \124cff4e7300"..RotAgent.unitCacheCombat[6].health)
		else
		    helperWindowCache_GUI.elements.unitcacheindex6key:SetText("")
		    helperWindowCache_GUI.elements.unitcacheindex6name:SetText("")
		    helperWindowCache_GUI.elements.unitcacheindex6value:SetText("")
		end
		if RotAgent.unitCacheCombat[7] ~= nil then
		    helperWindowCache_GUI.elements.unitcacheindex7key:SetText("\124cffFFFFFF[07] \124cff666666"..RotAgent.unitCacheCombat[7].object)
		    helperWindowCache_GUI.elements.unitcacheindex7name:SetText("\124cff4e7300"..RotAgent.unitCacheCombat[7].name)
		    helperWindowCache_GUI.elements.unitcacheindex7value:SetText("\124cffFFFFFFdistance \124cff666666= \124cff4e7300"..RotAgent.unitCacheCombat[7].distance.." \124cffFFFFFFhealth \124cff666666= \124cff4e7300"..RotAgent.unitCacheCombat[7].health)
		else
		    helperWindowCache_GUI.elements.unitcacheindex7key:SetText("")
		    helperWindowCache_GUI.elements.unitcacheindex7name:SetText("")
		    helperWindowCache_GUI.elements.unitcacheindex7value:SetText("")
		end
		if RotAgent.unitCacheCombat[8] ~= nil then
		    helperWindowCache_GUI.elements.unitcacheindex8key:SetText("\124cffFFFFFF[08] \124cff666666"..RotAgent.unitCacheCombat[8].object)
		    helperWindowCache_GUI.elements.unitcacheindex8name:SetText("\124cff4e7300"..RotAgent.unitCacheCombat[8].name)
		    helperWindowCache_GUI.elements.unitcacheindex8value:SetText("\124cffFFFFFFdistance \124cff666666= \124cff4e7300"..RotAgent.unitCacheCombat[8].distance.." \124cffFFFFFFhealth \124cff666666= \124cff4e7300"..RotAgent.unitCacheCombat[8].health)
		else
		    helperWindowCache_GUI.elements.unitcacheindex8key:SetText("")
		    helperWindowCache_GUI.elements.unitcacheindex8name:SetText("")
		    helperWindowCache_GUI.elements.unitcacheindex8value:SetText("")
		end
		if RotAgent.unitCacheCombat[9] ~= nil then
		    helperWindowCache_GUI.elements.unitcacheindex9key:SetText("\124cffFFFFFF[09] \124cff666666"..RotAgent.unitCacheCombat[9].object)
		    helperWindowCache_GUI.elements.unitcacheindex9name:SetText("\124cff4e7300"..RotAgent.unitCacheCombat[9].name)
		    helperWindowCache_GUI.elements.unitcacheindex9value:SetText("\124cffFFFFFFdistance \124cff666666= \124cff4e7300"..RotAgent.unitCacheCombat[9].distance.." \124cffFFFFFFhealth \124cff666666= \124cff4e7300"..RotAgent.unitCacheCombat[9].health)
		else
		    helperWindowCache_GUI.elements.unitcacheindex9key:SetText("")
		    helperWindowCache_GUI.elements.unitcacheindex9name:SetText("")
		    helperWindowCache_GUI.elements.unitcacheindex9value:SetText("")
		end
		if RotAgent.unitCacheCombat[10] ~= nil then
		    helperWindowCache_GUI.elements.unitcacheindex10key:SetText("\124cffFFFFFF[10] \124cff666666"..RotAgent.unitCacheCombat[10].object)
		    helperWindowCache_GUI.elements.unitcacheindex10name:SetText("\124cff4e7300"..RotAgent.unitCacheCombat[10].name)
		    helperWindowCache_GUI.elements.unitcacheindex10value:SetText("\124cffFFFFFFdistance \124cff666666= \124cff4e7300"..RotAgent.unitCacheCombat[10].distance.." \124cffFFFFFFhealth \124cff666666= \124cff4e7300"..RotAgent.unitCacheCombat[10].health)
		else
		    helperWindowCache_GUI.elements.unitcacheindex10key:SetText("")
		    helperWindowCache_GUI.elements.unitcacheindex10name:SetText("")
		    helperWindowCache_GUI.elements.unitcacheindex10value:SetText("")
		end

		if RotAgent.unitCacheCombat[11] ~= nil then
		    helperWindowCache_GUI.elements.unitcacheindex11key:SetText("\124cffFFFFFF[11] \124cff666666"..RotAgent.unitCacheCombat[11].object)
		    helperWindowCache_GUI.elements.unitcacheindex11name:SetText("\124cff4e7300"..RotAgent.unitCacheCombat[11].name)
		    helperWindowCache_GUI.elements.unitcacheindex11value:SetText("\124cffFFFFFFdistance \124cff666666= \124cff4e7300"..RotAgent.unitCacheCombat[11].distance.." \124cffFFFFFFhealth \124cff666666= \124cff4e7300"..RotAgent.unitCacheCombat[11].health)
		else
		    helperWindowCache_GUI.elements.unitcacheindex11key:SetText("")
		    helperWindowCache_GUI.elements.unitcacheindex11name:SetText("")
		    helperWindowCache_GUI.elements.unitcacheindex11value:SetText("")
		end
		if RotAgent.unitCacheCombat[12] ~= nil then
		    helperWindowCache_GUI.elements.unitcacheindex12key:SetText("\124cffFFFFFF[12] \124cff666666"..RotAgent.unitCacheCombat[12].object)
		    helperWindowCache_GUI.elements.unitcacheindex12name:SetText("\124cff4e7300"..RotAgent.unitCacheCombat[12].name)
		    helperWindowCache_GUI.elements.unitcacheindex12value:SetText("\124cffFFFFFFdistance \124cff666666= \124cff4e7300"..RotAgent.unitCacheCombat[12].distance.." \124cffFFFFFFhealth \124cff666666= \124cff4e7300"..RotAgent.unitCacheCombat[12].health)
		else
		    helperWindowCache_GUI.elements.unitcacheindex12key:SetText("")
		    helperWindowCache_GUI.elements.unitcacheindex12name:SetText("")
		    helperWindowCache_GUI.elements.unitcacheindex12value:SetText("")
		end
		if RotAgent.unitCacheCombat[13] ~= nil then
		    helperWindowCache_GUI.elements.unitcacheindex13key:SetText("\124cffFFFFFF[13] \124cff666666"..RotAgent.unitCacheCombat[13].object)
		    helperWindowCache_GUI.elements.unitcacheindex13name:SetText("\124cff4e7300"..RotAgent.unitCacheCombat[13].name)
		    helperWindowCache_GUI.elements.unitcacheindex13value:SetText("\124cffFFFFFFdistance \124cff666666= \124cff4e7300"..RotAgent.unitCacheCombat[13].distance.." \124cffFFFFFFhealth \124cff666666= \124cff4e7300"..RotAgent.unitCacheCombat[13].health)
		else
		    helperWindowCache_GUI.elements.unitcacheindex13key:SetText("")
		    helperWindowCache_GUI.elements.unitcacheindex13name:SetText("")
		    helperWindowCache_GUI.elements.unitcacheindex13value:SetText("")
		end
		if RotAgent.unitCacheCombat[14] ~= nil then
		    helperWindowCache_GUI.elements.unitcacheindex14key:SetText("\124cffFFFFFF[14] \124cff666666"..RotAgent.unitCacheCombat[14].object)
		    helperWindowCache_GUI.elements.unitcacheindex14name:SetText("\124cff4e7300"..RotAgent.unitCacheCombat[14].name)
		    helperWindowCache_GUI.elements.unitcacheindex14value:SetText("\124cffFFFFFFdistance \124cff666666= \124cff4e7300"..RotAgent.unitCacheCombat[14].distance.." \124cffFFFFFFhealth \124cff666666= \124cff4e7300"..RotAgent.unitCacheCombat[14].health)
		else
		    helperWindowCache_GUI.elements.unitcacheindex14key:SetText("")
		    helperWindowCache_GUI.elements.unitcacheindex14name:SetText("")
		    helperWindowCache_GUI.elements.unitcacheindex14value:SetText("")
		end
		if RotAgent.unitCacheCombat[15] ~= nil then
		    helperWindowCache_GUI.elements.unitcacheindex15key:SetText("\124cffFFFFFF[15] \124cff666666"..RotAgent.unitCacheCombat[15].object)
		    helperWindowCache_GUI.elements.unitcacheindex15name:SetText("\124cff4e7300"..RotAgent.unitCacheCombat[15].name)
		    helperWindowCache_GUI.elements.unitcacheindex15value:SetText("\124cffFFFFFFdistance \124cff666666= \124cff4e7300"..RotAgent.unitCacheCombat[15].distance.." \124cffFFFFFFhealth \124cff666666= \124cff4e7300"..RotAgent.unitCacheCombat[15].health)
		else
		    helperWindowCache_GUI.elements.unitcacheindex15key:SetText("")
		    helperWindowCache_GUI.elements.unitcacheindex15name:SetText("")
		    helperWindowCache_GUI.elements.unitcacheindex15value:SetText("")
		end
		if RotAgent.unitCacheCombat[16] ~= nil then
		    helperWindowCache_GUI.elements.unitcacheindex16key:SetText("\124cffFFFFFF[16] \124cff666666"..RotAgent.unitCacheCombat[16].object)
		    helperWindowCache_GUI.elements.unitcacheindex16name:SetText("\124cff4e7300"..RotAgent.unitCacheCombat[16].name)
		    helperWindowCache_GUI.elements.unitcacheindex16value:SetText("\124cffFFFFFFdistance \124cff666666= \124cff4e7300"..RotAgent.unitCacheCombat[16].distance.." \124cffFFFFFFhealth \124cff666666= \124cff4e7300"..RotAgent.unitCacheCombat[16].health)
		else
		    helperWindowCache_GUI.elements.unitcacheindex16key:SetText("")
		    helperWindowCache_GUI.elements.unitcacheindex16name:SetText("")
		    helperWindowCache_GUI.elements.unitcacheindex16value:SetText("")
		end
		if RotAgent.unitCacheCombat[17] ~= nil then
		    helperWindowCache_GUI.elements.unitcacheindex17key:SetText("\124cffFFFFFF[17] \124cff666666"..RotAgent.unitCacheCombat[17].object)
		    helperWindowCache_GUI.elements.unitcacheindex17name:SetText("\124cff4e7300"..RotAgent.unitCacheCombat[17].name)
		    helperWindowCache_GUI.elements.unitcacheindex17value:SetText("\124cffFFFFFFdistance \124cff666666= \124cff4e7300"..RotAgent.unitCacheCombat[17].distance.." \124cffFFFFFFhealth \124cff666666= \124cff4e7300"..RotAgent.unitCacheCombat[17].health)
		else
		    helperWindowCache_GUI.elements.unitcacheindex17key:SetText("")
		    helperWindowCache_GUI.elements.unitcacheindex17name:SetText("")
		    helperWindowCache_GUI.elements.unitcacheindex17value:SetText("")
		end
		if RotAgent.unitCacheCombat[18] ~= nil then
		    helperWindowCache_GUI.elements.unitcacheindex18key:SetText("\124cffFFFFFF[18] \124cff666666"..RotAgent.unitCacheCombat[18].object)
		    helperWindowCache_GUI.elements.unitcacheindex18name:SetText("\124cff4e7300"..RotAgent.unitCacheCombat[18].name)
		    helperWindowCache_GUI.elements.unitcacheindex18value:SetText("\124cffFFFFFFdistance \124cff666666= \124cff4e7300"..RotAgent.unitCacheCombat[18].distance.." \124cffFFFFFFhealth \124cff666666= \124cff4e7300"..RotAgent.unitCacheCombat[18].health)
		else
		    helperWindowCache_GUI.elements.unitcacheindex18key:SetText("")
		    helperWindowCache_GUI.elements.unitcacheindex18name:SetText("")
		    helperWindowCache_GUI.elements.unitcacheindex18value:SetText("")
		end
		if RotAgent.unitCacheCombat[19] ~= nil then
		    helperWindowCache_GUI.elements.unitcacheindex19key:SetText("\124cffFFFFFF[19] \124cff666666"..RotAgent.unitCacheCombat[19].object)
		    helperWindowCache_GUI.elements.unitcacheindex19name:SetText("\124cff4e7300"..RotAgent.unitCacheCombat[19].name)
		    helperWindowCache_GUI.elements.unitcacheindex19value:SetText("\124cffFFFFFFdistance \124cff666666= \124cff4e7300"..RotAgent.unitCacheCombat[19].distance.." \124cffFFFFFFhealth \124cff666666= \124cff4e7300"..RotAgent.unitCacheCombat[19].health)
		else
		    helperWindowCache_GUI.elements.unitcacheindex19key:SetText("")
		    helperWindowCache_GUI.elements.unitcacheindex19name:SetText("")
		    helperWindowCache_GUI.elements.unitcacheindex19value:SetText("")
		end
		if RotAgent.unitCacheCombat[20] ~= nil then
		    helperWindowCache_GUI.elements.unitcacheindex20key:SetText("\124cffFFFFFF[20] \124cff666666"..RotAgent.unitCacheCombat[20].object)
		    helperWindowCache_GUI.elements.unitcacheindex20name:SetText("\124cff4e7300"..RotAgent.unitCacheCombat[20].name)
		    helperWindowCache_GUI.elements.unitcacheindex20value:SetText("\124cffFFFFFFdistance \124cff666666= \124cff4e7300"..RotAgent.unitCacheCombat[20].distance.." \124cffFFFFFFhealth \124cff666666= \124cff4e7300"..RotAgent.unitCacheCombat[20].health)
		else
		    helperWindowCache_GUI.elements.unitcacheindex20key:SetText("")
		    helperWindowCache_GUI.elements.unitcacheindex20name:SetText("")
		    helperWindowCache_GUI.elements.unitcacheindex20value:SetText("")
		end

	end
end

function RotAgent.HelperWindowTargetUpdate()
	if RotAgent.helperWindowTargetShow then
		local name_index = tostring(RotAgent.currentTargetInfoTable["name"])
		local name_element = ("\124cffFFFFFFname \124cff666666= \124cff4e7300"..name_index)
		local distance_index = tostring(RotAgent.currentTargetInfoTable["distance"])
		local distance_element = ("\124cffFFFFFFdistance \124cff666666= \124cff4e7300"..distance_index)
		local reach_index = tostring(RotAgent.currentTargetInfoTable["reach"])
		local reach_element = ("\124cffFFFFFFreach \124cff666666= \124cff4e7300"..reach_index)
		local healthact_index = tostring(RotAgent.currentTargetInfoTable["healthact"])
		local healthact_element = ("\124cffFFFFFFhealth actual \124cff666666= \124cff4e7300"..healthact_index)
		local healthmax_index = tostring(RotAgent.currentTargetInfoTable["healthmax"])
		local healthmax_element = ("\124cffFFFFFFhealth max \124cff666666= \124cff4e7300"..healthmax_index)
		local healthpct_index = tostring(RotAgent.currentTargetInfoTable["healthpct"])
		local healthpct_element = ("\124cffFFFFFFhealth pct \124cff666666= \124cff4e7300"..healthpct_index)
		local combat_index = tostring(RotAgent.currentTargetInfoTable["combat"])
		local combat_element = ("\124cffFFFFFFcombat \124cff666666= \124cff4e7300"..combat_index)
		local reaction_index = tostring(RotAgent.currentTargetInfoTable["reaction"])
		local reaction_element = ("\124cffFFFFFFreaction \124cff666666= \124cff4e7300"..reaction_index)
		local specialaura_index = tostring(RotAgent.currentTargetInfoTable["specialaura"])
		local specialaura_element = ("\124cffFFFFFFspecial aura \124cff666666= \124cff4e7300"..specialaura_index)
		local specialtarget_index = tostring(RotAgent.currentTargetInfoTable["specialtarget"])
		local specialtarget_element = ("\124cffFFFFFFspecial target \124cff666666= \124cff4e7300"..specialtarget_index)
		local tappedbyme_index = tostring(RotAgent.currentTargetInfoTable["tappedbyme"])
		local tappedbyme_element = ("\124cffFFFFFFtapped by me \124cff666666= \124cff4e7300"..tappedbyme_index)
		local tappedbyall_index = tostring(RotAgent.currentTargetInfoTable["tappedbyall"])
		local tappedbyall_element = ("\124cffFFFFFFtapped by all \124cff666666= \124cff4e7300"..tappedbyall_index)
		local attackp2t_index = tostring(RotAgent.currentTargetInfoTable["attackp2t"])
		local attackp2t_element = ("\124cffFFFFFFyou can attack \124cff666666= \124cff4e7300"..attackp2t_index)
		local attackt2p_index = tostring(RotAgent.currentTargetInfoTable["attackt2p"])
		local attackt2p_element = ("\124cffFFFFFFcan attack you \124cff666666= \124cff4e7300"..attackt2p_index)
		local deathin_index = tostring(RotAgent.currentTargetInfoTable["deathin"])
		local deathin_element = ("\124cffFFFFFFdeath in \124cff666666= \124cff4e7300"..deathin_index)

		helperWindowTarget_GUI.elements.guid:SetText(RotAgent.currentTargetInfoTable["guid"])
		helperWindowTarget_GUI.elements.name:SetText(name_element)
		helperWindowTarget_GUI.elements.distance:SetText(distance_element)
		helperWindowTarget_GUI.elements.reach:SetText(reach_element)
		helperWindowTarget_GUI.elements.healthact:SetText(healthact_element)
		helperWindowTarget_GUI.elements.healthmax:SetText(healthmax_element)
		helperWindowTarget_GUI.elements.healthpct:SetText(healthpct_element)
		helperWindowTarget_GUI.elements.combat:SetText(combat_element)
		helperWindowTarget_GUI.elements.reaction:SetText(reaction_element)
		helperWindowTarget_GUI.elements.specialaura:SetText(specialaura_element)
		helperWindowTarget_GUI.elements.specialtarget:SetText(specialtarget_element)
		helperWindowTarget_GUI.elements.tappedbyme:SetText(tappedbyme_element)
		helperWindowTarget_GUI.elements.tappedbyall:SetText(tappedbyall_element)
		helperWindowTarget_GUI.elements.attackp2t:SetText(attackp2t_element)
		helperWindowTarget_GUI.elements.attackt2p:SetText(attackt2p_element)
		helperWindowTarget_GUI.elements.deathin:SetText(deathin_element)
	end
end

function RotAgent.CurrentTargetInfoTable(target)
	if not UnitExists(target) then
		for k in pairs(RotAgent.currentTargetInfoTable) do
			RotAgent.currentTargetInfoTable[k] = nil
		end
	end

	if FireHack then
		local totalObjects = ObjectCount()

		for i=1, totalObjects do
			local object = ObjectWithIndex(i)
			local _, objectExists = pcall(ObjectExists,object)

			if objectExists then
				local _, objectType = pcall(ObjectType, object)
				local bitband = bit.band(objectType, ObjectTypes.Unit)
				local _,_,_,_,_,objectGUID,_ = strsplit("-",UnitGUID(object))
				if bitband > 0 then
					if objectGUID == target then
						target = object
					end
				end
			end
		end
	else
		for k in pairs(RotAgent.currentTargetInfoTable) do
			RotAgent.currentTargetInfoTable[k] = nil
		end
	end

	if UnitExists(target) and (FireHack or oexecute) then
		local targetGUID = tostring(UnitGUID(target))
		local targetName = tostring(UnitName(target))
		local targetDistance = RotAgent.Distance("player", target, 2, "reach")
		local targetCombatReach = RotAgent.GetCombatReach(target)
		local targetHealthAct = UnitHealth(target)
		local targetHealthMax = UnitHealthMax(target)
		local targetHealthPct = math.floor((targetHealthAct / targetHealthMax) * 100)
		local targetAffectingCombat = tostring(UnitAffectingCombat(target))
		local targetReaction = UnitReaction("player", target)
		local targetSpecialAura = tostring(RotAgent.SpecialAurasCheck(target))
		local targetSpecialTarget = tostring(RotAgent.SpecialEnemyTargetsCheck(target))
		local targetTappedByPlayer = tostring(UnitIsTappedByPlayer(target))
		local targetTappedByAll = tostring(UnitIsTappedByAllThreatList(target))
		local targetAttackP2T = tostring(UnitCanAttack("player", target))
		local targetAttackT2P = tostring(UnitCanAttack(target, "player"))
		local targetDeathin = RotAgent.TimeToDeath(target)

		RotAgent.currentTargetInfoTable["guid"] = targetGUID
		RotAgent.currentTargetInfoTable["name"] = targetName
		RotAgent.currentTargetInfoTable["distance"] = targetDistance
		RotAgent.currentTargetInfoTable["reach"] = targetCombatReach
		RotAgent.currentTargetInfoTable["healthact"] = targetHealthAct
		RotAgent.currentTargetInfoTable["healthmax"] = targetHealthMax
		RotAgent.currentTargetInfoTable["healthpct"] = targetHealthPct
		RotAgent.currentTargetInfoTable["combat"] = targetAffectingCombat
		RotAgent.currentTargetInfoTable["reaction"] = targetReaction
		RotAgent.currentTargetInfoTable["specialaura"] = targetSpecialAura
		RotAgent.currentTargetInfoTable["specialtarget"] = targetSpecialTarget
		RotAgent.currentTargetInfoTable["tappedbyme"] = targetTappedByPlayer
		RotAgent.currentTargetInfoTable["tappedbyall"] = targetTappedByAll
		RotAgent.currentTargetInfoTable["attackp2t"] = targetAttackP2T
		RotAgent.currentTargetInfoTable["attackt2p"] = targetAttackT2P
		RotAgent.currentTargetInfoTable["deathin"] = targetDeathin
	end
end

function BuildTreeUnitCache()
	local DiesalGUI = LibStub("DiesalGUI-1.0")
	local explore = DiesalGUI:Create('TableExplorer')
	explore:SetTable("Cache Units Table", RotAgent.unitCacheCombat)
	explore:BuildTree()
end