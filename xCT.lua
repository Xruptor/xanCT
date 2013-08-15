--[[
Special thanks to:
Mikord for MikScrollingBattleText and the amazing warning sound files it has (Which this addon utilizes)

xCT by affli @ RU-Howling Fjord
All rights reserved.
Thanks ALZA and Shestak for making this mod possible. Thanks Tukz for his wonderful style of coding. Thanks Rostok for some fixes and healing code.

]]--

--some init
local addon, ns=...
ct=ns.config
ct.myname, _ = UnitName("player")
ct.myclass=select(2,UnitClass("player"))

local debugSwitch = false

local debugf = tekDebug and tekDebug:GetFrame("xCT")
local function Debug(...)
    if debugf then debugf:AddMessage(string.join(", ", tostringall(...))) end
end

---------------------------------------------------------------------------------
-- outgoing healing filter, hide this spammy shit, plx
if(ct.healing)then
	ct.healfilter={}
	-- See class-specific config for filtered spells.
end
---------------------------------------------------------------------------------
if(ct.mergeaoespam)then
	ct.aoespam={}
	ct.spellFilter={}
	-- See class-specific config for merged spells.
end
---------------------------------------------------------------------------------

if(ct.healing or ct.mergeaoespam)then
	--store a temp list of spam names as we find the skills, just in case to capture those
	--spellid's we may have missed ;) Not only that but we can link all children spells with the same name to the same darn spellid as the parent spell
	ct.spamName={}
end

--filter out specific spells
ct.spellFilter={}

-- class config, overrides general
if ct.myclass=="WARLOCK" then
	if(ct.mergeaoespam)then
		ct.aoespam[27243]=true		-- Seed of Corruption (DoT)
		ct.aoespam[27285]=true		-- Seed of Corruption (Explosion)
		ct.aoespam[87385]=true		-- Seed of Corruption (Explosion Soulburned)
		ct.aoespam[132566]=true		-- Seed of Corruption (MOP)
		ct.aoespam[172]=true		-- Corruption
		ct.aoespam[87389]=true		-- Corruption (Soulburn: Seed of Corruption)
		ct.aoespam[30108]=true		-- Unstable Affliction
		ct.aoespam[348]=true		-- Immolate
		ct.aoespam[980]=true		-- Bane of Agony
		ct.aoespam[85455]=true		-- Bane of Havoc
		ct.aoespam[85421]=true		-- Burning Embers
		ct.aoespam[42223]=true		-- Rain of Fire
		ct.aoespam[5857]=true		-- Hellfire Effect
		ct.aoespam[47897]=true		-- Shadowflame (shadow direct damage)
		ct.aoespam[47960]=true		-- Shadowflame (fire dot)
		ct.aoespam[50590]=true		-- Immolation Aura
		ct.aoespam[30213]=true		-- Legion Strike (Felguard)
		ct.aoespam[89753]=true		-- Felstorm (Felguard)
		ct.aoespam[20153]=true		-- Immolation (Infrenal)
		--MOP
		ct.aoespam[103103]=true		-- Malefic Grasp (MOP)
		ct.aoespam[131740]=true		-- Corruption (MOP)
		ct.aoespam[131737]=true		-- Agony (MOP)
		ct.aoespam[131736]=true		-- Unstable Affliction (MOP)
		ct.aoespam[114790]=true		-- Seed of Corruption (MOP)
		
		ct.aoespam[112092]=true		-- Shadowbolt (MOP)
		ct.aoespam[114328]=true		-- Shadowbolt (MOP)
		ct.aoespam[114329]=true		-- Shadowbolt (MOP)
		ct.aoespam[115832]=true		-- Wrathstorm (MOP)
		ct.aoespam[104318]=true		-- Firebolt (MOP)
		ct.aoespam[47960]=true		-- Shadowflame (MOP)
		ct.aoespam[115625]=true		-- Mortal Cleave (MOP)
		ct.aoespam[105174]=true		-- Hand of Gul'Dan (MOP)
		ct.aoespam[86040]=true		-- Hand of Gul'Dan (MOP)
		ct.aoespam[47960]=true		-- Shadowflame (MOP)
		ct.aoespam[129476]=true		-- Immolation Aura (MOP)
		ct.aoespam[124915]=true		-- Chaos Wave (MOP)
		ct.aoespam[103964]=true		-- Touch of Chaos (MOP)
		ct.aoespam[103967]=true		-- Carrion Swarm (MOP)
	end
	if(ct.healing)then
		ct.healfilter[28176] = true -- Fel Armor
		ct.healfilter[96379]=true	-- Fel Armor
		ct.healfilter[63106]=true	-- Siphon Life
		ct.healfilter[54181]=true	-- Fel Synergy
		ct.healfilter[89653]=true	-- Drain Life
		ct.healfilter[79268]=true	-- Soul Harvest
		ct.healfilter[30294]=true	-- Soul Leech
		ct.healfilter[108366]=true	-- Soul Leech (MOP)
		ct.healfilter[108503]=true	-- Grimoire of Sacrifice (MOP)		
	end
elseif ct.myclass=="DRUID"then
	if(ct.mergeaoespam)then
		-- Healing spells
		ct.aoespam[774] = true -- Rejuvenation (Normal)
		ct.aoespam[64801] = true -- Rejuvenation (First tick)
		ct.aoespam[48438] = true -- Wild Growth
		ct.aoespam[8936] = true -- Regrowth
		ct.aoespam[33763] = true -- Lifebloom
		ct.aoespam[44203] = true -- Tranquility
		ct.aoespam[81269] = true -- Efflorescence
		-- Damage spells
		ct.aoespam[8921] = true -- Moonfire
		ct.aoespam[93402] = true -- Sunfire
		ct.aoespam[5570] = true -- Insect Swarm
		ct.aoespam[42231] = true -- Hurricane
		ct.aoespam[50288] = true -- Starfall
		ct.aoespam[78777] = true -- Wild Mushroom
		ct.aoespam[61391] = true -- Typhoon
		ct.aoespam[1822] = true -- Rake
		ct.aoespam[33876] = true -- Mangle (Cat Form)
		ct.aoespam[33878] = true -- Mangle (Bear Form)
		ct.aoespam[62078] = true -- Swipe (Cat Form)
		ct.aoespam[779] = true -- Swipe (Bear Form)
		ct.aoespam[33745] = true -- Lacerate
		ct.aoespam[1079] = true -- Rip
	end
elseif ct.myclass=="PALADIN"then
	if(ct.mergeaoespam)then
		-- Healing spells
		ct.aoespam[20167] = true -- Seal of Insight (Heal Effect)
		ct.aoespam[94289] = true -- Protector of the Innocent
		ct.aoespam[53652] = true -- Beacon of Light
		ct.aoespam[85222] = true -- Light of Dawn
		ct.aoespam[82327] = true -- Holy Radiance
		ct.aoespam[86452] = true -- Holy Radiance (Hot)
		-- Damage spells
		ct.aoespam[81297] = true -- Consecration
		ct.aoespam[2812] = true -- Holy Wrath
		ct.aoespam[53385] = true -- Divine Storm
		ct.aoespam[31803] = true -- Censure
		ct.aoespam[20424] = true -- Seals of Command
		ct.aoespam[42463] = true -- Seal of Truth
		ct.aoespam[101423] = true -- Seal of Righteousness
		ct.aoespam[88263] = true -- Hammer of the Righteous
		ct.aoespam[31935] = true -- Avenger's Shield
		ct.aoespam[96172] = true -- Hand of Light (Mastery)		
	end
elseif ct.myclass=="PRIEST"then
	if(ct.mergeaoespam)then
		-- Healing spells
		ct.aoespam[47750] = true -- Penance (Heal Effect)
		ct.aoespam[139] = true -- Renew
		ct.aoespam[596] = true -- Prayer of Healing
		ct.aoespam[56161] = true -- Glyph of Prayer of Healing
		ct.aoespam[64844] = true -- Divine Hymn
		ct.aoespam[32546] = true -- Binding Heal
		ct.aoespam[77489] = true -- Echo of Light
		ct.aoespam[34861] = true -- Circle of Healing
		ct.aoespam[23455] = true -- Holy Nova (Healing Effect)
		ct.aoespam[33110] = true -- Prayer of Mending
		ct.aoespam[63544] = true -- Divine Touch
		ct.aoespam[81751] = true -- Atonement (Non-crit)
		ct.aoespam[94472] = true -- Atonement (Crit)
		ct.aoespam[120692] = true -- Halo (Healing)
		-- Damage spells
		ct.aoespam[47666] = true -- Penance (Damage Effect)
		ct.aoespam[15237] = true -- Holy Nova (Damage Effect)
		ct.aoespam[589] = true -- Shadow Word: Pain
		ct.aoespam[34914] = true -- Vampiric Touch
		ct.aoespam[2944] = true -- Devouring Plague
		ct.aoespam[63675] = true -- Improved Devouring Plague
		ct.aoespam[15407] = true -- Mind Flay
		ct.aoespam[49821] = true -- Mind Seer
		ct.aoespam[87532] = true -- Shadowy Apparition
		ct.aoespam[14914] = true -- Holy Firen
		ct.aoespam[120696] = true -- Halo
	end
	if(ct.healing)then
		ct.healfilter[2944]=true 	-- Devouring Plague (Healing)
		ct.healfilter[15290]=true	-- Vampiric Embrace
	end
elseif ct.myclass=="SHAMAN"then
	if(ct.mergeaoespam)then
		-- Healing spells
		ct.aoespam[73921] = true -- Healing Rain
		ct.aoespam[52042] = true -- Healing Stream Totem
		ct.aoespam[1064] = true -- Chain Heal
		ct.aoespam[51945] = true -- Earthliving
		ct.aoespam[61295] = true -- Riptide (HoT and instant heal)
		-- Damage spells
		ct.aoespam[421] = true -- Chain Lightning
		ct.aoespam[45297] = true -- Chain Lightning (Mastery proc)
		ct.aoespam[8349] = true -- Fire Nova
		ct.aoespam[77478] = true -- Earhquake
		ct.aoespam[51490] = true -- Thunderstorm
		ct.aoespam[8187] = true -- Magma Totem
		ct.aoespam[8050] = true -- Flame Shock
		ct.aoespam[25504] = true -- Windfury
		ct.aoespam[403] = true -- Lightning Bolt
	end
