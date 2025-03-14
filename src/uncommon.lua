SMODS.Joker {
	key = "faded_ribbon",
	loc_txt = {
		name = "Faded Ribbon",
		text = {
			"{C:attention}Glass{} Cards have a",
			"{C:green}#1# in #2#{} chance to be",
			"destroyed"
		}
	},
	config = {
		extra = {
			odds = 10
		}
	},
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 5, y = 0 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { G.GAME.probabilities.normal, card.ability.extra.odds } }
	end,
	add_to_deck = function(self, card, from_debuff)
		glass_chance(card.ability.extra.odds)
	end,
	update = function(self, card, dt)
		glass_chance(card.ability.extra.odds)
	end,
	remove_from_deck = function(self, card, from_debuff)
		glass_chance(4)
	end
}

function glass_chance(chance)
	if G.deck ~= nil and G.deck.cards ~= nil then
		for i = 1, #G.deck.cards do
			if G.deck.cards[i].config.center and (G.deck.cards[i].config.center.label == "Glass Card") and not G.deck.cards[i].vampired then 
				G.deck.cards[i].ability.extra = chance
			end				
		end
		for i = 1, #G.hand.cards do
			if G.hand.cards[i].config.center and (G.hand.cards[i].config.center.label == "Glass Card") and not G.hand.cards[i].vampired then 
				G.hand.cards[i].ability.extra = chance
			end				
		end
	end
end

SMODS.Joker {
	key = "snail_pie",
	loc_txt = {
		name = "Snail Pie",
		text = {
			"Sell this card to",
			"apply {C:dark_edition}#1#{} to",
			"{C:attention}#2#{} random Jokers"
		}
	},
	config = {
		jokers = 2
	},
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = false,
	atlas = "jokers",
	pos = { x = 8, y = 0 },
	cost = 8,
	loc_vars = function(self, info_queue, card)
		return { vars = { G.localization.descriptions.Edition.e_polychrome.name, card.ability.jokers } }
	end,
	calculate = function(self, card, context)
		if context.selling_self and #G.jokers.cards > 1 then
			--print("NOT WORKING!!!")
			local first = nil
			local repeat_count = math.min((#G.jokers.cards - 1), card.ability.jokers)
			for i = 1, repeat_count do
				local pool = EMPTY(pool)
				for k, v in pairs(G.jokers.cards) do
					if v.ability.set == 'Joker' and (not v.edition) then
						table.insert(pool, v)
					end
				end
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.4,
					func = function()
						local over = false
						local eligible_card = pseudorandom_element(pool, pseudoseed("snail_pie"))
						while eligible_card.label == "j_UT_snail_pie" do
							eligible_card = pseudorandom_element(pool, pseudoseed("snail_pie"))
						end
						if first == nil then
							first = eligible_card
						else
							while first == eligible_card or eligible_card.label == "j_UT_snail_pie" do
								eligible_card = pseudorandom_element(pool, pseudoseed("snail_pie"))
							end
						end
						
						eligible_card:set_edition({ polychrome = true }, true)
						return true
					end
				}))
            end
		end
	end
}

SMODS.Joker {
	key = "empty_gun",
	loc_txt = {
		name = "Empty Gun",
		text = {
			"Retrigger all played",
			"cards if played hand",
			"is a {C:attention}secret hand{}"
		}
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 5, y = 3 },
	cost = 3,
	calculate = function(self, card, context)
		if context.repetition and context.cardarea == G.play then	
			if 
			--base game
			next(context.poker_hands["Five of a Kind"]) or
			next(context.poker_hands["Flush Five"]) or
			next(context.poker_hands["Flush House"]) or
			--age gap t4t yuri (yes of course i added support for my own mod)
			next(context.poker_hands["TWT_greaterpolycule"]) or
			--cryptid
			next(context.poker_hands["cry_Bulwark"]) or
			next(context.poker_hands["cry_Clusterfuck"]) or
			next(context.poker_hands["cry_UltPair"]) or
			next(context.poker_hands["cry_WholeDeck"]) or
			--bunco
			next(context.poker_hands["bunc_Spectrum"]) or
			next(context.poker_hands["bunc_Straight Spectrum"]) or
			next(context.poker_hands["bunc_Spectrum House"]) or
			next(context.poker_hands["bunc_Spectrum Five"])
			then
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
		poly = 2
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
		edition_values(card.ability.foil, card.ability.holo, card.ability.poly)
	end,
	update = function(self, card, dt)
		edition_values(card.ability.foil, card.ability.holo, card.ability.poly)
	end,
	remove_from_deck = function(self, card, from_debuff)
		edition_values(50, 10, 1.5)
	end,
	calculate = function(self, card, context)
		if context.game_over then
			edition_values(50, 10, 1.5)
		end
	end
}

