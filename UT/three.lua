--uno
SMODS.Joker {
	key = "punch_card",
	loc_txt = {
		name = "Punch Card",
		text = {
			"{X:mult,C:white}X#1#{} Mult every",
			"{C:attention}#2#{} hands played",
			"{C:inactive}#3# remaining"
		}
	},
	config = {
		extra = {
			xmult = 2,
			cycled = 3,
			hands_remaining = 3,
			secret_chance = 3,
			super_secret_chance = 9
		},
		spared = false,
		old_bones = ""
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 6, y = 1 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult, card.ability.extra.cycled, card.ability.extra.hands_remaining } }
	end,
	add_to_deck = function(self, card, from_debuff)
		if not from_debuff then
			card.ability.old_bones = G.localization.misc.dictionary.ph_mr_bones
		end
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			if card.ability.extra.hands_remaining == 0 then
				card.ability.extra.hands_remaining = card.ability.extra.cycled
				return {
					xmult = card.ability.extra.xmult
				}
			end
		elseif context.after and not context.blueprint then
			if card.ability.extra.hands_remaining == 0 then
				local eval = function(card)
					return card.ability.extra.hands_remaining == 0
				end
				juice_card_until(card, eval, true)
			else
				card.ability.extra.hands_remaining = card.ability.extra.hands_remaining - 1
			end
		elseif context.selling_self and G.GAME.blind.in_blind and not G.GAME.blind.boss and not context.blueprint and SMODS.pseudorandom_probability(card, "punch_card_secret", 1, card.ability.extra.secret_chance, "UT_punch_card_secret") then
			card.ability.spared = true
			G.STATE = G.STATES.HAND_PLAYED
			G.STATE_COMPLETE = true
			end_round()
		elseif context.game_over and not G.GAME.blind.boss and card.ability.spared and not context.blueprint then
			G.localization.misc.dictionary.ph_mr_bones = "Redeemed the Punch Card"
			return {
				message = "Punched!",
				saved = true,
				colour = G.C.RED
			}
		elseif context.ending_shop and not context.blueprint then
			G.localization.misc.dictionary.ph_mr_bones = card.config.old_bones
        elseif context.end_of_round and context.cardarea == G.jokers and card.ability.extra.hands_remaining == 0 then
        	if SMODS.pseudorandom_probability(card, "punch_card_super_secret", 1, card.ability.extra.super_secret_chance, "UT_punch_card_secret") then
        		SMODS.add_card({ key = "j_UTDR_nice_cream" })
        		card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Punched!", colour = G.C.ATTENTION })
        	end
        end
	end
}

SMODS.Joker {
	key = "temmie_flakes",
	loc_txt = {
		name = "Temmie Flakes",
		text = {
			"{C:blue}pLaY twO!!!1!!{}"
		}
	},
	config = {
		chip_min = 5,
		chip_max = 30,
		mult_min = 1,
		mult_max = 8,
		xmult_min = 1.1,
		xmult_max = 1.5,
		money_min = 1,
		money_max = 4
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 3, y = 2 },
	cost = 2,
	loc_vars = function(self, info_queue, card)
		return { vars = {
			card.ability.chip_min,
			card.ability.chip_max,
			card.ability.mult_min,
			card.ability.mult_max,
			card.ability.xmult_min,
			card.ability.xmult_max,
			card.ability.money_min,
			card.ability.money_max
		} }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and context.other_card.base.value == "2" then
			local rand = pseudorandom("temmie_flakes")
				
			local zeroth = 0
			local first = 1 / 4
			local second = 2 / 4
			local third = 3 / 4
			local fourth = 1
			
			if zeroth < rand and rand < first then
				return {
					chips = math.floor(pseudorandom("temmie_flakes_chips") * 25) + 5
				}
			elseif first < rand and rand < second then
				return {
					mult = math.floor(pseudorandom("temmie_flakes_mult") * 8)
				}
			elseif second < rand and rand < third then
				return {
					xmult = 1 + (math.floor(pseudorandom("temmie_flakes_xmult") * 4) / 10)
				}
			elseif third < rand and rand < fourth then
				return {
					dollars = math.floor(pseudorandom("temmie_flakes_money") * 4)
				}
			end
        end
	end
}