elseif ct.myclass=="MONK"then
	if(ct.mergeaoespam)then
		-- Healing spells
		ct.aoespam[115175] = true -- Soothing Mist
		ct.aoespam[132120] = true -- Enveloping Mist
		ct.aoespam[119611] = true -- Renewing Mist
		ct.aoespam[117640] = true -- Spinning Crane Kick (Healing)
		ct.aoespam[124081] = true -- Zen Sphere
		ct.aoespam[124101] = true -- Zen Sphere: Detonate
		ct.aoespam[130654] = true -- Chi Burst (Heal)
		ct.aoespam[132463] = true -- Chi Wave (Heal)
		ct.aoespam[116670] = true -- Uplift
		-- Damage Spells
		ct.aoespam[107270] = true -- Spinning Crane Kick
		ct.aoespam[115181] = true -- Breath of Fire
		ct.aoespam[123725] = true -- Breath of Fire (Dot)
		ct.aoespam[121253] = true -- Keg Smash
		ct.aoespam[124098] = true -- Zen Sphere
		ct.aoespam[125033] = true -- Zen Sphere: Detonate
		ct.aoespam[118022] = true -- Dizzying Haze (Misfire Proc)
		ct.aoespam[130651] = true -- Chi Burst
		ct.aoespam[132467] = true -- Chi Wave
	end	
elseif ct.myclass=="MAGE"then
	if(ct.mergeaoespam)then
		ct.aoespam[44461] = true -- Living Bomb Explosion
		ct.aoespam[44457] = true -- Living Bomb Dot
		ct.aoespam[2120] = true -- Flamestrike
		ct.aoespam[12654] = true -- Ignite
		ct.aoespam[11366] = true -- Pyroblast
		ct.aoespam[31661] = true -- Dragon's Breath
		ct.aoespam[42208] = true -- Blizzard
		ct.aoespam[122] = true -- Frost Nova
		ct.aoespam[1449] = true -- Arcane Explosion
		ct.aoespam[92315] = true -- Pyroblast
		ct.aoespam[83853] = true -- Combustion
		ct.aoespam[11113] = true -- Blast Wave
		ct.aoespam[88148] = true -- Flamestrike void
		ct.aoespam[84721] = true -- Frostfire Orb
		ct.aoespam[82739] = true -- Flame Orb
		ct.aoespam[83619] = true -- Fire Power
		ct.aoespam[120] = true -- Cone of Cold
		ct.aoespam[114923] = true -- Nether Tempest
		ct.aoespam[113092] = true -- Frost Bomb
		ct.aoespam[44461] = true -- Living Bomb
	end
	if(ct.healing)then
		ct.healfilter[91394] = true --Permafrost (Talent)
	end
	ct.spellFilter[1953] = true --Blink (1sec buff)
elseif ct.myclass=="WARRIOR"then
	if(ct.mergeaoespam)then
		ct.aoespam[845] = true -- Cleave
		ct.aoespam[46968] = true -- Shockwave
		ct.aoespam[6343] = true -- Thunder Clap
		ct.aoespam[1680] = true -- Whirlwind
		ct.aoespam[94009] = true -- Rend
		ct.aoespam[12721] = true -- Deep Wounds
		ct.aoespam[50622] = true -- Bladestorm
		ct.aoespam[52174] = true -- Heroic Leap
	end
	if(ct.healing)then
		ct.healfilter[23880]=true	-- Bloodthirst
		ct.healfilter[55694]=true	-- Enraged Regeneration
	end
elseif ct.myclass=="HUNTER"then
	if(ct.mergeaoespam)then
		ct.aoespam[2643] = true -- Multi-Shot
		ct.aoespam[83077] = true -- Instant part of Serpent Sting
		ct.aoespam[88453] = true -- Serpent Sting (Dot 1/2)
		ct.aoespam[88466] = true -- Serpent Sting (Dot 2/2)
		ct.aoespam[1978] = true -- Serpent Sting
		ct.aoespam[13812] = true -- Explosive Trap
		ct.aoespam[53301] = true -- Explosive Shot
		ct.aoespam[118459] = true -- Beast Cleave
		ct.aoespam[118455] = true -- Beast Cleave
		ct.aoespam[120761] = true -- Glaive Toss
		ct.aoespam[121414] = true -- Glaive Toss		
	end
elseif ct.myclass=="DEATHKNIGHT"then
	if(ct.mergeaoespam)then
		ct.aoespam[55095] = true -- Frost Fever
		ct.aoespam[55078] = true -- Blood Plague
		ct.aoespam[55536] = true -- Unholy Blight
		ct.aoespam[48721] = true -- Blood Boil
		ct.aoespam[49184] = true -- Howling Blast
		ct.aoespam[52212] = true -- Death and Decay
		ct.aoespam[47541] = true -- Death Coil
		ct.aoespam[55050] = true -- Heart Strike
		ct.aoespam[98957] = true -- Burning Blood (T13 x2)
		ct.aoespam[59754] = true -- Rune Tap (AOE heal)
		ct.aoespam[49020] = true -- Obliterate MH
		ct.aoespam[66198] = true -- Obliterate OH
		ct.aoespam[49998] = true -- Death Strike MH
		ct.aoespam[66188] = true -- Death Strike OH
		ct.aoespam[45462] = true -- Plague Strike MH
		ct.aoespam[66216] = true -- Plague Strike OH
		ct.aoespam[49143] = true -- Frost Strike MH
		ct.aoespam[66196] = true -- Frost Strike OH
		ct.aoespam[56815] = true -- Rune Strike MH
		ct.aoespam[66217] = true -- Rune Strike OH
		ct.aoespam[45902] = true -- Blood Strike MH
		ct.aoespam[66215] = true -- Blood Strike OH
	end
elseif ct.myclass=="ROGUE"then
	if(ct.mergeaoespam)then
		ct.aoespam[51723] = true -- Fan of Knives
		ct.aoespam[2818] = true -- Deadly Poison
		ct.aoespam[8680] = true -- Instant Poison
		ct.aoespam[5374] = true -- Mutilate
		ct.aoespam[27576] = true -- Mutilate Off-Hand
	end

end
--GENERIC ALWAYS ADD
if (ct.mergeaoespam) then
	-- Healing spells
	ct.aoespam[109847]=true -- Maw of the Dragonlord LFR
	ct.aoespam[107835]=true -- Maw of the Dragonlord NORMAL
	ct.aoespam[109849]=true -- Maw of the Dragonlord HEROIC 
	-- Damage spells
	-- Dragon Soul - The Madness of Deathwing
	ct.aoespam[109609] = true -- Spellweave
	ct.aoespam[109610] = true -- Spellweave
	ct.aoespam[106043] = true -- Spellweave
	ct.aoespam[109611] = true -- Spellweave
	-- Item spells
	ct.aoespam[109851] = true -- Blast of Corruption (LFR)
	ct.aoespam[107831] = true -- Blast of Corruption (Normal)
	ct.aoespam[109854] = true -- Blast of Corruption (Heroic)
	ct.aoespam[109798] = true -- Shadowbolt Volley (LFR)
	ct.aoespam[108005] = true -- Shadowbolt Volley (Normal)
	ct.aoespam[109800] = true -- Shadowbolt Volley (Heroic)
	ct.aoespam[105996] = true -- Essence of Dreams
	ct.aoespam[109847] = true -- Cleansing Flames (LFR)
	ct.aoespam[107835] = true -- Cleansing Flames (Normal)
	ct.aoespam[109849] = true -- Cleansing Flames (Heroic)
	ct.aoespam[109752] = true -- Whirling Maw (LFR)
	ct.aoespam[107997] = true -- Whirling Maw (Normal)
	ct.aoespam[109754] = true -- Whirling Maw (Heroic)
	ct.aoespam[52586] = true -- Gurthalak, Voice of the Deeps
	ct.aoespam[109856] = true -- Speaking of Rage (LFR)
	ct.aoespam[107821] = true -- Speaking of Rage (Normal)
	ct.aoespam[109859] = true -- Speaking of Rage (Heroic)
	ct.aoespam[138374] = true -- Lightning Blast (Thunderhawk)
	ct.aoespam[141004] = true -- Lightning Strike (Proc)
end

if (ct.moreauras) then
	ct.spellFilter[75966] = true --Vashir (Sea Legs) buff
end

----------------------	
--BEGIN CORE ADDON
----------------------
local SQ, EQ, AQ = {}, {}, {}
local reactiveSpell = {}

local numf
if(ct.damage or ct.healing)then
	 numf=5
else
	 numf=4
end
-- detect vechile
local function SetUnit()
	if(UnitHasVehicleUI("player"))then
		ct.unit="vehicle"
	else
		ct.unit="player"
	end
	CombatTextSetActiveUnit(ct.unit)
end

--limit lines
local function LimitLines()
	for i=1,#ct.frames do
		f=ct.frames[i]
		f:SetMaxLines(f:GetHeight()/f.xfontsize)
	end
end

-- scrollable frames
local function SetScroll()
	for i=1,#ct.frames do
		ct.frames[i]:EnableMouseWheel(true)
		ct.frames[i]:SetScript("OnMouseWheel", function(self,delta)
			if delta >0 then
				self:ScrollUp()
			elseif delta <0 then
				self:ScrollDown()
			end
		end)
	end
end

local function SaveLayout(frame)
	if type(frame) ~= "string" then return end
	if not _G[frame] then return end
	if not xCT_DB then xCT_DB = {} end
	
	local opt = xCT_DB[frame] or nil

	if not opt then
		xCT_DB[frame] = {
			["point"] = "CENTER",
			["relativePoint"] = "CENTER",
			["xOfs"] = 0,
			["yOfs"] = 0,
		}
		opt = xCT_DB[frame]
		return
	end
	
	opt.width = _G[frame]:GetWidth()
	opt.height = _G[frame]:GetHeight()

	local point, relativeTo, relativePoint, xOfs, yOfs = _G[frame]:GetPoint()
	opt.point = point
	opt.relativePoint = relativePoint
	opt.xOfs = xOfs
	opt.yOfs = yOfs
end