function edition_values(foil, holo, poly)
	G.P_CENTERS.e_foil.config.chips = foil
	G.P_CENTERS.e_holo.config.mult = holo
	G.P_CENTERS.e_polychrome.config.x_mult = poly
end

SMODS.Joker {
	key = "mystery_key",
	loc_txt = {
		name = "Mystery Key",
		text = {
			"If {C:attention}first hand{} of round is",
			"a pair of {C:attention}Aces{}, destroy one",
			"of them and create a {C:spectral}Spectral{} card",
			"{C:inactive}(Must have room){}"
		}
	},
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 6, y = 3 },
	cost = 6,
	config = {
		spectral_gen = false
	},
	calculate = function(self, card, context)
		if context.setting_blind then
			card.ability.spectral_gen = false
		elseif context.destroying_card and not context.blueprint then
            if #context.full_hand == 2 and G.GAME.current_round.hands_played == 0 and not card.ability.spectral_gen then
        		for i = 1, #context.full_hand do
        			if context.full_hand[i].base.value ~= "Ace" then
        				return nil
        			end
        		end
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        delay = 0.0,
                        func = (function()
                                local card = create_card('Spectral',G.consumeables, nil, nil, nil, nil, nil, 'myst_key')
                                card:add_to_deck()
                                G.consumeables:emplace(card)
                                G.GAME.consumeable_buffer = 0
                            return true
                        end)}))
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, { message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral })
                    card.ability.spectral_gen = true
                end
               	return true
            end
            return nil
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

SMODS.Joker {
	key = "justice",
	loc_txt = {
		name = "Justice",
		text = {
			"This Joker gains",
			"{X:mult,C:white}X#1#{} Mult",
			"at end of round",
			"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"
		}
	},
	config = {
		xmult = 1,
		xmult_gain = 0.15,
		xmult_gained = false
	},
	loc_vars = function(self, info_queue, card)
		return { vars = {
			card.ability.xmult_gain,
			card.ability.xmult
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
			card.ability.xmult_gained = false
		elseif context.joker_main then
			return {
				xmult = card.ability.xmult
			}
		elseif context.end_of_round and not context.blueprint and not card.ability.xmult_gained then
            card.ability.xmult = card.ability.xmult + card.ability.xmult_gain
            card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize{ type = 'variable', key = 'a_xmult', vars = { card.ability.xmult } } })
            card.ability.xmult_gained = true
        end
	end
}

SMODS.Joker {
	key = "last_dream",
	loc_txt = {
		name = "Last Dream",
		text = {
			"{X:mult,C:white}X#1#{} Mult",
			"if all played cards",
			"are of {C:hearts}Heart{} suit"
		}
	},
	config = {
		xmult = 2.5,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult } }
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
				xmult = card.ability.xmult
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
		xmult_gain = 0.4,
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
	atlas = "jokers",
	pos = { x = 2, y = 7 },
	cost = 7,
	add_to_deck = function(self, card, from_debuff)
		G.hand:change_size(card.ability.hand_size)
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.hand:change_size(card.ability.hand_size)
	end,
	calculate = function(self, card, context)
		if context.setting_blind and not card.getting_sliced then
			ease_discard(-G.GAME.current_round.discards_left, nil, true)
        end
	end
}

