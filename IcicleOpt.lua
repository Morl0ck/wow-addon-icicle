--------------------------------
--// Icicle.
--------------------------------
local addon = {}
local addonName = "Icicle"
_G[addonName] = addon
--------------------------------
--------------------------------
local IcicleOpts
local G = _G

Icicle.fonts = {}
local LSM = LibStub("LibSharedMedia-3.0")
LSM:Register("font", "Hooge0655", [[Interface\AddOns\Icicle\Hooge0655.ttf]])

local function updateMedia(event, mediatype, key)
	if mediatype == "font" then
		Icicle.fonts[key] = SML:Fetch(mediaType, key)
	end
end
--------------------------------
--// Defaults.
--------------------------------
local Settings = {
	font = "Interface\\AddOns\\Icicle\\Hooge0655.ttf",
	fontX = 1,
	fontY =  -7,
	fontName = "Hooge0655",
	fontSize = 10,
	iconsize = 22,
	xoff = -60,
	yoff = 25,
	borderCol = {1, 1, 1},
	interCol = {1, .35, 0},
	trinketCol = {.5, 1, 0},
}

local cooldowns = {
	["Misc"] = {
		[59752] = 120,				--Every Man for Himself
		[42292] = 120,				--PvP Trinket
	},
	["Deathknight"] = {
		[108200] = 60,				--"Remorseless Winter",
		[108194] = 30,				--"Asphyxiate",
		[108199] = 60,				--"Gorefiend's Grasp",
		[115989] = 90,				--"Unholy Blight",
		[49039] = 120,				--"Lichborne",
		[47476] = 60,				--"Strangulate",
		[48707] = 45,				--"Anti-Magic Shell",
		[49576] = 25,				--"Death Grip",	
		[47528] = 15,				--"Mind Freeze",
		[49222] = 60,				--"Bone Shield",
		[51271] = 60,				--"Pillar of Frost",
		[49206] = 180,				--"Summon Gargoyle",
		[48792] = 180,				--"Icebound Fortitude",
	},
	["Mage"] = {
		[108839] = 45,				--"Ice Floes",
		[102051] = 20,				--"Frostjaw",
		[2139] = 24,				--"Counterspell",
		[44572] = 30,				--"Deep Freeze",
		[11958] = 180,				--"Cold Snap",
		[45438] = 300,				--"Ice Block",		
		[12042] = 90,				--"Arcane Power",		
		[122] = 25,					--"Frost Nova",	
		[11426] = 25,				--"Ice Barrier", 
		[12472] = 180,				--"Icy Veins",
		[113724] = 45,				--"Ring of Frost",
		[12043] = 90,				--"Presence of Mind",
		[11129] = 45,				--"Combustion",
		[31661] = 20,				--"Dragon's Breath",
		},
	["Priest"] = {
		[108921] = 45,				--"Psyfiend",
		[108920] = 30,				--"Void Tendrils",
		[89485] = 45,				--"Inner Focus",
		[64044] = 45,				--"Psychic Horror",
		[8122] = 30,				--"Psychic Scream",
		[15487] = 45,				--"Silence",
		[47585] = 120,				--"Dispersion",
		[33206] = 180,				--"Pain Suppression",
		[10060] = 120,				--"Power Infusion",
		[88625] = 30,				--"Holy Word: Chastise",
		[73325] = 90,				--"Leap of Faith",
	},
	["Druid"] = {
		[124974] = 90,				--"Nature's Vigil",
		[102359] = 30,				--"Mass Entanglement",
		[99] = 30,					--"Disorienting Roar",
		[102280] = 30,				--"Displacer Beast",
		[5211] = 50,				--"Mighty Bash",
		[22812] = 60,				--"Barkskin",
		[132158] = 60,				--"Nature's Swiftness",
		[61336] = 180,				--"Survival Instincts",
		[50334] = 180,				--"Berserk",
		[132469] = 30,				--"Typhoon",
		[78675] = 60,				--"Solar Beam",
		[5211] = 50,				--"Bash",
		[80964] = 15,				--"Skull Bash",
		[80965] = 15,				--"Skull Bash",
		[29166] = 180,				--"Innervate",
		},
	["Paladin"] = {
		[115750] = 120,				--"Blinding Light",
		[85499] = 45,				--"Speed of Light",
		[105593] = 30,				--"Fist of Justice",
		[1044] = 25,				--"Hand of Freedom",
		[31884] = 180,				--"Avenging Wrath",
		[853] = 60,					--"Hammer of Justice",
		[31935] = 15,				--"Avenger's Shield",
		[96231] = 15,				--"Rebuke",
		[633] = 600,				--"Lay on Hands",
		[1022] = 300,				--"Hand of Protection",
		[642] = 300,				--"Divine Shield",
		[6940] = 120,				--"Hand of Sacrifice",
		[31821] = 180,				--"Devotion Aura",
		[20066] = 15,				--"Repentance",
	},
	["Rogue"] = {
		[121471] = 180,				--"Shadow Blades",
		[2094] = 120,				--"Blind",
		[1766] = 15,				--"Kick",
		[14185] = 300,				--"Preparation",
		[31224] = 60,				--"Cloak of Shadows",
		[1856] = 120,				--"Vanish",
		[36554] = 20,				--"Shadowstep",
		[76577] = 180,				--"Smoke Bomb",
		[51690] = 120,				--"Killing Spree",
		[51713] = 60, 				--"Shadow Dance",
		[79140] = 120,				--"Vendetta",
	},
	["Monk"] = {
		[123904] = 180,				--"Invoke Xuen, the White Tiger",
		[101643] = 45,				--"Transcendence",
		[119996] = 25,				--"Transcendence: Transfer",
		[115176] = 180,				--"Zen Meditation",
		[115310] = 180,				--"Revival",
		[122278] = 90, 				--"Dampen Harm",
		[122783] = 90,				--"Diffuse Magic",
		[119381] = 45,				--"Leg Sweep",
		[116844] = 45,				--"Ring of Peace",
		[116849] = 120,				--"Life Cocoon",
		[115078] = 15,				--"Paralysis",
		[116705] = 15,				--"Spear Hand Strike",
		[137562] = 120,				--"Nimble Brew",
		[122470] = 90,				--"Touch of Karma",
		[116841] = 30,				--"Tiger's Lust",
		[113656] = 25,				--"Fists of Fury",
		[116705] = 15,				--"Spear Hand Strike",	
	},
	["Warlock"] = {
		[111397] = 30,				--"Blood Horror",
		[110913] = 180,				--"Dark Bargain",
		[108482] = 60,				--"Unbound Will",
		[108359] = 120,				--"Dark Regeneration",
		[108416] = 60,				--"Sacrificial Pact",
		[30283] = 30,				--"Shadowfury",
		[6789] = 45,				--"Mortal Coil",
		[5484] = 40,				--"Howl of Terror",
		[48020] = 25,				--"Demonic Circle: Teleport",
		[104773] = 180,             --Unending Resolve
	},
	["Hunter"] = {
	    [120697] = 90,				--"Lynx Rush",
		[120679] = 30,				--"Dire Beast",
		[109248] = 45,				--"Binding Shot",
		[1499] = 30,				--"Freezing Trap",
		[19386] = 45,				--"Wyvern Sting",
		[3045] = 180,				--"Rapid Fire",
		[53271] = 45, 				--"Master's Call",
		[19263] = 120,				--"Deterrence",
		--[19503] = 30,				--"Scatter Shot",
		--[34490] = 24,				--"Silencing Shot",
		[147362] = 24,				--"Counter Shot",
		[19574] = 60,				--"Bestial Wrath",      
	},
	["Shaman"] = {
		[108269] = 45,				--"Capacitor Totem",
		[108270] = 60,				--"Stone Bulwark Totem",
		[108280] = 180,				--"Healing Tide Totem",
		[98008] = 180,				--"Spirit Link Totem",
		[8177] = 25,				--"Grounding Totem",
		[57994] = 12,				--"Wind Shear",
		[51533] = 120,				--"Feral Spirit",
		[16190] = 180,				--"Mana Tide Totem",
		[30823] = 60,				--"Shamanistic Rage",
		[51490] = 45,				--"Thunderstorm",
		[2484] = 30,				--"Earthbind Totem",
		[8143] = 60,				--"Tremor Totem",
		[51514] = 45,				--"Hex",
		[79206] = 120,				--"Spiritwalker's Grace",
		[16166] = 90,				--"Elemental Mastery",
	},
	["Warrior"] = {
		[107574] = 180,				--"Avatar",
		[12292] = 60, 				--"Bloodbath",
		[6552] = 15,				--"Pummel",
		[102060] = 40,				--"Disrupting Shot",
		[23920] = 25,				--"Spell Reflection",
		[5246] = 90,				--"Intimidating Shout",
		[871] = 180,				--"Shield Wall",	
		[118038] = 120,				--"Die by the Sword",
		[1719] = 180,				--"Recklessness",
		[64382] = 300,				--"Shattering Throw",
		[12975] = 180,				--"Last Stand",
		[46924] = 60,				--"Bladestorm",
		[46968] = 40,				--"Shockwave",
	},
	["Hunter Pet"] = {
		[50479] = 40, 				--Nether Shock
		[50245] = 40, 				--Pin
		[26090] = 30, 				--Pummel
		[50318] = 60, 				--Serenity Dust
		[4167] = 40, 				--Web
	},
}
--------------------------------
--// Local functions.
--------------------------------
local function orderednext(t, n)
	local key = t[t.__next]
	if not key then return end
	t.__next = t.__next + 1
	return key, t.__source[key]
