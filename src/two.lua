--row one
SMODS.Joker {
	key = "tough_glove",
	loc_txt = {
		name = "Tough Glove",
		text = {
			"Gains {C:mult}+#1#{} Mult",
			"if played hand",
			"contains a {C:attention}#2#{}",
			"{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult)",
		}
	},
	config = {
		mult_gain = 5,
		mult = 0
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 2, y = 1 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = {
			card.ability.mult_gain,
			G.localization.misc.poker_hands['Flush'],
			card.ability.mult
		} }
	end,
	calculate = function(self, card, context)
		if context.before and context.cardarea == G.jokers and next(context.poker_hands['Flush']) and not context.blueprint then
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
	key = "manly_bandana",
	loc_txt = {
		name = "Manly Bandana",
		text = {
			"{C:mult}+#1#{} Mult for",
			"each remaining {C:blue}Hand{}"
		}
	},
	config = {
		extra = {
			mult = 7
		}
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 0, y = 1 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult = card.ability.extra.mult * G.GAME.current_round.hands_left
			}
		end
	end
}

SMODS.Joker {
	key = "snowman_piece",
	loc_txt = {
		name = "Snowman Piece",
		text = {
			"Gains {C:chips}+#1#{} Chips at",
			"end of round, destroys",
			"itself after {C:attention}#2#{} {C:inactive}[#3#]{} rounds",
			"{C:inactive}(Currently {C:chips}+#4#{C:inactive} Chips)",
		}
	},
	config = {
		chip_gain = 20,
		chips = 0,
		rounds = 0,
		round_limit = 6,
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 1, y = 1 },
	cost = 4,
	loc_vars = function(self, info_queue, card)
		return { vars = {
			card.ability.chip_gain,
			card.ability.round_limit,
			card.ability.rounds,
			card.ability.chips
		} }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chips = card.ability.chips
			}
		elseif context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
			if card.ability.rounds >= card.ability.round_limit then
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
					message = "Melted!"
				}
			elseif context.end_of_round and context.cardarea == G.jokers then
				card.ability.chips = card.ability.chips + card.ability.chip_gain
				card.ability.rounds = card.ability.rounds + 1
				return {
					message = localize('k_upgrade_ex'),
					colour = G.C.CHIPS,
					card = card
				}
			end
		end
	end
}

SMODS.Joker {
	key = "nice_cream",
	loc_txt = {
		name = "Nice Cream",
		text = {
			"{C:green}#1# in #2#{} chance to {C:attention}create{} a {C:tarot}Tarot{}",
			"card when a {C:planet}Planet{} card is used",
			"{C:green}#1# in #3#{} chance to be {C:attention}destroyed{}",
			"when a {C:planet}Planet{} card is used",
			"{C:inactive}(Must have room){}"
		}
	},
	config = {
		tarot_odds = 2,
		destroy_odds = 8
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = false,
	atlas = "jokers",
	pos = { x = 3, y = 1 },
	cost = 4,
	loc_vars = function(self, info_queue, card)
		return { vars = { G.GAME.probabilities.normal, card.ability.tarot_odds, card.ability.destroy_odds } }
	end,
	calculate = function(self, card, context)
		if context.using_consumeable and not context.blueprint and context.consumeable.ability.set == 'Planet' then
			if pseudorandom("nice_cream_tarot") < G.GAME.probabilities.normal/card.ability.tarot_odds then
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
			if pseudorandom("nice_cream_destroy") < G.GAME.probabilities.normal/card.ability.destroy_odds and not context.blueprint then
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
					message = "Melted!"
				}
			end
        end
	end
}

SMODS.Joker {
	key = "silver_key",
	loc_txt = {
		name = "Silver Key",
		text = {
			"Create a {C:spectral}Spectral{} card",
			"when {C:attention}Boss Blind{}",
			"is defeated",
			"{C:inactive}(Must have room){}"
		}
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 7, y = 3 },
	cost = 7,
	calculate = function(self, card, context)
		if context.end_of_round and context.cardarea == G.jokers and G.GAME.blind.boss then
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then 
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				G.E_MANAGER:add_event(Event({
					trigger = 'before',
					delay = 0.0,
					func = (function()
							local card = create_card('Spectral',G.consumeables, nil, nil, nil, nil, nil, 'silver_key')
							card:add_to_deck()
							G.consumeables:emplace(card)
							G.GAME.consumeable_buffer = 0
						return true
					end)}))
				card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, { message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral })
			end
        end
	end
}

