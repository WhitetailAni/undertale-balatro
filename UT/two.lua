--row one
SMODS.Joker {
	key = "monster_kid",
	config = {
		odds = 2,
		mult = 20,
		chips = 10,
	},
	attributes = {
		"chips",
		"mult",
		"chance"
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 4, y = 5 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		local probabilities_normal, odds = SMODS.get_probability_vars(card, 1, card.ability.odds, "UT_monster_kid")
		return { vars = { probabilities_normal, odds, card.ability.mult, card.ability.chips } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			if SMODS.pseudorandom_probability(card, "monster_kid_mult", 1, card.ability.odds, "UT_monster_kid_mult") then
				SMODS.calculate_effect({ mult = card.ability.mult }, card)
			end

			if SMODS.pseudorandom_probability(card, "monster_kid_chips", 1, card.ability.odds, "UT_monster_kid_chips") then
				SMODS.calculate_effect({ chips = -card.ability.chips }, card)
			end
		end
	end
}

SMODS.Joker {
	key = "manly_bandana",
	config = {
		mult = 5
	},
	attributes = {
		"mult",
		"hands",
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 0, y = 1 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.mult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult = card.ability.mult * G.GAME.current_round.hands_left
			}
		end
	end
}

SMODS.Joker {
	key = "snowman_piece",
	config = {
		chip_gain = 20,
		chips = 0,
		rounds = 0,
		round_limit = 6,
	},
	attributes = {
		"food",
		"chips",
		"scaling"
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = false,
	atlas = "UT_jokers",
	pos = { x = 1, y = 1 },
	cost = 4,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.chip_gain,
				card.ability.round_limit,
				card.ability.rounds,
				card.ability.chips
			}
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chips = card.ability.chips
			}
		elseif context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
			if card.ability.rounds >= card.ability.round_limit then
				card:start_dissolve()
				return {
					message = "Melted!"
				}
			elseif context.end_of_round and context.cardarea == G.jokers then
				SMODS.scale_card(card, {
					ref_table = card.ability,
					ref_value = "chips",
					scalar_value = "chip_gain",
					message_colour = G.C.CHIPS
				})
				card.ability.rounds = card.ability.rounds + 1
			end
		end
	end
}

SMODS.Joker {
	key = "tough_glove",
	config = {
		mult_gain = 2,
		mult = 0
	},
	attributes = {
		"mult",
		"scaling",
		"hand_type"
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "UT_jokers",
	pos = { x = 2, y = 1 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.mult_gain,
				G.localization.misc.poker_hands['Flush'],
				card.ability.mult
			}
		}
	end,
	calculate = function(self, card, context)
		if context.before and context.cardarea == G.jokers and next(context.poker_hands['Flush']) and not context.blueprint then
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
	key = "nice_cream",
	config = {
		tarot_odds = 2,
		destroy_odds = 8
	},
	attributes = {
		"food",
		"generation",
		"tarot",
		"planet",
		"chance"
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = false,
	atlas = "UT_jokers",
	pos = { x = 3, y = 1 },
	cost = 4,
	loc_vars = function(self, info_queue, card)
		local probabilities_normal, tarot_odds = SMODS.get_probability_vars(card, 1, card.ability.tarot_odds,
			"UT_nice_cream_tarot")
		local _, destroy_odds = SMODS.get_probability_vars(card, 1, card.ability.destroy_odds, "UT_nice_cream_destroy")
		return { vars = { probabilities_normal, tarot_odds, destroy_odds, localize("k_tarot"), localize("k_planet") } }
	end,
	calculate = function(self, card, context)
		if context.using_consumeable and context.consumeable.ability.set == 'Planet' then
			if SMODS.pseudorandom_probability(card, "nice_cream_tarot", 1, card.ability.tarot_odds, "UT_nice_cream_tarot") then
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.4,
					func = function()
						if G.consumeables.config.card_limit > #G.consumeables.cards then
							play_sound('timpani')
							local new_card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'nice_cream')
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
			if not context.blueprint then
				if SMODS.pseudorandom_probability(card, "nice_cream_destroy", 1, card.ability.destroy_odds, "UT_nice_cream_destroy") then
					card:start_dissolve()
					return {
						message = "Melted!"
					}
				end
			end
		end
	end
}

SMODS.Joker {
	key = "silver_key",
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 7, y = 3 },
	cost = 7,
	attributes = {
		"boss_blind",
		"generation",
		"spectral"
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { localize("k_spectral") } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.cardarea == G.jokers and G.GAME.blind.boss then
			if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				G.E_MANAGER:add_event(Event({
					trigger = 'before',
					delay = 0.0,
					func = (function()
						local card = create_card('Spectral', G.consumeables, nil, nil, nil, nil, nil, 'silver_key')
						card:add_to_deck()
						G.consumeables:emplace(card)
						G.GAME.consumeable_buffer = 0
						return true
					end)
				}))
				card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
					{ message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral })
			end
		end
	end
}

