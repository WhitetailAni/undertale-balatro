UTDR_Modules = {}

local lovely = require("lovely")

assert(SMODS.load_file('atlas.lua'))()
assert(SMODS.load_file('sound.lua'))()
assert(SMODS.load_file('tag.lua'))()
--assert(SMODS.load_file('challenge.lua'))() 3.1 feature!
assert(SMODS.load_file('shop_tabs.lua'))()
assert(SMODS.load_file('elleplural.lua'))() -- used by dev credits



local ease_background_colour_blind_hook = ease_background_colour_blind
function ease_background_colour_blind(state, blind_override, ...)
	if state == G.STATES.UTDR_SHOP_CAPSULE then
		ease_colour(G.C.DYN_UI.MAIN, HEX("ffd601"))
		ease_background_colour{new_colour = HEX("42d4a3"), special_colour = HEX("799f97"), contrast = 3}
	elseif state == G.STATES.UTDR_SHOP_CATTYBRATTY then
		ease_colour(G.C.DYN_UI.MAIN, HEX("dc8df0"))
		ease_background_colour{new_colour = G.C.PURPLE, special_colour = G.C.L_BLACK, contrast = 3}
	elseif state == G.STATES.UTDR_SHOP_LACQUER then
		ease_colour(G.C.DYN_UI.MAIN, G.C.LACQUER_OUTLINE)
		ease_background_colour{new_colour = G.C.LACQUER_BG, special_colour = G.C.L_BLACK, contrast = 3}
	else
		ease_background_colour_blind_hook(state, blind_override, ...)
	end
end

G.E_MANAGER:add_event(Event { func = function()
	local profile_name = G.PROFILES[G.SETTINGS.profile].name
	if profile_name and profile_name.upper(profile_name) == "GASTER" then
		G.PROFILES[G.SETTINGS.profile].name = "P" .. G.SETTINGS.profile
	end
	return true
end })

