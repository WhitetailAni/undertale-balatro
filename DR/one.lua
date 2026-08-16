--field
SMODS.Joker {
	key = "amber_card",
	config = {
		hands = 2,
		hand_size = 1
	},
	pixel_size = { w = 69, h = 69 },
	rarity = 1,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 5, y = 0 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.hands, card.ability.hand_size } }
	end,
	add_to_deck = function(self, card, from_debuff)
		G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.hands
		ease_hands_played(card.ability.hands)
		G.hand:change_size(-card.ability.hand_size)
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.hands
		ease_hands_played(-card.ability.hands)
		G.hand:change_size(card.ability.hand_size)
	end,
}

SMODS.Joker {
	key = "lancer_cookie",
	config = {
		chips = 60
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = false,
	atlas = "DR_jokers",
	pos = { x = 4, y = 0 },
	cost = 3,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.chips } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chips = card.ability.chips
			}
		elseif context.end_of_round and G.GAME.blind.boss and not context.blueprint then
			G.E_MANAGER:add_event(Event({
				func = function()
					card_eval_status_text(card, 'extra', nil, nil, nil,
						{ message = localize("k_UTDR_splat_ex"), colour = G.C.BLUE })
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
							return true;
						end
					}))
					return true
				end
			}))
		end
	end
}

SMODS.Joker {
	key = "top_cake",
	config = {
		xmult_gain = 0.2,
		xmult = 1,
		hands = 0,
		hand_limit = 15,
	},
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = false,
	atlas = "DR_jokers",
	pos = { x = 0, y = 0 },
	cost = 8,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.xmult_gain,
				card.ability.hand_limit,
				card.ability.hands,
				card.ability.xmult
			}
		}
	end,
	calculate = function(self, card, context)
		if context.before and context.cardarea == G.jokers then
			card.ability.hands = card.ability.hands + 1
			SMODS.scale_card(card, {
				ref_table = card.ability,
				ref_value = "xmult",
				scalar_value = "xmult_gain",
				message_colour = G.C.MULT
			})
		elseif context.joker_main then
			return {
				xmult = card.ability.xmult
			}
		elseif context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
			if card.ability.hands >= card.ability.hand_limit then
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
								return true;
							end
						}))
						return true
					end
				}))
				if #SMODS.find_card("j_UTDR_susie") > 0 then
					susie:juice_up(0.3, 0.3);
					return {
						message = "Consumed by the Dragon"
					}
				else
					return {
						message = "Mama miba!"
					}
				end
			end
		end
	end
}

SMODS.Joker {
	key = "thrash_machine",
	config = {
		chips = 100,
		discards_remaining = 0
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 5, y = 2 },
	cost = 4,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.chips, card.ability.discards_remaining } }
	end,
	calculate = function(self, card, context)
		if context.joker_main and G.GAME.current_round.discards_left == card.ability.discards_remaining then
			return {
				chips = card.ability.chips
			}
		end
	end
}

SMODS.Joker {
	key = "k_round",
	config = {
		chip_gain = 5,
		chip_loss = -5,
		chips = 0
	},
	pixel_size = { w = 68, h = 68 },
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 8, y = 2 },
	cost = 4,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.chip_gain, card.ability.chip_loss, card.ability.chips } }
	end,
	calculate = function(self, card, context)
		if context.pre_discard and context.cardarea == G.jokers and card.ability.chips > 0 and not context.blueprint then
			SMODS.scale_card(card, {
				ref_table = card.ability,
				ref_value = "chips",
				scalar_value = "chip_loss",
				message_colour = G.C.CHIPS
			})
		elseif context.before and context.cardarea == G.jokers and not context.blueprint then
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

--forest
SMODS.Joker {
	key = "seam",
	rarity = 1,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 7, y = 2 },
	cost = 6,
}

SMODS.Joker {
	key = "lancer",
	config = {
		chips = 30,
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 0, y = 2 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.chips, localize("Spades", 'suits_singular') or "Spade" } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and (context.other_card:is_suit("Spades") or SMODS.has_any_suit(context.other_card)) then
			return {
				chips = card.ability.chips
			}
		end
	end
}

SMODS.Joker {
	key = "king",
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 1, y = 3 },
	cost = 5,
	config = {
		xmult_gain = 0.2,
		xmult = 1,
		total_gain = 0
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult_gain, card.ability.xmult, localize("Spades", 'suits_singular') or "Spade" } }
	end,
	calculate = function(self, card, context)
		if context.remove_playing_cards and not context.blueprint then
			card.ability.total_gain = 0
			local nonspades = 0
			for i = 1, #context.removed do
				if (not context.removed[i]:is_suit("Spades") or SMODS.has_any_suit(context.removed[i])) then
					nonspades = nonspades + 1
				end
			end
			card.ability.total_gain = card.ability.xmult_gain * nonspades
			if nonspades > 0 then
				SMODS.scale_card(card, {
					ref_table = card.ability,
					ref_value = "xmult",
					scalar_value = "total_gain",
					message_colour = G.C.MULT
				})
			end
			return
		elseif context.joker_main then
			return {
				xmult = card.ability.xmult
			}
		end
	end
}