--row two
SMODS.Joker {
	key = "sans",
	loc_txt = {
		name = "sans.",
		text = {
			"{X:mult,C:white}x#1#{} mult if played",
			"hand is a {C:attention}#2#{}"
		}
	},
	config = {
		xmult = 3
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 1, y = 5 },
	cost = 6,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult, G.localization.misc.poker_hands['High Card'].lower(G.localization.misc.poker_hands['High Card']) } }
	end,
	calculate = function(self, card, context)
		if context.joker_main and next(context.poker_hands['High Card']) then
			local tableKeys = getTableKeys(context.poker_hands)
			for i = 1, #tableKeys do
				if tableKeys[i] ~= "High Card" then
					if #context.poker_hands[tableKeys[i]] > 0 then
						return nil
					end
				end
			end
			return {
				xmult = card.ability.xmult
			}
		end
	end
}

--https://gist.github.com/abursuc/51185d11ddd946f433e1299489ed2c07
function getTableKeys(tab)
	local keyset = {}
	for k,v in pairs(tab) do
    	keyset[#keyset + 1] = k
	end
	return keyset
end

SMODS.Joker {
	key = "papyrus",
	loc_txt = {
		name = "THE GREAT PAPYRUS!",
		text = {
			"RETRIGGER ALL SCORED",
			"CARDS IF PLAYED HAND",
			"CONTAINS A {C:attention}#1#{}!!!"
		}
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 3, y = 5 },
	cost = 6,
	loc_vars = function(self, info_queue, card)
		return { vars = { G.localization.misc.poker_hands['Straight'].upper(G.localization.misc.poker_hands['Straight']) } }
	end,
	calculate = function(self, card, context)
		if context.repetition and context.cardarea == G.play and next(context.poker_hands['Straight']) then
			return {
				message = localize('k_again_ex'),
				repetitions = 1,
				card = context.blueprint_card or card
			}
		end
	end
}

SMODS.Joker {
	key = "snowdin",
	loc_txt = {
		name = "Snowdin",
		text = {
			"Creates a {C:planet}Planet{}",
			"Card if played hand",
			"contains a {C:attention}#1#{}",
			"{C:inactive}(Must have room){}"
		}
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 2, y = 5 },
	cost = 4,
	loc_vars = function(self, info_queue, card)
		return { vars = { G.localization.misc.poker_hands['Straight'] } }
	end,
	calculate = function(self, card, context)
		if context.before and context.cardarea == G.jokers and next(context.poker_hands['Straight']) and not context.blueprint then
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
						--card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Created!", colour = G.C.SECONDARY_SET.PLANET})
					end
					return true
				end
			}))
		end
	end
}