SMODS.Joker {
	key = "annoying_dog",
	loc_txt = {
		name = "Annoying Dog",
		text = {
			"{X:mult,C:white}X#1#{} Mult",
			"{C:red}-#2#{} consumable slots",
			"{C:joker_grey}+1 dogs"
		}
	},
	config = {
		xmult = 3,
		slots = 2,
		secret_chance = 6
	},
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 5, y = 2 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult, card.ability.slots } }
	end,
	add_to_deck = function(self, card, from_debuff)
		G.consumeables.config.card_limit = G.consumeables.config.card_limit - card.ability.slots
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.slots
	end,
	calculate = function(self, card, context)
		if context.joker_main then
        	return {
        		xmult = card.ability.xmult
        	}
        elseif context.setting_blind and context.cardarea == G.jokers and not context.blueprint and #G.jokers.cards < G.jokers.config.card_limit then
			local count = math.floor(pseudorandom("annoying_dog_count") * 10)
			play_sound("UTDR_bark", 1.0, 0.7)
			for i = 1, count do
        			SMODS.add_card({ key = "j_UTDR_dog_residue" })
        			card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Bark!", colour = G.C.ATTENTION })
        	end
        end
	end
}

SMODS.Joker {
	key = "temmie_armor",
	loc_txt = {
		name = "Temmie Armor",
		text = {
			"Played {C:attention}Enhanced 2's{} each",
			"give {X:mult,C:white}X#1#{} Mult when scored"
		}
	},
	config = {
		xmult = 2
	},
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 4, y = 2 },
	cost = 8,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and context.other_card.base.value == "2" and context.other_card.config.center_key ~= "c_base" then
			return {
				x_mult = card.ability.xmult,
				colour = G.C.MULT,
				card = context.blueprint_card or card
			}
        end
	end
}

SMODS.Joker {
	key = "mystery_key",
	loc_txt = {
		name = "Mystery Key",
		text = {
			"If {C:attention}first hand{} of round is",
			"a pair of {C:attention}Aces{}, destroy one",
			"and create a {C:spectral}Spectral{} card",
			"{C:inactive}(Must have room){}"
		}
	},
	config = {
		spectral_gen = false
	},
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 6, y = 3 },
	cost = 6,
	loc_vars = function(self, info_queue, card)
		if UTDR.config_file.deltarune then
			return { key = "j_UTDR_mystery_key_DR" }
		end
	end,
	calculate = function(self, card, context)
		if context.setting_blind and not context.blueprint then
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
	key = "mystery_key_DR",
	loc_txt = {
		name = "Mystery Key",
		text = {
			"If {C:attention}first hand{} of round is",
			"a pair of {C:attention}Aces{}, destroy one",
			"and create a {C:spectral}Prophecy{} card",
			"{C:inactive}(Must have room){}"
		}
	},
	no_collection = true,
	in_pool = function(self, args)
		return false
	end,
	atlas = "UT_jokers",
}

--dos
SMODS.Joker {
	key = "sea_tea",
	loc_txt = {
		name = "Sea Tea",
		text = {
			"{C:chips}+#1#{} Chips",
			"{C:chips}-#2#{} Chips per",
			"round played"
		}
	},
	config = {
		chips = 125,
		chips_loss = 25,
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = false,
	atlas = "UT_jokers",
	pos = { x = 0, y = 2 },
	cost = 4,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.chips, card.ability.chips_loss } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chips = card.ability.chips
			}
		elseif context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
			if card.ability.chips - card.ability.chips_loss <= 0 then 
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
					message = "Evaporated!",
					colour = G.C.BLUE
				}
			else
				card.ability.chips = card.ability.chips - card.ability.chips_loss
				return {
					message = localize{ type = 'variable', key = 'a_chips_minus', vars = { card.ability.chips_loss } },
					colour = G.C.CHIPS
				}
			end
		end
	end
}

SMODS.Joker {
	key = "glasses",
	loc_txt = {
		name = "Cloudy Glasses",
		text = {
			"{C:attention}Glass Cards{} can",
			"{C:attention}no longer{} break"
		}
	},
	config = {
		thorning_is_older = false
	},
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 1, y = 2 },
	cost = 8,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.m_glass
	end,
	add_to_deck = function(self, card, from_debuff)
		if #SMODS.find_card("j_UTDR_thornring") > 0 then
			card.ability.thornring_is_older = true
		end
	end,
	calculate = function(self, card, context)
		if context.mod_probability and not context.blueprint and context.identifier == "glass" and not card.ability.thornring_is_older then
			return {
				numerator = 0
			}
		elseif context.selling_card and context.card.label == "j_UTDR_thornring" and #SMODS.find_card("j_UTDR_thornring") == 1 and not context.blueprint then
			card.ability.thorning_is_older = false
		end
	end
}

SMODS.Joker {
	key = "gerson",
	loc_txt = {
		name = "Gerson",
		text = {
			"All cards and packs",
			"in shop are {C:money}$#1#{} cheaper"
		}
	},
	config = {
		discount = 1
	},
	rarity = 1,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 9, y = 5 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.discount } }
	end,
	add_to_deck = function(self, card, from_debuff)
		G.GAME.inflation = -card.ability.discount
		for k, v in pairs(G.I.CARD) do
			if v.set_cost then v:set_cost() end
		end
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.GAME.inflation = G.GAME.inflation + card.ability.discount
		for k, v in pairs(G.I.CARD) do
			if v.set_cost then v:set_cost() end
		end
	end
}

