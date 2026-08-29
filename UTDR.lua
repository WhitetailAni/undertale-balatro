UTDR_Modules = {}

local lovely = require("lovely")

assert(SMODS.load_file('atlas.lua'))()
assert(SMODS.load_file('sound.lua'))()
assert(SMODS.load_file('tag.lua'))()
--assert(SMODS.load_file('challenge.lua'))() 3.1 feature! wait.

SMODS.Font {
	key = "USPS",
	path = "USPS.ttf"
}

G.E_MANAGER:add_event(Event { func = function()
	local profile_name = G.PROFILES[G.SETTINGS.profile].name
	if profile_name and profile_name.upper(profile_name) == "GASTER" then
		G.PROFILES[G.SETTINGS.profile].name = "P" .. G.SETTINGS.profile
	end
	return true
end })

UTDR = SMODS.current_mod
local my_config = UTDR.config
--[[
if NFS.read(SMODS.current_mod.path .. "config.lua") then
	local file = STR_UNPACK(NFS.read(SMODS.current_mod.path .. "config.lua"))
	UTDR.config_file = file
end
]]

G.FUNCS.restart_game_smods = function(e)
	SMODS.save_mod_config(UTDR)
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

-- developer cards
SMODS.Joker {
	key = "dev_viomarks",
	no_mod_badge = true,
	discovered = true,
	atlas = "UTDR_devs",
	pos = { x = 0, y = 0 },
	pixel_size = { w = 69, h = 69 },
	display_size = { w = 69, h = 69 },
	no_collection = true,
	loc_vars = function(self, info_queue, card)
		return {}
	end,
	in_pool = function(self, args)
		return false
	end,
	set_badges = function(self, card, badges)
		badges = EMPTY(badges)
	end
}

