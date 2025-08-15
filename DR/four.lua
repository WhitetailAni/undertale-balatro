--first sanctuary
SMODS.Joker {
	key = "sanctuary",
	loc_txt = {
		name = "Dark Sanctuary",
		text = {
			"Gives {C:mult}+#1#{} Mult for each",
			"card in your full deck",
			"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)"
		}
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 7, y = 4 },
	soul_pos = { x = 9, y = 7 },
	cost = 5,
	config = {
		mult_per = 0.5
	},
	loc_vars = function(self, info_queue, card)
		if G.playing_cards then
			return { vars = { card.ability.mult_per, card.ability.mult_per * #G.playing_cards } }
		else
			return { vars = { card.ability.mult_per, card.ability.mult_per * 52 } }
		end
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult = card.ability.mult_per * #G.playing_cards
			}
		end
	end
}

SMODS.Joker {
	key = "cupwalker",
	loc_txt = {
		name = "Cuptains",
		text = {
			"Gains {C:chips}+#1#{} Chips",
			"if played hand is",
			"a {C:attention}#2#",
			"{C:inactive}(Currently {C:chips}+#3#{C:inactive} Chips)",
		}
	},
	config = {
		chip_gain = 4,
		chips = 0
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 0, y = 6 },
	cost = 4,
	loc_vars = function(self, info_queue, card)
		return { vars = {
			card.ability.chip_gain,
			G.localization.misc.poker_hands['High Card'],
			card.ability.chips
		} }
	end,
	calculate = function(self, card, context)
		if context.before and context.cardarea == G.jokers and context.scoring_name == "High Card" and not context.blueprint then
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
		end
	end
}

SMODS.Joker {
	key = "oldman",
	loc_txt = {
		name = "Old Man",
		text = {
			"This Joker gains {C:mult}+#1#{} Mult",
			"per {C:attention}consecutive{} hand",
			"without playing any hand",
			"type {C:attention}twice in a row",
			"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
			"{s:0.8,C:joker_grey}I'm old!"
		}
	},
	config = {
		mult_gain = 1,
		mult = 0,
		last_played_hand = nil
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 2, y = 6 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.mult_gain, card.ability.mult } }
	end,
	calculate = function(self, card, context)
		if context.before and context.cardarea == G.jokers and not context.blueprint then
			if card.ability.last_played_hand == context.scoring_name then
				card.ability.mult = 0
				return {
					card = card,
					message = localize('k_reset'),
					colour = G.C.MULT
				}
			else
				card.ability.last_played_hand = context.scoring_name
				card.ability.mult = card.ability.mult + card.ability.mult_gain
				return {
					message = localize('k_upgrade_ex'),
					colour = G.C.MULT,
					card = card
				}
			end
		elseif context.joker_main then
			return {
				mult = card.ability.mult
			}
		end
	end
}

SMODS.Joker {
	key = "missmizzle",
	loc_txt = {
		name = "Miss Mizzle",
		text = {
			"All Seals are",
			"considered",
			"{C:attention}Gold Seals{} "
		}
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_SEALS['gold_seal'] or G.P_SEALS[SMODS.Seal.badge_to_key['gold_seal'] or '']
	end,
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 1, y = 6 },
	cost = 6,
}

SMODS.Joker {
	key = "philosopher",
	loc_txt = {
		name = "Philosopher",
		text = {
			"{C:planet}Planet{} cards may",
			"appear in any of",
			"the {C:attention}Arcana Packs"
		}
	},
	rarity = 1,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 6, y = 6 },
	cost = 5,
}

