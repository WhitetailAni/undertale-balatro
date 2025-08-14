--field
SMODS.Joker {
	key = "amber_card",
	loc_txt = {
		name = "Amber Card",
		text = {
			"{C:blue}+#1#{} hands per round",
			"{C:red}-#2#{} hand size"
		}
	},
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
	loc_txt = {
		name = "Lancer Cookie",
		text = {
			"{C:chips}+#1#{} Chips",
			"Destroyed when {C:attention}Boss",
			"{C:attention}Blind{} is defeated"
		}
	},
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
						card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Splat!", colour = G.C.BLUE })
						play_sound('tarot1')
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
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
	key = "castle_town",
	loc_txt = {
		name = "Castle Town",
		text = {
			"{C:mult}+#1#{} Mult for each",
			"card above {C:attention}#2#{}",
			"in your full deck",
			"{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult)"
		}
	},
	config = {
			mult_per = 5
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 1, y = 2 },
	cost = 6,
	loc_vars = function(self, info_queue, card)
		if G.playing_cards then
			if #G.playing_cards > G.GAME.starting_deck_size then
				return { vars = { card.ability.mult_per, G.GAME.starting_deck_size, (card.ability.mult_per * (#G.playing_cards - G.GAME.starting_deck_size)) } }
			else
				return { vars = { card.ability.mult_per, 52, 0 } }
			end
		else
			return { vars = { card.ability.mult_per, G.GAME.starting_deck_size, (card.ability.mult_per * (52 - G.GAME.starting_deck_size)) } }
		end
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult = (card.ability.mult_per * (G.playing_cards and (#G.playing_cards - G.GAME.starting_deck_size) or 0))
			}
		end
	end
}

SMODS.Joker {
	key = "thrash_machine",
	loc_txt = {
		name = "Thrash Machine",
		text = {
			"{C:chips}+#1#{} Chips when",
			"{C:red}#2#{} discards remaining"
		}
	},
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
	loc_txt = {
		name = "K. Round",
		text = {
			"{C:chips}+#1#{} Chips for each {C:attention}hand{} played",
			"{C:red}-#2#{} Chips for each {C:attention}discard{} used",
			"{C:inactive}(Currently {C:attention}+#3#{C:inactive} Chips)"
		}
	},
	config = {
			chip_gain = 5,
			chip_loss = 5,
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
			card.ability.chips = card.ability.chips - card.ability.chip_loss
			return {
				message = localize{ type = 'variable', key = 'a_chips_minus', vars = { card.ability.chip_loss } },
				colour = G.C.CHIPS
			}
		elseif context.before and context.cardarea == G.jokers and not context.blueprint then
			card.ability.chips = card.ability.chips + card.ability.chip_gain
			return {
				message = localize{ type = 'variable', key = 'a_chips', vars = { card.ability.chip_gain } },
				colour = G.C.CHIPS
			}
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
	loc_txt = {
		name = "Seam",
		text = {
			"Only {C:attention}Mega{} booster packs",
			"show up in shop"
		}
	},
	rarity = 1,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 7, y = 2 },
	cost = 6,
}

SMODS.Joker {
	key = "lancer",
	loc_txt = {
		name = "Lancer",
		text = {
			"Played cards with",
			"{C:spades}Spade{} suit give",
			"{C:chips}+#1#{} Chips when scored"
		}
	},
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
		return { vars = { card.ability.chips } }
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
	loc_txt = {
		name = "Chaos King",
		text = {
			"Gains {X:mult,C:white}X#1#{} Mult when a",
			"{C:attention}playing card{} not of",
			"{C:spades}Spade{} suit is destroyed",
			"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"
		}
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 1, y = 3 },
	cost = 5,
	config = {
		xmult_gain = 0.2,
		xmult = 1,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult_gain, card.ability.xmult } }
	end,
	calculate = function(self, card, context)
		if context.remove_playing_cards and not context.blueprint then
			local nonspades = 0
			for i = 1, #context.removed do
				if (not context.removed[i]:is_suit("Spades") or SMODS.has_any_suit(context.removed[i])) then
					nonspades = nonspades + 1
				end
			end
			if nonspades > 0 then
				G.E_MANAGER:add_event(Event({
					func = function()
						card.ability.xmult = card.ability.xmult + nonspades*card.ability.xmult_gain
						card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.xmult } }, colour = G.C.MULT })
						return true
					end
				}))
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
	loc_txt = {
		name = "Clover",
		text = {
			"Played cards with",
			 "{C:clubs}Club{} suit give",
			"{C:chips}+#1#{} Chips and",
			"{C:mult}+#2#{} Mult{} when scored"
		}
	},
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
		return { vars = { card.ability.chips, card.ability.mult } }
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
	loc_txt = {
		name = "Jevil",
		text = {
			"Retrigger all",
			"played {C:attention}Wild Cards{}"
		}
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 0, y = 3 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.m_wild 
	end,
	calculate = function(self, card, context)
		if context.repetition and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, "m_wild") then
			return {
				message = localize('k_again_ex'),
				repetitions = 1,
				card = context.blueprint_card or card
			}
		end
	end
}

--castle
SMODS.Joker {
	key = "scarlet_forest",
	loc_txt = {
		name = "Scarlet Forest",
		text = {
			"Gains {C:mult}+#1#{} Mult if played",
			"hand contains a {C:attention}#2#{}",
			"{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult)",
		}
	},
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
		return { vars = {
			card.ability.mult_gain,
			G.localization.misc.poker_hands['Straight'],
			card.ability.mult
		} }
	end,
	calculate = function(self, card, context)
		if context.before and context.cardarea == G.jokers and next(context.poker_hands['Straight']) and not context.blueprint then
			card.ability.mult = card.ability.mult + card.ability.mult_gain
			return {
				message = localize('k_upgrade_ex'),
				colour = G.C.MULT,
				card = card
			}
		elseif context.joker_main then
			return {
				mult = card.ability.mult
			}
		end
	end
}

SMODS.Joker {
	key = "top_cake",
	loc_txt = {
		name = "Top Cake",
		text = {
			"Gains {X:mult,C:white}X#1#{} Mult per",
			"hand played, destroys",
			"itself after {C:attention}#2#{} {C:inactive}[#3#]{} hands",
			"{C:inactive}(Currently {X:mult,C:white}X#4#{C:inactive} Mult)",
		}
	},
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
		return { vars = {
			card.ability.xmult_gain,
			card.ability.hand_limit,
			card.ability.hands,
			card.ability.xmult
		} }
	end,
	calculate = function(self, card, context)
		if context.before and context.cardarea == G.jokers then
			card.ability.xmult = card.ability.xmult + card.ability.xmult_gain
			card.ability.hands = card.ability.hands + 1
			return {
				message = localize('k_upgrade_ex'),
				colour = G.C.MULT,
				card = card
			}
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
						G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
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
				local susie = SMODS.find_card("j_UTDR_susie", true)
				if #susie > 0 and pseudorandom('susie_ate_the_cake') > 0.7 then
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
	key = "rouxls",
	loc_txt = {
		name = "Rouxls Kaard",
		text = {
			"Gains {C:chips}+#1#{} Chips",
			"when played hand",
			"is a {C:attention}#2#{}",
			"{s:0.8}hand changes at end of round",
			"{C:inactive}(Currently {C:chips}+#3#{C:inactive} Chips)"
		}
	},
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
			card.ability.chips = card.ability.chips + card.ability.chip_gain
			return {
				message = localize('k_upgrade_ex'),
				colour = G.C.CHIPS,
				card = card
			}
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
	key = "shackle",
	loc_txt = {
		name = "Iron Shackle",
		text = {
			"{C:attention}Gold Cards{} and {C:attention}Steel Cards",
			"are considered the",
			"{C:attention}same enhancement"
		}
	},
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
		info_queue[#info_queue+1] = G.P_CENTERS.m_steel 
        info_queue[#info_queue+1] = G.P_CENTERS.m_gold 
		return { vars = { card.ability.mult } }
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
	loc_txt = {
		name = "Devilsknife",
		text = {
			"Played {C:attention}Wild Cards{} give",
			"{X:mult,C:white}X#1#{} Mult when scored"
		}
	},
	config = {
		xmult = 1.75
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.m_wild 
		return { vars = { card.ability.xmult } }
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