end

local function orderedpairs(t, f)
	local keys, kn = {__source = t, __next = 1}, 1
	for k in pairs(t) do
		keys[kn], kn = k, kn + 1
	end
	table.sort(keys, f)
	return orderednext, keys
end

--// Create tooltip
local function AddTooltip(Parent, tooltipText)
	Parent:SetScript('OnEnter', function(self)
		if ( self.OnEnter ) then
			self:OnEnter()
		else
			GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
			GameTooltip:SetText(tooltipText, nil, nil, nil, nil, true)
			GameTooltip:Show()
		end
	end)

	Parent:SetScript('OnLeave', function(self)
		if self.OnLeave then
			self:OnLeave()
		else
			GameTooltip:Hide()
		end
	end)
end

--// Create options frame.
local OptionsGen = CreateFrame("Frame", nil, InterfaceOptionsFrame)
OptionsGen.name = addonName
--OptionsGen.okay = function (self) refreshCooldowns() end
OptionsGen:Hide()

local function createLabel(frame, name)
	local label = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	label:SetText(name)
	return label
end

local function createSlider(name, x, y, min, max, step)
	local sliderOpt = CreateFrame("Slider", "Icicle" .. name, OptionsGen, "OptionsSliderTemplate")
	sliderOpt:SetWidth(x)
	sliderOpt:SetHeight(y)
	sliderOpt:SetMinMaxValues(min, max)
	sliderOpt:SetValueStep(step)
	G[sliderOpt:GetName() .. "Low"]:SetText('')
	G[sliderOpt:GetName() .. "High"]:SetText('')
	G[sliderOpt:GetName() .. 'Text']:SetText(name)
	return sliderOpt