--second sanctuary
SMODS.Joker {
	key = "jackenstein",
	loc_txt = {
		name = "Jackenstein",
		text = {
			"{X:mult,C:white}X#1#{} Mult on {C:attention}first",
			"{C:attention}hand of round",
			"{X:mult,C:white}X#2#{} Mult on all",
			"subsequent hands"
		}
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 9, y = 5 },
	cost = 6,
	config = {
		xmult_first = 2,
		xmult_too_long = 0.5
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult_first, card.ability.xmult_too_long } }
	end,
	calculate = function(self, card, context)
		if context.before and context.cardarea == G.jokers  then
			if G.GAME.current_round.hands_played == 1 then
				return {
					sound = "UTDR_your_taking_too_long",
					message = "YOUR TAKING TOO LONG"
				}
			elseif context.scoring_name == "Pair" and context.scoring_hand[1].base.value == "2" and context.scoring_hand[2].base.value == "2" then
				return {
					sound = "UTDR_your_too_too",
					message = "YOUR     TOO TOO"
				}
			end
		elseif context.joker_main then
			if G.GAME.current_round.hands_played == 0 then
				return {
					xmult = card.ability.xmult_first
				}
			else
				return {
					xmult = card.ability.xmult_too_long
				}
			end
		end
	end
}

SMODS.Joker {
	key = "scarlixir",
	loc_txt = {
		name = "Scarlixir",
		text = {
			"Earn {C:money}$#1#{} at end of",
			"round, decreases",
			"by {C:red}-$#2#{} every round"
		}
	},
	config = {
		extra = 8,
		hole_in_my_pocket = 2,
		first_round = true
	},
	rarity = 1,
	blueprint_compat = false,
	eternal_compat = false,
	atlas = "DR_jokers",
	pos = { x = 9, y = 6 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra, card.ability.hole_in_my_pocket } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
			if card.ability.first_round then
				card.ability.first_round = false
			elseif not ((card.ability.extra - card.ability.hole_in_my_pocket) > 0) then
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
				return {
					message = "Drank!"
				}
			else
				card.ability.extra = card.ability.extra - card.ability.hole_in_my_pocket
				return {
					message = "-$"..card.ability.hole_in_my_pocket,
					colour = G.C.RED,
					sound = "coin6",
					card = card
				}
			end
		end
	end
}

SMODS.Joker {
	key = "motherfucking_gerson_boom",
	loc_txt = {
		name = "Hammer of Justice",
		text = {
			"This Joker gains {X:mult,C:white}X#1#{} Mult per",
			"{C:attention}Voucher{} redeemed this run",
			"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"
		}
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 9, y = 4 },
	cost = 6,
	config = {
		xmult_gain = 0.25,
		xmult = 1
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult_gain, card.ability.xmult } }
	end,
	set_ability = function(self, card, initial, delay_sprites)
		card.ability.xmult = card.ability.xmult + card.ability.xmult_gain * #get_keys(G.GAME.used_vouchers)
	end,
	calculate = function(self, card, context)
		if context.voucher_redeem and not context.blueprint then
			card.ability.xmult = card.ability.xmult + card.ability.xmult_gain
			return {
				card = card,
				message = localize('k_upgrade_ex'),
				colour = G.C.MULT
			}
		elseif context.joker_main then
			return {
				xmult = card.ability.xmult
			}
		end
	end
}

SMODS.Joker {
	key = "axe_of_justice",
	loc_txt = {
		name = "Justice Axe",
		text = {
			"Played cards give",
			"{X:mult,C:white}X#1#{} Mult when scored"
		}
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 8, y = 5 },
	cost = 6,
	config = {
		xmult = 1.25,
		money_spent = 0
	},
	in_pool = function(self, args)
		local money_spent = G.GAME.money_spent or 0
		return money_spent >= 150
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			return {
				xmult = card.ability.xmult
			}
		end
	end
}

SMODS.Joker {
	key = "second_sanctuary",
	loc_txt = {
		name = "Second Sanctuary",
		text = {
			"{X:mult,C:white}X#1#{} Mult for each card",
			"{C:attention}removed{} from your deck",
			"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"
		}
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 8, y = 4 },
	soul_pos = { x = 0, y = 8 },
	cost = 6,
	config = {
		xmult_per = 0.05,
		xmult = 1,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult_per, card.ability.xmult} }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				xmult = card.ability.xmult
			}
		elseif context.remove_playing_cards and not context.blueprint then
			local xmult_gain = #context.removed * card.ability.xmult_per
			G.E_MANAGER:add_event(Event({
				func = function()
					G.E_MANAGER:add_event(Event({
						func = function()
							card.ability.xmult = card.ability.xmult + xmult_gain
							return true
						end
					}))
					card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.xmult + xmult_gain } }, colour = G.C.MULT })
					return true
				end
			}))
			return
		end
	end
}