SMODS.Joker {
	key = "monster_kid",
	loc_txt = {
		name = "Monster Kid",
		text = {
			"{C:green}#1# in #2#{} chance for {C:mult}+#3#{} Mult",
			"{C:green}#1# in #2#{} chance for {C:chips}-#4#{} Chips",
		}
	},
	config = {
		odds = 2,
		mult = 20,
		chips = 10,
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 4, y = 5 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { G.GAME.probabilities.normal, card.ability.odds, card.ability.mult, card.ability.chips } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			if pseudorandom("monster_kid_mult") < G.GAME.probabilities.normal/card.ability.odds then
				SMODS.calculate_effect({ mult = card.ability.mult }, card)
			end
			
			if pseudorandom("monster_kid_chips") < G.GAME.probabilities.normal/card.ability.odds then 
				SMODS.calculate_effect({ chips = -card.ability.chips }, card)
			end
        end
	end
}

SMODS.Joker {
	key = "undyne",
	loc_txt = {
		name = "Undyne",
		text = {
			"Each card of {C:spades}Spade{}",
			"suit held in hand",
			"gives {X:mult,C:white}X#1#{} Mult"
		}
	},
	config = {
		xmult = 1.25
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 7, y = 5 },
	cost = 8,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.hand and (context.other_card.base.suit == "Spades" or SMODS.has_any_suit(context.other_card)) then
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
        end
	end
}

--row three
SMODS.Joker {
	key = "ballet_shoes",
	loc_txt = {
		name = "Ballet Shoes",
		text = {
			"Gains {C:chips}+#1#{} Chips",
			"when a {C:attention}playing card{}",
			"is destroyed",
			"{C:inactive}(Currently {C:chips}+#2#{} Chips)"
		}
	},
	rarity = 1,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 5, y = 1 },
	cost = 5,
	config = {
		chip_gain = 10,
		chips = 0,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.chip_gain, card.ability.chips } }
	end,
	calculate = function(self, card, context)
		if context.remove_playing_cards and not context.blueprint then
			G.E_MANAGER:add_event(Event({
				func = function()
					G.E_MANAGER:add_event(Event({
						func = function()
							card.ability.chips = card.ability.chips + #context.removed*card.ability.chip_gain
							return true
						end
					}))
					card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize{ type = 'variable', key = 'a_chips', vars = { card.ability.chips + #context.removed*card.ability.chip_gain } } })
					return true
				end
			}))

			return
		end
	end
}

SMODS.Joker {
	key = "echo_flower",
	loc_txt = {
		name = "Echo Flower",
		text = {
			"Retriggers every",
			"{C:attention}other{} scored card"
		}
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 5, y = 5 },
	cost = 4,
	calculate = function(self, card, context)
		if context.repetition and context.cardarea == G.play then
			if card.ability.other_card then
				card.ability.other_card = false
			else
				card.ability.other_card = true
				return {
					message = localize('k_again_ex'),
					repetitions = 1,
					card = card
				}
			end
		end
	end
}

SMODS.Joker {
	key = "abandoned_quiche",
	loc_txt = {
		name = "Abandoned Quiche",
		text = {
			"{C:green}#1# in #2#{} chance this card is",
			"{C:attention}destroyed{} at end of round",
			"and creates {C:attention}#3#{} Tags"
		}
	},
	config = {
		odds = 5,
		tag_count = 3
	},
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = false,
	atlas = "jokers",
	pos = { x = 7, y = 1 },
	cost = 4,
	loc_vars = function(self, info_queue, card)
		return { vars = { G.GAME.probabilities.normal, card.ability.odds, card.ability.tag_count } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
			if pseudorandom("nice_cream") < G.GAME.probabilities.normal/card.ability.odds then
				for i = 1, card.ability.tag_count do
					local tag = Tag(get_next_tag_key("twt_punch_card"))
					if tag.name == "Orbital Tag" then
						local _poker_hands = {}
						for k, v in pairs(G.GAME.hands) do
							if v.visible then
								_poker_hands[#_poker_hands + 1] = k
							end
						end
						tag.ability.orbital_hand = pseudorandom_element(_poker_hands, pseudoseed("nice_cream_orbital"))
					end
					if tag.name == "Boss Tag" then
						i = i - 1 --reroll tags can break if a booster pack tag is generated
					else
						add_tag(tag)
					end
				end
				
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
					message = "Abandoned!"
				}
			end
        end
	end
}

SMODS.Joker {
	key = "waterfall",
	loc_txt = {
		name = "Waterfall",
		text = {
			"Each card of {C:diamonds}Diamond{}",
			"suit held in hand has a",
			"{C:green}#1# in #2#{} chance to give",
			"{C:money}$#3#{} when scored"
		}
	},
	config = {
		odds = 2,
		money = 1
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 6, y = 5 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { G.GAME.probabilities.normal, card.ability.odds, card.ability.money } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.hand and (context.other_card.base.suit == "Diamonds" or SMODS.has_any_suit(context.other_card)) then
			if pseudorandom("waterfall") < G.GAME.probabilities.normal/card.ability.odds then
				if context.other_card.debuff then
					return {
						message = localize('k_debuffed'),
						colour = G.C.MONEY,
						card = context.blueprint_card or card,
					}
				else
					return {
						dollars = card.ability.money
					}
				end
			end
        end
	end
}

SMODS.Joker {
	key = "old_tutu",
	loc_txt = {
		name = "Old Tutu",
		text = {
			"Retrigger all",
			"played {C:attention}Bonus{} cards"
		}
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 8, y = 1 },
	cost = 7,
	calculate = function(self, card, context)
		if context.repetition and context.cardarea == G.play and context.other_card.config.center_key == "m_bonus" then
			return {
				message = localize('k_again_ex'),
				repetitions = 1,
				card = context.blueprint_card or card
			}
		end
	end
}