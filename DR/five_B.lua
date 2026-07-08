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
		all_flowers = false
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
			play_flowery_sound("nonono")
		elseif context.joker_main then
			local aquas = SMODS.find_card("j_UTDR_aqua")
			local seths = SMODS.find_card("j_UTDR_seth")
			local yellows = SMODS.find_card("j_UTDR_yellow")
			local blues = SMODS.find_card("j_UTDR_blue")
			local oranges = SMODS.find_card("j_UTDR_orange")
			local greens = SMODS.find_card("j_UTDR_green")
			local flowerys = SMODS.find_card("j_UTDR_flowery")
			local pinks = SMODS.find_card("j_UTDR_pink")
			if G.GAME.round_resets.hands == 0 or card.ability.all_flowers then
				play_flowery_sound("last_jarona")
			elseif #aquas > 0 and #seths > 0 and #yellows > 0 and #blues > 0 and #oranges > 0 and #greens > 0 then
				play_flowery_sound("lend_me_your_power")
				card.ability.all_flowers = true
				
				for i = 1, #aquas do
					aquas[i]:set_eternal(true)
					aquas[i]:set_edition({ negative = true }, true)
				end
				for i = 1, #seths do
					seths[i]:set_eternal(true)
					seths[i]:set_edition({ negative = true }, true)
				end
				for i = 1, #yellows do
					yellows[i]:set_eternal(true)
					yellows[i]:set_edition({ negative = true }, true)
				end
				for i = 1, #blues do
					blues[i]:set_eternal(true)
					blues[i]:set_edition({ negative = true }, true)
				end
				for i = 1, #oranges do
					oranges[i]:set_eternal(true)
					oranges[i]:set_edition({ negative = true }, true)
				end
				for i = 1, #greens do
					greens[i]:set_eternal(true)
					greens[i]:set_edition({ negative = true }, true)
				end
				for i = 1, #flowerys do
					flowerys[i]:set_eternal(true)
					flowerys[i]:set_edition({ negative = true }, true)
				end
				--if you have her on the team, fun little bonus! not required for Last Jaronaing though
				for i = 1, #pinks do
					pinks[i]:set_eternal(true)
					pinks[i]:set_edition({ negative = true }, true)
				end
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
				"wow",
				"thatsgreat",
				"leaf_it_to_me",
				"give_it_to_you",
			})
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
			elseif context.card.config.center.key == "j_UTDR_aqua" or context.card.config.center.key == "j_UTDR_seth" or context.card.config.center.key == "j_UTDR_yellow"or  context.card.config.center.key == "j_UTDR_blue" or context.card.config.center.key == "j_UTDR_green" then
				play_flowery_sound_random({
					"its_so_human",
					"my_human",
				})
			elseif not context.buying_self or context.open_booster then
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
		elseif context.selling_self then
			play_flowery_sound("goodbye")
		end
	end
}