end

local function createCheck(frame, key, wth, hgt, displayname, tooltipText)
	local chkOpt = CreateFrame("CheckButton", "Icicle" .. key, frame, "OptionsCheckButtonTemplate")
	chkOpt:SetWidth(wth)
	chkOpt:SetHeight(hgt)
	getglobal(chkOpt:GetName() .. 'Text'):SetText(displayname);

	if ( tooltipText ) then
		AddTooltip(chkOpt, tooltipText)
	end

	return chkOpt
end

local function createIcon(key, size)
	local icon = CreateFrame("frame", nil, nil)
	icon:SetHeight(size)
	icon:SetWidth(size)
	icon.background = icon:CreateTexture(nil, "BORDER")
	icon.background:SetAllPoints(icon)
	icon.background:SetTexture(1, 1, 1)
	icon.texture = icon:CreateTexture(nil, "ARTWORK")
	icon.texture:SetHeight(size - 2)
	icon.texture:SetWidth(size - 2)
	icon.texture:SetTexture(select(3, GetSpellInfo(key)))
	icon.texture:SetPoint("CENTER", icon)
	icon.cooldown = icon:CreateFontString(nil, "OVERLAY")
	icon.cooldown:SetPoint("CENTER", icon, 0, -6)
	icon.cooldown:SetHeight(size + 4)
	icon.cooldown:SetWidth(size + 4)
	icon.cooldown:SetFont(Icicle.Settings.font , Icicle.Settings.fontSize, "OUTLINE")
	icon.cooldown:SetTextColor(0.7, 1, 0)
	return icon