SMODS.Joker {
<<<<<<< HEAD
	key = "dev_white_tail_ani",
=======
	key = "dev_ani",
	no_mod_badge = true,
>>>>>>> 74c6176dc4fa7ffdb42f58921a903d81f22f8280
	discovered = true,
	atlas = "UTDR_devs",
	pos = { x = 1, y = 0 },
	pixel_size = { w = 69, h = 69 },
	display_size = { w = 69, h = 69 },
	no_collection = true,
	no_mod_badge = true,
	loc_vars = function(self, info_queue, card)
		local key = pseudorandom_element({
			"j_UTDR_dev_ani",
			"j_UTDR_dev_ani_riddle",
			"j_UTDR_dev_ani_caly",
			"j_UTDR_dev_ani_oh_no",
			"j_UTDR_dev_ani_sjelter",
			"j_UTDR_dev_ani_xavier_magic_button",
			"j_UTDR_dev_ani_usps",
			"j_UTDR_dev_ani_bridge_mistress",
			"j_UTDR_dev_ani_kalos",
			"j_UTDR_dev_ani_kalos_Z",
			"j_UTDR_dev_ani_theory",
			"j_UTDR_dev_ani_sweepstakes_1",
			"j_UTDR_dev_ani_sweepstakes_2",
			"j_UTDR_dev_ani_sweepstakes_3",
			"j_UTDR_dev_ani_sweepstakes_5",
			"j_UTDR_dev_ani_sweepstakes_6",
			"j_UTDR_dev_ani_sweepstakes_7",
			"j_UTDR_dev_ani_juice",
			
		}, "14a93012r")
		return {
			key = key,
			colours = {
				G.C.ALPHYS_JUICE_1,
				G.C.ALPHYS_JUICE_2,
				G.C.ALPHYS_JUICE_3,
				G.C.ALPHYS_JUICE_4,
				G.C.ALPHYS_JUICE_5,
				G.C.ALPHYS_JUICE_6,
				G.C.ALPHYS_JUICE_7,
				G.C.ALPHYS_JUICE_8,
				G.C.ALPHYS_JUICE_9,
				G.C.ALPHYS_JUICE_10,
				G.C.ALPHYS_JUICE_11,
				G.C.ALPHYS_JUICE_12,
				G.C.ALPHYS_JUICE_13,
				G.C.ALPHYS_JUICE_14,
				G.C.ALPHYS_JUICE_15,
				G.C.ALPHYS_JUICE_16,
				G.C.ALPHYS_JUICE_17,
			},
		}
	end,
	in_pool = function(self, args)
		return false
	end,
	set_badges = function(self, card, badges)
		badges[#badges] = create_badge("   /   ", G.C.HOMURA, G.C.ANGEL, 1.2)
	end
}

SMODS.Joker {
	key = "dev_j8",
	no_mod_badge = true,
	discovered = true,
	atlas = "UTDR_devs",
	pos = { x = 0, y = 1 },
	pixel_size = { w = 69, h = 69 },
	display_size = { w = 69, h = 69 },
	no_collection = true,
	loc_vars = function(self, info_queue, card)
		return {}
	end,
	in_pool = function(self, args)
		return false
	end,
	set_badges = function(self, card, badges)
		badges = EMPTY(badges)
	end
}

SMODS.Joker {
	key = "dev_elle",
	no_mod_badge = true,
	discovered = true,
	atlas = "UTDR_devs",
	pos = { x = 1, y = 1 },
	pixel_size = { w = 69, h = 69 },
	display_size = { w = 69, h = 69 },
	no_collection = true,
	loc_vars = function(self, info_queue, card)
		return {}
	end,
	in_pool = function(self, args)
		return false
	end,
	set_badges = function(self, card, badges)
		badges = EMPTY(badges)
	end
}

-- credits/config tabs

UTDR.special_thanks = {
	"Toby Fox",
	"Temmie Chang",
	"UT/DR Developers",
	"invalidOS (aka alexi)",
	"Balatro Discord Server",
}

UTDR.text_to_text_table = function(text, char_limit)
	local text_table = {}
	local string_copy = text
	local cur_string = ""
	while (#string_copy > 0) do
		local next_char = string.sub(string_copy, 1, 1)
		string_copy = string.sub(string_copy, 2, #string_copy)
		if (next_char == " " and #cur_string >= char_limit) or next_char == "\n" then
			table.insert(text_table, cur_string)
			cur_string = ""
		else
			cur_string = cur_string .. next_char
		end
	end
	if #cur_string > 0 then
		table.insert(text_table, cur_string)
	end
	return text_table
end

SMODS.current_mod.custom_ui = function(mod_nodes)
	-- header stuff

	local modname_text = ""
	local modname_scale = 0.75
	if my_config['undertale'] and my_config['deltarune'] then
		modname_text = "UNDERTALE/DELTARUNE"
	elseif my_config['undertale'] then
		modname_text = "UNDERTALE"
		modname_scale = 1.0
	elseif my_config['deltarune'] then
		modname_text = "DELTARUNE"
		modname_scale = 1.0
	else
		modname_text = "UNRELATED"
		modname_scale = 1.0
	end

	-- description stuff

	local desc_table = UTDR.text_to_text_table(UTDR.description, 72)
	local desc_nodes = {}
	for _, text in ipairs(desc_table) do
		table.insert(desc_nodes,
			{
				n = G.UIT.R,
				config = {
					align = "cl",
				},
				nodes = {
					{ n = G.UIT.T, config = { text = text, scale = .3, colour = G.C.TEXT_LIGHT } }
				}
			})
	end

	-- developer area

	local dev_area = CardArea(
		0,
		0,
		4.125 * G.CARD_W,
		1.05 * G.CARD_W,
		{ card_limit = 4, type = 'title', highlight_limit = 0 }
	)
	local dev_cards = { "j_UTDR_dev_viomarks", "j_UTDR_dev_white_tail_ani", "j_UTDR_dev_j8", "j_UTDR_dev_elle" }

	for _, v in ipairs(dev_cards) do
		local c = SMODS.create_card(type(v) == "table" and v or
			{ key = v, area = dev_area, no_edition = true, soulable = false })
		dev_area:emplace(c)
	end

	-- special thanks

	local thanks_nodes = {}
	for _, text in ipairs(UTDR.special_thanks) do
		table.insert(thanks_nodes,
			{
				n = G.UIT.R,
				config = {
					align = "cl",
				},
				nodes = {
					{ n = G.UIT.T, config = { text = text, scale = .275, colour = G.C.TEXT_LIGHT } }
				}
			})
	end
	table.insert(thanks_nodes,
		{
			n = G.UIT.R,
			config = {
				align = "cl",
			},
			nodes = {
				{ n = G.UIT.T, config = { text = "..and ", scale = .275, colour = G.C.TEXT_LIGHT } },
				{ n = G.UIT.T, config = { text = string.upper(localize({ type = 'name_text', set = "Joker", key = "j_UTDR_you" })) or 'YOU', scale = .275, colour = G.C.BALLGAME } },
				{ n = G.UIT.T, config = { text = "!", scale = .275, colour = G.C.TEXT_LIGHT } }
			}
		})

	-- putting it all together

	mod_nodes = EMPTY(mod_nodes)

	mod_nodes[#mod_nodes + 1] = {
		n = G.UIT.C,
		config = { padding = 0.1, align = 'cm' },
		nodes = {
			{
				n = G.UIT.R,
				config = { padding = 0.05, align = 'cm' },
				nodes = {
					{
						n = G.UIT.R,
						config = {
							align = "cl"
						},
						nodes = {
							{ n = G.UIT.T, config = { text = "the", scale = .325, colour = G.C.TEXT_LIGHT } }
						}
					},
					{
						n = G.UIT.R,
						config = {
							align = "cm"
						},
						nodes = {
							{ n = G.UIT.T, config = { text = modname_text, scale = modname_scale, colour = G.C.TEXT_LIGHT } }
						}
					},
					{
						n = G.UIT.R,
						config = {
							align = "cr"
						},
						nodes = {
							{ n = G.UIT.T, config = { text = "mod", scale = .325, colour = G.C.TEXT_LIGHT } }
						}
					},
				}
			},
			{
				n = G.UIT.R,
				config = { padding = 0.05, align = 'cm' },
				nodes = desc_nodes
			},
			{
				n = G.UIT.R,
				config = { padding = 0.05, align = 'cm', colour = G.C.L_BLACK, r = 0.05 },
				nodes = {
					{ n = G.UIT.T, config = { text = "AUTHORS", scale = 0.625, colour = G.C.BLACK, vert = true } },
					{ n = G.UIT.T, config = { text = "(hover for info)", scale = 0.25, colour = G.C.BLACK, vert = true } },
					{
						n = G.UIT.C,
						config = { padding = 0.1, align = 'cm', colour = G.C.BLACK, r = 0.05, minw = 3.0 },
						nodes = {
							{ n = G.UIT.O, config = { object = dev_area } }
						}
					}

				}
			},
			{
				n = G.UIT.R,
				config = { padding = 0.05, align = 'cm', colour = G.C.L_BLACK, r = 0.05 },
				nodes = {
					{
						n = G.UIT.C,
						config = { padding = 0.1, align = 'cm' },
						nodes = {
							{ n = G.UIT.T, config = { text = "SPECIAL THANKS", scale = 0.25, colour = G.C.BLACK, vert = true } },
						}
					},
					{
						n = G.UIT.C,
						config = { padding = 0.05, align = 'cm', colour = G.C.BLACK, r = 0.05, minw = 9.0 },
						nodes = thanks_nodes
					}
				}
			},
		}
	}
end

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
					label = localize("b_utdr_enable_undertale"),
					ref_table = my_config,
					ref_value = "undertale",
					tooltip = { text = localize("b_utdr_requires_restart"), scale = 0.5 }
					--[[
					callback = function(_set_toggle)
						UTDR.config_file.undertale = _set_toggle
						NFS.write(lovely.mod_dir .. "/UTDR/config.lua", STR_PACK(UTDR.config_file))
					end
					]]
				}
			),
			create_toggle(
				{
					align = "tl",
					label = localize("b_utdr_enable_deltarune"),
					ref_table = my_config,
					ref_value = "deltarune",
					tooltip = { text = localize("b_utdr_requires_restart"), scale = 0.5 }
					--[[
					callback = function(_set_toggle)
						UTDR.config_file.deltarune = _set_toggle
						NFS.write(lovely.mod_dir .. "/UTDR/config.lua", STR_PACK(UTDR.config_file))
					end
					]]
				}
			),
			create_toggle(
				{
					align = "tl",
					label = localize("b_utdr_voice_clips"),
					ref_table = my_config,
					ref_value = "voiceclips",
					--[[
					callback = function(_set_toggle)
						UTDR.config_file.voiceclips = _set_toggle
						NFS.write(lovely.mod_dir .. "/UTDR/config.lua", STR_PACK(UTDR.config_file))
					end
					]]
				}
			),
			create_toggle(
				{
					align = "tl",
					label = localize("b_utdr_ralseis"),
					ref_table = my_config,
					ref_value = "ralseis",
					--[[
					callback = function(_set_toggle)
						UTDR.config_file.ralseis = _set_toggle
						NFS.write(lovely.mod_dir .. "/UTDR/config.lua", STR_PACK(UTDR.config_file))
					end
					]]
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

function UTDR.reset_game_globals(run_start)
	if run_start then
		UTDR_Modules.Trading.reroll_catty_shop()
	end
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
if my_config['undertale'] then
	assert(SMODS.load_file('UT/one.lua'))()
	assert(SMODS.load_file('UT/two.lua'))()
	assert(SMODS.load_file('UT/three.lua'))()
	assert(SMODS.load_file('UT/four.lua'))()
	assert(SMODS.load_file('UT/five.lua'))()
	assert(SMODS.load_file('UT/six.lua'))()
	assert(SMODS.load_file('UT/trading.lua'))()


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
if my_config["deltarune"] then
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
	--assert(SMODS.load_file('DR/capsule.lua'))()

	assert(SMODS.load_file('DR/deck.lua'))()
	assert(SMODS.load_file('DR/booster.lua'))()
	assert(SMODS.load_file('DR/prophecy.lua'))()
	assert(SMODS.load_file('DR/tarot.lua'))()
	assert(SMODS.load_file('DR/spectral.lua'))()
	assert(SMODS.load_file('DR/swoon.lua'))()
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

--[[SMODS.PokerHand {
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
				return {}
			end
		end
		return { hand }
	end,
}]]

SMODS.Attribute {
	key = "UTDR_dog",
	keys = {
		"j_UTDR_annoying_dog",
		"j_UTDR_dog_residue",
		"j_UTDR_hot_dog",
		"j_UTDR_dog_shrine",
		"j_UTDR_lesser_dog",
		"j_UTDR_doghole",
		"j_UTDR_dogcheck"
	}
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

SMODS.Shader {
	key = 'empty', -- ScreenShaders need a shader key, even if the shader never gets applied. Used by Swoon ScreenShader effect.
	path = 'empty.fs'
}