--row two
SMODS.Joker {
	key = "sans",
	config = {
		xmult = 3
	},
	attributes = {
		"xmult",
		"hand_type",
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 1, y = 5 },
	cost = 6,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult, G.localization.misc.poker_hands['High Card'].lower(G.localization.misc.poker_hands['High Card']) } }
	end,
	calculate = function(self, card, context)
		if context.joker_main and context.scoring_name == "High Card" then
			play_sound("UTDR_sans", 1.0, 0.7)
			return {
				xmult = card.ability.xmult
			}
		end
	end
}

SMODS.Joker {
	key = "snowdin",
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 2, y = 5 },
	cost = 4,
	attributes = {
		"planet",
		"generation",
		"hand_type",
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { G.localization.misc.poker_hands['Straight'], localize("k_planet") } }
	end,
	calculate = function(self, card, context)
		if context.before and context.cardarea == G.jokers and next(context.poker_hands['Straight']) then
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.4,
				func = function()
					if G.consumeables.config.card_limit > #G.consumeables.cards then
						play_sound('timpani')
						local new_card = create_card('Planet', G.consumeables, nil, nil, nil, nil, nil, 'snowdin')
						new_card:add_to_deck()
						G.consumeables:emplace(new_card)
						card:juice_up(0.3, 0.5)
						card_eval_status_text(self, 'extra', nil, nil, nil,
							{ message = localize('k_plus_planet'), colour = G.C.SECONDARY_SET.Planet })
					end
					return true
				end
			}))
		end
	end
}

SMODS.Joker {
	key = "papyrus",
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 3, y = 5 },
	cost = 6,
	attributes = {
		"hand_type",
		"retrigger"
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { G.localization.misc.poker_hands['Straight'].upper(G.localization.misc.poker_hands['Straight']) } }
	end,
	calculate = function(self, card, context)
		if context.repetition and context.cardarea == G.play and next(context.poker_hands['Straight']) then
			G.E_MANAGER:add_event(Event({
				func = function()
					play_sound("UTDR_papyrus", 1.0, 0.7)
					return true
				end
			}))
			return {
				repetitions = 1,
			}
		end
	end
}

SMODS.Joker {
	key = "mad_mew_mew",
	config = {
		money = 10,
	},
	attributes = {
		"economy",
		"destroy_card",
		"rank",
		"king",
		"jack"
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.money, localize("King", 'ranks') or "King", localize("Jack", 'ranks') or "Jack" } }
	end,
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 7, y = 8 },
	cost = 6,
	calculate = function(self, card, context)
		if context.remove_playing_cards then
			local count = 0
			for i = 1, #context.removed do
				local rank = context.removed[i].base.value
				if rank == "King" or rank == "Jack" then
					count = count + 1
				end
			end
			if count > 0 then
				return {
					dollars = card.ability.money * count
				}
			end
		end
	end
}