end

local function fontInit(fontOpt)
	local function dropClick(info)
		UIDropDownMenu_SetSelectedValue(fontOpt, info.value)
		for key, val in ipairs(LSM:List("font")) do
			if (LSM:Fetch("font", val) == info.value) then
				UIDropDownMenu_SetText(fontOpt, val)
				IcicleVars.Settings.fontName = val
			end
		end
		IcicleVars.Settings.font = info.value
	end
	
	local info = {}
	for key, val in ipairs(LSM:List("font")) do
		info.text = val
		info.value = LSM:Fetch("font", val)
		info.func = dropClick
		UIDropDownMenu_AddButton(info)
	end
	UIDropDownMenu_SetText(fontOpt, IcicleVars.Settings.fontName)
	UIDropDownMenu_SetSelectedValue(fontOpt, IcicleVars.Settings.font)
end
--------------------------------
--// Create options menu.
--------------------------------
local function showOpts(OptionsGen)
	local dummy
	
	local sizeSldr = createSlider("Icon Size", 140, 15, 16, 30, 1)
	sizeSldr:SetValue(IcicleVars.Settings.iconsize)
	sizeSldr:SetPoint("TOPLEFT", 30, -34)
	sizeSldr:SetScript("OnValueChanged", function(self, value)
		IcicleVars.Settings.iconsize = value
		dummy.icon:SetHeight(value)
		dummy.icon:SetWidth(value)
		dummy.icon.texture:SetHeight(value - 2)
		dummy.icon.texture:SetWidth(value - 2)
	end)
	
	local xoffSldr = createSlider("Icon X", 150 , 15, -115, 120, 5)
	xoffSldr:SetValue(IcicleVars.Settings.xoff)
	xoffSldr:SetPoint("CENTER", 0, 160)
	xoffSldr:SetScript("OnValueChanged", function(self, value)
		IcicleVars.Settings.xoff = value
		dummy.icon:SetPoint("CENTER", dummy, value, IcicleVars.Settings.yoff)
	end)
	
	local yoffSldr = createSlider("Icon Y", 15, 100, -65, 55, 5)
	yoffSldr:SetOrientation("VERTICAL")
	yoffSldr:SetValue(IcicleVars.Settings.yoff)
	yoffSldr:SetPoint("LEFT", 70, 20)
	yoffSldr:SetScript("OnValueChanged", function(self, value)
		IcicleVars.Settings.yoff = value
		dummy.icon:SetPoint("CENTER", dummy, IcicleVars.Settings.xoff, value)
	end)
	
	local fntsSldr = createSlider("Font Size", 150 , 15, 6, 30, 1)
	fntsSldr:SetValue(IcicleVars.Settings.fontSize)
	fntsSldr:SetPoint("TOPRIGHT", -30, -34)
	fntsSldr:SetScript("OnValueChanged", function(self, value)
		IcicleVars.Settings.fontSize = value
		dummy.cooldown:SetFont(Icicle.Settings.font , value, "OUTLINE")
	end)
	
	local fntySldr = createSlider("Font Y", 15 , 100, -15, 15, 1)
	fntySldr:SetOrientation("VERTICAL")
	fntySldr:SetValue(IcicleVars.Settings.fontY)
	fntySldr:SetPoint("RIGHT", -70, 20)
	fntySldr:SetScript("OnValueChanged", function(self, value)
		IcicleVars.Settings.fontY = value
		dummy.cooldown:SetPoint("CENTER", dummy.icon, IcicleVars.Settings.fontX, value)
	end)
	
	local fntxSldr = createSlider("Font X", 150 , 15, -15, 15, 1)
	fntxSldr:SetValue(IcicleVars.Settings.fontX)
	fntxSldr:SetPoint("CENTER", 0, -120)
	fntxSldr:SetScript("OnValueChanged", function(self, value)
		IcicleVars.Settings.fontX = value
		dummy.cooldown:SetPoint("CENTER", dummy.icon, value, IcicleVars.Settings.fontY)
	end)
	dummy = CreateFrame("Frame")
	dummy:SetHeight(36)
	dummy:SetWidth(130)
	dummy:SetScale(1.5)
	dummy:SetParent(OptionsGen)
	dummy:SetPoint("CENTER", 0, 20)
	dummy.background = dummy:CreateTexture(nil, "BORDER")
	dummy.background:SetPoint("BOTTOMLEFT", dummy, 3, 3.5)
	dummy.background:SetHeight(12)
	dummy.background:SetWidth(130)
	dummy.background:SetTexture(1, 1, 1)
	dummy.foreground = dummy:CreateTexture(nil, "ARTWORK")
	dummy.foreground:SetPoint("BOTTOMLEFT", dummy, 4, 4.5)
	dummy.foreground:SetHeight(10)
	dummy.foreground:SetWidth(128)
	dummy.foreground:SetTexture(.5, .5, 1)
	dummy.lab = createLabel(dummy, '*Default nameplate.')
	dummy.lab:SetPoint("BOTTOM", 0, 4)
	dummy.icon = createIcon(42292, IcicleVars.Settings.iconsize)
	dummy.icon:SetParent(dummy)
	dummy.icon:SetPoint("CENTER", IcicleVars.Settings.xoff, IcicleVars.Settings.yoff)
	dummy.cooldown = dummy:CreateFontString(nil, "OVERLAY")
	dummy.cooldown:SetParent(dummy.icon)
	dummy.cooldown:SetPoint("CENTER", dummy.icon, IcicleVars.Settings.fontX, IcicleVars.Settings.fontY)
	dummy.cooldown:SetHeight(50)
	dummy.cooldown:SetWidth(50)
	dummy.cooldown:SetFont(Icicle.Settings.font , Icicle.Settings.fontSize, "OUTLINE")
	dummy.cooldown:SetTextColor(0.7, 1, 0)
	dummy.cooldown:SetText(30)
	
	local fontOpt = CreateFrame("Frame", "Iciclefont", OptionsGen, "UIDropDownMenuTemplate")
	fontOpt.lab = createLabel(fontOpt, "Font Face")
	fontOpt:SetWidth(200)
	fontOpt:SetPoint("TOP", 15, -30)
	
	UIDropDownMenu_Initialize(fontOpt, fontInit)

