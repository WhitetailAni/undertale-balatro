--first
SMODS.Joker {
	key = "worn_dagger",
	loc_txt = {
		name = "Worn Dagger",
		text = {
			"Scored cards of {C:hearts}Heart{}",
			"suit give {C:money}$#1#{} or {C:chips}+#2#{}",
			"Chips when scored"
		},
		unlock = {
			"Have no more than",
			"{E:1,C:money}$50{} at any point ",
			"during a run"
		},
	},
	config = {
		money = 1,
		chips = 20
	},
	--unlocked = false
	unlock_condition = {type = 'win_custom'},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 1, y = 4 },
	cost = 3,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.money, card.ability.chips } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and (context.other_card:is_suit("Hearts") or SMODS.has_any_suit(context.other_card)) then
			if pseudorandom("worn_dagger") < 1/2 then
				return {
					dollars = card.ability.money
				}
			else 
				return {
					chips = card.ability.chips
				}
			end
        end
	end
}

SMODS.Joker {
	key = "patience",
	loc_txt = {
		name = "Patience",
		text = {
			"Doubles {C:money}interest{} and",
			"{C:money}Blind payout{} if round",
			"was won on {C:attention}final hand{}"
		},
		unlock = {
			"Win a run {E:1,C:attention}without{}",
			"skipping any Blinds"
		}
	},
	config = {
		final_hand = false,
		increased_interest = false
	},
	--unlocked = false
	unlock_condition = {type = 'win_custom'},
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 9, y = 0 },
	cost = 5,
	calculate = function(self, card, context)
		if context.setting_blind and card.ability.increased_interest and not card.getting_sliced and not context.blueprint then
			G.GAME.interest_amount = G.GAME.interest_amount / 2
			card.ability.increased_interest = false
		elseif context.joker_main and G.GAME.current_round.hands_left == 0 and not context.blueprint then
			G.GAME.blind.dollars = G.GAME.blind.dollars * 2
			card.ability.final_hand = true
		elseif context.end_of_round and context.cardarea == G.jokers and card.ability.final_hand and not context.blueprint then
			card.ability.final_hand = false
			G.GAME.interest_amount = G.GAME.interest_amount * 2
			card.ability.increased_interest = true
			return {
				message = "X2",
				colour = G.C.MONEY
			}
		end
	end
}

SMODS.Joker {
	key = "boss_monster_soul",
	loc_txt = {
		name = "Boss Monster Soul",
		text = {
			"Gains {C:chips}+#1#{} Chips when a playing",
			"card is either {C:attention}destroyed{}",
			"or {C:attention}added{} to your deck",
			"{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)"
		},
		unlock = {
			"Discard a",
			"{E:1,C:attention}Full House{}"
		}
	},
	config = {
		chips = 0,
		chip_gain = 35
	},
	--unlocked = false
	unlock_condition = {type = 'discard_custom'},
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 5, y = 4 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.chip_gain, card.ability.chips } }
	end,
	calculate = function(self, card, context)
		if (context.cards_destroyed or context.remove_playing_cards or context.playing_card_added) and not context.blueprint then
			local increase_count = 0
			if context.cards_destroyed then
				increase_count = card.ability.chip_gain * #context.glass_shattered
			elseif context.remove_playing_cards then
				increase_count = card.ability.chip_gain * #context.removed
			elseif context.playing_card_added then
				increase_count = card.ability.chip_gain * #context.cards
			end
			card.ability.chips = card.ability.chips + increase_count
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
	key = "bravery",
	loc_txt = {
		name = "Bravery",
		text = {
			"This Joker gains {X:mult,C:white}X#1#{} Mult",
			"for each shop visited",
			"{C:attention}without buying anything{}",
			"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"
		},
		unlock = {
			"Play a hand containing",
			"at least 4 {E:1,C:attention}Glass Cards{}"
		}
	},
	config = {
		xmult_gain = 0.25,
		xmult = 1,
		bought = false
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult_gain, card.ability.xmult } }
	end,
	--unlocked = false
	unlock_condition = {type = 'hand_contents'},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 4, y = 1 },
	cost = 6,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				xmult = card.ability.xmult
			}
		elseif context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
			card.ability.bought = false
		elseif context.open_booster or context.buying_card and not context.blueprint then
			card.ability.bought = true
		elseif context.ending_shop and not context.blueprint then
			if not card.ability.bought then
				card.ability.xmult = card.ability.xmult + card.ability.xmult_gain
				card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize{ type = 'variable', key = 'a_xmult', vars = { card.ability.xmult } } })
			end
        end
	end
}