SMODS.Joker {
	key = "undyne_the_undying",
	loc_txt = {
		name = "Undyne the Undying",
		text = {
			"This Joker gains {C:mult}+#1#{} Mult",
			"for every card",
			"{C:attention}discarded{} this round",
			"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)"
		}
	},
	config = {
		mult_per_card = 3,
		mult = 0
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.mult_per_card, card.ability.mult } }
	end,
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 3, y = 7 },
	cost = 7,calculate = function(self, card, context)
		if context.discard and not context.other_card.debuff and not context.blueprint then
			card.ability.mult = card.ability.mult + card.ability.mult_per_card
			return {
				message = localize { type = 'variable', key = 'a_mult',vars = { card.ability.mult }},
				colour = G.C.RED,
				delay = 0.45, 
				card = card
			}
        end
	end
}

SMODS.Joker {
	key = "new_home",
	loc_txt = {
		name = "New Home",
		text = {
			"{C:chips}+#1#{} Chips in {C:attention}final",
			"{C:attention}hand{} of round"
		}
	},
	config = {
		extra = {
			chips = 300
		}
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 7, y = 6 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips } }
	end,
	calculate = function(self, card, context)
		if context.joker_main and G.GAME.current_round.hands_left == 0 then
        	return {
				chips = card.ability.extra.chips
			}
        end
	end
}

SMODS.Joker {
	key = "muffet",
	loc_txt = {
		name = "Muffet",
		text = {
			"{X:mult,C:white}X#1#{} Mult if you",
			"have at least {C:money}$#2#{}"
		}
	},
	config = {
		extra = {
			xmult = 3,
			dollars = 30
		}
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 4, y = 6 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult, card.ability.extra.dollars } }
	end,
	calculate = function(self, card, context)
		if context.joker_main and G.GAME.dollars > to_big(card.ability.extra.dollars) then
        	return {
				xmult = card.ability.extra.xmult
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
	atlas = "jokers",
	pos = { x = 7, y = 0 },
	cost = 8,
	add_to_deck = function(self, card, from_debuff)
		if not from_debuff then
			card.ability.old_bones = G.localization.misc.dictionary.ph_mr_bones
		end
	end,
	calculate = function(self, card, context)
		if context.selling_self and G.GAME.blind.in_blind and not G.GAME.blind.boss then
			card.ability.spared = true
			G.STATE = G.STATES.HAND_PLAYED
			G.STATE_COMPLETE = true
			end_round()
		elseif context.game_over and not G.GAME.blind.boss and card.ability.spared then
			G.localization.misc.dictionary.ph_mr_bones = "Spared by Buttspie"
			return {
				message = "Spared!",
				saved = true,
				colour = G.C.RED
			}
		elseif context.ending_shop then
			G.localization.misc.dictionary.ph_mr_bones = card.config.old_bones
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

SMODS.Joker {
	key = "integrity",
	loc_txt = {
		name = "Integrity",
		text = {
			"{X:mult,C:white}X#1#{} Mult if",
			"all played cards have",
			"the {C:attention}same{} Enhancement"
		}
	},
	config = {
		xmult = 3
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult } }
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
				xmult = card.ability.xmult
			}
		end
	end
}

SMODS.Joker {
	key = "cloudy_glasses",
	loc_txt = {
		name = "Cloudy Glasses",
		text = {
			"{C:attention}Glass{} Cards can",
			"{C:attention}no longer{} break"
		}
	},
	config = {
		old_glass = 0,
	},
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 1, y = 2 },
	cost = 8,
	add_to_deck = function(self, card, from_debuff)
		card.ability.old_glass = G.GAME.probabilities.glass
		G.GAME.probabilities.glass = 0
	end,
	update = function(self, card, dt)
		G.GAME.probabilities.glass = 0
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.GAME.probabilities.glass = card.ability.old_glass
	end
}