local function RestoreLayout(frame, index)
	if type(frame) ~= "string" then return end
	if not _G[frame] then return end
	if not xCT_DB then xCT_DB = {} end

	local opt = xCT_DB[frame] or nil

	if not opt then
		xCT_DB[frame] = {
			["point"] = "CENTER",
			["relativePoint"] = "CENTER",
			["xOfs"] = 0,
			["yOfs"] = 0,
		}
		opt = xCT_DB[frame]
		
		--defaults
		if (index == 1) then
			opt.xOfs = -255
			opt.yOfs = 70
		elseif (index==2)then
			opt.xOfs = 248
			opt.yOfs = 70
		elseif (index==3)then
			opt.xOfs = -7
			opt.yOfs = -210
		elseif (index==4)then
			opt.xOfs = -5
			opt.yOfs = -100
		else
			opt.xOfs = 438
			opt.yOfs = 131
		end
	end
	
	if not opt.width then
		if index == 3 then
			opt.width = 308
		elseif index == 4 then
			opt.width = 650
		elseif index == 5 then
			opt.width = 169
		else
			opt.width = 230
		end
	end
	_G[frame]:SetWidth(opt.width)
	
	if not opt.height then
		if index == 3 then
			opt.height = 126
		elseif index == 4 then
			opt.height = 109
		elseif index == 5 then
			opt.height = 256
		else
			opt.height = 228
		end
	end
	_G[frame]:SetHeight(opt.height)
	
	_G[frame]:ClearAllPoints()
	_G[frame]:SetPoint(opt.point, UIParent, opt.relativePoint, opt.xOfs, opt.yOfs)
end

	
-- msg flow direction
local function ScrollDirection()
	if (COMBAT_TEXT_FLOAT_MODE=="2") then
		ct.mode="TOP"
	else
		ct.mode="BOTTOM"
	end
	for i=1,#ct.frames do
		ct.frames[i]:Clear()
		ct.frames[i]:SetInsertMode(ct.mode)
	end
end

--function for spam prevention on the event frame
local function pushEventFrame(frameOut, msg, name, amount, style, r, g, b, bypass_eventspamtime)
	if (ct.eventspam and msg and name) then
		if reactiveSpell[name] then return end --don't process reactive skills let the regular combat_text do that
		if not EQ[name] then EQ[name] = {} end
		EQ[name]["locked"]=true
		if not EQ[name]["queue"] then EQ[name]["queue"] = 0 end
		--add the data
		EQ[name]["msg"]=msg
		if tonumber(amount) and tonumber(amount) > 0 then
			EQ[name]["queue"] = EQ[name]["queue"] + tonumber(amount)
		end
		EQ[name]["style"]=style
		if bypass_eventspamtime then EQ[name]["bypass_eventspamtime"] = bypass_eventspamtime end
		EQ[name]["color"]={r, g, b}
		if not EQ[name]["count"] or EQ[name]["count"] == 0 then
			EQ[name]["count"] = 1
			EQ[name]["utime"]=time()
		else
			EQ[name]["count"] = EQ[name]["count"] + 1
		end
		EQ[name]["locked"]=false
		EQ[name]["frameOut"]=frameOut
	else
		frameOut:AddMessage(msg, r, g, b)
	end
end

-- partial resists styler
local part="-%s (|cFFEFD2D2%s|r %s)"  --regular resists light pink
local part2="-%s (|cFFD7A9D7%s|r %s)" --spell absorbs/resists light lavander
local lastAura

local r,g,b
-- the function, handles everything
local function OnEvent(self,event,...)
local subevent = ...
if(event=="COMBAT_TEXT_UPDATE")then
	local _,arg2,arg3 = ...
	if (SHOW_COMBAT_TEXT=="0")then
		return
	else
	if subevent=="DAMAGE"then
		xCT1:AddMessage("-"..arg2,.75,.1,.1)
	elseif subevent=="DAMAGE_CRIT"then
		xCT1:AddMessage(ct.critprefix.."-"..arg2..ct.critpostfix,1,.1,.1)
	elseif subevent=="SPELL_DAMAGE"then
		xCT1:AddMessage("-"..arg2,.75,.3,.85)
	elseif subevent=="SPELL_DAMAGE_CRIT"then
		xCT1:AddMessage(ct.critprefix.."-"..arg2..ct.critpostfix,1,.3,.5)


	-- elseif subevent=="HEAL"then
		-- if(arg3>=ct.healtreshold)then
			-- if(arg2)then
				-- if(COMBAT_TEXT_SHOW_FRIENDLY_NAMES=="1")then
					-- xCT2:AddMessage("|cFF2AC85E"..arg2:match("^([^-]+)").."|r  +"..arg3,.1,.75,.1)
				-- else
					-- xCT2:AddMessage("+"..arg3,.1,.75,.1)
				-- end
			-- end
		-- end
	-- elseif subevent=="HEAL_CRIT"then
		-- if(arg3>=ct.healtreshold)then
			-- if(arg2)then
				-- if(COMBAT_TEXT_SHOW_FRIENDLY_NAMES=="1")then
					-- xCT2:AddMessage("|cFF2AC85E"..arg2:match("^([^-]+)").."|r  +"..arg3,.1,1,.1)
				-- else
					-- xCT2:AddMessage("+"..arg3,.1,1,.1)
				-- end
			-- end
		-- end
	-- elseif subevent=="PERIODIC_HEAL"then
		-- if(arg3>=ct.healtreshold)then
			-- xCT2:AddMessage("+"..arg3,.1,.5,.1)
		-- end
	
	elseif subevent=="SPELL_CAST"then
		--xCT3:AddMessage(arg2, 1, .82, 0)
		xCT3:AddMessage(arg2, 1, .46, 0.10)
		reactiveSpell[arg2] = true --prevent future parsing of this on the spam queue
		--remove from event queue spam if it's in there
		if EQ and EQ[arg2] and EQ[arg2]["count"] > 0 then
			EQ[arg2]["count"]=0
			EQ[arg2]["queue"]=0
			EQ[arg2]["style"]=nil
			EQ[arg2]["bypass_eventspamtime"]=nil
		end
		
	elseif subevent=="MISS"and(COMBAT_TEXT_SHOW_DODGE_PARRY_MISS=="1")then
		xCT1:AddMessage(MISS,.5,.5,.5)
	elseif subevent=="DODGE"and(COMBAT_TEXT_SHOW_DODGE_PARRY_MISS=="1")then
		xCT1:AddMessage(DODGE,.5,.5,.5)
	elseif subevent=="PARRY"and(COMBAT_TEXT_SHOW_DODGE_PARRY_MISS=="1")then
		xCT1:AddMessage(PARRY,.5,.5,.5)
	elseif subevent=="EVADE"and(COMBAT_TEXT_SHOW_DODGE_PARRY_MISS=="1")then
		xCT1:AddMessage(EVADE,.5,.5,.5)
	elseif subevent=="IMMUNE"and(COMBAT_TEXT_SHOW_DODGE_PARRY_MISS=="1")then
		xCT1:AddMessage(IMMUNE,.5,.5,.5)
	elseif subevent=="DEFLECT"and(COMBAT_TEXT_SHOW_DODGE_PARRY_MISS=="1")then
		xCT1:AddMessage(DEFLECT,.5,.5,.5)
	elseif subevent=="REFLECT"and(COMBAT_TEXT_SHOW_DODGE_PARRY_MISS=="1")then
		xCT1:AddMessage(REFLECT,.5,.5,.5)
	elseif subevent=="SPELL_MISS"and(COMBAT_TEXT_SHOW_DODGE_PARRY_MISS=="1")then
		xCT1:AddMessage(MISS,.5,.5,.5)
	elseif subevent=="SPELL_DODGE"and(COMBAT_TEXT_SHOW_DODGE_PARRY_MISS=="1")then
		xCT1:AddMessage(DODGE,.5,.5,.5)
	elseif subevent=="SPELL_PARRY"and(COMBAT_TEXT_SHOW_DODGE_PARRY_MISS=="1")then
		xCT1:AddMessage(PARRY,.5,.5,.5)
	elseif subevent=="SPELL_EVADE"and(COMBAT_TEXT_SHOW_DODGE_PARRY_MISS=="1")then
		xCT1:AddMessage(EVADE,.5,.5,.5)
	elseif subevent=="SPELL_IMMUNE"and(COMBAT_TEXT_SHOW_DODGE_PARRY_MISS=="1")then
		xCT1:AddMessage(IMMUNE,.5,.5,.5)
	elseif subevent=="SPELL_DEFLECT"and(COMBAT_TEXT_SHOW_DODGE_PARRY_MISS=="1")then
		xCT1:AddMessage(DEFLECT,.5,.5,.5)
	elseif subevent=="SPELL_REFLECT"and(COMBAT_TEXT_SHOW_DODGE_PARRY_MISS=="1")then
		xCT1:AddMessage(REFLECT,.5,.5,.5)

	elseif subevent=="RESIST"then
		if(arg3)then
			if(COMBAT_TEXT_SHOW_RESISTANCES=="1") then
				xCT1:AddMessage(part:format(arg2,RESIST,arg3),.75,.5,.5)
			else
				xCT1:AddMessage(arg2,.75,.1,.1)
			end
		elseif(COMBAT_TEXT_SHOW_RESISTANCES=="1")then
			xCT1:AddMessage(RESIST,.5,.5,.5)
		end
	elseif subevent=="BLOCK"then
		if(arg3)then
			if(COMBAT_TEXT_SHOW_RESISTANCES=="1")then
				xCT1:AddMessage(part:format(arg2,BLOCK,arg3),.75,.5,.5)
			else
				xCT1:AddMessage(arg2,.75,.1,.1)
			end
		elseif(COMBAT_TEXT_SHOW_RESISTANCES=="1")then
			xCT1:AddMessage(BLOCK,.5,.5,.5)
		end
	elseif subevent=="ABSORB"then
		if(arg3)then
			if(COMBAT_TEXT_SHOW_RESISTANCES=="1")then
				xCT1:AddMessage(part:format(arg2,ABSORB,arg3),.75,.5,.5)
			else
				xCT1:AddMessage(arg2,.75,.1,.1)
			end
		elseif(COMBAT_TEXT_SHOW_RESISTANCES=="1")then
			xCT1:AddMessage(ABSORB,.5,.5,.5)
		end
	elseif subevent=="SPELL_RESIST"then
		if(arg3)then
			if(COMBAT_TEXT_SHOW_RESISTANCES=="1") then
				xCT1:AddMessage(part2:format(arg2,RESIST,arg3),.5,.3,.5)
			else
				xCT1:AddMessage(arg2,.75,.3,.85)
			end
		elseif(COMBAT_TEXT_SHOW_RESISTANCES=="1")then
			xCT1:AddMessage(RESIST,.5,.5,.5)
		end
	elseif subevent=="SPELL_BLOCK"then
		if (arg3)then
			if(COMBAT_TEXT_SHOW_RESISTANCES=="1")then
				xCT1:AddMessage(part2:format(arg2,BLOCK,arg3),.5,.3,.5)
			else
				xCT1:AddMessage("-"..arg2,.75,.3,.85)
			end
		elseif(COMBAT_TEXT_SHOW_RESISTANCES=="1")then
			xCT1:AddMessage(BLOCK,.5,.5,.5)
		end
	elseif subevent=="SPELL_ABSORB"then
		if(arg3)then
			if(COMBAT_TEXT_SHOW_RESISTANCES=="1")then
				xCT1:AddMessage(part2:format(arg2,ABSORB,arg3),.5,.3,.5)
			else
				xCT1:AddMessage(arg2,.75,.3,.85)
			end
		elseif(COMBAT_TEXT_SHOW_RESISTANCES=="1")then
			xCT1:AddMessage(ABSORB,.5,.5,.5)
		end

	elseif subevent=="ENERGIZE"and(COMBAT_TEXT_SHOW_ENERGIZE=="1")then
		if  tonumber(arg2)>0 then
			if(arg3 and arg3=="MANA" or arg3=="RAGE" or arg3=="FOCUS" or arg3=="ENERGY" or arg3=="RUNIC_POWER" or arg3=="SOUL_SHARDS" or arg3=="HOLY_POWER" or arg3=="LIGHT_FORCE")then
				pushEventFrame(xCT3, "+"..arg2.."  ".._G[arg3], _G[arg3], arg2, "+%2$s  %1$s", PowerBarColor[arg3].r, PowerBarColor[arg3].g, PowerBarColor[arg3].b)
			end
		end
		if ( arg3 == "ECLIPSE" ) then
			if ( tonumber(arg2) < 0 ) then
				pushEventFrame(xCT3, "+"..abs(tonumber(arg2)).."  "..BALANCE_NEGATIVE_ENERGY, BALANCE_NEGATIVE_ENERGY, abs(tonumber(arg2)), "+%2$s  %1$s", PowerBarColor[arg3].negative.r, PowerBarColor[arg3].negative.g, PowerBarColor[arg3].negative.b)
			else
				pushEventFrame(xCT3, arg2.."  "..BALANCE_POSITIVE_ENERGY, BALANCE_POSITIVE_ENERGY, arg2, "+%2$s  %1$s", PowerBarColor[arg3].positive.r, PowerBarColor[arg3].positive.g, PowerBarColor[arg3].positive.b)
			end
		end

	elseif subevent=="PERIODIC_ENERGIZE"and(COMBAT_TEXT_SHOW_PERIODIC_ENERGIZE=="1")then
		if  tonumber(arg2)>0 then
			if(arg3 and arg3=="MANA" or arg3=="RAGE" or arg3=="FOCUS" or arg3=="ENERGY" or arg3=="RUNIC_POWER" or arg3=="SOUL_SHARDS" or arg3=="HOLY_POWER" or arg3=="LIGHT_FORCE")then
				pushEventFrame(xCT3, "+"..arg2.." ".._G[arg3], _G[arg3], arg2, "+%2$s  %1$s", PowerBarColor[arg3].r, PowerBarColor[arg3].g, PowerBarColor[arg3].b)
			end
		end
		if ( arg3 == "ECLIPSE" ) then
			if ( tonumber(arg2) < 0 ) then
				pushEventFrame(xCT3, "+"..abs(tonumber(arg2)).."  "..BALANCE_NEGATIVE_ENERGY, BALANCE_NEGATIVE_ENERGY, abs(tonumber(arg2)), "+%2$s  %1$s", PowerBarColor[arg3].negative.r, PowerBarColor[arg3].negative.g, PowerBarColor[arg3].negative.b)
			else
				pushEventFrame(xCT3, arg2.."  "..BALANCE_POSITIVE_ENERGY, BALANCE_POSITIVE_ENERGY, arg2, "+%2$s  %1$s", PowerBarColor[arg3].positive.r, PowerBarColor[arg3].positive.g, PowerBarColor[arg3].positive.b)
			end
		end

	-- elseif subevent=="SPELL_AURA_START"and(COMBAT_TEXT_SHOW_AURAS=="1")then
		--xCT3:AddMessage("+"..arg2, 1,.5,.5)
	-- elseif subevent=="SPELL_AURA_END"and(COMBAT_TEXT_SHOW_AURAS=="1")then
		--xCT3:AddMessage("-"..arg2, .5,.5,.5)
		
	elseif subevent=="SPELL_AURA_START_HARMFUL"and(COMBAT_TEXT_SHOW_AURAS=="1")and(ct.auras)then
		if arg2 == lastAura then return end
		xCT3:AddMessage("+"..arg2, 1, .1, .1)

	elseif subevent=="SPELL_AURA_END_HARMFUL"and(COMBAT_TEXT_SHOW_AURAS=="1")and(ct.auras)then
		xCT3:AddMessage("-"..arg2, .1, 1, .1)

	elseif subevent=="HONOR_GAINED"and(COMBAT_TEXT_SHOW_HONOR_GAINED=="1")then
		arg2=tonumber(arg2)
		if(arg2 and abs(arg2)>1) then
			arg2=floor(arg2)
			if (arg2>0)then
				pushEventFrame(xCT3, HONOR.."  +"..arg2, HONOR, arg2, "%1$s  +%2$s", .1, .1, 1)
			end
		end

	elseif subevent=="FACTION"and(COMBAT_TEXT_SHOW_REPUTATION=="1")then
		--only show guild rep if user has turned it on
		if strlower(arg2) == strlower(GUILD) then
			if ct.showguildrep then
				pushEventFrame(xCT3, arg2.."  +"..arg3, arg2, arg3, "%1$s  +%2$s", .1, .1, 1)
			end
			return
		end
		
		pushEventFrame(xCT3, arg2.."  +"..arg3, arg2, arg3, "%1$s  +%2$s", .1, .1, 1)

	elseif subevent=="SPELL_ACTIVE"and(COMBAT_TEXT_SHOW_REACTIVES=="1")then
		xCT3:AddMessage(arg2, 1, .82, 0)
		reactiveSpell[arg2] = true --prevent future parsing of this on the spam queue
		--remove from event queue spam if it's in there
		if EQ and EQ[arg2] and EQ[arg2]["count"] > 0 then
			EQ[arg2]["count"]=0
			EQ[arg2]["queue"]=0
			EQ[arg2]["style"]=nil
			EQ[arg2]["bypass_eventspamtime"]=nil
		end
	end