SMODS.Joker {
	key = "last_dream",
	loc_txt = {
		name = "Last Dream",
		text = {
			"{C:chips}+#1#{} Chips",
			"if all played cards",
			"are of {C:hearts}Heart{} suit"
		},
		unlock = {
			"Reach Ante",
			"level {E:1,C:attention}10{}"
		}
	},
	config = {
		chips = 200
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.chips } }
	end,
	--unlocked = false
	unlock_condition = { type = 'ante_up', ante = 10, extra = 10 },
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 4, y = 4 },
	soul_pos = { x = 5, y = 7 },
	cost = 8,
	calculate = function(self, card, context)
		if context.joker_main then
			for i = 1, #context.full_hand do
				if not (context.full_hand[i]:is_suit( "Hearts") or SMODS.has_any_suit(context.full_hand[i])) then
					return nil
				end
			end
			return {
				chips = card.ability.chips
			}
        end
	end
}

--next
SMODS.Joker {
	key = "justice",
	loc_txt = {
		name = "Justice",
		text = {
			"This Joker gains",
			"{C:mult}+#1#{} Mult at",
			"end of round",
			"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)"
		},
		unlock = {
			"Play a",
			"{E:1,C:attention}secret hand"
		}
	},
	config = {
		mult = 0,
		mult_gain = 4,
		mult_gained = false
	},
	--unlocked = false
	unlock_condition = {type = 'hand_contents'},
	loc_vars = function(self, info_queue, card)
		return { vars = {
			card.ability.mult_gain,
			card.ability.mult
		} }
	end,
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 0, y = 4 },
	cost = 6,
	calculate = function(self, card, context)
		if context.setting_blind and not context.blueprint then
			card.ability.mult_gained = false
		elseif context.joker_main then
			return {
				mult = card.ability.mult
			}
		elseif context.end_of_round and not context.blueprint and not card.ability.mult_gained and not context.blueprint then
            card.ability.mult = card.ability.mult + card.ability.mult_gain
            card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize{ type = 'variable', key = 'a_mult', vars = { card.ability.mult } } })
            card.ability.mult_gained = true
        end
	end
}

SMODS.Joker {
	key = "asgore",
	loc_txt = {
		name = "Asgore",
		text = {
			"{X:mult,C:white}X#1#{} Mult for every",
			"{C:attention}Consumable{} card held",
			"{C:blue}+#2#{} consumable slots",
			"{C:inactive}(Currently {X:mult,C:white}X#3#{C:inactive} Mult)"
		},
		unlock = {
			"Have at least",
			"{E:1,C:attention}7{} Jokers"
		}
	},
	config = {
		xmult_per = 0.75,
		slots = 4
	},
	--unlocked = false
	unlock_condition = {type = 'modify_jokers', extra = { count = 7 } },
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 8, y = 6 },
	cost = 8,
	loc_vars = function(self, info_queue, card)
		if G.consumeables ~= nil and G.consumeables.config ~= nil then
			return { vars = { card.ability.xmult_per, card.ability.slots, 1 + (card.ability.xmult_per * G.consumeables.config.card_count) } }
		else
			return { vars = { card.ability.xmult_per, card.ability.slots, 1 } }
		end
	end,
	add_to_deck = function(self, card, from_debuff)
		G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.slots
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.consumeables.config.card_limit = G.consumeables.config.card_limit - card.ability.slots
	end,
	calculate = function(self, card, context)
		if context.joker_main then
        	return {
        		xmult = 1 + (card.ability.xmult_per * G.consumeables.config.card_count)
        	}
        end
	end
}

