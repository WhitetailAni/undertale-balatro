--first row
SMODS.Joker {
	key = "bandage",
	loc_txt = {
		name = "Bandage",
		text = {
			"{C:chips}+#1#{} Chips",
			"and {C:mult}+#2#{} Mult"
		}
	},
	config = {
		mult = 5,
		chips = 20
	},
	discovered = true,
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 1, y = 0 },
	cost = 4,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.chips, card.ability.mult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chips = card.ability.chips,
				mult = card.ability.mult
			}
		end
	end
}

SMODS.Joker {
	key = "stick",
	loc_txt = {
		name = "Stick",
		text = {
			"{X:mult,C:white}X#1#{} Mult"
		}
	},
	config = {
		xmult = 1.5,
	},
	discovered = true,
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 2, y = 0 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				Xmult = card.ability.xmult
			}
		end
	end
}

SMODS.Joker {
	key = "flowey",
	loc_txt = {
		name = "Flowey",
		text = {
			"{C:mult}+#1#{} Mult",
			"{C:red}-#2#{} hand size"
		}
	},
	config = {
		mult = 99,
		hand_loss = 2
	},
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 6, y = 4 },
	cost = 8,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.mult, card.ability.hand_loss } }
	end,
	add_to_deck = function(self, card, from_debuff)
		G.hand:change_size(-card.ability.hand_loss)
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.hand:change_size(card.ability.hand_loss)
	end,
	calculate = function(self, card, context)
		if context.joker_main then
        	return {
        		mult = card.ability.mult
        	}
        end
	end
}

SMODS.Joker {
	key = "candy",
	loc_txt = {
		name = "Monster Candy",
		text = {
			"Each played {C:attention}Ace{}, {C:attention}2{}, or {C:attention}3{}",
			"gives {C:mult}+#1#{} Mult when scored",
			"{C:green}#2# in #3#{} chance this card is",
			"destroyed at end of round"
		}
	},
	config = {
		mult = 5,
		odds = 4,
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = false,
	atlas = "UT_jokers",
	pos = { x = 3, y = 0 },
	cost = 4,
	loc_vars = function(self, info_queue, card)
		local probabilities_normal, odds = SMODS.get_probability_vars(card, 1, card.ability.odds, 'UT_candy')
		return { vars = { card.ability.mult, probabilities_normal, odds } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card.base.value == "Ace" or context.other_card.base.value == "2" or context.other_card.base.value == "3" then
				return {
					mult = card.ability.mult
				}
			end
		elseif context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
			if SMODS.pseudorandom_probability(card, "monster_candy", 1, card.ability.odds, "UT_candy") then
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
					message = "Dropped!"
				}
			end
		end
	end
}

SMODS.Joker {
	key = "spider_donut",
	loc_txt = {
		name = "Spider Donut",
		text = {
			"Each played {C:attention}7{} gives",
			"{C:mult}+#1#{} mult when scored",
			"Each played {C:attention}9{} gives",
			"{C:mult}+#2#{} mult when scored,",
			"but this Joker is",
			"{C:attention}destroyed{} after scoring"
		}
	},
	config = {
		seven = 7,
		nine = 9,
		destroy_self = false
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = false,
	atlas = "UT_jokers",
	pos = { x = 4, y = 0 },
	cost = 6,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.seven, card.ability.nine } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card.base.value == "7" then
				return {
					mult = card.ability.seven
				}
			elseif context.other_card.base.value == "9" then
				card.ability.destroy_self = true
				return {
					mult = card.ability.nine
				}
			end
		elseif context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
			if card.ability.destroy_self then
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
					message = "Eaten!"
				}
			end
		end
	end
}

--second row
SMODS.Joker {
	key = "mt_ebott",
	loc_txt = {
		name = "Mt. Ebott",
		text = {
			"{C:attention}+#1#{} hand size,",
			"{C:attention}lose all discards{}",
		}
	},
	config = {
		hand_size = 5
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.hand_size } }
	end,
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 2, y = 7 },
	cost = 7,
	add_to_deck = function(self, card, from_debuff)
		G.hand:change_size(card.ability.hand_size)
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.hand:change_size(-card.ability.hand_size)
	end,
	calculate = function(self, card, context)
		if context.setting_blind and not card.getting_sliced and not context.blueprint then
			ease_discard(-G.GAME.current_round.discards_left, nil, true)
        end
	end
}

SMODS.Joker {
	key = "ruins",
	loc_txt = {
		name = "Ruins",
		text = {
			"{C:chips}+#1#{} Chips if played",
			"hand contains",
			"{C:attention}4{} or fewer cards"
		}
	},
	config = {
		chips = 100
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 7, y = 4 },
	cost = 3,
	loc_vars = function(self, info_queue, card)
		return { vars = {
			card.ability.chips
		} }
	end,
	calculate = function(self, card, context)
		if context.joker_main and #context.full_hand <= 4 then
			return {
				chips = card.ability.chips
			}
        end
	end
}