UTDR = SMODS.current_mod
local UTDR_config = UTDR.config

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
	key = "dev_white_tail_ani",
	config = {
		has_viewed = false
	},
	no_mod_badge = true,
	discovered = true,
	atlas = "UTDR_devs",
	pos = { x = 1, y = 0 },
	pixel_size = { w = 69, h = 69 },
	display_size = { w = 69, h = 69 },
	no_collection = true,
	no_mod_badge = true,
	loc_vars = function(self, info_queue, card)
		if not has_viewed then
			has_viewed = true
			return { key = "j_UTDR_dev_white_tail_ani_first_look" }
		end
		
		for key, value in pairs(G.CONTROLLER.held_keys) do
			if (key == "lalt" and value == true) or (key == "ralt" and value == true) then
				return { key = "j_UTDR_dev_white_tail_ani" }
			elseif (key == "lctrl" and value == true) or (key == "rctrl" and value == true) then
				play_sound("UTDR_flowery_yas", 1.0, 0.7)
				return { key = "j_UTDR_dev_ani_no_no_no" }
			end
		end
		local key = pseudorandom_element({
			"j_UTDR_dev_ani",
			"j_UTDR_dev_ani_caly",
			"j_UTDR_dev_ani_oh_no",
			"j_UTDR_dev_ani_sjelter",
			"j_UTDR_dev_ani_xavier_magic_button",
			"j_UTDR_dev_ani_kalos",
			"j_UTDR_dev_ani_theory",
			"j_UTDR_dev_ani_sweepstakes_2",
			"j_UTDR_dev_ani_sweepstakes_5",
			"j_UTDR_dev_ani_sweepstakes_6",
			"j_UTDR_dev_ani_sweepstakes_7",
			"j_UTDR_dev_ani_juice",
		}, "14a93012r")
		return {
			key = key,
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
		local fail = #UTDR_Modules.elle_plurality.syslist==0

		local text = SMODS.create_sprite(0, 0, 2,  69/391*2, "UTDR_ellecredits_physical_challenges", { x = 0, y = 0 })
		local element = {n = G.UIT.C, config = {padding=-.1}, nodes = {
			{n = G.UIT.R, config = {minh = .2}},
			{n = G.UIT.R, nodes = {
				{n = G.UIT.O, config = {object = text}}
			}}
		}}

		return { vars = {
			fail and "???" or #UTDR_Modules.elle_plurality.syslist+UTDR_Modules.elle_plurality.hidden_count,
			elements = {
				UTDR_Modules.elle_plurality.generate_syslist_ui(UTDR_Modules.elle_plurality[fail and "fallback" or "syslist"]),
				element
			},
			colours = {
				HEX("ff53a9")
			}
		}}
	end,
	in_pool = function(self, args)
		return false
	end,
	set_badges = function(self, card, badges)
		badges[#badges] = create_badge("She/It", HEX("ff53a9"),G.C.WHITE, 1.2)
	end
}

-- credits/config tabs

UTDR.special_thanks = {
	"Toby Fox",
	"Temmie Chang",
	"UT/DR Developers",
	"invalidOS (aka alexi)",
	"GhostSalt",
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
	if UTDR_config['undertale'] and UTDR_config['deltarune'] then
		modname_text = "UNDERTALE/DELTARUNE"
	elseif UTDR_config['undertale'] then
		modname_text = "UNDERTALE"
		modname_scale = 1.0
	elseif UTDR_config['deltarune'] then
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
					label = localize("b_UTDR_enable_undertale"),
					ref_table = UTDR_config,
					ref_value = "undertale",
					tooltip = { text = localize("b_UTDR_requires_restart"), scale = 0.5 }
				}
			),
			create_toggle(
				{
					align = "tl",
					label = localize("b_UTDR_enable_deltarune"),
					ref_table = UTDR_config,
					ref_value = "deltarune",
					tooltip = { text = localize("b_UTDR_requires_restart"), scale = 0.5 }
				}
			),
			create_toggle(
				{
					align = "tl",
					label = localize("b_UTDR_voice_clips"),
					ref_table = UTDR_config,
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
					label = localize("b_UTDR_ralseis"),
					ref_table = UTDR_config,
					ref_value = "ralseis",
					callback = function(_set_toggle)
						if UTDR_config.voiceclips and #SMODS.find_card("j_UTDR_flowery") > 0 and not UTDR_config.ralseis then
							play_sound("UTDR_flowery_sorryaboutthatlittleguy")
						end
					end
				}
			),
			UIBox_button(
				{
					align = "tl",
					label = { localize("b_UTDR_restart") },
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
if UTDR_config['undertale'] then
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
if UTDR_config["deltarune"] then
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

	assert(SMODS.load_file('DR/capsule.lua'))()
	assert(SMODS.load_file('DR/point.lua'))()
	assert(SMODS.load_file('DR/lacquer_shop.lua'))()

	assert(SMODS.load_file('DR/deck.lua'))()
	assert(SMODS.load_file('DR/booster.lua'))()
	assert(SMODS.load_file('DR/prophecy.lua'))()
	assert(SMODS.load_file('DR/tarot.lua'))()
	assert(SMODS.load_file('DR/spectral.lua'))()
	assert(SMODS.load_file('DR/swoon.lua'))()
end

if UTDR_config["deltarune"] and UTDR_config["deltarune"] then
	
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

function UTDR.reset_game_globals(run_start)
	-- Ralsei Card stuff
	local selected_card = pseudorandom_element(G.playing_cards, "ralsei")
	G.GAME.current_round.ralsei_card = G.GAME.current_round.ralsei_card or {}
	G.GAME.current_round.ralsei_card.suit = selected_card.base.suit
	G.GAME.current_round.ralsei_card.rank = selected_card.base.value

	-- Restock Shop
	if UTDR_Modules.Trading and run_start then UTDR_Modules.Trading.reroll_catty_shop() end
end