--CLASS OPTIONS
	for key, val in orderedpairs(cooldowns) do
		if (key ~= "Misc") then
			local classOpt = CreateFrame("Frame")
			classOpt.name = key
			classOpt.parent = addonName

			InterfaceOptions_AddCategory(classOpt)
		
			local ind = 1
			local xOffset=0
			for key, val in pairs(val) do
				if (ind==12) then ind=13 end       ---SET TO 13 for  1 modulo 12 =1
				if (ind>12) then xOffset = 250 end
				classOpt.Abi = createIcon(key, 36)
				classOpt.Abi:Show()
				classOpt.Abi:SetParent(classOpt)
				classOpt.Abi:SetPoint("TOPLEFT", xOffset+15, (ind % 12) * -45 + 35)
				classOpt.Abi:SetScript("OnEnter", function()
					GameTooltip:SetOwner(classOpt.Abi, "ANCHOR_CURSOR");
					GameTooltip:SetSpellByID(key)
					GameTooltip:Show()
				end)
				classOpt.Abi:SetScript("OnLeave", function()
				GameTooltip:Hide()
				end)
				--classOpt.lab = createLabel(classOpt, select(1, GetSpellInfo(key)))
				--classOpt.lab:SetPoint("TOPLEFT", xOffset+60, (ind % 12) * -45 + 12)
				classOpt.chk = createCheck(classOpt, key, 20, 20, select(1, GetSpellInfo(key)), "Enable this if you DO NOT want to track it")
				classOpt.chk:SetPoint("TOPLEFT", xOffset+60, (ind % 12) * -45 + 25)
				if (IcicleVars.CooldownsMD[key]) then
					classOpt.chk:SetChecked()
				end
				classOpt.chk:SetScript("OnClick", function()
					if (IcicleVars.CooldownsMD[key]) then
						IcicleVars.CooldownsMD[key] = false
						Icicle.Cooldowns[key].enabled = false
					else
						IcicleVars.CooldownsMD[key] = true
						Icicle.Cooldowns[key].enabled = true
					end
				end)
				ind = ind + 1
			end
		end	
	end