SMODS.Joker {
	key = "torn_notebook",
	loc_txt = {
		name = "Torn Notebook",
		text = {
			"Each card of {C:clubs}Club{}",
			"suit held in hand",
			"gives {C:chips}+#1#{} Chips"
		}
	},
	config = {
		chips = 30,
		has_scored = false
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 2, y = 2 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.chips } }
	end,
	calculate = function(self, card, context)
		if context.before and context.cardarea == G.jokers and not context.blueprint then
			card.ability.has_scored = false
		elseif context.individual and context.cardarea == G.hand and (context.other_card:is_suit("Clubs") or SMODS.has_any_suit(context.other_card)) and not card.ability.has_scored then
			if context.other_card.debuff then
				return {
					message = localize('k_debuffed'),
					colour = G.C.RED,
					card = context.blueprint_card or card,
				}
			else
				return {
					chips = card.ability.chips
				}
			end
		elseif context.after and context.cardarea == G.jokers and not context.blueprint then
			card.ability.has_scored = true
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
	atlas = "UT_jokers",
	pos = { x = 3, y = 7 },
	cost = 7,calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult = card.ability.mult
			}
		elseif context.discard and not context.other_card.debuff and not context.blueprint then
			card.ability.mult = card.ability.mult + card.ability.mult_per_card
			return {
				message = localize { type = 'variable', key = 'a_mult',vars = { card.ability.mult_gain }},
				colour = G.C.RED,
				delay = 0.45, 
				card = card
			}
		elseif context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
			card.ability.mult = 0
			return {
				message = localize('k_reset'),
				colour = G.C.RED
			}
        end
	end
}

--tres
SMODS.Joker {
	key = "mad_dummy",
	loc_txt = {
		name = "Mad Dummy",
		text = {
			"{C:red}Destroys{} {C:attention}#1#{} random card",
			"held in hand at end of round"
		}
	},
	config = {
		cards_destroyed = 1
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 8, y = 5 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.cards_destroyed } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.cardarea == G.jokers and #G.hand.cards > 0 then
			local knife = pseudorandom_element(G.hand.cards, pseudoseed('mad_dummy'))
			G.E_MANAGER:add_event(Event({
            	trigger = 'after',
            	delay = 0.1,
            	func = function()
					play_sound("UTDR_dummy", 1, 0.7)
					card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Futile!", colour = G.C.RED})
					if context.blueprint then
						context.blueprint_card:juice_up(0.3, 0.5)
					else
						card:juice_up(0.3, 0.5)
					end
					return true
				end
			}))
			G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function() 
                    if SMODS.has_enhancement(knife, "m_glass") then
						knife:shatter()
					else
						knife:start_dissolve(nil, false)
					end
					SMODS.calculate_context({remove_playing_cards = true, removed = { knife }})
                    return true
                end
            }))
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
	atlas = "UT_jokers",
	pos = { x = 0, y = 6 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.money } }
	end,
	calculate = function(self, card, context)
		if context.before and context.cardarea == G.jokers and not context.blueprint and #context.full_hand == 1 and G.GAME.current_round.hands_played == 0 then
			G.E_MANAGER:add_event(Event({
				trigger = "before",
				delay = 0.4,
				func = function()
					if not context.scoring_hand[1].seal then
						card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Sealed!", colour = G.C.ATTENTION})
						context.scoring_hand[1]:set_seal(
							SMODS.poll_seal({ guaranteed = true, type_key = "hotland" }),
							true,
							false
						)
						context.scoring_hand[1]:juice_up()
					end
					play_sound("gold_seal", 1.2, 0.4)
					card:juice_up()
					
					return true
				end,
			}))
			return nil
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
			--[["{C:inactive}[Bonuses are {C:blue}+#1#{C:inactive} Hands,",
			"{C:red}+#2#{C:inactive} Discards, {C:attention}+#3#{C:inactive} hand size,",
			"{C:chips}+#4#{C:inactive} Chips, {C:mult}+#5#{C:inactive} Mult, {X:mult,C:white}X#6#{C:inactive} Mult,",
			"{C:inactive}retriggering all scored cards,",
			"{C:inactive}or disabling the current {C:attention}Boss Blind"]]
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
	atlas = "UT_jokers",
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
			play_sound("UTDR_alphys", 1.0, 0.7)
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
				G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.values.hand_count
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
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = false,
	atlas = "UT_jokers",
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
	atlas = "UT_jokers",
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