SMODS.Joker {
	key = "clover",
	config = {
		chips = 21,
		mult = 3,
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 9, y = 2 },
	cost = 4,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.chips, card.ability.mult, localize("Clubs", 'suits_singular') or "Club" } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and (context.other_card:is_suit("Clubs") or SMODS.has_any_suit(context.other_card)) then
			return {
				chips = card.ability.chips,
				mult = card.ability.mult
			}
		end
	end
}

SMODS.Joker {
	key = "jevil",
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 0, y = 3 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_wild
		return { vars = { localize({ type = 'name_text', set = "Enhanced", key = "m_wild" }) or "Wild Card" } }
	end,
	calculate = function(self, card, context)
		if context.repetition and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, "m_wild") then
			return {
				repetitions = 1,
			}
		end
	end
}

--castle
SMODS.Joker {
	key = "scarlet_forest",
	config = {
		mult_gain = 2,
		mult = 0
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 4, y = 2 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.mult_gain,
				G.localization.misc.poker_hands['Straight'],
				card.ability.mult
			}
		}
	end,
	calculate = function(self, card, context)
		if context.before and context.cardarea == G.jokers and next(context.poker_hands['Straight']) and not context.blueprint then
			SMODS.scale_card(card, {
				ref_table = card.ability,
				ref_value = "mult",
				scalar_value = "mult_gain",
				message_colour = G.C.MULT
			})
		elseif context.joker_main then
			return {
				mult = card.ability.mult
			}
		end
	end
}

SMODS.Joker {
	key = "glowshard",
	config = {
		sell_value_gain = 1,
		extra_value = 0
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.sell_value_gain } }
	end,
	rarity = 1,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 1, y = 0 },
	cost = 3,
	calculate = function(self, card, context)
		if context.selling_card and context.card ~= card and not context.blueprint then
			card.ability.extra_value = card.ability.extra_value + card.ability.sell_value_gain
			card:set_cost()
			return {
				message = localize('k_val_up'),
				colour = G.C.MONEY
			}
		end
	end
}

SMODS.Joker {
	key = "rouxls",
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 6, y = 2 },
	cost = 5,
	config = {
		chip_gain = 10,
		chips = 0,
		selected_hand = "Three of a Kind"
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.chip_gain, G.localization.misc.poker_hands[card.ability.selected_hand], card.ability.chips } }
	end,
	set_ability = function(self, card, initial, delay_sprites)
		card.ability.selected_hand = pseudorandom_element(get_keys(G.GAME.hands), "rouxls")
	end,
	calculate = function(self, card, context)
		if context.before and context.cardarea == G.jokers and context.scoring_name == card.ability.selected_hand and not context.blueprint then
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
		elseif context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
			card.ability.selected_hand = pseudorandom_element(get_keys(G.GAME.hands), "rouxls")
			while not G.GAME.hands[card.ability.selected_hand].visible do
				card.ability.selected_hand = pseudorandom_element(get_keys(G.GAME.hands), "rouxls")
			end
		end
	end
}

SMODS.Joker {
	key = "iron_shackle",
	config = {
		in_build = false
	},
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 6, y = 0 },
	cost = 6,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_gold
		info_queue[#info_queue + 1] = G.P_CENTERS.m_steel
		return { vars = { localize({ type = 'name_text', set = "Enhanced", key = "m_gold" }), localize({ type = 'name_text', set = "Enhanced", key = "m_steel" }), card.ability.mult } }
	end,
	add_to_deck = function(self, card, from_debuff)
		card.ability.in_build = true
	end,
	update = function(self, card, dt)
		if card.ability.in_build then
			iron_gold_crosstalk(true)
		end
	end,
	remove_from_deck = function(self, card, from_debuff)
		card.ability.in_build = false
		iron_gold_crosstalk(false)
	end
}

function iron_gold_crosstalk(on_off)
	if on_off then
		for i = 1, #G.playing_cards do
			if SMODS.has_enhancement(G.playing_cards[i], "m_steel") then
				G.playing_cards[i].ability.h_dollars = G.P_CENTERS.m_gold.config.h_dollars
			end
			if SMODS.has_enhancement(G.playing_cards[i], "m_gold") then
				G.playing_cards[i].ability.h_x_mult = G.P_CENTERS.m_steel.config.h_x_mult
			end
		end
	else
		for i = 1, #G.playing_cards do
			if SMODS.has_enhancement(G.playing_cards[i], "m_steel") then
				G.playing_cards[i].ability.h_dollars = nil
			end
			if SMODS.has_enhancement(G.playing_cards[i], "m_gold") then
				G.playing_cards[i].ability.h_x_mult = nil
			end
		end
	end
end

SMODS.Joker {
	key = "devilsknife",
	config = {
		xmult = 1.75
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_wild
		return { vars = { card.ability.xmult, localize({ type = 'name_text', set = "Enhanced", key = "m_wild" }) } }
	end,
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 0, y = 1 },
	cost = 8,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, "m_wild") then
			return {
				xmult = card.ability.xmult
			}
		end
	end
}