SMODS.Joker {
	key = "asriel",
	loc_txt = {
		name = "Asriel",
		text = {
			"Each played {C:attention}Ace{} gives",
			"{X:mult,C:white}X#1#{} Mult when scored",
			"{C:inactive}Activates after {C:attention}#2# {C:inactive}[#3#] rounds"
		},
		unlock = {
			"Play a 5 card hand",
			"containing only {E:1,C:attention}Aces{}"
		}
	},
	config = {
		xmult = 2.5,
		threshold = 6,
		turns_elapsed = 0
	},
	rarity = 3,
	--unlocked = false
	unlock_condition = {type = 'hand_contents'},
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 1, y = 7 },
	soul_pos = { x = 6, y = 7 },
	cost = 8,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult, card.ability.threshold, card.ability.turns_elapsed} }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and context.other_card.base.value == "Ace"and card.ability.turns_elapsed >= card.ability.threshold then
			return {
				xmult = card.ability.xmult
			}
		elseif context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
			card.ability.turns_elapsed = card.ability.turns_elapsed + 1
			card:juice_up(0.3,0.4)
			if card.ability.turns_elapsed == card.ability.threshold then
				play_sound("UTDR_asriel", 1.0, 0.7)
				card:juice_up(0.3,0.5)
			end
        end
	end
}

SMODS.Joker {
	key = "omega_flowey",
	loc_txt = {
		name = "Omega Flowey",
		text = {
			"Prevents Death if chips",
			"scored are at least",
			"{C:attention}#1#%{} of required chips,",
			"gains {X:mult,C:white}X#2#{} Mult when",
			"Death is prevented",
			"{C:inactive}(Currently {X:mult,C:white}X#3#{C:inactive} Mult)"
		},
		unlock = {
			"Lose a run on",
			"Ante level {E:1,C:attention}8{}"
		}
	},
	config = {
		extra = {
			required_chips = 50,
			xmult_gain = 1,
			xmult = 1
		},
		old_bones = ""
	},
	check_for_unlock = function(self, args)
		return (args.type == "loss_ante" and args.ante == 8)
	end,
	--unlocked = false
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 9, y = 6 },
	cost = 10,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.required_chips, card.ability.extra.xmult_gain, card.ability.extra.xmult } }
	end,
	add_to_deck = function(self, card, from_debuff)
		if not from_debuff then
			card.ability.old_bones = G.localization.misc.dictionary.ph_mr_bones
		end
	end,
	calculate = function(self, card, context)
		if context.joker_main then
        	return {
        		xmult = card.ability.extra.xmult
        	}
        elseif context.game_over and to_big(G.GAME.chips)/G.GAME.blind.chips >= to_big(card.ability.extra.required_chips / 100) and not context.blueprint then
        	card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
        	G.E_MANAGER:add_event(Event({
				func = function()
					G.hand_text_area.blind_chips:juice_up()
					G.hand_text_area.game_chips:juice_up()
					play_sound('tarot1')
					return true
				end
			}))
			G.localization.misc.dictionary.ph_mr_bones = "HAHAHAHAHAHAHAHAHAHAHA!!"
			play_sound("UTDR_omega_flowey", 1.0, 0.7)
			return {
				message = localize { type = 'variable', key = 'a_xmult',vars = { card.ability.extra.xmult }},
				saved = true,
				colour = G.C.RED
			}
		elseif context.ending_shop and not context.blueprint then
			G.localization.misc.dictionary.ph_mr_bones = card.ability.old_bones
        end
	end
}

