UTDR_Modules = {}

local lovely = require("lovely")

assert(SMODS.load_file('atlas.lua'))()
assert(SMODS.load_file('sound.lua'))()
assert(SMODS.load_file('tag.lua'))()
assert(SMODS.load_file('challenge.lua'))()

local profile_name = G.PROFILES[G.SETTINGS.profile].name
if profile_name.upper(profile_name) == "GASTER" then
	G.PROFILES[G.SETTINGS.profile].name = "P" .. G.SETTINGS.profile
end

UTDR = SMODS.current_mod
if NFS.read(SMODS.current_mod.path .. "config.lua") then
	local file = STR_UNPACK(NFS.read(SMODS.current_mod.path .. "config.lua"))
	UTDR.config_file = file
end

G.FUNCS.restart_game_smods = function(e)
	SMODS.restart_game()
end

-- asriel colors
local asriel_colors = {
	HEX("FF0000"),
	HEX("FCA600"),
	HEX("FFFF00"),
	HEX("00c000"),
	HEX("42FCFF"),
	HEX("003CFF"),
	HEX("D535D9"),
}

SMODS.Gradient {
	key = "asriel_background",
	colours = asriel_colors,
	cycle = 66,
	interpolation = "linear"
}

SMODS.DynaTextEffect {
	key = "asriel",
	func = function(dynatext, index, letter)
		local s = #asriel_colors
		local o = index * -0.5
		local t = (G.TIMERS.REAL + o)
		--letter.colour = asriel_colors[((math.floor(t) + s) % s) + 1]
		letter.colour = mix_colours(
			asriel_colors[((math.floor(t) + s + 1) % s) + 1],
			asriel_colors[((math.floor(t) + s) % s) + 1],
			t % 1.0)
		--[[
		letter.colour = mix_colours(
			asriel_colors[i + 1],
			asriel_colors[((i + 1) % s) + 1],
			t / frequency
		)
		]]
		letter.offset.y = math.sin(t * 2.0 + o) * 16
		letter.offset.x = math.cos(t * 1.0 + o) * 16
	end,
}

SMODS.DynaTextEffect {
	key = "tropiss",
	func = function(dynatext, index, letter)
		local s = #asriel_colors
		local o = index * -0.5
		local t = (G.TIMERS.REAL + o)
		--letter.colour = asriel_colors[((math.floor(t) + s) % s) + 1]
		letter.colour = mix_colours(
			asriel_colors[((math.floor(t) + s + 1) % s) + 1],
			asriel_colors[((math.floor(t) + s) % s) + 1],
			t % 1.0)
	end,
}

SMODS.DynaTextEffect {
	key = "gaster",
	draw_letter = function(dynatext, index, letter)
		
	end,
}

-- config tabs

UTDR.config_tab = function()
	return {
		n = G.UIT.ROOT,
		config = {
			emboss = 0.05,
			r = 0.1,
			align = "tl",
			padding = 0.2,
			colour = G.C.BLACK
		},
		nodes = {
			create_toggle(
				{
					align = "tl",
					label = "UNDERTALE",
					ref_table = UTDR.config_file,
					ref_value = "undertale",
					callback = function(_set_toggle)
						UTDR.config_file.undertale = _set_toggle
						NFS.write(lovely.mod_dir .. "/UTDR/config.lua", STR_PACK(UTDR.config_file))
					end
				}
			),
			create_toggle(
				{
					align = "tl",
					label = "DELTARUNE",
					ref_table = UTDR.config_file,
					ref_value = "deltarune",
					callback = function(_set_toggle)
						UTDR.config_file.deltarune = _set_toggle
						NFS.write(lovely.mod_dir .. "/UTDR/config.lua", STR_PACK(UTDR.config_file))
					end
				}
			),
			create_toggle(
				{
					align = "tl",
					label = "Voice Clips",
					ref_table = UTDR.config_file,
					ref_value = "voiceclips",
					callback = function(_set_toggle)
						UTDR.config_file.voiceclips = _set_toggle
						NFS.write(lovely.mod_dir .. "/UTDR/config.lua", STR_PACK(UTDR.config_file))
					end
				}
			),
			create_toggle(
				{
					align = "tl",
					label = "Ralseis",
					ref_table = UTDR.config_file,
					ref_value = "ralseis",
					callback = function(_set_toggle)
						UTDR.config_file.ralseis = _set_toggle
						NFS.write(lovely.mod_dir .. "/UTDR/config.lua", STR_PACK(UTDR.config_file))
					end
				}
			),
			UIBox_button(
				{
					align = "tl",
					label = { "Apply Changes" },
					minw = 3.5,
					button = 'restart_game_smods'
				}
			),
		}
	}
end

function joker_rarity(common, uncommon, rare, legendary)
	SMODS.ObjectTypes["Joker"].rarities[1].weight = common
	SMODS.ObjectTypes["Joker"].rarities[2].weight = uncommon
	SMODS.ObjectTypes["Joker"].rarities[3].weight = rare
	if legendary == 0 then
		SMODS.ObjectTypes["Joker"].rarities[4] = nil
	else
		SMODS.ObjectTypes["Joker"].rarities[4] = { key = "Legendary", weight = legendary }
	end
end