SMODS.Joker {
	key = "echo_flower",
	config = {
		other_card = false
	},
	attributes = {
		"retrigger",
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 5, y = 5 },
	cost = 4,
	calculate = function(self, card, context)
		if context.repetition and context.cardarea == G.play then
			if card.ability.other_card then
				card.ability.other_card = false
			else
				card.ability.other_card = true
				return {
					repetitions = 1,
				}
			end
		end
	end
}

SMODS.Joker {
	key = "old_tutu",
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 8, y = 1 },
	cost = 7,
	attributes = {
		"retrigger",
		"enhancements"
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_bonus
		return { vars = { localize({ type = 'name_text', set = "Enhanced", key = "m_bonus" }) } }
	end,
	in_pool = function(self, args)
        for _, card in ipairs(G.playing_cards or {}) do
            if SMODS.has_enhancement(card, 'm_bonus') then
                return true
            end
        end
        return false
    end,
	calculate = function(self, card, context)
		if context.repetition and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, "m_bonus") then
			return {
				repetitions = 1,
			}
		end
	end
}

SMODS.Joker {
	key = "undyne",
	config = {
		xmult = 1.25,
		has_scored = false
	},
	attributes = {
		"suit",
		"spades",
		"xmult",
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 7, y = 5 },
	cost = 8,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult, localize("Spades", 'suits_singular') or "Spade" } }
	end,
	calculate = function(self, card, context)
		if context.before and context.cardarea == G.jokers then
			card.ability.has_scored = false
		elseif context.individual and context.cardarea == G.hand and (context.other_card:is_suit("Spades") or SMODS.has_any_suit(context.other_card)) and not card.ability.has_scored then
			if context.other_card.debuff then
				return {
					message = localize('k_debuffed'),
					colour = G.C.RED,
					card = context.blueprint_card or card,
				}
			else
				return {
					xmult = card.ability.xmult
				}
			end
		elseif context.after and context.cardarea == G.jokers then
			card.ability.has_scored = true
		end
	end
}

SMODS.Joker {
	key = "ballet_shoes",
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "UT_jokers",
	pos = { x = 5, y = 1 },
	cost = 5,
	config = {
		chip_gain = 15,
		chips = 0,
	},
	attributes = {
		"chips",
		"scaling",
		"destroy_card",
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.chip_gain, card.ability.chips } }
	end,
	calculate = function(self, card, context)
		if context.remove_playing_cards and not context.blueprint then
			SMODS.scale_card(card, {
				ref_table = card.ability,
				ref_value = "chips",
				scalar_value = "chip_gain",
				message_colour = G.C.CHIPS
			})
			return
		elseif context.joker_main then
			return {
				chips = card.ability.chips
			}
		end
	end
}

SMODS.Joker {
	key = "waterfall",
	config = {
		odds = 2,
		money = 1
	},
	attributes = {
		"suit",
		"diamonds",
		"chance",
		"economy"
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 6, y = 5 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		local probabilities_normal, odds = SMODS.get_probability_vars(card, 1, card.ability.odds, 'UT_waterfall')
		return { vars = { probabilities_normal, odds, card.ability.money, localize("Diamonds", 'suits_singular') } }
	end,
	calculate = function(self, card, context)
		if context.before and context.cardarea == G.jokers then
			card.ability.has_scored = false
		elseif context.individual and context.cardarea == G.hand and (context.other_card:is_suit("Diamonds") or SMODS.has_any_suit(context.other_card)) and not card.ability.has_scored then
			if SMODS.pseudorandom_probability(card, "waterfall", 1, card.ability.odds, "UT_waterfall") then
				if context.other_card.debuff then
					return {
						message = localize('k_debuffed'),
						colour = G.C.MONEY,
					}
				else
					return {
						dollars = card.ability.money
					}
				end
			end
		elseif context.after and context.cardarea == G.jokers then
			card.ability.has_scored = true
		end
	end
}