SMODS.Joker {
	key = "integrity",
	loc_txt = {
		name = "Integrity",
		text = {
			"{C:chips}+#1#{} Chips if",
			"all played cards have",
			"the {C:attention}same{} Enhancement"
		},
		unlock = {
			"Play any hand",
			"type {E:1,C:attention}25{} times",
			"in one run"
		}
	},
	config = {
		chips = 150
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.chips } }
	end,
	--unlocked = false
	unlock_condition = {type = 'hand', count = 25},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 9, y = 1 },
	cost = 7,
	calculate = function(self, card, context)
		if context.joker_main and context.cardarea == G.jokers then
			local enhancement = context.full_hand[1].config.center_key
			for i = 2, #context.full_hand do
				if context.full_hand[i].config.center_key ~= enhancement then
					return nil
				end
			end
			return {
				chips = card.ability.chips
			}
		end
	end
}

--last
SMODS.Joker {
	key = "real_knife",
	loc_txt = {
		name = "Real Knife",
		text = {
			"Gains {X:mult,C:white}X#1#{} Mult when",
			"a {C:attention}playing card{} with",
			"{C:hearts}Heart{} suit is destroyed",
			"{C:inactive}(Currently {X:mult,C:white}X#2#{} Mult)"
		},
		unlock = {
			"Thin your full",
			"deck to {E:1,C:attention}30{}",
			"cards or less"
		}
	},
	--unlocked = false
	unlock_condition = {type = 'modify_deck'},
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 2, y = 4 },
	cost = 9,
	config = {
		xmult_gain = 0.6,
		xmult = 1,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult_gain, card.ability.xmult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				xmult = card.ability.xmult
			}
		elseif context.remove_playing_cards and not context.blueprint then
			local hearts = 0
			for i = 1, #context.removed do
				if context.removed[i]:is_suit("Hearts") or SMODS.has_any_suit(context.removed[i]) then
					hearts = hearts + 1
				end
			end
		
			G.E_MANAGER:add_event(Event({
				func = function()
					G.E_MANAGER:add_event(Event({
						func = function()
							card.ability.xmult = card.ability.xmult + hearts*card.ability.xmult_gain
							return true
						end
					}))
					play_sound("UTDR_lvup", 1.0, 0.7)
					card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize{ type = 'variable', key = 'a_xmult', vars = { card.ability.xmult + hearts*card.ability.xmult_gain } } })
					return true
				end
			}))
			return
		end
	end
}

SMODS.Joker {
	key = "kindness",
	loc_txt = {
		name = "Kindness",
		text = {
			"{C:dark_edition}#1#{} Cards grant {C:chips}+#2#{} Chips",
			"{C:dark_edition}#3#{} Cards grant {C:mult}+#4#{} Mult",
			"{C:dark_edition}#5#{} Cards grant {X:mult,C:white}X#6#{} Mult",
		},
		unlock = {
			"Use no {E:1,C:red}discards{} for",
			"{E:1,C:attention}3{} consecutive rounds",
		}
	},
	config = {
		foil = 100,
		holo = 25,
		poly = 2.5,
		
		old_foil = 0,
		old_holo = 0,
		old_poly = 0,
		
		in_build = false
	},
	--unlocked = false
	unlock_condition = {type = 'round_win'},
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 3, y = 3 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = {
			G.localization.descriptions.Edition.e_foil.name,
			card.ability.foil,
			G.localization.descriptions.Edition.e_holo.name,
			card.ability.holo,
			G.localization.descriptions.Edition.e_polychrome.name,
			card.ability.poly
		} }
	end,
	add_to_deck = function(self, card, from_debuff)
		card.ability.old_foil = G.P_CENTERS.e_foil.config.chips
		card.ability.old_holo = G.P_CENTERS.e_holo.config.mult
		card.ability.old_poly = G.P_CENTERS.e_polychrome.config.x_mult
	
		card.ability.in_build = true
		
		edition_values(card.ability.foil, card.ability.holo, card.ability.poly, true)
	end,
	update = function(self, card, dt)
		if card.ability.in_build then
			edition_values(card.ability.foil, card.ability.holo, card.ability.poly)
		end
	end,
	remove_from_deck = function(self, card, from_debuff)
		card.ability.in_build = false
		edition_values(card.ability.old_foil, card.ability.old_holo, card.ability.old_poly, true)
	end,
	calculate = function(self, card, context)
		if context.game_over and not context.blueprint then
			card.ability.in_build = false
			edition_values(card.ability.old_foil, card.ability.old_holo, card.ability.old_poly)
		end
	end
}

