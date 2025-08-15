-- field
SMODS.Joker {
	key = "sweet_capn_cakes",
	loc_txt = {
		name = "Sweet Cap'n Cakes",
		text = {
			"{C:blue}Common{} jokers each",
			"give {C:chips}+#1#{} Chips and",
			"{C:mult}+#2#{} Mult when sccored"
		}
	},
	config = {
			chips = 10,
			mult = 5,
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 5, y = 3 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.chips, card.ability.mult } }
	end,
	calculate = function(self, card, context)
		if context.other_joker and (context.other_joker.config.center.rarity == 1 or context.other_joker.config.center.rarity == "Common") and context.other_joker ~= card then
			return {
				chips = card.ability.chips,
				mult = card.ability.mult
			}
		end
	end
}

SMODS.Joker {
	key = "kris_tea",
	loc_txt = {
		name = "Kris Tea",
		text = {
			"{C:chips}+#1#{} Chips for each played {C:spades}Spade{} card",
			"{X:mult,C:white}X#2#{} Mult for each played {C:hearts}Heart{} card",
			"{C:mult}+#3#{} Mult for each played {C:clubs}Club{} card",
			"{C:money}$#4#{} for each played {C:diamonds}Diamond{} card",
			"Destroyed after {C:attention}#5# {C:inactive}[#6#]{} rounds"
		}
	},
	config = {
			chips = 40,
			xmult = 1.25,
			mult = 5,
			bigbucks = 1,
			steep_time = 4,
			tea_timer = 0,
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = false,
	atlas = "DR_jokers",
	pos = { x = 3, y = 0 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = {
			card.ability.chips,
			card.ability.xmult,
			card.ability.mult,
			card.ability.bigbucks,
			card.ability.steep_time,
			card.ability.tea_timer
		} }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			local result = {}
			if context.other_card:is_suit("Spades") or SMODS.has_any_suit(context.other_card) then
				result["chips"] = card.ability.chips
			end
			if context.other_card:is_suit("Hearts") or SMODS.has_any_suit(context.other_card) then
				result["xmult"] = card.ability.xmult
			end
			if context.other_card.base.suit == "Clubs" or SMODS.has_any_suit(context.other_card) then
				result["mult"] = card.ability.mult
			end
			if context.other_card.base.suit == "Diamonds" or SMODS.has_any_suit(context.other_card) then
				result["dollars"] = card.ability.bigbucks
			end
			return result
		elseif context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
			if card.ability.tea_timer == card.ability.steep_time then
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
					message = "Rotten!",
					colour = G.C.RED
				}
			else
				card.ability.tea_timer = card.ability.tea_timer + 1
				card:juice_up(0.3,0.4)
			end
		end
	end
}

SMODS.Joker {
	key = "cyber_world",
	loc_txt = {
		name = "Cyber World",
		text = {
			"{C:green}#1# in #2#{} chance to create",
			"a {C:planet}Planet{} card when a",
			"{C:tarot}Tarot{} card is used"
		}
	},
	config = {
			odds = 2
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 2, y = 3 },
	cost = 4,
	loc_vars = function(self, info_queue, card)
		local probabilities_normal, odds = SMODS.get_probability_vars(card, 1, card.ability.odds, "DR_cyber_world")
		return { vars = { probabilities_normal, odds } }
	end,
	calculate = function(self, card, context)
		if context.using_consumeable and context.consumeable.ability.set == 'Tarot' then
			if SMODS.pseudorandom_probability(card, "cyber_world", 1, card.ability.odds, "DR_cyber_world") then
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.4,
					func = function()
						if G.consumeables.config.card_limit > #G.consumeables.cards then
							play_sound('timpani')
							local new_card = create_card('Planet', G.consumeables, nil, nil, nil, nil, nil, 'cyber_world')
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
	end
}

SMODS.Joker {
	key = "pin",
	loc_txt = {
		name = "Royal Pin",
		text = {
			"Gains {C:chips}+#1#{} Chips when a",
			"{C:attention}face{} card is scored",
			"{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)"
		}
	},
	config = {
		chip_gain = 3,
		chips = 0
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 9, y = 0 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.chip_gain, card.ability.chips } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and context.other_card:is_face() and not context.blueprint then
			card.ability.chips = card.ability.chips + card.ability.chip_gain
			card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize('k_upgrade_ex'), colour = G.C.CHIPS })
		elseif context.joker_main then
			return {
				chips = card.ability.chips
			}
		end
	end
}

