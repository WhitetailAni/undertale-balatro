--first
SMODS.Joker {
	key = "worn_dagger",
	loc_txt = {
		name = "Worn Dagger",
		text = {
			"Scored cards of {C:hearts}Heart{}",
			"suit give {C:money}$#1#{} or {C:chips}+#2#{}",
			"Chips when scored"
		}
	},
	config = {
		money = 1,
		chips = 20
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 1, y = 4 },
	cost = 3,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.money, card.ability.chips } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and (context.other_card.base.suit == "Hearts" or SMODS.has_any_suit(context.other_card)) then
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
		}
	},
	config = {
		final_hand = false,
		increased_interest = false
	},
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 9, y = 0 },
	cost = 5,
	calculate = function(self, card, context)
		if context.setting_blind and card.ability.increased_interest and not card.getting_sliced then
			G.GAME.interest_amount = G.GAME.interest_amount / 2
			card.ability.increased_interest = false
		elseif context.joker_main and G.GAME.current_round.hands_left == 0 then
			G.GAME.blind.dollars = G.GAME.blind.dollars * 2
			card.ability.final_hand = true
		elseif context.end_of_round and context.cardarea == G.jokers and card.ability.final_hand then
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
			"Gains {C:chips}+#1#{} Chips",
			"when a playing card is",
			"either {C:attention}destroyed{} or",
			"{C:attention}added{} to your deck",
			"{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)"
		}
	},
	config = {
		extra = {
			chips = 0,
			chip_gain = 20
		}
	},
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 5, y = 4 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chip_gain, card.ability.extra.chips } }
	end,
	calculate = function(self, card, context)
		if (context.cards_destroyed or context.remove_playing_cards or context.playing_card_added) and not context.blueprint then
			local increase_count = 0
			if context.cards_destroyed then
				increase_count = card.ability.extra.chip_gain * #context.glass_shattered
			elseif context.remove_playing_cards then
				increase_count = card.ability.extra.chip_gain * #context.removed
			elseif context.playing_card_added then
				increase_count = card.ability.extra.chip_gain * #context.cards
			end
			card.ability.extra.chips = card.ability.extra.chips + increase_count
			return {
				message = localize('k_upgrade_ex'),
				colour = G.C.CHIPS,
				card = card
			}
        elseif context.joker_main then
        	return {
        		chips = card.ability.extra.chips 
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
		}
	},
	config = {
		xmult_gain = 0.5,
		xmult = 1,
		bought = false
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult_gain, card.ability.xmult } }
	end,
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
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
		}
	},
	config = {
		chips = 250
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.chips } }
	end,
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 4, y = 4 },
	soul_pos = { x = 5, y = 7 },
	cost = 8,
	calculate = function(self, card, context)
		if context.joker_main then
			for i = 1, #context.full_hand do
				if not (context.full_hand[i].base.suit == "Hearts" or SMODS.has_any_suit(context.full_hand[i])) then
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
			"{C:mult}+#1#{} Mult",
			"at end of round",
			"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)"
		}
	},
	config = {
		mult = 0,
		mult_gain = 5,
		mult_gained = false
	},
	loc_vars = function(self, info_queue, card)
		return { vars = {
			card.ability.mult_gain,
			card.ability.mult
		} }
	end,
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 0, y = 4 },
	cost = 6,
	calculate = function(self, card, context)
		if context.setting_blind then
			card.ability.mult_gained = false
		elseif context.joker_main then
			return {
				mult = card.ability.mult
			}
		elseif context.end_of_round and not context.blueprint and not card.ability.mult_gained then
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
		}
	},
	config = {
		extra = {
			xmult_per = 0.75,
			slots = 4
		}
	},
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 8, y = 6 },
	cost = 8,
	loc_vars = function(self, info_queue, card)
		if G.consumeables ~= nil and G.consumeables.config ~= nil then
			return { vars = { card.ability.extra.xmult_per, card.ability.extra.slots, 1 + (card.ability.extra.xmult_per * G.consumeables.config.card_count) } }
		else
			return { vars = { card.ability.extra.xmult_per, card.ability.extra.slots, 1 } }
		end
	end,
	add_to_deck = function(self, card, from_debuff)
		G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.extra.slots
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.consumeables.config.card_limit = G.consumeables.config.card_limit - card.ability.extra.slots
	end,
	calculate = function(self, card, context)
		if context.joker_main then
        	return {
        		xmult = 1 + (card.ability.extra.xmult_per * G.consumeables.config.card_count)
        	}
        end
	end
}

