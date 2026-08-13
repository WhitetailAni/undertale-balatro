SMODS.Challenge {
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
		{ id = "j_UTDR_aqua", eternal = true },
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
}

SMODS.Challenge {
	key = "balatro_the_musical",
	jokers = {
		{ id = "j_UTDR_mettaton_ex" },
		{ id = "j_UTDR_burgerpants", eternal = true },
	},
}

SMODS.Challenge {
	key = "neutral_on_these_things",
	rules = {
        custom = {
            { id = "inflation", value = 3 },
        },
        modifiers = {
        	{ id = "joker_slots", value = 7 },
        	{ id = "hand_size", value = 5 },
        }
    },
	jokers = {
		{ id = "j_UTDR_fallen_human" },
	},
}

SMODS.Challenge {
	key = "find_her_dot_o_g_g",
    restrictions = {
    	banned_cards = {
    		{ id = "p_arcana_normal_1" },
    		{ id = "p_arcana_normal_2" },
    		{ id = "p_arcana_normal_3" },
    		{ id = "p_arcana_normal_4" },
    		{ id = "p_arcana_jumbo_1" },
    		{ id = "p_arcana_jumbo_2" },
    		{ id = "p_arcana_mega_1" },
    		{ id = "p_arcana_mega_2" },
    		
    		{ id = "p_celestial_normal_1" },
    		{ id = "p_celestial_normal_2" },
    		{ id = "p_celestial_normal_3" },
    		{ id = "p_celestial_normal_4" },
    		{ id = "p_celestial_jumbo_1" },
    		{ id = "p_celestial_jumbo_2" },
    		{ id = "p_celestial_mega_1" },
    		{ id = "p_celestial_mega_2" },
    		
    		{ id = "p_spectral_normal_1" },
    		{ id = "p_spectral_normal_2" },
    		{ id = "p_spectral_jumbo_1" },
    		{ id = "p_spectral_mega_1" },
    		
    		{ id = "v_planet_tycoon" },
    		{ id = "v_planet_tycoon" },
    		{ id = "v_tarot_tycoon" },
    		{ id = "v_tarot_merchant" },
    		{ id = "v_magic_trick" },
    		{ id = "v_illusion" },
    		{ id = "v_omen_globe" },
    	},
    	banned_tags = {
    		{ id = "tag_charm" },
    		{ id = "tag_meteor" },
    		{ id = "tag_ethereal" },
    		{ id = "tag_orbital" },
    	},
    },
	jokers = {
		{
			id = "j_UTDR_find_her_dogg_girl",
			edition = "negative",
			eternal = true
		},
		{
			id = "j_UTDR_ROOTS",
			eternal = true
		},
	},
}

SMODS.Challenge {
	key = "shatter_dream",
	rules = {
        modifiers = {
        	{ id = "joker_slots", value = 3 },
        }
    },
	jokers = {
		{
			id = "j_UTDR_shadow_crystal",
			edition = "negative",
			eternal = true
		},
	},
	apply = function(self)
		G.GAME.spectral_rate = 2
	end,
}

SMODS.Challenge {
	key = "sans",
	rules = {
        modifiers = {
        	{ id = "hand_size", value = 7 },
        	{ id = "consumable_slots", value = 1 },
        	{ id = "discards", value = 1 },
        	{ id = "hands", value = 5 },
        }
    },
     restrictions = {
    	banned_cards = {
    		{ id = "c_mercury" },
    		{ id = "c_venus" },
    		{ id = "c_earth" },
    		{ id = "c_mars" },
    		{ id = "c_jupiter" },
    		{ id = "c_saturn" },
    		{ id = "c_uranus" },
    		{ id = "c_neptune" },
    		{ id = "c_planet_x" },
    		{ id = "c_ceres" },
    		{ id = "c_eris" },
    	},
    },
	jokers = {
		{ id = "j_UTDR_sans" },
	},
	--possibly add hook into planet card gen to ensure only pluto? that way all mods will work
}