SMODS.Joker {
	key = "starwalker",
	loc_txt = {
		name = "Starwalker",
		text = {
			"These cards are {C:red}Pissing me off.",
			"{C:chips}+#1#{} Chips if all played cards are       {C:diamonds}Diamond suit{}"
		}
	},
	config = {
			chips = 90
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 1, y = 4 },
	soul_pos = { x = 7, y = 7 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.chips } }
	end,
	calculate = function(self, card, context)
		if context.joker_main and G.GAME.starting_deck_size == #G.playing_cards then
			for i = 1, #context.scoring_hand do
				if context.scoring_hand[i].base.suit ~= "Diamonds" and not SMODS.has_any_suit(context.scoring_hand[i]) then
					return
				end
			end
			return {
				chips = card.ability.chips
			}
		end
	end
}

--city
SMODS.Joker {
	key = "watch",
	loc_txt = {
		name = "Silver Watch",
		text = {
			"Played cards give {C:mult}+#1#{}",
			"Mult when scored",
			"{C:red}only one hand per round"
		}
	},
	config = {
			mult = 15
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 7, y = 0 },
	cost = 6,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.mult } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			return {
				mult = card.ability.mult
			}
		elseif context.setting_blind and context.cardarea == G.jokers and G.GAME.blind.name ~= "The Needle" and not context.blueprint  then
			ease_hands_played(-G.GAME.current_round.hands_left + 1)
		end
	end
}

SMODS.Joker {
	key = "swatch",
	loc_txt = {
		name = "Swatch",
		text = {
			"This Joker gains {C:mult}+#1#{} Mult when",
			"{C:attention}anything{} is bought in the shop",
			"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)"
		},
	},
	config = {
		mult_gain = 1,
		mult = 0
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.mult_gain, card.ability.mult } }
	end,
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 7, y = 3 },
	cost = 5,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult = card.ability.mult
			}
		elseif context.open_booster or context.buying_card and not context.blueprint then
			card.ability.mult = card.ability.mult + card.ability.mult_gain
			card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize{ type = 'variable', key = 'a_mult', vars = { card.ability.mult } }, colour = G.C.MULT })
        end
	end
}

SMODS.Joker {
	key = "queen",
	loc_txt = {
		name = "Q5U4EX7YY2E9N",
		text = {
			"This Joker gains {C:mult}+#1#{} Mult",
			"per {C:attention}consecutive hand played",
			"without a scoring {C:attention}numerical{} card",
			"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)"
		},
	},
	config = {
		mult_gain = 3,
		mult = 0
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.mult_gain, card.ability.mult } }
	end,
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 3, y = 3 },
	cost = 6,
	calculate = function(self, card, context)
		if context.before and context.cardarea == G.jokers and not context.blueprint then
			for i = 1, #context.scoring_hand do
				if tonumber(context.scoring_hand[i].base.value) then
					card.ability.mult = 0
					return {
						card = card,
						message = localize('k_reset'),
						colour = G.C.MULT
					}
				end
			end
			card.ability.mult = card.ability.mult + card.ability.mult_gain
			return {
				card = card,
				message = localize('k_upgrade_ex'),
				colour = G.C.MULT
			}
		elseif context.joker_main then
			return {
				mult = card.ability.mult
			}
		end
	end
}

SMODS.Joker {
	key = "tasque_manager",
	loc_txt = {
		name = "Tasque Manager",
		text = {
			"{X:mult,C:white}X#1#{} Mult if your {C:attention{full",
			"{C:attention}deck{} is exactly {C:attention}#2#{} cards"
		}
	},
	config = {
			xmult = 3
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 8, y = 3 },
	cost = 6,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult, G.GAME.starting_deck_size } }
	end,
	calculate = function(self, card, context)
		if context.joker_main and G.GAME.starting_deck_size == #G.playing_cards then
			return {
				xmult = card.ability.xmult
			}
		end
	end
}