SMODS.Joker {
	key = "asriel",
	loc_txt = {
		name = "Asriel",
		text = {
			"Each played {C:attention}Ace{}",
			"gives {X:mult,C:white}X#1#{} Mult",
			"when scored"
		}
	},
	config = {
		extra = {
			xmult = 2.5,
		}
	},
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 1, y = 7 },
	soul_pos = { x = 6, y = 7 },
	cost = 8,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and context.other_card.base.value == "Ace" then
        	return {
        		xmult = card.ability.extra.xmult
        	}
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
			"gains {X:mult,C:white}X#2#{} Mult when Death",
			"is prevented",
			"{C:inactive}(Currently {X:mult,C:white}X#3#{C:inactive} Mult)"
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
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
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
		}
	},
	config = {
		chips = 250
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.chips } }
	end,
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
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
		}
	},
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
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
				if context.removed[i].base.suit == "Hearts" or SMODS.has_any_suit(context.removed[i]) then
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
		}
	},
	config = {
		foil = 100,
		holo = 20,
		poly = 2,
		
		old_foil = 0,
		old_holo = 0,
		old_poly = 0,
		
		in_build = false
	},
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "jokers",
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
		
		edition_values(card.ability.foil, card.ability.holo, card.ability.poly)
	end,
	update = function(self, card, dt)
		if card.ability.in_build then
			edition_values(card.ability.foil, card.ability.holo, card.ability.poly)
		end
	end,
	remove_from_deck = function(self, card, from_debuff)
		card.ability.in_build = false
		edition_values(card.ability.old_foil, card.ability.old_holo, card.ability.old_poly)
	end,
	calculate = function(self, card, context)
		if context.game_over then
			card.ability.in_build = false
			edition_values(card.ability.old_foil, card.ability.old_holo, card.ability.old_poly)
		end
	end
}

function edition_values(foil, holo, poly)
	G.P_CENTERS.e_foil.config.chips = foil
	G.P_CENTERS.e_holo.config.mult = holo
	G.P_CENTERS.e_polychrome.config.x_mult = poly
end

SMODS.Joker {
	key = "heart_locket",
	loc_txt = {
		name = "Heart Locket",
		text = {
			"Scored {C:attention}Steel Cards{}",
			"have a {C:green}#1# in #2#{} chance",
			"to give {C:mult}+#3#{} Mult"
		}
	},
	config = {
		odds = 2,
		mult = 15
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 3, y = 4 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return { vars = { G.GAME.probabilities.normal, card.ability.odds, card.ability.mult } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and context.other_card.config.center_key == "m_steel" then
			if pseudorandom("heart_locket") < G.GAME.probabilities.normal/card.ability.odds then
				return {
					mult = card.ability.mult
				}
			end
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
		}
	},
	config = {
		enhancement_count = 0,
		cap = 8,
		xmult = 2
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult, card.ability.cap, card.ability.enhancement_count } }
	end,
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
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
		}
	},
	config = {
		extra = {
			xmult = 5,
			hand_loss = 3
		}
	},
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 4, y = 7 },
	soul_pos = { x = 7, y = 7 },
	cost = 9,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult, card.ability.extra.hand_loss } }
	end,
	add_to_deck = function(self, card, from_debuff)
		G.hand:change_size(-card.ability.extra.hand_loss)
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.hand:change_size(card.ability.extra.hand_loss)
	end,
	calculate = function(self, card, context)
		if context.joker_main then
        	return {
        		xmult = card.ability.extra.xmult
        	}
        end
	end
}