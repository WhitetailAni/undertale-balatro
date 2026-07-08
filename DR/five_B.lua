SMODS.Joker {
	key = "aqua",
	loc_txt = {
		name = "Aqua",
		text = {
			"Played cards give a",
			"{C:attention}random{} amount of",
			"{C:mult}Mult{} when scored",
		}
	},
	config = {
		lower_bound = 1,
		upper_bound = 10
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 5, y = 3 },
	cost = 3,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			return {
				mult = (math.floor(pseudorandom("aqua") * 10) + 1),
				card = context.blueprint_card or card
			}
		end
	end
}

SMODS.Joker {
	key = "flowery",
	loc_txt = {
		name = "Flowery",
		text = {
			"Each played {C:attention}9{} ",
			"gives {X:mult,C:white}X#1#{} Mult and",
			"is {C:attention}retriggered{}",
			"when scored",
		}
	},
	config = {
		xmult = 2,
	},
	loc_vars = function(self, info_queue, card)
		if not card.debuff then
			play_flowery_sound_random({
				"flowery",
				"flowery2",
				"hey",
				"heyguys",
				"itsme",
				"itsmeflowery",
				"heytherelittleguy",
				"thisguysyourbestfriend",
				"glue",
			})
		end
		return { vars = { card.ability.xmult } }
	end,
		rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 5, y = 3 },
	cost = 3,
	calculate = function(self, card, context)
		if context.repetition and context.cardarea == G.play then
			if context.other_card:get_id() == 9 then
				return {
					message = localize('k_again_ex'),
					repetitions = 1,
					card = context.blueprint_card or card
				}
			end
		elseif context.individual and context.cardarea == G.play then
			if context.other_card:get_id() == 9 then
				return {
					xmult = card.ability.xmult,
					card = context.blueprint_card or card
				}
			end
		
		--sound effect checking
		elseif context.showdown_blind_effect then
			print("hey_guys")
			play_flowery_sound("nonono")
		elseif context.joker_main then
			if G.GAME.round_resets.hands == 0 then
				play_flowery_sound("last_jarona")
			else 
				play_flowery_sound_random({
					"blingo_blizzard",
					"flowers_blooms_in_your_heart",
					"wow",
					"try_my_flavor",
					"the_diner",
					"the_boys",
					"thatsgreat",
					"thats_my_dreams",
					"take_that",
					"suckle_it_up",
					"spiral_dance",
					"smile_again",
					"say_that_again",
					"prism_blow",
					"powering_up",
					"minipeppers",
					"leaf_it_to_me",
					"jarona1",
					"jarona2",
					"jarona3",
					"jarona4",
					"its_all_yours",
					"its_all_in_a_name",
					"im_only_trying_to_help_you",
					"huhillshowyou",
					"huh",
					"hoo",
					"hah",
					"glue",
					"give_it_to_you",
					"get_a_chance_1",
					"get_a_chance_2",
					"forget_it",
					"youre_a_hero",
					"glue",
				})
			end
		elseif context.blind_defeated then
			play_flowery_sound_random({
				"heh_one_more_for_the_fans",
				"heh_its_my_jarona",
				"according_to_plant",
			})
		elseif context.game_over then
			play_flowery_sound("sustingus")
		elseif context.buying_card then
			if context.card.config.center.key == "j_UTDR_ralsei" then
				play_flowery_sound("hey_raly")
			elseif context.card.config.center.key == "j_UTDR_susie" then
				if #SMODS.find_card("j_UTDR_kris") then
					play_flowery_sound("my_favorite_two")
				else
					play_flowery_sound("susie")
				end
			elseif context.card.config.center.key == "j_UTDR_kris" then
				if #SMODS.find_card("j_UTDR_susie") then
					play_flowery_sound("my_favorite_two")
				else
					play_flowery_sound_random({
						"kris",
						"grown_like_a_turnip",
					})
				end
			elseif context.card.config.center.key == "j_UTDR_asgore" then
				if #SMODS.find_card("j_UTDR_kris") then
					play_flowery_sound("your_dad")
				else
					play_flowery_sound("my_king")
				end
			elseif context.card.config.center.key == "j_UTDR_orange" then
				if pseudorandom("ja_orange") > 0.5 then
					play_flowery_sound("ja_orange_1")
				else
					play_flowery_sound("ja_orange_2")
				end
			elseif not context.buying_self then
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
				"glue",
			})
		elseif context.selling_self then
			play_flowery_sound("goodbye")
		end
	end
}