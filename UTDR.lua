local lovely = require("lovely")

assert(SMODS.load_file('atlas.lua'))()
assert(SMODS.load_file('sound.lua'))()

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

--if the joker you display on the title screen isn't discovered it renders the "pls discover this joker" texture which is very funny
--so here's my solution!
SMODS.Joker {
	key = "sans_title",
	discovered = true,
	atlas = "UT_jokers",
	pos = { x = 1, y = 5 },
	no_collection = true,
	in_pool = function(self, args)
		return false
	end,
}

SMODS.Joker {
	key = "tv_world_title",
	discovered = true,
	atlas = "DR_jokers",
	pos = { x = 0, y = 5 },
	no_collection = true,
	in_pool = function(self, args)
		return false
	end,
}

SMODS.Joker {
	key = "chara_title",
	discovered = true,
	atlas = "UT_jokers",
	pos = { x = 4, y = 7 },
	soul_pos = { x = 7, y = 7 },
	no_collection = true,
	in_pool = function(self, args)
		return false
	end,
}

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
		path = "UndertaleSans.ttf"
	}

	SMODS.Font {
		key = "PapyrusUT",
		path = "UndertalePapyrus.ttf"
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

assert(SMODS.load_file('tag.lua'))()

-- load DR
if UTDR.config_file.deltarune then
	assert(SMODS.load_file('DR/one.lua'))()
	assert(SMODS.load_file('DR/two.lua'))()
	assert(SMODS.load_file('DR/three.lua'))()
	assert(SMODS.load_file('DR/tenna.lua'))()
	
	assert(SMODS.load_file('DR/four.lua'))()
	assert(SMODS.load_file('DR/five.lua'))()
	assert(SMODS.load_file('DR/flowery.lua'))()
	
	assert(SMODS.load_file('DR/66.lua'))()
	assert(SMODS.load_file('DR/99.lua'))()

	assert(SMODS.load_file('DR/point.lua'))()

	
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

--[[SMODS.Challenge {
	key = "flowers",
	rules = {
        custom = {
            { id = "no_shop_jokers" },
        },
        modifiers = {
        	{ id = "joker_slots", value = 8 },
        }
    },
    restrictions = {
    	banned_cards = {
    		{ id = "c_temperance" },
    		{ id = "c_judgement" },
    		{ id = "c_wraith" },
    		{ id = "c_ankh" },
    		{ id = "c_hex" },
    		{ id = "c_soul" },
    		{ id = "c_ectoplasm" },
    		{ id = "p_buffoon_normal_1" },
    		{ id = "p_buffoon_normal_2" },
    		{ id = "p_buffoon_jumbo_1" },
    		{ id = "p_buffoon_mega_1" },
    		{ id = "v_hone" },
    		{ id = "v_glow_up" },
    		{ id = "v_blank" },
    		{ id = "v_antimatter" },
    	},
    	banned_tags = {
    		{ id = "tag_uncommon" },
    		{ id = "tag_rare" },
    		{ id = "tag_negative" },
    		{ id = "tag_foil" },
    		{ id = "tag_holo" },
    		{ id = "tag_polychrome" },
    		{ id = "tag_buffoon" },
    		{ id = "tag_top_up" },
    	},
    },
	jokers = {
		{ id = "j_UTDR_aqua" },
	},
	vouchers = {
		{ id = "v_overstock_norm" },
	},
	apply = function(self)
		G.GAME.interest = 1.5
		--G.GAME.discount_percent = 25
	end,
	calculate = function(self, context)
		if context.ante_change then
			local ante = G.GAME.round_resets.ante
			if ante == 1 then
				SMODS.add_card({ key = "j_UTDR_seth" })
				SMODS.find_card("j_UTDR_seth")[1]:juice_up()
				SMODS.find_card("j_UTDR_seth")[1]:set_eternal(true)
			elseif ante == 2 then
				SMODS.add_card({ key = "j_UTDR_orange" })
				SMODS.find_card("j_UTDR_orange")[1]:juice_up()
				SMODS.find_card("j_UTDR_orange")[1]:set_eternal(true)
			elseif ante == 3 then
				SMODS.add_card({ key = "j_UTDR_green" })
				SMODS.find_card("j_UTDR_green")[1]:juice_up()
				SMODS.find_card("j_UTDR_green")[1]:set_eternal(true)
			elseif ante == 4 then
				SMODS.add_card({ key = "j_UTDR_blue" })
				SMODS.find_card("j_UTDR_blue")[1]:juice_up()
				SMODS.find_card("j_UTDR_blue")[1]:set_eternal(true)
			elseif ante == 5 then
				SMODS.add_card({ key = "j_UTDR_yellow" })
				SMODS.find_card("j_UTDR_yellow")[1]:juice_up()
				SMODS.find_card("j_UTDR_yellow")[1]:set_eternal(true)
			elseif ante == 6 then
				SMODS.add_card({ key = "j_UTDR_pink" })
				SMODS.find_card("j_UTDR_pink")[1]:juice_up()
				SMODS.find_card("j_UTDR_pink")[1]:set_eternal(true)
			elseif ante == 7 then
				SMODS.add_card({ key = "j_UTDR_flowery" })
				SMODS.find_card("j_UTDR_flowery")[1]:juice_up()
				SMODS.find_card("j_UTDR_flowery")[1]:set_eternal(true)
			end
		end
	end
}]]

SMODS.Rarity {
	key = "dog",
	loc_txt = "Dog",
	badge_colour = HEX('000000'),
	text_colour = HEX('ffffff'),
	default_weight = 0.5,
}

function UTDR.calculate(self, context)
	-- flowery voicelines
	if #SMODS.find_card("j_UTDR_flowery") > 0 then
		local card = SMODS.find_card("j_UTDR_flowery")[1]
		--sound effect checking
		if context.showdown_blind_effect then
			play_flowery_sound("nonono")
		elseif context.after then
			card.ability.orange_active = false
		elseif context.before then
			card.config.center:last_jarona(card)
		elseif context.joker_main then
			local oranges = SMODS.find_card("j_UTDR_orange")
			for i = 1, #oranges do
				if oranges[i].config.center.config.card_was_sold then
					card.ability.orange_active = true
				end
			end
			if G.GAME.current_round.hands_left == 0 then
				play_flowery_sound("last_jarona")
				card.ability.final_hand = true
			elseif card.ability.all_flowers then
				play_flowery_sound_random({
					"last_jarona",
					"lend_me_your_power",
					"omega_flowery"
				})
			elseif not card.ability.orange_active then
				play_flowery_sound_grabbag()
			end
		elseif context.blind_defeated then
			if card.ability.final_hand and pseudorandom("its_my_jarona") > 0.67 then
				play_flowery_sound("heh_its_my_jarona")
				card.ability.final_hand = false
			else
				play_flowery_sound_random({
					"heh_one_more_for_the_fans",
					"heh_its_my_jarona",
					"according_to_plant",
					"wow",
					"thatsgreat",
					"leaf_it_to_me",
					"give_it_to_you",
				})
			end
		elseif context.game_over or context.skipping_booster then
			play_flowery_sound_random({
				"sustingus",
				"nonono",
				"goodbye",
				"go_home",
				"get_a_chance_1",
				"get_a_chance_2",
				"forget_it"
			})
		elseif context.card_added then
			if context.card.config.center.key == "j_UTDR_ralsei" then
				play_flowery_sound("hey_raly")
			elseif context.card.config.center.key == "j_UTDR_susie" then
				if #SMODS.find_card("j_UTDR_kris") > 0 then
					play_flowery_sound("my_favorite_two")
				else
					play_flowery_sound("susie")
				end
			elseif context.card.config.center.key == "j_UTDR_kris" then
				if #SMODS.find_card("j_UTDR_susie") > 0 then
					play_flowery_sound("my_favorite_two")
				else
					play_flowery_sound_random({
						"kris",
						"grown_like_a_turnip",
					})
				end
			elseif context.card.config.center.key == "j_UTDR_asgore" then
				if #SMODS.find_card("j_UTDR_kris") > 0 then
					play_flowery_sound("your_dad")
				else
					play_flowery_sound("my_king")
				end
			elseif context.card.config.center.key == "j_UTDR_flowery" then
				play_flowery_sound_random({
					"flowery",
					"itsme",
					"leaf_it_to_me",
					"flowery",
					"flowery2",
				})
			elseif is_card_flower(context.card, true, false) then
				play_flowery_sound_random({
					"its_so_human",
					"my_human",
				})
				if context.card.config.center.key == "j_UTDR_pink" and card.ability.all_flowers then
					context.card:set_eternal(true)
					context.card:set_edition({ negative = true }, true)
				end
			elseif (not context.buying_self or context.open_booster) and context.card.config.center.set == "Joker" then
				play_flowery_sound_random({
					"calling_for_help",
					"heytherelittleguy",
					"heyguysithinkifoundaglue",
				})
			else
				play_flowery_sound_random({
					"sorrytokeepyouwaiting1",
					"sorrytokeepyouwaiting2",
					"sorrytokeepyouladies",
					"sorrytokeepaladyinwaiting",
					"imsorryonceagainikeptaladyinwaiting",
					"hereicomesanfrandisco",
					"glue",
				})
			end
		elseif context.modify_shop_card and context.card == card then
			play_flowery_sound_random({
				"heytherelittleguy",
				"heyguys",
				"hey",
				"hey_boys",
			})
		elseif ((context.selling_card and (is_card_flower(context.card, true, true) or context.card == card)) or (context.joker_type_destroyed and context.card.config.center.key == "j_UTDR_flowery")) then
			play_flowery_sound("goodbye")
		end
	end
end