--third sanctuary
SMODS.Joker {
	key = "princess_ribbon",
	loc_txt = {
		name = "Princess Ribbon",
		text = {
			"Played {C:attention}Glass Cards{} give",
			"{C:chips}+#1#{} Chips when scored"
		}
	},
	config = {
		chips = 50
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.m_glass 
		return { vars = { card.ability.chips } }
	end,
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 4, y = 6 },
	cost = 5,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, "m_glass") then
			return {
				chips = card.ability.chips
			}
		end
	end
}

SMODS.Joker {
	key = "spawn",
	loc_txt = {
		name = "Titan Spawn",
		text = {
			"Gains {C:mult}+#1#{} Mult when a",
			"{C:attention}Stone Card{} is scored",
			"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)"
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
	pos = { x = 3, y = 6 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.m_stone 
		return { vars = { card.ability.mult_gain, card.ability.mult } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, "m_stone") and not context.blueprint then
			card.ability.mult = card.ability.mult + card.ability.mult_gain
			card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize('k_upgrade_ex'), colour = G.C.MULT })
		elseif context.joker_main then
			return {
				mult = card.ability.mult
			}
		end
	end
}

SMODS.Joker {
	key = "dark_fountain",
	loc_txt = {
		name = "Dark Fountain",
		text = {
			"After {C:attention}#1#{C:inactive} [#2#]{} rounds,",
			"sell this card to",
			"apply {C:dark_edition}#3#{} to the",
			"Joker to the {C:attention}right"
		}
	},
	config = {
		turn_cap = 3,
		turns = 0
	},
	rarity = 3,
	blueprint_compat = false,
	eternal_compat = false,
	atlas = "DR_jokers",
	pos = { x = 2, y = 2 },
	soul_pos = { x = 6, y = 7 },
	cost = 8,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.e_negative
		return { vars = { card.ability.turn_cap, card.ability.turns, G.localization.descriptions.Edition.e_negative.name } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
			card.ability.turns = card.ability.turns + 1
			card:juice_up(0.3,0.4)
			if card.ability.turns >= card.ability.turn_cap then
				local eval = function(card)
					return card.ability.turns >= card.ability.turn_cap
				end
				juice_card_until(card, eval, true)
			end
		elseif context.selling_self and #G.jokers.cards > 1 and card.ability.turns >= card.ability.turn_cap and not context.blueprint then
			local joker = nil
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] == card then
					joker = G.jokers.cards[i + 1]
				end
			end
			if joker then
				G.E_MANAGER:add_event(Event({
						trigger = 'after',
						delay = 0.4,
						func = function()
							joker:set_edition("e_negative", true)
							return true
						end
					}))
				end
		end
	end
}

SMODS.Joker {
	key = "titan",
	loc_txt = {
		name = "Titan",
		text = {
			"Retrigger each played",
			"{C:attention}Stone Card #1#{} times"
		}
	},
	config = {
		repetitions = 4
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.m_stone 
		return { vars = { card.ability.repetitions } }
	end,
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 7, y = 5 },
	soul_pos = { x = 2, y = 8 },
	cost = 9,
	calculate = function(self, card, context)
		if context.repetition and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, "m_stone") then
			return {
				message = localize('k_again_ex'),
				repetitions = card.ability.repetitions,
				card = context.blueprint_card or card
			}
		end
	end
}

SMODS.Joker {
	key = "bittertear",
	loc_txt = {
		name = "BitterTear",
		text = {
			"The next {C:attention}#1#{} played",
			"cards give {C:money}$#2#{}",
			"when scored"
		}
	},
	config = {
		bigbucks = 1,
		card_count = 30
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 6, y = 5 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.card_count, card.ability.bigbucks }
		}
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			card.ability.card_count = card.ability.card_count - 1
			SMODS.calculate_effect( {dollars = card.ability.bigbucks}, context.other_card)
			if card.ability.card_count == 0 then
				card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Drank!" })
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.4,
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
			end
		end
	end
}