SMODS.Joker {
	key = "human_soul",
	loc_txt = {
		name = "Human Soul",
		text = {
			"{C:attention}+#1#{} hand size for",
			"each {C:attention}Joker{} card",
			"{C:inactive}(Currently {C:attention}+#2#{C:inactive} hand size)"
		}
	},
	config = {
		hand_size_gain = 1,
		joker_count = 0,
		in_build = false
	},
	rarity = 3,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 0, y = 0 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		if card.ability.in_build then
			return { vars = { card.ability.hand_size_gain, #G.jokers.cards * card.ability.hand_size_gain } }
		else
			return { vars = { card.ability.hand_size_gain, card.ability.hand_size_gain } }
		end
	end,
	add_to_deck = function(self, card, from_debuff)
		card.ability.in_build = true
		G.hand:change_size((#G.jokers.cards * card.ability.hand_size_gain))
		card.ability.joker_count = #G.jokers.cards
	end,
	update = function(self, card, dt)
		if card.ability.in_build then
			if card.ability.joker_count ~= #G.jokers.cards then
				G.hand:change_size(#G.jokers.cards - card.ability.joker_count)
				card.ability.joker_count = #G.jokers.cards
			end
		end
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.hand:change_size(-(#G.jokers.cards * card.ability.hand_size_gain))
		card.ability.in_build = false
	end,
}

SMODS.Joker {
	key = "toy_knife",
	loc_txt = {
		name = "Toy Knife",
		text = {
			"{C:mult}+#1#{} Mult every",
			"{C:attention}#2#{} hands played",
			"{C:inactive}#3# remaining"
		}
	},
	config = {
		mult = 30,
		cycled = 3,
		hands_remaining = 3,
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 6, y = 0 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.mult, card.ability.cycled, card.ability.hands_remaining } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			if card.ability.hands_remaining == 0 then
				card.ability.hands_remaining = card.ability.cycled
				return {
					mult = card.ability.mult
				}
			end
		elseif context.after and not context.blueprint then
			if card.ability.hands_remaining == 0 then
				local eval = function(card)
					return card.ability.hands_remaining == 0
				end
				juice_card_until(card, eval, true)
			else
				card.ability.hands_remaining = card.ability.hands_remaining - 1
			end
		end
	end
}

SMODS.Joker {
	key = "home",
	loc_txt = {
		name = "Home",
		text = {
			"{C:chips}Chips{} are rounded up to",
			"next multiple of {C:attention}#1#{}",
			"{C:mult}Mult{} is rounded up to",
			"next multiple of {C:attention}#2#{}"
		}
	},
	config = {
		mult_round = 10,
		chips_round = 50
	},
	rarity = 1,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 9, y = 4 },
	cost = 3,
	loc_vars = function(self, info_queue, card)
		return { vars = {
			card.ability.chips_round,
			card.ability.mult_round
		} }
	end,
	calculate = function(self, card, context)
		if context.joker_main and not context.debuffed_hand and hand_chips and mult and not context.blueprint then
			hand_chips = mod_chips(math.ceil(hand_chips / card.ability.chips_round) * card.ability.chips_round)
			mult = mod_mult(math.ceil(mult / card.ability.mult_round) * card.ability.mult_round)
			update_hand_text({ delay = 0 }, { mult = mult, chips = hand_chips })
			return {
				message = "Saved!",
				colour = G.C.PURPLE
			}
		end
	end
}

--third row
SMODS.Joker {
	key = "napstablook",
	loc_txt = {
		name = "Napstablook",
		text = {
			"{C:chips}+#1#{} Chips for each",
			"empty {C:attention}Joker{} slot",
			"{s:0.8}Napstablook included{}",
			"{C:inactive}(Currently {C:chips}+#2#{} Chips)"
		}
	},
	config = {
		chips_per = 40,
		chips = 0
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 8, y = 4 },
	cost = 4,
	loc_vars = function(self, info_queue, card)
		if G.jokers ~= nil and G.jokers.config ~= nil and G.jokers.cards ~= nil and G.jokers.config.card_limit ~= nil then
			return { vars = {
				card.ability.chips_per,
				card.ability.chips
			} }
		else 
			return { vars = {
				card.ability.chips_per,
				card.ability.chips_per
			} }
		end
	end,
	update = function(self, card, dt)
		if G.jokers ~= nil and G.jokers.config ~= nil and G.jokers.cards ~= nil and G.jokers.config.card_limit ~= nil then
			card.ability.chips = (G.jokers.config.card_limit - #G.jokers.cards) * card.ability.chips_per
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i].label == 'j_UTDR_napstablook' then
					card.ability.chips = card.ability.chips + card.ability.chips_per
				end
			end
		end
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chips = card.ability.chips
			}
		end
	end
}

SMODS.Joker {
	key = "butterscotch-cinnamon_pie",
	loc_txt = {
		name = "Butterscotch-Cinnamon Pie",
		text = {
			"Sell this card to",
			"{C:attention}end{} the current Blind",
			"without {C:money}cashing out{}",
			"{C:inactive}(Excludes {C:attention}Boss Blinds{C:inactive})"
		}
	},
	config = {
		spared = false,
		old_bones = ""
	},
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = false,
	atlas = "UT_jokers",
	pos = { x = 7, y = 0 },
	cost = 8,
	add_to_deck = function(self, card, from_debuff)
		if not from_debuff then
			card.ability.old_bones = G.localization.misc.dictionary.ph_mr_bones
		end
	end,
	calculate = function(self, card, context)
		if context.selling_self and G.GAME.blind.in_blind and not G.GAME.blind.boss and not context.blueprint then
			card.ability.spared = true
			G.STATE = G.STATES.HAND_PLAYED
			G.STATE_COMPLETE = true
			end_round()
		elseif context.game_over and not G.GAME.blind.boss and card.ability.spared and not context.blueprint then
			G.localization.misc.dictionary.ph_mr_bones = "Spared by Buttspie"
			return {
				message = "Spared!",
				saved = true,
				colour = G.C.RED
			}
		elseif context.ending_shop and not context.blueprint then
			G.localization.misc.dictionary.ph_mr_bones = card.config.old_bones
        end
	end
}

SMODS.Joker {
	key = "ribbon",
	loc_txt = {
		name = "Faded Ribbon",
		text = {
			"{C:attention}Glass Cards{} have a",
			"{C:green}#1# in #2#{} chance to be",
			"destroyed"
		}
	},
	config = {
		odds = 8,
		noelle_is_older = false
	},
	rarity = 1,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 5, y = 0 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.m_glass
		local probabilities_glass, odds = SMODS.get_probability_vars(card, 1, card.ability.odds, "glass")
		return { vars = { probabilities_glass, odds } }
	end,
	add_to_deck = function(self, card, from_debuff)
		if #SMODS.find_card("j_UTDR_noelle") > 0 then
			card.ability.noelle_is_older = true
		end
	end,
	calculate = function(self, card, context)
		if context.mod_probability and not context.blueprint and context.identifier == "glass" and not card.ability.noelle_is_older then
			return {
				denominator = 8
			}
		elseif context.selling_card and context.card.label == "j_UTDR_noelle" and #SMODS.find_card("j_UTDR_noelle") == 1 and not context.blueprint then
			card.ability.noelle_is_older = false
		end
	end
}

SMODS.Joker {
	key = "snail_pie",
	loc_txt = {
		name = "Snail Pie",
		text = {
			"Sell this card to",
			"apply {C:dark_edition}#1#{}, {C:dark_edition}#2#{},",
			"or {C:dark_edition}#3#{} to",
			"{C:attention}#4#{} random Jokers"
		}
	},
	config = {
		jokers = 2
	},
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = false,
	atlas = "UT_jokers",
	pos = { x = 8, y = 0 },
	cost = 8,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.e_foil
		info_queue[#info_queue+1] = G.P_CENTERS.e_holo
		info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome
		return { vars = { G.localization.descriptions.Edition.e_foil.name, G.localization.descriptions.Edition.e_holo.name, G.localization.descriptions.Edition.e_polychrome.name, card.ability.jokers } }
	end,
	calculate = function(self, card, context)
		if context.selling_self and not context.blueprint and #G.jokers.cards > 1 then
			for i = 1, card.ability.jokers do
				local pool = {}
			
				for j = 1, #G.jokers.cards do
					if G.jokers.cards[j] ~= card and not G.jokers.cards[j].edition then
						pool[#pool + 1] = G.jokers.cards[j]
					end
				end
				if #pool < 1 then
					break
				end
				local joker = pseudorandom_element(pool, "snail_pie_joker")
				joker:set_edition(poll_edition("snail_pie_edition", nil, true, true), true)
			end
		end
	end
}

SMODS.Joker {
	key = "toriel",
	loc_txt = {
		name = "Toriel",
		text = {
			"When {C:attention}Boss Blind{} is",
			"selected, create an",
			"{C:green}Uncommon{} or {C:red}Rare{} {C:attention}Joker{}",
			"{C:inactive}(Must have room){}"
		}
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 0, y = 5 },
	cost = 9,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult } }
	end,
	calculate = function(self, card, context)
		if context.setting_blind and not (context.blueprint_card or card).getting_sliced and #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit and context.blind.boss then
			local uncommon_or_rare = pseudorandom("toriel")
			local color = nil
			local rarity = 0
			G.GAME.joker_buffer = G.GAME.joker_buffer + math.min(1, G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer))
			if uncommon_or_rare < 1/4 then
				color = G.C.GREEN
				rarity = 1
			else
				color = G.C.RED
				rarity = 0.75
			end
			
			G.E_MANAGER:add_event(Event({
				func = function() 
					local card = create_card('Joker', G.jokers, nil, rarity, nil, nil, nil, 'toriel')
					card:add_to_deck()
					G.jokers:emplace(card)
					card:start_materialize()
					G.GAME.joker_buffer = 0
					return true
				end
			}))   
			card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, { message = localize('k_plus_joker'), colour = color })
        end
	end
}