-- load UT
if UTDR.config_file['undertale'] then
	assert(SMODS.load_file('UT/one.lua'))()
	assert(SMODS.load_file('UT/two.lua'))()
	assert(SMODS.load_file('UT/three.lua'))()
	assert(SMODS.load_file('UT/four.lua'))()
	assert(SMODS.load_file('UT/five.lua'))()
	assert(SMODS.load_file('UT/six.lua'))()
	

	SMODS.Font {
		key = "ComicSansUT",
		path = "sans.ttf"
	}

	SMODS.Font {
		key = "PapyrusUT",
		path = "papyrus.ttf"
	}

	SMODS.Back {
		key = "dog",
		--[[
		loc_txt = {
			name = "Dogdeck",
			text = {
				"Start run with",
				"{C:attention}Bandage{} and {C:attention}Stick{}",
				"Winning ante is {C:attention}9"
			},
		},
		]]
		unlocked = true,
		atlas = "UT_deck",
		pos = { x = 0, y = 0 },
		config = { win_ante = 9, extra_jokers = { "j_UTDR_bandage", "j_UTDR_stick" } },
		loc_vars = function(self, info_queue, back)
			--print(localize({ type = 'name_text', set = "Joker", key = self.config.extra_jokers[1] }))
			--print(localize({ type = 'name_text', set = "Joker", key = self.config.extra_jokers[2] }))
			return { vars = { localize({ type = 'name_text', set = "Joker", key = self.config.extra_jokers[1] }) or 'Bandage', localize({ type = 'name_text', set = "Joker", key = self.config.extra_jokers[2] }) or 'Stick', self.config.win_ante } }
		end,
		apply = function(self, back)
			G.GAME.win_ante = 9
			for i = 1, #self.config.extra_jokers do
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					func = function()
						SMODS.add_card({ key = self.config.extra_jokers[i], no_edition = true })
						return true
					end
				}))
			end
		end
	}
end

-- load DR
if UTDR.config_file.deltarune then
	SMODS.Font {
		key = "HIM",
		path = "gaster.ttf"
	}

	assert(SMODS.load_file('DR/one.lua'))()
	assert(SMODS.load_file('DR/two.lua'))()
	assert(SMODS.load_file('DR/three.lua'))()
	assert(SMODS.load_file('DR/tenna.lua'))()
	
	assert(SMODS.load_file('DR/four.lua'))()
	assert(SMODS.load_file('DR/five.lua'))()
	
	assert(SMODS.load_file('DR/66.lua'))()
	assert(SMODS.load_file('DR/99.lua'))()

	assert(SMODS.load_file('DR/point.lua'))()
	assert(SMODS.load_file('DR/capsule.lua'))()
	
	assert(SMODS.load_file('DR/deck.lua'))()
	assert(SMODS.load_file('DR/booster.lua'))()
	assert(SMODS.load_file('DR/prophecy.lua'))()
	assert(SMODS.load_file('DR/tarot.lua'))()
	assert(SMODS.load_file('DR/spectral.lua'))()
	assert(SMODS.load_file('DR/spectral_crystal.lua'))()
	assert(SMODS.load_file('DR/shop.lua'))()
	--become_prophecy()
end

function played_secret_hand(played_hands)
	local base = false
	local problematic = false
	local cryptid = false
	local bunco = false
	local sixsuits = false

	if next(played_hands["Five of a Kind"]) or
		next(played_hands["Flush Five"]) or
		next(played_hands["Flush House"]) then
		base = true
	end

	if (SMODS.Mods["TWT"] or {}).can_load then
		if next(played_hands["TWT_greaterpolycule"]) then
			problematic = true
		end
	end
	if (SMODS.Mods["Cryptid"] or {}).can_load then
		if next(played_hands["cry_Bulwark"]) or
			next(played_hands["cry_Clusterfuck"]) or
			next(played_hands["cry_UltPair"]) or
			next(played_hands["cry_WholeDeck"]) then
			cryptid = true
		end
	end

	if (SMODS.Mods["Bunco"] or {}).can_load then
		if next(played_hands["bunc_Spectrum"]) or
			next(played_hands["bunc_Straight Spectrum"]) or
			next(played_hands["bunc_Spectrum House"]) or
			next(played_hands["bunc_Spectrum Five"]) then
			bunco = true
		end
	end

	if (SMODS.Mods["SixSuits"] or {}).can_load then
		if next(played_hands["six_Spectrum House"]) or
			next(played_hands["six_Spectrum Five"]) then
			sixsuits = true
		end
	end

	return base or problematic or cryptid or bunco or sixsuits
end

function get_keys(t)
	local keys = {}
	for key, _ in pairs(t) do
		table.insert(keys, key)
	end
	return keys
end

SMODS.PokerHand {
    key = "him",
    mult = 66666,
    chips = 66666,
    l_mult = 6666,
    l_chips = 6666,
    example = {
        { 'H_6', true },
        { 'H_6', true },
        { 'S_6', true },
        { 'S_6', true },
        { 'C_6', true },
        { 'C_6', true },
    },
    visible = false,
    evaluate = function(parts, hand)
    	--it's like it's some king of unused content....
   		if #hand < 6 or #hand > 6 then return false end
    	for i = 1, #hand do
    		if hand[i].base.value ~= "6" then
    			return { }
    		end
    	end
    	return { hand }
    end,
}

--rigging the rarity poll to make FRIEND show up quicker if youve got protein is hard, so we cheat. cause im LAZY
SMODS.Rarity {
    key = "UTDR_FRIEND",
    badge_colour = HEX('fe5f55'),
    pools = {
    	Joker = true
    },
    get_weight = function(self, weight, object_type)
    	local multiplier = 1
    	local protein_count = #SMODS.find_card("j_egg")
    	if protein_count == 1 then
    		multiplier = 4
    	elseif protein_count == 2 then
    		multiplier = 7
    	elseif protein_count == 3 then
    		multiplier = 9
    	elseif protein_count >= 4 then
    		multiplier = 10
    	end
        return 0.0025 * multiplier
    end,
}