end

elseif event=="UNIT_HEALTH"and(COMBAT_TEXT_SHOW_LOW_HEALTH_MANA=="1")then
	if subevent==ct.unit then
		if(UnitHealth(ct.unit)/UnitHealthMax(ct.unit)<=COMBAT_TEXT_LOW_HEALTH_THRESHOLD)then
			if (not lowHealth) then
				xCT3:AddMessage(HEALTH_LOW, 1, .1, .1)
				PlaySoundFile("Interface\\AddOns\\xCT\\sounds\\LowHealth.ogg", "Master")
				lowHealth=true
			end
		else
			lowHealth=nil
		end
	end

elseif event=="UNIT_MANA"and(COMBAT_TEXT_SHOW_LOW_HEALTH_MANA=="1")then
	if subevent==ct.unit then
		local _,powerToken=UnitPowerType(ct.unit)
		if (powerToken=="MANA"and(UnitPower(ct.unit)/UnitPowerMax(ct.unit))<=COMBAT_TEXT_LOW_MANA_THRESHOLD)then
			if (not lowMana)then
				xCT3:AddMessage(MANA_LOW, 1, .1, .1)
				PlaySoundFile("Interface\\AddOns\\xCT\\sounds\\LowMana.ogg", "Master")
				lowMana=true
			end
		else
			lowMana=nil
		end
	end

elseif event=="PLAYER_REGEN_ENABLED"and(COMBAT_TEXT_SHOW_COMBAT_STATE=="1")then
		xCT3:AddMessage("-"..LEAVING_COMBAT, .1, 1, .1)

elseif event=="PLAYER_REGEN_DISABLED"and(COMBAT_TEXT_SHOW_COMBAT_STATE=="1")then
		xCT3:AddMessage("+"..ENTERING_COMBAT, 1, .1, .1)

elseif event=="UNIT_COMBO_POINTS"and(COMBAT_TEXT_SHOW_COMBO_POINTS=="1")then
	if(subevent==ct.unit)then
		local cp=GetComboPoints(ct.unit,"target")
			if(cp>0)then
				r,g,b=1,.82,.0
				if (cp==MAX_COMBO_POINTS)then
					r,g,b=0,.82,1
				end
				xCT3:AddMessage(format(COMBAT_TEXT_COMBO_POINTS,cp), r, g, b)
			end
	end

elseif event=="RUNE_POWER_UPDATE"then
	local arg1,arg2 = ...
	local start, duration, runeReady = GetRuneCooldown(arg1)
	if(runeReady)then
		localruneMapping = {
			[1] = "BLOOD",
			[2] = "UNHOLY",
			[3] = "FROST",
			[4] = "DEATH",
		}
		local rune=GetRuneType(arg1);
		local msg=_G["COMBAT_TEXT_RUNE_"..RUNE_MAPPING[rune]]
		if(rune==1)then 
			r=.75
			g=0
			b=0
		elseif(rune==2)then
			r=.75
			g=1
			b=0
		elseif(rune==3)then
			r=0
			g=1
			b=1
		elseif(rune==4)then
			r=0.96
			g=0.13
			b=0.98
		end
		xCT3:AddMessage("+"..msg, r, g, b)
	end

elseif event=="UNIT_ENTERED_VEHICLE"or event=="UNIT_EXITING_VEHICLE"then
	local arg1,arg2 = ...
	if(arg1=="player")then
		SetUnit()
	end

elseif event=="PLAYER_ENTERING_WORLD"then
	SetUnit()
	
	if(ct.scrollable)then
		SetScroll()
	else
		LimitLines()
	end

	if(ct.damage or ct.healing or ct.auras)then
		ct.pguid=UnitGUID"player"
	end

elseif event=="PLAYER_LOGIN"then
	if not xCT_DB then xCT_DB = {} end
	
	for i=1,numf do
		RestoreLayout("xCT"..i, i)
	end

	--set the thresholds
	COMBAT_TEXT_LOW_HEALTH_THRESHOLD = ct.lowmanathreshold
	COMBAT_TEXT_LOW_MANA_THRESHOLD = ct.lowhealththreshold
	
elseif event=="RAID_BOSS_EMOTE" or event=="RAID_BOSS_WHISPER" or event=="CHAT_MSG_RAID_WARNING" then
	local msg,arg2 = ...

	--http://wow.go-hero.net/framexml/15595/RaidWarning.lua
	if (event == "RAID_BOSS_EMOTE" or event == "RAID_BOSS_WHISPER") then
		RaidBossEmoteFrame_OnEvent(RaidBossEmoteFrame, event, ...)
	else
		--CHAT_MSG_RAID_WARNING
		RaidWarningFrame_OnEvent(RaidWarningFrame, event, msg)
	end
