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
	key = "petal_feather",
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers_2",
	pos = { x = 2, y = 0 },
	soul_pos = { x = 2, y = 3 },
	cost = 3,
	calculate = function(self, card, context)
		if context.evaluate_poker_hand then
			print(context.full_hand[1])
		end
	end
}

SMODS.Joker {
	key = "aqua",
	config = {
		lower_bound = 1,
		upper_bound = 6
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
		cannot_speak = false,
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
	soul_pos = { x = 0, y = 3 },
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
		elseif not (context.blueprint or card.ability.cannot_speak) then --we dont want blueprint or brainstorm doubletalking, do we? (i discovered that this would happen while verifying blueprint compat. MY EARS)
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
			elseif context.card_added then
				if context.card.config.center.key == "j_UTDR_flowery" then
					context.card.config.center.config.cannot_speak = true --multiple flowerys and yet only one can speak. what a conundrum
				elseif context.card.config.center.key == "j_UTDR_ralsei" then
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
			elseif (context.selling_card and is_card_flower(context.card, true, true)) or context.selling_self then
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
	cost = 5,
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

SMODS.Joker {
	key = "pink",
	config = {
		extra = {
			odds = 4,
			suit = "Hearts",
			card_type = "Tarot"
		}
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers_2",
	pos = { x = 0, y = 1 },
	cost = 8,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { type = 'name_text', key = "e_negative_consumable", set = "Edition", config = { extra = 1 } }
		local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'pink')
		return {
			vars = {
				numerator,
				denominator,
				localize("k_" .. string.lower(card.ability.extra.card_type)),
				localize(card.ability.extra.suit, 'suits_singular') or "Heart",
				localize { type = 'name_text', key = "e_negative_consumable", set = "Edition", config = { extra = 1 } },
				colours = {
					G.C.SUITS[card.ability.extra.suit],
					G.C.SECONDARY_SET[card.ability.extra.card_type] or G.C.FILTER
				}
			}
		}
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and (context.other_card:is_suit(card.ability.extra.suit) or SMODS.has_any_suit(context.other_card)) and SMODS.pseudorandom_probability(card, 'j_UTDR_pink', 1, card.ability.extra.odds) then
			-- check if should add consumable
			local do_message = false
			if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
				do_message = true
			end
			-- create spectral
			if do_message then
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				return {
					extra = {
						message = localize('k_plus_' .. string.lower(card.ability.extra.card_type)),
						colour = G.C.SECONDARY_SET[card.ability.extra.card_type] or G.C.FILTER,
						message_card = card,
						func = function() -- This is for timing purposes, everything here runs after the message
							G.E_MANAGER:add_event(Event({
								func = (function()
									SMODS.add_card {
										set = card.ability.extra.card_type,
										edition = "e_negative",
										key_append = 'UTDR_pink' -- Optional, useful for manipulating the random seed and checking the source of the creation in `in_pool`.
									}
									G.GAME.consumeable_buffer = 0
									return true
								end)
							}))
						end
					},
				}
			end
		end
	end,
}

SMODS.Joker {
	key = "netskie",
	config = {
		mult = 8,
		in_build = false,
		disguised = false,
		chosen_joker_key = "",
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers_2",
	pos = { x = 7, y = 1 },
	soul_pos = { x = 1, y = 8 },
	cost = 5,
	disguise = function(self_self, self_card)
		local keys = {}
		for key, value in pairs(G.localization.descriptions.Joker) do
		  keys[#keys + 1] = key
		end
		
		local j = 1
		for i = 1, #keys do
			if keys[i]:find("UTDR", 1, true) then
				keys[j] = keys[i]
				j = j + 1
			end
		end
		for i = j, #keys do
			keys[i] = nil
    	end
		
		--make sure it sticks to 1 joker!!
		local chosen_joker_key = ""
		if not self_card.config.disguised then
			chosen_joker_key = pseudorandom_element(keys, "netskie_joker")
			self_card.config.chosen_joker_key = chosen_joker_key
		else
			chosen_joker_key = self_card.config.chosen_joker_key
		end
		self_card.config.disguised = true
		
		--reset to default "Kee kee~"
		G.localization.descriptions.Joker["j_UTDR_netskie_disguise"].text = G.localization.descriptions.Joker["j_UTDR_netskie_disguise_base"].text
		G.localization.descriptions.Joker["j_UTDR_netskie_disguise"].text_parsed = G.localization.descriptions.Joker["j_UTDR_netskie_disguise_base"].text_parsed
		
		--put the desired text before the "Kee kee~" since parsing the text hard and ill just have the game do it
		G.localization.descriptions.Joker["j_UTDR_netskie_disguise"].text = prepend_to_table(G.localization.descriptions.Joker["j_UTDR_netskie_disguise"].text, G.localization.descriptions.Joker[chosen_joker_key].text)
		G.localization.descriptions.Joker["j_UTDR_netskie_disguise"].text_parsed = prepend_to_table(G.localization.descriptions.Joker["j_UTDR_netskie_disguise"].text_parsed, G.localization.descriptions.Joker[chosen_joker_key].text_parsed)
	
		--idk if we Need to copy over the base .text and .name but ill do it in case theres any sneaky detection jokers.
		G.localization.descriptions.Joker["j_UTDR_netskie_disguise"].name = G.localization.descriptions.Joker[chosen_joker_key].name
		G.localization.descriptions.Joker["j_UTDR_netskie_disguise"].name_parsed = G.localization.descriptions.Joker[chosen_joker_key].name_parsed

		local center = G.P_CENTERS[chosen_joker_key]
		local can_localize = false
		if center then
			for key, value in pairs(center) do
				if key == "loc_vars" then
					can_localize = true
				end
			end
		end
		
		local dummy = SMODS.create_card({
			key = chosen_joker_key,
			skip_materialize = true,
			set = "Joker",
			no_edition = true
		})
		
		--print("self_self")
		
		for key, value in pairs(self_self) do
			--print(key)
		end
		
		--print(" ")
		--print("self_card")
		
		for key, value in pairs(self_card) do
			--print(key)
		end
		
		--print(self_self)
		--print(self_card.mod)
		
		--print(self_card)
		--print(card.children)
		--print(card.children.center)
		--self_card.config.center:set_sprite_pos({ x = 2, y = 1 })
		
		--local dummy_sprite = Sprite:init(0, 0, 71, 75, "DR_jokers_2", { x = 2, y = 1 })
		--print(dummy_sprite)
		
		local vars = { vars = { } }
		if can_localize then
			local card = dummy.config.center
			card["ability"] = dummy.config.center.config
			vars = center:loc_vars({}, card)
			dummy:remove()
		end
		
		return vars["vars"]
	end,
	loc_vars = function(self, info_queue, card)
		if not card.in_build then
			return {
				vars = self:disguise(self, card),
				key = "j_UTDR_netskie_disguise",
			}
		end
		return { vars = { card.ability.mult } }
	end,
	add_to_deck = function(self, card, from_debuff)
		card.ability.in_build = true
		--play_sound("UTDR_netskie", 1.0, 0.7)
	end,
	remove_from_deck = function(self, card, from_debuff)
		card.ability.in_build = false
	end,
	calculate = function(self, card, context)
		if context.discard and SMODS.pseudorandom_probability(card, "eram", 1, card.ability.odds, "DR_eram") then
			card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Burned!" })
			play_sound("UTDR_ERAM", 1.0, 0.7)
			return {
				remove = true,
				removed = context.other_card
			}
		end
	end
}

function prepend_to_table(tabble, new_items)
    local tabbble = {}
    for _, v in ipairs(new_items) do
        table.insert(tabbble, v)
    end
    table.insert(tabbble, tabble[1])
    return tabbble
end