function edition_values(foil, holo, poly)
	G.P_CENTERS.e_foil.config.chips = foil
	G.P_CENTERS.e_holo.config.mult = holo
	G.P_CENTERS.e_polychrome.config.x_mult = poly
	
	if add_remove then
		for i = 1, #G.playing_cards do
			local card = G.playing_cards[i]
			if card.edition then
				if card.edition.key == "e_foil" then
					card.edition.chips = foil
				elseif card.edition.key == "e_holo" then
					card.edition.mult = holo
				elseif card.edition.key == "e_polychrome" then
					card.edition.x_mult = poly
				end
			end
		end
	end
end

SMODS.Joker {
	key = "heart_locket",
	loc_txt = {
		name = "Heart Locket",
		text = {
			"{C:attention}Steel Cards{} give",
			"{C:mult}+#3#{} Mult when scored"
		},
		unlock = {
			"Have at least {E:1,C:attention}5{}",
			"{E:1,C:attention}Steel Cards{} in",
			"your deck"
		}
	},
	config = {
		mult = 15
	},
	--unlocked = false
	unlock_condition = {type = 'modify_deck', extra = {count = 5, enhancement = 'Steel Card', e_key = 'm_steel'}},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 3, y = 4 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.m_steel 
		return { vars = { G.GAME.probabilities.normal, card.ability.odds, card.ability.mult } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, "m_steel") then
			return {
				mult = card.ability.mult
			}
        end
	end
}

SMODS.Joker {
	key = "perseverance",
	loc_txt = {
		name = "Perseverance",
		text = {
			"{X:mult,C:white}X#1#{} Mult if you have",
			"at most {C:attention}#2#{} Enhanced",
			"cards in your full deck",
			"{C:inactive}(Currently {C:attention}#3#{C:inactive})"
		},
		unlock = {
			"Win a run on",
			"{E:1,C:attention}your final hand{}"
		}
	},
	config = {
		enhancement_count = 0,
		cap = 8,
		xmult = 2
	},
	--unlocked = false
	unlock_condition = {type = 'win_custom'},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult, card.ability.cap, card.ability.enhancement_count } }
	end,
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 7, y = 2 },
	cost = 5,
	update = function(self, card, dt)
		card.ability.enhancement_count = 0
		if G.playing_cards ~= nil then
			for k, v in pairs(G.playing_cards) do
				if v.config.center and (v.config.center.name ~= "Default Base") then
					card.ability.enhancement_count = card.ability.enhancement_count + 1
				end
			end
		end
	end,
	calculate = function(self, card, context)
		if context.joker_main and card.ability.enhancement_count <= card.ability.cap then
			return {
				xmult = card.ability.xmult
			}
		end
	end
}

SMODS.Joker {
	key = "chara",
	loc_txt = {
		name = "​",
		text = {
			"{X:mult,C:white}X#1#{} Mult",
			"{C:red}-#2#{} hand size"
		},
		unlock = {
			"{E:1,C:red}Five heart nines.{}"
		}
	},
	config = {
		xmult = 5,
		hand_loss = 3
	},
	--unlocked = false
	unlock_condition = {type = 'hand_contents'},
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 4, y = 7 },
	soul_pos = { x = 7, y = 7 },
	cost = 9,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult, card.ability.hand_loss } }
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
        		xmult = card.ability.xmult
        	}
        end
	end
}