end

end

-- change damage font (if desired)
if(ct.damagestyle)then
	DAMAGE_TEXT_FONT=ct.damagefont
end

-- the frames
ct.locked=true
ct.frames={}
for i=1,numf do
	local f=CreateFrame("ScrollingMessageFrame","xCT"..i,UIParent)
	f.xfont = ct["font_"..i]
	f.xfontsize = ct["fontsize_"..i]
	f.xfontstyle = ct["fontstyle_"..i]
	f:SetFont(f.xfont,f.xfontsize,f.xfontstyle)
	f:SetShadowColor(0,0,0,0)
	f:SetFading(true)
	f:SetFadeDuration(0.5)
	f:SetTimeVisible(ct.timevisible)
	f:SetFadeDuration(3)
	f:SetMaxLines(ct.maxlines)
	f:SetSpacing(2)
	f:SetWidth(128)
	f:SetHeight(128)
	f:SetPoint("CENTER",0,0)
	f:SetMovable(true)
	f:SetResizable(true)
	f:SetMinResize(64,64)
	f:SetMaxResize(768,768)
	f:SetClampedToScreen(true)
	f:SetClampRectInsets(0,0,f.xfontsize,0)
	if(i==1)then
		f:SetJustifyH(ct.justify_1)
		f:SetPoint("CENTER",-192,-32)
	elseif(i==2)then
		f:SetJustifyH(ct.justify_2)
		f:SetPoint("CENTER",192,-32)
	elseif(i==3)then
		f:SetJustifyH(ct.justify_3)
		f:SetWidth(256)
		f:SetPoint("CENTER",0,192)
	elseif(i==4)then
		f:SetJustifyH(ct.justify_4)
		f:SetWidth(650)
		f:SetPoint("CENTER",0,-192)
	else
		f:SetJustifyH(ct.justify_5)
		f:SetPoint("CENTER",320,0)
		local a,_,c=f:GetFont()
		if (ct.damagefontsize=="auto")then
			if ct.icons then
				f:SetFont(a,ct.iconsize/2,c)
			end
		elseif (type(ct.damagefontsize)=="number")then
			f:SetFont(a,ct.damagefontsize,c)
		end
			
	end
	--create anchor
	f.anchor = CreateFrame("Frame", "xCT"..i.."anchor", f)
	
	f.anchor:SetWidth(25)
	f.anchor:SetHeight(25)
	f.anchor:SetMovable(true)
	f.anchor:SetClampedToScreen(true)
	f.anchor:EnableMouse(true)

	f.anchor:ClearAllPoints()
	f.anchor:SetPoint("TOPLEFT", "xCT"..i, "TOPLEFT", -25, 0)
	f.anchor:SetFrameStrata("DIALOG")
	
	f.anchor:SetBackdrop({
			bgFile = "Interface/Tooltips/UI-Tooltip-Background",
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			tile = true,
			tileSize = 16,
			edgeSize = 16,
			insets = { left = 5, right = 5, top = 5, bottom = 5 }
	})
	f.anchor:SetBackdropColor(0.75,0,0,1)
	f.anchor:SetBackdropBorderColor(0.75,0,0,1)

	f.anchor:SetScript("OnMouseDown", function(frame, button)
		if frame:GetParent():IsMovable() then
			frame:GetParent().isMoving = true
			frame:GetParent():StartMoving()
		end
	end)

	f.anchor:SetScript("OnMouseUp", function(frame, button) 
		if( frame:GetParent().isMoving ) then
			frame:GetParent().isMoving = nil
			frame:GetParent():StopMovingOrSizing()
			SaveLayout(frame:GetParent():GetName())
		end
	end)
	f.anchor:Hide()
	
	ct.frames[i] = f
end

-- turn off blizz ct
CombatText:UnregisterAllEvents()
CombatText:SetScript("OnLoad",nil)
CombatText:SetScript("OnEvent",nil)
CombatText:SetScript("OnUpdate",nil)

--turn off boss alerts / raid warning
RaidBossEmoteFrame:UnregisterAllEvents()
RaidBossEmoteFrame:SetScript("OnLoad",nil)
--RaidBossEmoteFrame:SetScript("OnEvent",nil)
RaidBossEmoteFrame:SetScript("OnUpdate",nil)
CinematicFrameRaidBossEmoteFrame:UnregisterAllEvents()
CinematicFrameRaidBossEmoteFrame:SetScript("OnLoad",nil)
CinematicFrameRaidBossEmoteFrame:SetScript("OnEvent",nil)
CinematicFrameRaidBossEmoteFrame:SetScript("OnUpdate",nil)
RaidWarningFrame:UnregisterAllEvents()
RaidWarningFrame:SetScript("OnLoad",nil)
--RaidWarningFrame:SetScript("OnEvent",nil)
RaidWarningFrame:SetScript("OnUpdate",nil)

