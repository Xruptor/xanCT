local addon, ns=...
ns.config={
---------------------------------------------------------------------------------
-- use ["option"] = true/false, to set options.
-- options
-- blizz damage options.
	["blizzheadnumbers"] = true,	-- use blizzard damage/healing output (above mob/player head)
	["damagestyle"] = false,		-- change default damage/healing font above mobs/player heads. you need to restart WoW to see changes! has no effect if blizzheadnumbers = false
-- xCT outgoing damage/healing options
	["damage"] = true,		-- show outgoing damage in it's own frame
	["healing"] = true,		-- show outgoing healing in it's own frame
	["auras"] = true,		-- process auras, make sure to enable it as well in the blizzard combat text panel
	["showhots"] = true,		-- show periodic healing effects in xCT healing frame.
	["damagecolor"] = true,		-- display damage numbers depending on school of magic, see http://www.wowwiki.com/API_COMBAT_LOG_EVENT
	["critprefix"] = "|cffFF0000*|r",	-- symbol that will be added before amount, if you deal critical strike/heal. leave "" for empty. default is red *
	["critpostfix"] = "|cffFF0000*|r",	-- postfix symbol, "" for empty.
	["icons"] = true,		-- show outgoing damage icons
	["iconsize"] = 20,		-- icon size of spells in outgoing damage frame, also has effect on dmg font size if it's set to "auto"
	["petdamage"] = true,		-- show your pet damage.
	["dotdamage"] = true,		-- show damage from your dots. someone asked an option to disable lol.
	["treshold"] = 1,		-- minimum damage to show in outgoing damage frame
	["healtreshold"] = 1,		-- minimum healing to show in incoming/outgoing healing messages.
	["lowmanathreshold"] = 0.35, --set the percentage threshold for low mana
	["lowhealththreshold"] = 0.35, --set the percentage threshold for low health
	
-- appearence
	["font"] = "Interface\\Addons\\xCT\\HOOGE.TTF",	-- "Fonts\\ARIALN.ttf" is default WoW font.
	["fontsize"] = 16,
	["fontstyle"] = "OUTLINE",	-- valid options are "OUTLINE", "MONOCHROME", "THICKOUTLINE", "OUTLINE,MONOCHROME", "THICKOUTLINE,MONOCHROME"
	["damagefont"] = "Interface\\Addons\\xCT\\HOOGE.TTF",	 -- "Fonts\\FRIZQT__.ttf" is default WoW damage font
	--["damagefontsize"] = "auto",	-- size of xCT damage font. use "auto" to set it automatically depending on icon size, or use own value, 16 for example. if it's set to number value icons will change size.
	["damagefontsize"] = 16,	-- size of xCT damage font. use "auto" to set it automatically depending on icon size, or use own value, 16 for example. if it's set to number value icons will change size.
	["timevisible"] = 3, 		-- time (seconds) a single message will be visible. 3 is a good value.
	["scrollable"] = false,		-- allows you to scroll frame lines with mousewheel.
	["maxlines"] = 64,		-- max lines to keep in scrollable mode. more lines=more memory. nom nom nom.

-- justify messages in frames, valid values are "RIGHT" "LEFT" "CENTER"
	["justify_1"] = "RIGHT",		-- incoming damage justify
	["justify_2"] = "LEFT",	-- incoming healing justify
	["justify_3"] = "CENTER",	-- various messages justify (mana, rage, auras, etc)
	["justify_4"] = "CENTER",	-- boss alerts and or emotes
	["justify_5"] = "LEFT",	-- outgoing damage/healing justify

-- class modules and goodies
	["stopvespam"] = true,		-- automaticly turns off healing spam for priests in shadowform. HIDE THOSE GREEN NUMBERS PLX!
	["dkrunes"] = true,		-- show deatchknight rune recharge
	["mergeaoespam"] = true,	-- merges multiple aoe spam into single message, can be useful for dots too.
	["mergeaoespamtime"] = 4,	-- time in seconds aoe spell will be merged into single message. minimum is 1.
	["mergeswingdamage"] = true, --merge swing (auto-attack or melee) damage using the spam assistance.  This is also called white damage.
	["mergerangedamage"] = true, --merge range (auto-attack or bow) damage using the spam assistance.  This is also called white damage.
	["killingblow"] = true,		-- tells you about your killingblows (works only with ["damage"] = true,)
	["dispel"] = true,		-- tells you about your dispels (works only with ["damage"] = true,)
	["interrupt"] = true,		-- tells you about your interrupts (works only with ["damage"] = true,)
	["eventspam"] = true,		-- enable spam protection on the event frame that has various messages like mana, rage, auras, runes, reputation etc..
	["eventspamtime"] = 3,		-- time in seconds that event spam messages will be merged, 3 is good 1 is minimum
}
