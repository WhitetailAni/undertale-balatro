SMODS.Joker {
	key = "flower_castle",
	config = {
		chips = 0,
		chip_gain = 2
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.chip_gain, localize("Clubs", 'suits_singular'), card.ability.chips } }
	end,
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers_2",
	pos = { x = 2, y = 1 },
	cost = 3,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and (context.other_card.base.suit == "Clubs" or SMODS.has_any_suit(context.other_card)) then
			SMODS.scale_card(card, {
				ref_table = card.ability,
				ref_value = "chips",
				scalar_value = "chip_gain",
				message_colour = G.C.CHIPS
			})
		elseif context.joker_main then
			return {
				chips = card.ability.chips
			}
		end
	end
}

SMODS.Joker {
	key = "aqua",
	config = {
		lower_bound = 1,
		upper_bound = 10
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers_2",
	pos = { x = 6, y = 0 },
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
	config = {
		xmult = 1.5,
		all_flowers = false,
		orange_active = false,
		final_hand = false,
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
		return { vars = { card.ability.xmult, localize("9", "ranks") or "9" } }
	end,
		rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers_2",
	pos = { x = 9, y = 0 },
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
		elseif not context.blueprint then --we dont want blueprint or brainstorm doubletalking, do we? (i discovered that this would happen while verifying blueprint compat. MY EARS)
			--sound effect checking
			if context.showdown_blind_effect then
				play_flowery_sound("nonono")
			elseif context.after then
				card.ability.orange_active = false
			elseif context.before then
				local aquas = SMODS.find_card("j_UTDR_aqua")
				local seths = SMODS.find_card("j_UTDR_seth")
				local yellows = SMODS.find_card("j_UTDR_yellow")
				local blues = SMODS.find_card("j_UTDR_blue")
				local oranges = SMODS.find_card("j_UTDR_orange")
				local greens = SMODS.find_card("j_UTDR_green")
				local flowerys = SMODS.find_card("j_UTDR_flowery")
				local pinks = SMODS.find_card("j_UTDR_pink")
				
				if #aquas > 0 and #seths > 0 and #yellows > 0 and #blues > 0 and #oranges > 0 and #greens > 0 then
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
						oranges[i].config.center.config.all_flowers = true
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
				end 
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
				if card.ability.final_hand and pseudorandom("its_my_jarona") > 0.6 then
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
				elseif context.card.config.center.key == "j_UTDR_aqua" or context.card.config.center.key == "j_UTDR_seth" or context.card.config.center.key == "j_UTDR_yellow"or  context.card.config.center.key == "j_UTDR_blue" or context.card.config.center.key == "j_UTDR_green" or context.card.config.center.key == "j_UTDR_orange" then
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
			elseif context.modify_shop_card and context.card == card and not context.blueprint then
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
	end
}

SMODS.Joker {
	key = "orange",
	config = {
		mult = 40,
		card_was_sold = false,
		all_flowers = false
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.mult } }
	end,
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers_2",
	pos = { x = 8, y = 0 },
	cost = 3,
	calculate = function(self, card, context)
		if context.selling_card and not card.ability.card_was_sold then
			card.ability.card_was_sold = true
			return {
				message = localize('k_active_ex'),
				colour = G.C.FILTER
			}
		elseif context.selling_self then
			local flowerys = SMODS.find_card("j_UTDR_flowery", true)
			for i = 1, #flowerys do
				flowerys[i].config.center.config.orange_active = false
			end
		elseif context.joker_main and card.ability.card_was_sold and not card.ability.all_flowers then
			if #SMODS.find_card("j_UTDR_flowery") > 0 and G.GAME.current_round.hands_left > 0 then
				local which_sfx = pseudorandom("ja_orange")
				if which_sfx > 0.8 then
					play_flowery_sound("ja_orange_1")
				elseif which_sfx > 0.6 then
					play_flowery_sound("ja_orange_2")
				else
					play_flowery_sound_grabbag()
				end
			end		
			return {
				mult = card.ability.mult
			}
		elseif context.end_of_round and context.main_eval and card.ability.card_was_sold then
			card.ability.card_was_sold = false
			return {
				message = localize('k_reset')
			}
		end
	end
}

SMODS.Joker {
	key = "blue",
	config = {
		required_chips = 75,
	},
	--unlocked = false
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers_2",
	pos = { x = 4, y = 0 },
	cost = 10,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.required_chips } }
	end,
	calculate = function(self, card, context)
		if context.game_over and G.GAME.chips / G.GAME.blind.chips >= card.ability.required_chips / 100 and not context.blueprint then
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.4,
				func = function()
					if G.consumeables.config.card_limit > #G.consumeables.cards then
						play_sound('timpani')
						local new_card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'blue_tarot')
						new_card:add_to_deck()
						G.consumeables:emplace(new_card)
						if context.blueprint then
							context.blueprint_card:juice_up(0.3, 0.5)
						else
							card:juice_up(0.3, 0.5)
						end
					end
					return true
				end
			}))
			G.E_MANAGER:add_event(Event({
				func = function()
					G.hand_text_area.blind_chips:juice_up()
					G.hand_text_area.game_chips:juice_up()
					play_sound('tarot1')
					return true
				end
			}))
			return {
				saved = "totem_UTDR_blue",
			}
		elseif context.end_of_round and context.main_eval and not context.game_over then
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.4,
				func = function()
					if G.consumeables.config.card_limit > #G.consumeables.cards then
						play_sound('timpani')
						local new_card = create_card('Planet', G.consumeables, nil, nil, nil, nil, nil, 'blue_planet') --wow didnt know he was mormon
						new_card:add_to_deck()
						G.consumeables:emplace(new_card)
						if context.blueprint then
							context.blueprint_card:juice_up(0.3, 0.5)
						else
							card:juice_up(0.3, 0.5)
						end
					end
					return true
				end
			}))
		end
	end
}