--redirect any custom addon messages sent to RaidNotice_AddMessage as well 
local orig_RaidNotice_AddMessage = RaidNotice_AddMessage
local function customRaidNotice_AddMessage(self, ...)
	--ignore self that's the frame to send the messages too
	--print(self:GetName() or 'nil'
	local msg, color, arg3, arg4 = ...
	xCT4:AddMessage(msg, color.r, color.g, color.b)
end
RaidNotice_AddMessage = customRaidNotice_AddMessage


-- register events
local xCT=CreateFrame"Frame"
xCT:RegisterEvent"COMBAT_TEXT_UPDATE"
xCT:RegisterEvent"UNIT_HEALTH"
xCT:RegisterEvent"UNIT_MANA"
xCT:RegisterEvent"PLAYER_REGEN_DISABLED"
xCT:RegisterEvent"PLAYER_REGEN_ENABLED"
xCT:RegisterEvent"UNIT_COMBO_POINTS"
if(ct.dkrunes and select(2,UnitClass"player")=="DEATHKNIGHT")then
	xCT:RegisterEvent"RUNE_POWER_UPDATE"
end
xCT:RegisterEvent"UNIT_ENTERED_VEHICLE"
xCT:RegisterEvent"UNIT_EXITING_VEHICLE"
xCT:RegisterEvent"PLAYER_ENTERING_WORLD"
xCT:RegisterEvent"PLAYER_LOGIN"

xCT:RegisterEvent"RAID_BOSS_EMOTE"
xCT:RegisterEvent"RAID_BOSS_WHISPER"
xCT:RegisterEvent"CHAT_MSG_RAID_WARNING"

xCT:SetScript("OnEvent",OnEvent)

-- steal external messages sent by other addons using CombatText_AddMessage
Blizzard_CombatText_AddMessage=CombatText_AddMessage
function CombatText_AddMessage(message,scrollFunction,r,g,b,displayType,isStaggered)
	pushEventFrame(xCT3, message, message, nil, nil, r, g, b)
end

-- force hide blizz damage/healing, if desired
if not(ct.blizzheadnumbers==true)then
	InterfaceOptionsCombatTextPanelTargetDamage:Hide()
	InterfaceOptionsCombatTextPanelPeriodicDamage:Hide()
	InterfaceOptionsCombatTextPanelPetDamage:Hide()
	InterfaceOptionsCombatTextPanelHealing:Hide()
	SetCVar("CombatLogPeriodicSpells",0)
	SetCVar("PetMeleeDamage",0)
	SetCVar("CombatDamage",0)
	SetCVar("CombatHealing",0)
end

-- hook blizz float mode selector. blizz sucks, because changing  cVar combatTextFloatMode doesn't fire CVAR_UPDATE
--hooksecurefunc("InterfaceOptionsCombatTextPanelFCTDropDown_OnClick",ScrollDirection)
--COMBAT_TEXT_SCROLL_ARC="" --may cause unexpected bugs, use with caution!
InterfaceOptionsCombatTextPanelFCTDropDown:Hide() -- sorry, blizz fucking bug with SCM:SetInsertMode()

-- modify blizz ct options title lol
InterfaceOptionsCombatTextPanelTitle:SetText(COMBAT_TEXT_LABEL.." (powered by |cffFF0000x|rCT)")

-- color printer
local pr = function(msg)
    print("|cffFF0000x|rCT:", tostring(msg))
end

-- awesome configmode and testmode
local StartConfigmode=function()
	if not InCombatLockdown()then
		for i=1,#ct.frames do
			f=ct.frames[i]
			f:SetBackdrop({
				bgFile="Interface/Tooltips/UI-Tooltip-Background",
				edgeFile="Interface/Tooltips/UI-Tooltip-Border",
				tile=false,tileSize=0,edgeSize=2,
				insets={left=0,right=0,top=0,bottom=0}})
			f:SetBackdropColor(.1,.1,.1,.8)
			f:SetBackdropBorderColor(.1,.1,.1,.5)

			f.fs=f:CreateFontString(nil,"OVERLAY")
			f.fs:SetFont(f.xfont,f.xfontsize,f.xfontstyle)
			f.fs:SetPoint("BOTTOM",f,"TOP",0,0)
			if(i==1)then
				f.fs:SetText(DAMAGE)
				f.fs:SetTextColor(1,.1,.1,.9)
			elseif(i==2)then
				f.fs:SetText(SHOW_COMBAT_HEALING)
				f.fs:SetTextColor(.1,1,.1,.9)
			elseif(i==3)then
				f.fs:SetText(COMBAT_TEXT_LABEL)
				f.fs:SetTextColor(.1,.1,1,.9)
			elseif(i==4)then
				f.fs:SetText(RAID_BOSS_MESSAGE.." / "..CHAT_MSG_RAID_WARNING)
				f.fs:SetTextColor(.1,.1,1,.9)
			else
				f.fs:SetText(SCORE_DAMAGE_DONE.." / "..SCORE_HEALING_DONE)
				f.fs:SetTextColor(1,1,0,.9)
			end

			f.t=f:CreateTexture"ARTWORK"
			f.t:SetPoint("TOPLEFT",f,"TOPLEFT",1,-1)
			f.t:SetPoint("TOPRIGHT",f,"TOPRIGHT",-1,-19)
			f.t:SetHeight(20)
			f.t:SetTexture(.5,.5,.5)
			f.t:SetAlpha(.3)

			f.d=f:CreateTexture"ARTWORK"
			f.d:SetHeight(16)
			f.d:SetWidth(16)
			f.d:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",-1,1)
			f.d:SetTexture(.5,.5,.5)
			f.d:SetAlpha(.3)

			f:EnableMouse(true)
			f:RegisterForDrag"LeftButton"
			f:SetScript("OnDragStart",function(self, button)
				if self.isMoving then return end
				self:StartSizing()
			end)
			if not(ct.scrollable)then
				f:SetScript("OnSizeChanged",function(self)
					if self.isMoving then return end
					self:SetMaxLines(self:GetHeight()/f.xfontsize)
					self:Clear()
				end)
			end
			f:SetScript("OnDragStop",function(self)
				if self.isMoving then return end
				self:StopMovingOrSizing()
				SaveLayout(self:GetName())
			end)
			
			f.anchor:Show()
			
			ct.locked=false
		end
		pr("unlocked.")
	else
		pr("can't be configured in combat.")
	end
end

local function EndConfigmode()
	for i=1,#ct.frames do
		f=ct.frames[i]
		f:SetBackdrop(nil)
		f.fs:Hide()
		f.fs=nil
		f.t:Hide()
		f.t=nil
		f.d:Hide()
		f.d=nil
		f.tr=nil
		f:EnableMouse(false)
		f:SetScript("OnDragStart",nil)
		f:SetScript("OnDragStop",nil)
		f.anchor:Hide()
	end
	ct.locked=true
	pr("Window positions unsaved, don't forget to reload UI.")
end

local function StartTestMode()
--init really random number generator.
	local random=math.random
	random(time());random(); random(time())
	
	local TimeSinceLastUpdate=0
	local UpdateInterval
	if(ct.damagecolor)then
		ct.dmindex={}
		ct.dmindex[1]=1
		ct.dmindex[2]=2
		ct.dmindex[3]=4
		ct.dmindex[4]=8
		ct.dmindex[5]=16
		ct.dmindex[6]=32
		ct.dmindex[7]=64
	end

	
	for i=1,#ct.frames do
	ct.frames[i]:SetScript("OnUpdate",function(self,elapsed)
		UpdateInterval=random(65,1000)/250
		TimeSinceLastUpdate=TimeSinceLastUpdate+elapsed
		if(TimeSinceLastUpdate>UpdateInterval)then
			if(i==1)then
			ct.frames[i]:AddMessage("-"..random(100000),1,random(255)/255,random(255)/255)
			elseif(i==2)then
			ct.frames[i]:AddMessage("+"..random(50000),.1,random(128,255)/255,.1)
			elseif(i==3)then
			ct.frames[i]:AddMessage(COMBAT_TEXT_LABEL,random(255)/255,random(255)/255,random(255)/255)
			elseif(i==4)then
				local msg
				local icon
				local color={}
				msg=random(40000)
				if(ct.icons)then
					_,_,icon=GetSpellInfo(msg)
				end
				msg = RAID_BOSS_MESSAGE.." / "..CHAT_MSG_RAID_WARNING
				if(icon)then
					msg=msg.." \124T"..icon..":"..ct.iconsize..":"..ct.iconsize..":0:0:64:64:5:59:5:59\124t"
					if(ct.damagecolor)then
						color=ct.dmgcolor[ct.dmindex[random(#ct.dmindex)]]
					else
						color={1,1,0}
					end
				elseif(ct.damagecolor) and not(ct.icons)then
					color=ct.dmgcolor[ct.dmindex[random(#ct.dmindex)]]
				elseif not(ct.damagecolor)then
					color={1,1,random(0,1)}
				end
				ct.frames[i]:AddMessage(msg,unpack(color))
			elseif(i==5)then
				local msg
				local icon
				local color={}
				msg=random(40000)
				if(ct.icons)then
					_,_,icon=GetSpellInfo(msg)
				end
				if(icon)then
					msg=msg.." \124T"..icon..":"..ct.iconsize..":"..ct.iconsize..":0:0:64:64:5:59:5:59\124t"
					if(ct.damagecolor)then
						color=ct.dmgcolor[ct.dmindex[random(#ct.dmindex)]]
					else
						color={1,1,0}
					end
				elseif(ct.damagecolor) and not(ct.icons)then
					color=ct.dmgcolor[ct.dmindex[random(#ct.dmindex)]]
				elseif not(ct.damagecolor)then
					color={1,1,random(0,1)}
				end
				ct.frames[i]:AddMessage(msg,unpack(color))
				
			end
			TimeSinceLastUpdate = 0
		end
		end)		
	ct.testmode=true
end
end

local function EndTestMode()
	for i=1,#ct.frames do
		ct.frames[i]:SetScript("OnUpdate",nil)
		ct.frames[i]:Clear()
	end
	if(ct.damagecolor)then
		ct.dmindex=nil
	end
	ct.testmode=false
	end

-- /xct lock popup dialog
StaticPopupDialogs["XCT_LOCK"]={
	text="To save |cffFF0000x|rCT window positions you need to reload your UI.\n Click "..ACCEPT.." to reload UI.\nClick "..CANCEL.." to do it later.",
	button1=ACCEPT,
	button2=CANCEL,
	OnAccept=function() if not InCombatLockdown() then ReloadUI() else EndConfigmode() end end,
	OnCancel=EndConfigmode,
	timeout=0,
	whileDead=1,
	hideOnEscape=true,
	showAlert=true,
}

-- slash commands
SLASH_XCT1="/xct"
SlashCmdList["XCT"]=function(input)
	input=string.lower(input)
	if(input=="unlock")then
		if (ct.locked)then
			StartConfigmode()
		else
			pr("already unlocked.")
		end
	elseif(input=="lock")then
		if (ct.locked) then
			pr("already locked.")
		else
			StaticPopup_Show("XCT_LOCK")
		end
	elseif(input=="test")then
		if (ct.testmode) then
			EndTestMode()
			pr("test mode disabled.")
		else
			StartTestMode()
			pr("test mode enabled.")
		end
	elseif(input=="reset")then
		for i=1,numf do
			if _G["xCT"..i] then
				_G["xCT"..i]:ClearAllPoints()
				_G["xCT"..i]:SetPoint("CENTER",UIParent, "CENTER", 0, 0)
				_G["xCT"..i]:SetHeight(128)
				_G["xCT"..i]:SetWidth(128)
			end
		end
	elseif(input=="debug")then
		if debugSwitch then
			debugSwitch = false
			DEFAULT_CHAT_FRAME:AddMessage("xCT: Debugging is now [|cFF99CC33OFF|r]")
		else
			debugSwitch = true
			DEFAULT_CHAT_FRAME:AddMessage("xCT: Debugging is now [|cFF99CC33ON|r] (Requires Addon tekDebug, type /tekdebug)")
		end	
	else
		pr("use |cffFF0000/xct unlock|r to move and resize frames.")
		pr("use |cffFF0000/xct lock|r to lock frames.")
		pr("use |cffFF0000/xct test|r to toggle testmode (sample xCT output).")
		pr("use |cffFF0000/xct reset|r to reset frame positions.")
		pr("use |cffFF0000/xct debug|r to toggle debugging mode.  Note: requires tekDebug addon!")
	end
end

-- awesome shadow priest helper
if(ct.stopvespam and ct.myclass=="PRIEST")then
	local sp=CreateFrame("Frame")
	sp:SetScript("OnEvent",function(...)
		if(GetShapeshiftForm()==1)then
			if(ct.blizzheadnumbers)then
				SetCVar('CombatHealing',0)
			end
		else
			if(ct.blizzheadnumbers)then
				SetCVar('CombatHealing',1)
			end
		end
	end)
	sp:RegisterEvent("PLAYER_ENTERING_WORLD")	
	sp:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
	sp:RegisterEvent("UPDATE_SHAPESHIFT_FORMS")
end

-- spam merger (event and aoe)
if(ct.mergeaoespam or ct.eventspam) then
	local pairs=pairs
	
	if ct.eventspam then
		if (not ct.eventspamtime or ct.eventspamtime<1) then
			ct.eventspamtime=1
		end
	end
	if ct.mergeaoespam then
		if (not ct.mergeaoespamtime or ct.mergeaoespamtime<1) then
			ct.mergeaoespamtime=1
		end
		for k,v in pairs(ct.aoespam) do
			SQ[k]={queue = 0, msg = "", color={}, count=0, utime=0, locked=false}
		end
		SQ["SWING_DAMAGE"]={queue = 0, msg = "", color={}, count=0, utime=0, locked=false}
		SQ["RANGE_DAMAGE"]={queue = 0, msg = "", color={}, count=0, utime=0, locked=false}
		
		ct.SpamQueue=function(spellId, add)
			local amount
			local spam=SQ[spellId]["queue"]
			if (spam and type(spam=="number"))then
				amount=spam+add
			else
				amount=add
			end
			return amount
		end
	end

	local tslu=0
	local xCTspam=CreateFrame"Frame"
	
	xCTspam:SetScript("OnUpdate", function(self, elapsed)
		local count, queue

		local utime=time()
		
		if ct.eventspam then
			for k,v in pairs(EQ) do
				if not reactiveSpell[k] then
					local spamTimeChk
					if EQ[k]["bypass_eventspamtime"] then
						spamTimeChk = EQ[k]["bypass_eventspamtime"]
					else
						spamTimeChk = ct.eventspamtime
					end
					if not EQ[k]["locked"] and EQ[k]["count"] > 0 and EQ[k]["utime"]+spamTimeChk<=utime then
						if EQ[k]["count"]>1 then
							count=" |cffFFFFFF x "..EQ[k]["count"].."|r"
						else
							--this only happens if we pass nil to amount
							count=""
						end
						if EQ[k]["queue"]>0 then
							queue = EQ[k]["queue"]
						else
							--this only happens if we pass nil to amount
							queue = ""
						end
						
						if EQ[k]["frameOut"] then
							if EQ[k]["style"] and EQ[k]["queue"]>0 then
								EQ[k]["frameOut"]:AddMessage(string.format(EQ[k]["style"], k, EQ[k]["queue"])..count, unpack(EQ[k]["color"]))
							else
								EQ[k]["frameOut"]:AddMessage(queue..EQ[k]["msg"]..count, unpack(EQ[k]["color"]))
							end
						end

						EQ[k]["count"]=0
						EQ[k]["queue"]=0
						EQ[k]["style"]=nil
						EQ[k]["bypass_eventspamtime"]=nil
					end
				end
			end
		end

		tslu=tslu+elapsed
		if tslu > 0.5 then
			tslu=0
			local utime=time()
			
			if ct.mergeaoespam then
				for k,v in pairs(SQ) do
					if not SQ[k]["locked"] and SQ[k]["queue"]>0 and SQ[k]["utime"]+ct.mergeaoespamtime<=utime then
						if SQ[k]["count"]>1 then
							count=" |cffFFFFFF x "..SQ[k]["count"].."|r"
						else
							count=""
						end
						xCT5:AddMessage(SQ[k]["queue"]..SQ[k]["msg"]..count, unpack(SQ[k]["color"]))
						SQ[k]["queue"]=0
						SQ[k]["count"]=0
					end
				end
				--check the adaptive learning
				for k,v in pairs(AQ) do
					if not AQ[k]["locked"] and AQ[k]["utime"]+1<=utime then --set it to 1 second checks
						--if we have at least a skill firing something 3 times within one second then it's safe to assume that it's spam
						if AQ[k]["count"] >= 3 then
							ct.aoespam[k] = true --add it to our spam aoe table temporarily until the user logs off
						end
						AQ[k] = nil --remove from our observation table for another try
					end
				end
			end
			
		end
	end)
end

local debugSwitchEvent = {
	["SPELL_PERIODIC_HEAL"] = true,
	["SPELL_HEAL"] = true,
	["SPELL_DAMAGE"] = true,
	["SPELL_PERIODIC_DAMAGE"] = true,
	["SWING_DAMAGE"] = true,
	["RANGE_DAMAGE"] = true,
	["SWING_MISSED"] = true,
	["SPELL_MISSED"] = true,
	["RANGE_MISSED"] = true,
}

local unpack,select,time=unpack,select,time
local	gflags=bit.bor(	COMBATLOG_OBJECT_AFFILIATION_MINE,
		COMBATLOG_OBJECT_REACTION_FRIENDLY,
		COMBATLOG_OBJECT_CONTROL_PLAYER,
		COMBATLOG_OBJECT_TYPE_GUARDIAN
		)
			
if ct.auras or ct.damage or ct.healing then
	local xCTe=CreateFrame"Frame"
	if(ct.damage and ct.damagecolor)then
		ct.dmgcolor={}
		ct.dmgcolor[1]={1,1,0} -- physical
		ct.dmgcolor[2]={1,.9,.5} -- holy
		ct.dmgcolor[4]={1,.5,0} -- fire
		ct.dmgcolor[8]={.3,1,.3} -- nature
		ct.dmgcolor[16]={.5,1,1} -- frost
		ct.dmgcolor[32]={.5,.5,1} -- shadow
		ct.dmgcolor[64]={1,.5,1} -- arcane
	end
	
	if(ct.icons)then
		ct.blank=GetSpellTexture(74009) or GetSpellTexture(6603)
	end
	
	local eventF=function(self,event,...) 
		local msg,icon
	--	local timestamp, eventType, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags = select(1,...)
		local timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags, srcFlags2, destGUID, destName, destFlags, destFlags2 = select(1,...)
		
		if debugSwitch and debugSwitchEvent[eventType] ~= nil then
			if(sourceGUID==ct.pguid)or(sourceGUID==UnitGUID("pet"))or(sourceFlags==gflags)then
				local spellId,spellName,spellSchool,amount=select(12,...)
				local isPet = '  '
				local totalDmg = ''
				if sourceGUID==UnitGUID("pet") then
					isPet = '|cFFFFFF00PET_SKILL|r'
				end
				if eventType == "SWING_DAMAGE" then
					totalDmg = spellId --amount gets stored as the first variable
				else
					totalDmg = amount
				end
				if eventType == "SWING_DAMAGE" or eventType == "RANGE_DAMAGE" then spellId = nil end
				if eventType == "SWING_DAMAGE" then spellName = "SWING_DAMAGE" end
				if eventType == "RANGE_DAMAGE" then spellName = "RANGE_DAMAGE" end
				Debug(eventType,'   ','|cFF99CC33SPELL_ID = '..tostring(spellId)..'|r','|cFFDF2B2B'..tostring(spellName)..'|r', isPet, tostring(totalDmg))
			end
		end
		
		-- local sourceIsFriendly = bit.band(sourceFlags, COMBATLOG_OBJECT_REACTION_FRIENDLY)
		-- local sourceIsEnemy = bit.band(sourceFlags, COMBATLOG_OBJECT_REACTION_HOSTILE)
		-- local destIsFriendly = bit.band(destFlags, COMBATLOG_OBJECT_REACTION_FRIENDLY)
		-- local destIsEnenemy = bit.band(destFlags, COMBATLOG_OBJECT_REACTION_HOSTILE)
		
		-- local OBJECT_TYPE_ENEMY_PLAYER = bit.bor(
			-- COMBATLOG_OBJECT_AFFILIATION_OUTSIDER,
			-- COMBATLOG_OBJECT_REACTION_HOSTILE,
			-- COMBATLOG_OBJECT_TYPE_PLAYER,
			-- COMBATLOG_OBJECT_CONTROL_PLAYER,
			-- COMBATLOG_OBJECT_TARGET
			-- )
				
		-- local OBJECT_TYPE_ENEMY_PET = bit.bor(
			-- COMBATLOG_OBJECT_AFFILIATION_OUTSIDER,
			-- COMBATLOG_OBJECT_REACTION_HOSTILE,
			-- COMBATLOG_OBJECT_TYPE_PET,
			-- COMBATLOG_OBJECT_CONTROL_PLAYER,
			-- COMBATLOG_OBJECT_TARGET
			-- )
			
		-- if (CombatLog_Object_IsA(destFlags, OBJECT_TYPE_ENEMY_PLAYER)) then

		local destIsPlayer = bit.band(destFlags, COMBATLOG_OBJECT_TYPE_PLAYER) == COMBATLOG_OBJECT_TYPE_PLAYER or bit.band(destFlags, COMBATLOG_OBJECT_CONTROL_PLAYER) == COMBATLOG_OBJECT_CONTROL_PLAYER
		
		--AURAS
		if (ct.auras and COMBAT_TEXT_SHOW_AURAS=="1") then
			-- auras (only show applied, don't show remove notifications cause honestly that's a lot of spam LOL)
			if(sourceGUID==ct.pguid)or(sourceGUID==UnitGUID("pet"))or(sourceFlags==gflags)then
				if (destGUID==ct.pguid) or (destGUID==UnitGUID("pet")) then
					if(eventType=="SPELL_AURA_APPLIED" and ct.moreauras) then
						local spellId,spellName,spellSchool,amount=select(12,...)
						if not spellId then return end
						local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate = UnitAura("player",spellName)
						--don't show auras with no durations
						if name and duration and duration <=0 then return end
						if ct.spellFilter[spellId] then return end
						if reactiveSpell[spellName] then return end
						lastAura = spellName
						--depending on the return amount can be auraType
						if amount=="DEBUFF" then
							pushEventFrame(xCT3, "+"..spellName, spellName, nil, nil, 1, .1, .1, 0)
						else
							pushEventFrame(xCT3, "+"..spellName, spellName, nil, nil, 0.39, 0.50, 0.98, 0)
						end
						return
					elseif (eventType=="ENCHANT_APPLIED")then
						local spellName=select(12,...)
						if reactiveSpell[spellName] then return end
						pushEventFrame(xCT3, "+"..spellName, spellName, nil, nil, 0.39, 0.50, 0.98, 0)
						return
					end
				end
			end
		end
		
		--DAMAGE
		if ct.damage then
			if (sourceGUID==ct.pguid and destGUID~=ct.pguid)or(sourceGUID==UnitGUID("pet") and ct.petdamage)or(sourceFlags==gflags)then
				if(eventType=="SWING_DAMAGE")then
					local amount,_,_,_,_,_,critical=select(12,...)
					if not amount then return end
					if(amount>=ct.treshold)then
						local rawamount=amount
						local queueMsg = ""
						msg=amount
						if (critical) then
							msg=ct.critprefix..msg..ct.critpostfix
						end
						if(ct.icons)then
							if(sourceGUID==UnitGUID("pet")) or (sourceFlags==gflags)then
								icon=PET_ATTACK_TEXTURE
							else
								icon=GetSpellTexture(6603)
							end
							queueMsg=" \124T"..icon..":"..ct.iconsize..":"..ct.iconsize..":0:0:64:64:5:59:5:59\124t"
						end
						if ct.mergeaoespam and ct.mergeswingdamage then
							SQ["SWING_DAMAGE"]["locked"]=true
							SQ["SWING_DAMAGE"]["queue"]=ct.SpamQueue("SWING_DAMAGE", tonumber(rawamount))
							SQ["SWING_DAMAGE"]["msg"]=queueMsg
							SQ["SWING_DAMAGE"]["color"]={1,1,1}
							SQ["SWING_DAMAGE"]["count"]=SQ["SWING_DAMAGE"]["count"]+1
							if SQ["SWING_DAMAGE"]["count"]==1 then
								SQ["SWING_DAMAGE"]["utime"]=time()
							end
							SQ["SWING_DAMAGE"]["locked"]=false
							return
						end
						msg=msg..queueMsg
						xCT5:AddMessage(msg)
					end
					return
				elseif(eventType=="RANGE_DAMAGE")then
					local spellId,_,_,amount,_,_,_,_,_,critical=select(12,...)
					if not spellId then return end
					if(amount>=ct.treshold)then
						local rawamount=amount
						local queueMsg = ""
						msg=amount
						if (critical) then
							msg=ct.critprefix..msg..ct.critpostfix
						end
						if(ct.icons)then
							icon=GetSpellTexture(spellId)
							queueMsg=" \124T"..icon..":"..ct.iconsize..":"..ct.iconsize..":0:0:64:64:5:59:5:59\124t"
						end
						if ct.mergeaoespam and ct.mergerangedamage then
							SQ["RANGE_DAMAGE"]["locked"]=true
							SQ["RANGE_DAMAGE"]["queue"]=ct.SpamQueue("RANGE_DAMAGE", tonumber(rawamount))
							SQ["RANGE_DAMAGE"]["msg"]=queueMsg
							SQ["RANGE_DAMAGE"]["color"]={1,1,1}
							SQ["RANGE_DAMAGE"]["count"]=SQ["RANGE_DAMAGE"]["count"]+1
							if SQ["RANGE_DAMAGE"]["count"]==1 then
								SQ["RANGE_DAMAGE"]["utime"]=time()
							end
							SQ["RANGE_DAMAGE"]["locked"]=false
							return
						end
						msg=msg..queueMsg						
						xCT5:AddMessage(msg)
					end
					return
				elseif(eventType=="SPELL_DAMAGE")or(eventType=="SPELL_PERIODIC_DAMAGE" and ct.dotdamage)then
					local spellId,spellName,spellSchool,amount,_,_,_,_,_,critical=select(12,...)
					if not spellId then return end
					--trace spell
					--if not ct.aoespam[spellId] or not ct.spamName[spellName] then
					--	print(spellId, spellName)
					--end
					if(amount>=ct.treshold)then
						local color={}
						local rawamount=amount
						if (critical) then
							amount=ct.critprefix..amount..ct.critpostfix
						end
		
						if(ct.icons)then
							icon=GetSpellTexture(spellId)
						end
						if(ct.damagecolor)then
							if(ct.dmgcolor[spellSchool])then
								color=ct.dmgcolor[spellSchool]
							else
								color=ct.dmgcolor[1]
							end
						else
							color={1,1,0}
						end
						if (icon) then
							msg=" \124T"..icon..":"..ct.iconsize..":"..ct.iconsize..":0:0:64:64:5:59:5:59\124t"
						elseif(ct.icons)then
							msg=" \124T"..ct.blank..":"..ct.iconsize..":"..ct.iconsize..":0:0:64:64:5:59:5:59\124t"
						else
							msg=""
						end
						--if we have this spellname already stored use that spellid rather then the one passed
						--we do this to condense all the spells with the same name but different spellid's, example Corruption
						local spellTmp = spellId
						if ct.spamName[tostring(spellName).."_DMG"] then --distinguish between damage and heal spam by using a suffix
							spellTmp = ct.spamName[tostring(spellName).."_DMG"]
						elseif ct.aoespam[spellId] then
							if not ct.spamName[tostring(spellName).."_DMG"] then ct.spamName[tostring(spellName).."_DMG"]=spellId end
						else
							--lets try adaptive learning, we will process this and if we detect it's a spammable skill, then lets add it temporarily to spamaoe table
							if not AQ[spellTmp] then
								AQ[spellTmp] = {}
								AQ[spellTmp]["count"] = 0 
							end
							AQ[spellTmp]["locked"]=true
							AQ[spellTmp]["count"]=AQ[spellTmp]["count"]+1
							if AQ[spellTmp]["count"]==1 then
								AQ[spellTmp]["utime"]=time()
							end
							AQ[spellTmp]["locked"]=false
						end

						if ct.mergeaoespam and ct.aoespam[spellTmp] then
							if not SQ[spellTmp] then
								SQ[spellTmp]={queue = 0, msg = "", color={}, count=0, utime=0, locked=false}
							end
							SQ[spellTmp]["locked"]=true
							SQ[spellTmp]["queue"]=ct.SpamQueue(spellTmp, rawamount)
							SQ[spellTmp]["msg"]=msg
							SQ[spellTmp]["color"]=color
							SQ[spellTmp]["count"]=SQ[spellTmp]["count"]+1
							if SQ[spellTmp]["count"]==1 then
								SQ[spellTmp]["utime"]=time()
							end
							SQ[spellTmp]["locked"]=false
							return
						end
						xCT5:AddMessage(amount..""..msg,unpack(color))
					end
					return
				elseif(eventType=="SWING_MISSED")then
					local missType,_=select(12,...)
					if not missType then return end
					if(ct.icons)then
						if(sourceGUID==UnitGUID("pet")) or (sourceFlags==gflags)then
							icon=PET_ATTACK_TEXTURE
						else
							icon=GetSpellTexture(6603)
						end
						missType=missType.." \124T"..icon..":"..ct.iconsize..":"..ct.iconsize..":0:0:64:64:5:59:5:59\124t"
					end
		
					xCT5:AddMessage(missType)
					return
				elseif(eventType=="SPELL_MISSED")or(eventType=="RANGE_MISSED")then
					local spellId,_,_,missType,_ = select(12,...)
					if not spellId then return end
					if(ct.icons)then
						icon=GetSpellTexture(spellId)
						missType=missType.." \124T"..icon..":"..ct.iconsize..":"..ct.iconsize..":0:0:64:64:5:59:5:59\124t"
					end 
					xCT5:AddMessage(missType)
					return
				elseif(eventType=="SPELL_DISPEL")and ct.dispel then
					local target,_, _, id, effect, _, etype = select(12,...)
					if not id then return end
					local color
					if(ct.icons)then
						icon=GetSpellTexture(id)
					end
					if (icon) then
						msg=" \124T"..icon..":"..ct.iconsize..":"..ct.iconsize..":0:0:64:64:5:59:5:59\124t"
					elseif(ct.icons)then
						msg=" \124T"..ct.blank..":"..ct.iconsize..":"..ct.iconsize..":0:0:64:64:5:59:5:59\124t"
					else
						msg=""
					end
					if etype=="BUFF"then
						color={0,1,.5}
					else
						color={1,0,.5}
					end
					xCT3:AddMessage(ACTION_SPELL_DISPEL..": "..effect..msg, unpack(color))
					return
				elseif(eventType=="SPELL_INTERRUPT")and ct.interrupt then
					local target,_, _, id, effect = select(12,...)
					local color={1,.5,0}
					if not id then return end
					if(ct.icons)then
						icon=GetSpellTexture(id)
					end
					if (icon) then
						msg=" \124T"..icon..":"..ct.iconsize..":"..ct.iconsize..":0:0:64:64:5:59:5:59\124t"
					elseif(ct.icons)then
						msg=" \124T"..ct.blank..":"..ct.iconsize..":"..ct.iconsize..":0:0:64:64:5:59:5:59\124t"
					else
						msg=""
					end
					xCT3:AddMessage(ACTION_SPELL_INTERRUPT..": "..effect..msg, unpack(color))

				elseif(eventType=="PARTY_KILL") and ct.killingblow and destIsPlayer then
					local tname=select(9,...)
					pushEventFrame(xCT3, ACTION_PARTY_KILL..": "..tname, ACTION_PARTY_KILL, nil, nil, .2, 1, .2)
				end
			end
		end
		
		--HEALING
		if ct.healingincoming then
			--do incoming healing for the xCT2 frame (only do the player.. who cares about the pet, we have to do it this way in order to filter out certain heals
			--we don't want to see.  Sadly the default blizzard combat text doesn't give spellid
			if (destGUID==ct.pguid) then
				if(eventType=='SPELL_HEAL' or eventType=='SPELL_PERIODIC_HEAL')then
					--ct.mergehealspam
					local spellId,spellName,spellSchool,amount,overhealing,absorbed,critical = select(12,...)
					if not spellId then return end
					
					if(ct.healfilter[spellId]) then
						return
					end
					
					local sNameF
					if sourceName == nil then
						sNameF = spellName
					else
						sNameF = sourceName:match("^([^-]+)") or spellName
					end
					
					if (critical) then
						if(amount>=ct.healtreshold)then
							if(COMBAT_TEXT_SHOW_FRIENDLY_NAMES=="1")then
								xCT2:AddMessage("|cFF2AC85E"..sNameF.."|r  +"..amount,.1,1,.1)
							else
								xCT2:AddMessage("+"..amount,.1,1,.1)
							end
						end
					else
						if(amount>=ct.healtreshold)then
							if(COMBAT_TEXT_SHOW_FRIENDLY_NAMES=="1")then
								--we can only do spam checks when we have friendly names on, otherwise we have no means to compare ;)
								--we only really want to do this with hots sooooo
								if ct.mergeaoespam and eventType=='SPELL_PERIODIC_HEAL' then
									pushEventFrame(xCT2, "|cFF2AC85E"..sNameF.."|r  +"..amount, sNameF, amount, "|cFF2AC85E%1$s|r  +%2$s", .1,.75,.1)
								else
									xCT2:AddMessage("|cFF2AC85E"..sNameF.."|r  +"..amount,.1,.75,.1)
								end
							else
								xCT2:AddMessage("+"..amount,.1,.75,.1)
							end
						end
						
					end
				
				end
			end
		end
		
		if ct.healing then
			--both incoming and outgoing heals to the external icon frame xCT5
			if(sourceGUID==ct.pguid)or(sourceFlags==gflags)then
				if(eventType=='SPELL_HEAL')or(eventType=='SPELL_PERIODIC_HEAL'and ct.showhots)then
				
					local spellId,spellName,spellSchool,amount,overhealing,absorbed,critical = select(12,...)
					if not spellId then return end
					
					if(ct.healfilter[spellId]) then
						return
					end
					if(amount>=ct.healtreshold)then
						local color={}
						local rawamount=amount
						if (critical) then 
							amount=ct.critprefix..amount..ct.critpostfix
							color={.1,1,.1}
						else
							color={.1,.65,.1}
						end 
						if(ct.icons)then
							icon=GetSpellTexture(spellId)
						else
							msg=""
						end
						
						if (icon) then 
							msg=' \124T'..icon..':'..ct.iconsize..':'..ct.iconsize..':0:0:64:64:5:59:5:59\124t'
						elseif(ct.icons)then
							msg=" \124T"..ct.blank..":"..ct.iconsize..":"..ct.iconsize..":0:0:64:64:5:59:5:59\124t"
						end
						
						local spellTmp = spellId
						if ct.spamName[tostring(spellName).."_HEAL"] then --distinguish between damage and heal spam by using a suffix
							spellTmp = ct.spamName[tostring(spellName).."_HEAL"]
						elseif ct.aoespam[spellId] then
							if not ct.spamName[tostring(spellName).."_HEAL"] then ct.spamName[tostring(spellName).."_HEAL"]=spellId end
						else
							--lets try adaptive learning, we will process this and if we detect it's a spammable skill, then lets add it temporarily to spamaoe table
							if not AQ[spellTmp] then
								AQ[spellTmp] = {}
								AQ[spellTmp]["count"] = 0
							end
							AQ[spellTmp]["locked"]=true
							AQ[spellTmp]["count"]=AQ[spellTmp]["count"]+1
							if AQ[spellTmp]["count"]==1 then
								AQ[spellTmp]["utime"]=time()
							end
							AQ[spellTmp]["locked"]=false
						end
						
						if ct.mergeaoespam and ct.aoespam[spellTmp] then
							if not SQ[spellTmp] then
								SQ[spellTmp]={queue = 0, msg = "", color={}, count=0, utime=0, locked=false}
							end						
							SQ[spellTmp]["locked"]=true
							SQ[spellTmp]["queue"]=ct.SpamQueue(spellTmp, rawamount)
							SQ[spellTmp]["msg"]=msg
							SQ[spellTmp]["color"]=color
							SQ[spellTmp]["count"]=SQ[spellTmp]["count"]+1
							if SQ[spellTmp]["count"]==1 then
								SQ[spellTmp]["utime"]=time()
							end
							SQ[spellTmp]["locked"]=false
							return
						end
						if amount == nil or amount == "" then return end
						xCT5:AddMessage(amount..""..msg,unpack(color))
					end
				end
			end
		end
	
	end
	
	xCTe:RegisterEvent"COMBAT_LOG_EVENT_UNFILTERED"
	xCTe:SetScript("OnEvent",eventF)
end