SMODS.Joker {
	key = "instant_noodles",
	loc_txt = {
		name = "Instant Noodles",
		text = {
			"{X:mult,C:white}X#1#{} Mult",
			"Destroyed when",
			"{C:attention}Boss Blind{} is defeated"
		}
	},
	config = {
		xmult = 3
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 0, y = 3 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				xmult = card.ability.xmult
			}
		elseif context.end_of_round and context.cardarea == G.jokers and G.GAME.blind.boss and not context.blueprint then
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
				message = "Cooked!"
			}
        end
	end
}

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

SMODS.Joker {
	key = "hotland",
	loc_txt = {
		name = "Hotland",
		text = {
			"If {C:attention}first hand{} of round has",
			"only one played card, add a",
			"random {C:attention}Seal{} to it"
		}
	},
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 0, y = 6 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.money } }
	end,
	calculate = function(self, card, context)
		if context.destroying_card and not context.blueprint and #context.full_hand == 1 and G.GAME.current_round.hands_played == 0 then
			print("before")
			G.E_MANAGER:add_event(Event({
				trigger = "before",
				delay = 0.4,
				func = function()
					if not context.scoring_hand[1].seal then
						print("gm")
						context.scoring_hand[1]:set_seal(
							SMODS.poll_seal({ guaranteed = true--[[, type_key = "hotland"]] }),
							true,
							false
						)
						context.scoring_hand[1]:juice_up()
					end
					play_sound("gold_seal", 1.2, 0.4)
					card:juice_up()
					card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Sealed!", colour = G.C.ATTENTION})
					return true
				end,
			}))
			return nil
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
	rarity = 1,
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
	key = "mettaton_steak",
	loc_txt = {
		name = "Steak in the Shape of Mettaton's Face",
		text = {
			"{C:attention}Face{} cards held in hand give {C:mult}+#1#{} Mult"
		}
	},
	config = {
		mult = 15
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 9, y = 3 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.mult } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.hand and context.other_card:is_face() then
			if context.other_card.debuff then
				return {
					message = localize('k_debuffed'),
					colour = G.C.RED,
					card = context.blueprint_card or card,
				}
			else
				--[[return {
					mult = card.ability.mult
				}]]
			end
        end
	end
}

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
	key = "alphys",
	loc_txt = {
		name = "Alphys",
		text = {
			"Gives a random {C:attention}Bonus{}",
			"when Blind is selected",
			"{C:inactive}[Bonuses are {C:blue}+#1#{C:inactive} Hands,",
			"{C:red}+#2#{C:inactive} Discards, {C:attention}+#3#{C:inactive} hand size,",
			"{C:chips}+#4#{C:inactive} Chips, {C:mult}+#5#{C:inactive} Mult, {X:mult,C:white}X#6#{C:inactive} Mult,",
			"{C:inactive}retriggering all scored cards,",
			"{C:inactive}or disabling the current {C:attention}Boss Blind"
		}
	},
	config = {
		values = {
			hand_count = 2,
			discard_count = 2,
			hand_size_count = 2,
			chips_count = 120,
			mult_count = 25,
			xmult_count = 2
		},
		
		states = {
			hand = false,
			discard = false,
			hand_size = false,
			chips = false,
			mult = false,
			xmult = false,
			retrigger = false,
			chicot = false
		}
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 1, y = 6 },
	cost = 8,
	loc_vars = function(self, info_queue, card)
		return { vars = {
			card.ability.values.hand_count,
			card.ability.values.discard_count,
			card.ability.values.hand_size_count,
			card.ability.values.chips_count,
			card.ability.values.mult_count,
			card.ability.values.xmult_count,
		} }
	end,
	calculate = function(self, card, context)
		if context.setting_blind and not card.getting_sliced then
			local rand = pseudorandom("alphys")
			card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Called in!" })
			
			if G.GAME.blind.boss then
				local zeroth = 0
				local first = 1 / 8
				local second = 2 / 8
				local third = 3 / 8
				local fourth = 4 / 8
				local fifth = 5 / 8
				local sixth = 6 / 8
				local seventh = 7 / 8
				local eighth = 1
				
				if zeroth < rand and rand < first then
					card.ability.states.hand = true
				elseif first < rand and rand < second then
					card.ability.states.discard = true
				elseif second < rand and rand < third then
					card.ability.states.hand_size = true
				elseif third < rand and rand < fourth then
					card.ability.states.chips = true
				elseif fourth < rand and rand < fifth then
					card.ability.states.mult = true
				elseif fifth < rand and rand < sixth then
					card.ability.states.xmult = true
				elseif sixth < rand and rand < seventh then
					card.ability.states.retrigger = true
				elseif seventh < rand and rand < eighth then
					card.ability.states.chicot = true
				end
			else
				local zeroth = 0
				local first = 1 / 7
				local second = 2 / 7
				local third = 3 / 7
				local fourth = 4 / 7
				local fifth = 5 / 7
				local sixth = 6 / 7
				local seventh = 1
				
				if zeroth < rand and rand < first then
					card.ability.states.hand = true
				elseif first < rand and rand < second then
					card.ability.states.discard = true
				elseif second < rand and rand < third then
					card.ability.states.hand_size = true
				elseif third < rand and rand < fourth then
					card.ability.states.chips = true
				elseif fourth < rand and rand < fifth then
					card.ability.states.mult = true
				elseif fifth < rand and rand < sixth then
					card.ability.states.xmult = true
				elseif sixth < rand and rand < seventh then
					card.ability.states.retrigger = true
				end
			end
			
			if card.ability.states.hand then
				G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.values.hand_count
        		ease_hands_played(card.ability.values.hand_count)
			elseif card.ability.states.discard then
				G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.values.discard_count
        		ease_hands_played(card.ability.values.discard_count)
			elseif card.ability.states.hand_size then
				G.hand:change_size(card.ability.values.hand_size_count)
			elseif card.ability.states.chicot then
				G.E_MANAGER:add_event(Event({
					func = function()
                    	G.E_MANAGER:add_event(Event({
                    		func = function()
								G.GAME.blind:disable()
								play_sound('timpani')
								delay(0.4)
								return true
							end
						}))
                    	card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize('ph_boss_disabled') })
                		return true
                	end
                }))
			end
		elseif context.joker_main then
			if card.ability.states.chips then
				return {
					chips = card.ability.values.chips_count
				}
			elseif card.ability.states.mult then
				return {
					mult = card.ability.values.mult_count
				}
			elseif card.ability.states.xmult then
				return {
					xmult = card.ability.values.xmult_count
				}
			end
		elseif context.repetition and context.cardarea == G.play and card.ability.states.retrigger then
			return {
				message = localize('k_again_ex'),
				repetitions = 1,
				card = context.blueprint_card or card
			}
		elseif context.end_of_round and context.cardarea == G.jokers then
			if card.ability.states.hand then
				G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.values.hand_count
        		ease_hands_played(-card.ability.values.hand_count)
        		
        		card.ability.states.hand = false
			elseif card.ability.states.discard then
				G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.values.discard_count
        		ease_hands_played(-card.ability.values.discard_count)
        		
        		card.ability.states.discard = false
			elseif card.ability.states.hand_size then
				G.hand:change_size(-card.ability.values.hand_size_count)
				
				card.ability.states.hand_size = false
			elseif card.ability.states.chips then
				card.ability.states.chips = false
			elseif card.ability.states.mult then
				card.ability.states.mult = false
			elseif card.ability.states.xmult then
				card.ability.states.xmult = false
			elseif card.ability.states.retrigger then
				card.ability.states.retrigger = false
			elseif card.ability.states.chicot then
				card.ability.states.chicot = false
			end
		end
	end
}

SMODS.Joker {
	key = "true_lab",
	loc_txt = {
		name = "True Lab",
		text = {
			"Gains {C:mult}+#1#{} Mult when",
			"a card is {C:attention}copied{}",
			"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)"
		}
	},
	config = {
		mult = 0,
		mult_gain = 10,
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "deck",
	pos = { x = 0, y = 7 },
	cost = 6,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.mult_gain, card.ability.mult } }
	end,
	calculate = function(self, card, context)
		if context.copied_card and not context.blueprint then
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