SMODS.Joker {
	key = "twin_ribbon",
	loc_txt = {
		name = "Twin Ribbon",
		text = {
			"{C:mult}+#1#{} Mult for each",
			"{C:attention}change{} in hand",
			"size from {C:attention}#2#",
			"{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult)"
		}
	},
	config = {
		mult = 25
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 8, y = 0 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		if G.hand and G.hand.config then
			return { vars = { card.ability.mult, G.GAME.starting_params.hand_size, card.ability.mult * math.abs(G.hand.config.card_limit - G.GAME.starting_params.hand_size) } }
		else
			return { vars = { card.ability.mult, G.GAME.starting_params.hand_size, card.ability.mult * math.abs(8 - G.GAME.starting_params.hand_size) } }
		end
	end,
	calculate = function(self, card, context)
		if context.joker_main and G.hand.config.card_limit ~= G.GAME.starting_params.hand_size then
			return {
				mult = card.ability.mult * math.abs(G.hand.config.card_limit - G.GAME.starting_params.hand_size)
			}
		end
	end
}

--mansion
SMODS.Joker {
	key = "spamton",
	loc_txt = {
		name = "Spamton G. Spamton",
		text = {
			"Each played {C:attention}Ace{}, {C:attention}9{}, or {C:attention}7",
			"has a {C:green}#1# in #2#{} chance",
			"to give {C:money}$#3#{} when scored"
		}
	},
	config = {
		odds = 2,
		bigbucks = 2
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 6, y = 3 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		local probabilities_normal, odds = SMODS.get_probability_vars(card, 1, card.ability.odds, 'DR_spamton')
		return { vars = { probabilities_normal, odds, card.ability.bigbucks } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			local rank = context.other_card.base.value
			if rank == "Ace" or rank == "9" or rank == "7" and SMODS.pseudorandom_probability(card, "spamton", 1, card.ability.odds, "DR_spamton") then
				return {
					dollars = card.ability.bigbucks
				}
			end
		end
	end
}

SMODS.Joker {
	key = "pipis",
	loc_txt = {
		name = "Pipis",
		text = {
			"{C:mult}-#1#{} Mult",
			"{X:mult,C:white}X#2#{} Mult during {C:attention}Boss Blind{}" ,
			"Destroyed when {C:attention}Boss",
			"{C:attention}Blind{} is defeated"
		}
	},
	config = {
		mult = 5,
		xmult = 1.25
	},
	pixel_size = { w = 69, h = 69 },
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = false,
	atlas = "DR_jokers",
	pos = { x = 0, y = 4 },
	cost = 3,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.mult, card.ability.xmult } }
	end,
	add_to_deck = function(self, card, from_debuff)
		if not from_debuff then
			play_sound('UTDR_pipis_laugh', 1.4, 0.9)
		end
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			if G.GAME.blind.boss then
				return {
					mult = -card.ability.mult,
					xmult = card.ability.xmult
				}
			else
				return {
					mult = -card.ability.mult
				}
			end
		elseif context.end_of_round and context.cardarea == G.jokers and G.GAME.blind.boss and not context.blueprint then
            G.E_MANAGER:add_event(Event({
				func = function()
					play_sound('tarot1')
					play_sound('UTDR_pipis_boom', 1.0, 0.7)
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
				message = "[7470 liked that]",
				colour = G.C.BLUE
			}
        end
	end
}

SMODS.Joker {
	key = "spamton_neo",
	loc_txt = {
		name = "SPAMTON NEO",
		text = {
			"RETRIGGER [EveryHotSingle]",
			"{C:attention}1{}, {C:attention}9{}, OR {C:attention}7!!"
		}
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 9, y = 3 },
	cost = 7,
	calculate = function(self, card, context)
		if context.repetition and context.cardarea == G.play then
			local rank = context.other_card.base.value
			if rank == "Ace" or rank == "9" or rank == "7" then
				return {
					message = localize('k_again_ex'),
					repetitions = 1,
					card = context.blueprint_card or card
				}
			end
		end
	end
}

SMODS.Joker {
	key = "dealmaker",
	loc_txt = {
		name = "Dealmaker",
		text = {
			"Each scored card",
			"gives {C:money}$#1#{} when",
			"{C:red}#2#{} discards remaining"
		}
	},
	config = {
		bigbucks = 1,
		discards_remaining = 0
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 2, y = 1 },
	cost = 6,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.bigbucks, card.ability.discards_remaining } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and G.GAME.current_round.discards_left == card.ability.discards_remaining then
			return {
				dollars = card.ability.bigbucks
			}
		end
	end
}

SMODS.Joker {
	key = "revivemint",
	loc_txt = {
		name = "Revivemint",
		text = {
			"Creates a {C:tarot}#1#{} card",
			"when {C:attention}Blind{} is selected",
			"{C:green}#2# in #3#{} chance for this",
			"card to destroy itself",
			"when {C:attention}Blind{} is selected",
		}
	},
	config = {
		odds = 6
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 2, y = 0 },
	cost = 6,
	loc_vars = function(self, info_queue, card)
		local probabilities_normal, odds = SMODS.get_probability_vars(card, 1, card.ability.odds, "DR_revivemint")
		return { vars = { G.localization.descriptions.Tarot.c_judgement.name, probabilities_normal, odds } }
	end,
	calculate = function(self, card, context)
		if context.setting_blind and context.cardarea == G.jokers then
			SMODS.add_card( {
				set = "Tarot",
				area = G.consumeables,
				key = "c_judgement"
			})
			card:juice_up(0.3, 0.4)
			play_sound("UTDR_revivemint", 1.0, 0.7)
			if not context.blueprint then
				if SMODS.pseudorandom_probability(card, "revivemint", 1, card.ability.odds, "DR_revivemint") then
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
						message = "DOWN"
					}
				end
			end
		end
	end
}