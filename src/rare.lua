SMODS.Joker {
	key = "human_soul",
	loc_txt = {
		name = "Human Soul",
		text = {
			"{X:mult,C:white}X#1#{} Mult for",
			"each {C:attention}Joker{} card",
			"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"
		}
	},
	config = {
		extra = {
			xmult = 1.5,
		}
	},
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 0, y = 0 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		if G.jokers ~= nil and G.jokers.cards ~= nil then
			return { vars = { card.ability.extra.xmult, card.ability.extra.xmult * #G.jokers.cards } }
		else
			return { vars = { card.ability.extra.xmult, card.ability.extra.xmult } }
		end
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				xmult = card.ability.extra.xmult * #G.jokers.cards
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
			chips = 20,
			card_count = 0,
		}
	},
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 5, y = 4 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips, card.ability.extra.chips * card.ability.extra.card_count } }
	end,
	calculate = function(self, card, context)
		if (context.cards_destroyed or context.playing_card_added) and not context.blueprint then
			G.E_MANAGER:add_event(Event({
				func = function()
					G.E_MANAGER:add_event(Event({
						func = function()
							card.ability.extra.card_count = card.ability.extra.card_count + 1
							return true
						end
					}))
					card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips * card.ability.extra.card*count}}})
					return true
                end
            }))
        elseif context.joker_main then
        	return {
        		chips = card.ability.extra.chips * card.ability.extra.card_count
        	}
        end
	end
}

SMODS.Joker {
	key = "annoying_dog",
	loc_txt = {
		name = "Annoying Dog",
		text = {
			"{X:mult,C:white}X#1#{} Mult",
			"{C:red}-#2#{} consumable slots"
		}
	},
	config = {
		extra = {
			xmult = 4,
			slots = 2,
			secret_chance = 6
		}
	},
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 5, y = 2 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult, card.ability.extra.slots } }
	end,
	add_to_deck = function(self, card, from_debuff)
		G.consumeables.config.card_limit = G.consumeables.config.card_limit - card.ability.extra.slots
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.extra.slots
	end,
	calculate = function(self, card, context)
		if context.joker_main then
        	return {
        		xmult = card.ability.extra.xmult
        	}
        elseif context.end_of_round and context.cardarea == G.jokers then
        	if pseudorandom("annoying_dog") < G.GAME.probabilities.normal/card.ability.extra.secret_chance then
        		SMODS.add_card({ key = "j_UT_dog_residue" })
        		card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, { message = "Bark!", colour = G.C.ATTENTION })
        	end
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
		extra = {
			mult = 99,
			hand_loss = 2
		}
	},
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 6, y = 4 },
	cost = 8,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.hand_loss } }
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
        		mult = card.ability.extra.mult
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
	key = "mettaton_ex",
	loc_txt = {
		name = "Mettaton EX",
		text = {
			"{X:mult,C:white}X#1#{} Mult for every",
			"{C:money}$#2#{} you have",
			"{C:inactive}(Currently {X:mult,C:white}X#3#{C:inactive} Mult)"
		}
	},
	config = {
		extra = {
			xmult_per = 0.1,
			money = 5
		}
	},
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 6, y = 6 },
	cost = 8,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult_per, card.ability.extra.money, (1 + card.ability.extra.xmult_per*math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0))/card.ability.extra.money)) } }
	end,
	calculate = function(self, card, context)
		if context.joker_main and to_number(math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0))/card.ability.extra.money)) >= 1 then
        	return {
				xmult = 1 + to_number(card.ability.extra.xmult_per*math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0))/card.ability.extra.money))
			}
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
	atlas = "jokers",
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
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 0, y = 5 },
	cost = 9,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult } }
	end,
	calculate = function(self, card, context)
		if context.setting_blind and not (context.blueprint_card or card).getting_sliced and #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
			local uncommon_or_rare = pseudorandom("toriel")
			G.GAME.joker_buffer = G.GAME.joker_buffer + math.min(1, G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer))
			if uncommon_or_rare < 1/4 then
				G.E_MANAGER:add_event(Event({
                    func = function() 
                        local card = create_card('Joker', G.jokers, nil, 1, nil, nil, nil, 'toriel')
						card:add_to_deck()
						G.jokers:emplace(card)
						card:start_materialize()
						G.GAME.joker_buffer = 0
                        return true
                    end
                }))   
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, { message = localize('k_plus_joker'), colour = G.C.GREEN })
			else
				G.E_MANAGER:add_event(Event({
                    func = function() 
                        local card = create_card('Joker', G.jokers, nil, 0.75, nil, nil, nil, 'toriel')
						card:add_to_deck()
						G.jokers:emplace(card)
						card:start_materialize()
						G.GAME.joker_buffer = 0
                        return true
                    end
                }))   
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, { message = localize('k_plus_joker'), colour = G.C.RED })
			end
        end
	end
}

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