--PVP TRINKET ICONS
	local ind = 1
	for key, val in pairs(cooldowns.Misc) do
		OptionsGen.Abi = createIcon(key, 36)
		OptionsGen.Abi:Show()
		OptionsGen.Abi:SetParent(OptionsGen)
		OptionsGen.Abi:SetPoint("BOTTOMLEFT", 15, ind * 60 - 35)
		OptionsGen.Abi:SetScript("OnEnter", function()
			GameTooltip:SetOwner(OptionsGen.Abi, "ANCHOR_CURSOR");
			GameTooltip:SetSpellByID(key)
			GameTooltip:Show()
		end)
		OptionsGen.Abi:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)
		OptionsGen.lab = createLabel(OptionsGen, select(1, GetSpellInfo(key)))
		OptionsGen.lab:SetPoint("BOTTOMLEFT", 60, ind * 60 - 34)
		OptionsGen.chk = createCheck(OptionsGen, key, 20, 20)
		OptionsGen.chk:SetPoint("BOTTOMLEFT", 60, ind * 60 - 18)
		if (IcicleVars.CooldownsMD[key]) then
			OptionsGen.chk:SetChecked()
		end
		OptionsGen.chk:SetScript("OnClick", function()
			if (IcicleVars.CooldownsMD[key]) then
				IcicleVars.CooldownsMD[key] = false
				Icicle.Cooldowns[key].enabled = false
			else
				IcicleVars.CooldownsMD[key] = true
				Icicle.Cooldowns[key].enabled = true
			end
		end)
		ind = ind + 1
	end
end
InterfaceOptions_AddCategory(OptionsGen)
--------------------------------
--// Initialize icicle.
--------------------------------
local function refreshCooldowns()  
	for key, val in pairs(cooldowns) do
		for key, val in pairs(val) do
			local t={}
			t.enabled = IcicleVars.CooldownsMD[key]
			t.cd=val
			tinsert(Icicle.Cooldowns, key, t)
		end
	end
end

local function initCore()
	Icicle.Core.enAble()
end
 
local function initVars()
	if not IcicleVars then
		IcicleVars = {}
		IcicleVars.Settings = {}
		IcicleVars.Settings = Settings
	end
		
	if not IcicleVars.CooldownsMD then --migrate old saved vars
		IcicleVars.CooldownsMD = {}
	end
	for key, val in pairs(cooldowns) do
		for key, val in pairs(val) do
			if IcicleVars.CooldownsMD[key]==nil then
				tinsert(IcicleVars.CooldownsMD, key, true)
			end
		end
	end

	Icicle.Settings = IcicleVars.Settings
	Icicle.Cooldowns = {}
	refreshCooldowns()
end

local function onEvent(frame, event, arg)
	if (event == "ADDON_LOADED") then
		if (arg ~= "Icicle") then return end
		initVars()
		frame:UnregisterEvent("ADDON_LOADED")
	elseif (event == "VARIABLES_LOADED") then
		initCore()
		for key, val in ipairs(LSM:List("font")) do
			tinsert(Icicle.fonts, val)
		end
		table.sort(Icicle.fonts)
		LSM.RegisterCallback(frame, "LibSharedMedia_Registered", updateMedia)
		showOpts(OptionsGen)
	end
end

IcicleOpts = CreateFrame("Frame")
IcicleOpts:SetScript("OnEvent", onEvent)
IcicleOpts:RegisterEvent("ADDON_LOADED")
IcicleOpts:RegisterEvent("VARIABLES_LOADED")
--------------------------------
--------------------------------
SlashCmdList["ICICLE"] = function() InterfaceOptionsFrame_OpenToCategory(addonName) end
SLASH_ICICLE1 = "/icicle"


