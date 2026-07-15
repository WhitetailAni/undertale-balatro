-- field
SMODS.Joker {
	key = "sweet_capn_cakes",
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
		return { vars = { card.ability.chips, card.ability.mult, localize("k_common") } }
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
		return {
			vars = {
				card.ability.chips,
				card.ability.xmult,
				card.ability.mult,
				card.ability.bigbucks,
				card.ability.steep_time,
				card.ability.tea_timer,
				localize("Spades", 'suits_singular'),
				localize("Hearts", 'suits_singular'),
				localize("Clubs", 'suits_singular'),
				localize("Diamonds", 'suits_singular'),
			}
		}
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
				return {
					message = "Rotten!",
					colour = G.C.RED
				}
			else
				card.ability.tea_timer = card.ability.tea_timer + 1
				card:juice_up(0.3, 0.4)
			end
		end
	end
}

SMODS.Joker {
	key = "cyber_world",
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
		return { vars = { probabilities_normal, odds, localize("k_planet"), localize("k_tarot") } }
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
	key = "starwalker",
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
		return { vars = { card.ability.chips, localize("Diamonds", 'suits_singular') or "Diamond" } }
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
		elseif context.setting_blind and context.cardarea == G.jokers and G.GAME.blind.name ~= "The Needle" and not context.blueprint then
			ease_hands_played(-G.GAME.current_round.hands_left + 1)
		end
	end
}

SMODS.Joker {
	key = "swatch",
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
			SMODS.scale_card(card, {
				ref_table = card.ability,
				ref_value = "mult",
				scalar_value = "mult_gain",
				message_colour = G.C.MULT
			})
		end
	end
}

SMODS.Joker {
	key = "queen",
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 3, y = 3 },
	cost = 6,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_steel
	end,
	calculate = function(self, card, context)
		if context.before and not context.blueprint then
			local faces = {}
			for k, v in ipairs(context.scoring_hand) do
				if v:is_face() then 
					faces[#faces+1] = v
					v:set_ability("m_steel", nil, true)
					G.E_MANAGER:add_event(Event({
						func = function()
							v:juice_up()
							return true
						end
					})) 
				end
			end
			if #faces > 0 then 
				return {
					message = localize('k_UTDR_robot'),
					colour = G.C.STEEL,
				}
			end
		end
	end
}

SMODS.Joker {
	key = "tasque_manager",
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
		return { vars = { probabilities_normal, odds, card.ability.bigbucks, localize("Ace", "ranks"), localize("9", "ranks"), localize("7", "ranks") } }
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
			return {
				message = "["..pseudorandom('pipis_liked_that', 1173, 8824).." liked that]",
				colour = G.C.BLUE
			}
		end
	end
}

SMODS.Joker {
	key = "spamton_neo",
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
			SMODS.add_card({
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
					return {
						message = "DOWN"
					}
				end
			end
		end
	end
}
