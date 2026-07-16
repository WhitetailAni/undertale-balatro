SMODS.Joker {
	key = "doghole",
	config = {
		values = {
			chips_count = 90,
			mult_count = 15,
			xmult_count = 1.5,
			dollars_count = 2,
		},

		states = {
			chips = false,
			mult = false,
			xmult = false,
			money = false,
		}
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 4, y = 11 },
	cost = 8,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.values.chips_count,
				card.ability.values.mult_count,
				card.ability.values.xmult_count,
				card.ability.values.dollars_count
			}
		}
	end,
	calculate = function(self, card, context)
		if context.setting_blind and not card.getting_sliced then
			local rand = pseudorandom("doghole")
			--play_sound("UTDR_alphys", 1.0, 0.7)
			--card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Called in!" })

			local zeroth = 0
			local first = 1 / 4
			local second = 2 / 4
			local third = 3 / 4
			local fourth = 4 / 4

			if zeroth < rand and rand < first then
				card.ability.states.chips = true
			elseif first < rand and rand < second then
				card.ability.states.mult = true
			elseif second < rand and rand < third then
				card.ability.states.xmult = true
			elseif third < rand and rand < fourth then
				card.ability.states.money = true
			end
		elseif context.joker_main then
			if card.ability.states.chips then
				return {
					chips = card.ability.values.chips_count
				}
			elseif card.ability.states.mult then
				return {
					mult = card.ability.values.mult_count
				}
			elseif card.ability.states.xmult then
				return {
					xmult = card.ability.values.xmult_count
				}
			end
		elseif context.individual and context.cardarea == G.play then
			return {
				dollars = card.ability.dollars_count
			}
		elseif context.end_of_round and context.cardarea == G.jokers then
			if card.ability.states.chips then
				card.ability.states.chips = false
			elseif card.ability.states.mult then
				card.ability.states.mult = false
			elseif card.ability.states.xmult then
				card.ability.states.xmult = false
			end
		end
	end
}

SMODS.Joker {
	key = "mysterious_artifact",
	rarity = 3,
	blueprint_compat = false,
	eternal_compat = false,
	atlas = "DR_jokers",
	pos = { x = 5, y = 11 },
	cost = 12,
	add_to_deck = function(self, card, from_debuff)
		play_sound("UTDR_badexplosion", 1.0, 0.7)

		G.E_MANAGER:add_event(Event({
			func = function()
				play_sound('tarot1')
				card.T.r = -0.2
				card:juice_up(0.3, 0.4)
				card.states.drag.is = true
				card.children.center.pinch.x = true
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.3,
					blockable = false,
					func = function()
						G.jokers:remove_card(card)
						card:remove()
						card = nil
						SMODS.add_card({ key = "j_UTDR_annoying_dog" })
						return true;
					end
				}))
				return true
			end
		}))
	end
}

SMODS.Joker {
	key = "dog_shrine",
	rarity = 1,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 3, y = 11 },
	config = {
		money = 1,
		extra_boosters = 1
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.money } }
	end,
	calc_dollar_bonus = function(self, card)
		return -card.ability.money
	end,
	add_to_deck = function(self, card, from_debuff)
		SMODS.change_booster_limit(card.ability.extra_boosters)
	end,
	remove_from_deck = function(self, card, from_debuff)
		SMODS.change_booster_limit(-card.ability.extra_boosters)
	end
}

-- roast chicken
SMODS.Joker {
	key = "check_it_out_im_in_the_house_like_carpet",
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	cost = 3,
	pos = { x = 6, y = 11 },
	config = { extra = { hands = 0, hands_required = 3, consumable_type = "Planet" } },
	loc_vars = function(self, info_queue, card)
		return { vars = {
			card.ability.extra.hands,
			card.ability.extra.hands_required,
			localize("k_" .. string.lower(card.ability.extra.consumable_type)),
		} }
	end,
	calculate = function(self, card, context)
		if context.after then
			local create_new_card = false
			if not context.blueprint then
				card.ability.extra.hands = card.ability.extra.hands + 1
				if card.ability.extra.hands >= card.ability.extra.hands_required then
					create_new_card = true
					card.ability.extra.hands = 0
				end
			end
			if create_new_card then
				if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
					G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
					return {
						extra = {
							message = localize('k_plus_' .. string.lower(card.ability.extra.consumable_type)),
							colour = G.C.SECONDARY_SET[card.ability.extra.consumable_type] or G.C.FILTER,
							message_card = card,
							func = function() -- This is for timing purposes, everything here runs after the message
								G.E_MANAGER:add_event(Event({
									func = (function()
										SMODS.add_card {
											set = card.ability.extra.consumable_type,
											key_append = 'UTDR_roast_chicken'
										}
										G.GAME.consumeable_buffer = 0
										return true
									end)
								}))
							end
						},
					}
				else
					-- no room
				end
			else
				if not context.blueprint then
					return {
						message = tostring(card.ability.extra.hands) ..
							"/" .. tostring(card.ability.extra.hands_required),
						colour = G.C.SECONDARY_SET[card.ability.extra.consumable_type] or G.C.FILTER
					}
				end
			end
		end
	end
}
