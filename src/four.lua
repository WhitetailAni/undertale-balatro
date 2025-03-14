--top
SMODS.Joker {
	key = "stained_apron",
	loc_txt = {
		name = "Stained Apron",
		text = {
			"Earn {C:money}$#1#{} on every",
			"{C:attention}other{} scored card"
		}
	},
	config = {
		money = 1,
		other_card = false
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 8, y = 2 },
	cost = 4,
	loc_vars = function(self, info_queue, card)
		return { vars = {
			card.ability.money
		} }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if card.ability.other_card then
				card.ability.other_card = false
			else
				card.ability.other_card = true
				return {
					dollars = card.ability.money
				}
			end
        end
	end
}

SMODS.Joker {
	key = "hot_dog",
	loc_txt = {
		name = "Hot Dog",
		text = {
			"Sell this card to",
			"create {C:attention}#1#{} random",
			"{C:tarot}Tarot{} cards",
			"{C:inactive}(Must have room){}"
		}
	},
	config = {
		card_count = 2
	},
	rarity = 1,
	blueprint_compat = false,
	eternal_compat = false,
	atlas = "jokers",
	pos = { x = 1, y = 3 },
	cost = 4,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.card_count } }
	end,
	calculate = function(self, card, context)
		if context.selling_self then
			for i = 1, math.min(card.ability.card_count, G.consumeables.config.card_limit - #G.consumeables.cards) do
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.4,
					func = function()
						if G.consumeables.config.card_limit > #G.consumeables.cards then
							play_sound('timpani')
							local new_card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'dog')
							new_card:add_to_deck()
							G.consumeables:emplace(new_card)
							card:juice_up(0.3, 0.5)
						end
						return true
					end
				}))
        	end
		end
	end
}

SMODS.Joker {
	key = "yaoi",
	loc_txt = {
		name = "Royal Guards",
		text = {
			"Gains {C:chips}+#1#{} Chips",
			"if played hand",
			"contains a {C:attention}#2#{}",
			"{C:inactive}(Currently {C:chips}+#3#{C:inactive} Chips)",
		}
	},
	config = {
		chip_gain = 5,
		chips = 0
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 3, y = 6 },
	cost = 4,
	loc_vars = function(self, info_queue, card)
		return { vars = {
			card.ability.chip_gain,
			G.localization.misc.poker_hands['Pair'],
			card.ability.chips
		} }
	end,
	calculate = function(self, card, context)
		if context.before and context.cardarea == G.jokers and next(context.poker_hands['Pair']) and not context.blueprint then
			card.ability.chips = card.ability.chips + card.ability.chip_gain
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
	key = "hot_cat",
	loc_txt = {
		name = "Hot Cat",
		text = {
			"Sell this card to",
			"create {C:attention}#1#{} random",
			"{C:planet}Planet{} cards",
			"{C:inactive}(Must have room){}"
		}
	},
	config = {
		card_count = 2
	},
	rarity = 1,
	blueprint_compat = false,
	eternal_compat = false,
	atlas = "jokers",
	pos = { x = 2, y = 3 },
	cost = 3,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.card_count } }
	end,
	calculate = function(self, card, context)
		if context.selling_self then
			for i = 1, math.min(card.ability.card_count, G.consumeables.config.card_limit - #G.consumeables.cards) do
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.4,
					func = function()
						if G.consumeables.config.card_limit > #G.consumeables.cards then
							play_sound('timpani')
							local new_card = create_card('Planet', G.consumeables, nil, nil, nil, nil, nil, 'cat')
							new_card:add_to_deck()
							G.consumeables:emplace(new_card)
							card:juice_up(0.3, 0.5)
						end
						return true
					end
				}))
        	end
		end
	end
}

SMODS.Joker {
	key = "burnt_pan",
	loc_txt = {
		name = "Burnt Pan",
		text = {
			"{C:tarot}+#1#{} consumable slots"
		}
	},
	config = {
		extra = {
			slots = 2,
		}
	},
	rarity = 1,
	blueprint_compat = false,
	eternal_compat = false,
	atlas = "jokers",
	pos = { x = 9, y = 2 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.slots } }
	end,
	add_to_deck = function(self, card, from_debuff)
		G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.extra.slots
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.consumeables.config.card_limit = G.consumeables.config.card_limit - card.ability.extra.slots
	end
}

--middle
--[[
if you're looking at the code and you've used this mod, you may be wondering:
"how does dog residue give another joker slot?"
well, i don't know either. i left it in cause it's funny.
because then, the dog residue is double negative
]]
SMODS.Joker {
	key = "dog_residue",
	loc_txt = {
		name = "Dog Residue",
		text = {
			"{C:mult}+#1#{} Mult, and...?"
		}
	},
	config = {
		extra = {
			mult = 1
		}
	},
	in_pool = function()
		return false
	end,
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 6, y = 2 },
	cost = 1,
	add_to_deck = function(self, card, from_debuff)
		if not from_debuff then
			card:set_edition({ negative = true }, true)
		end
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
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
	key = "cowboy_hat",
	loc_txt = {
		name = "Cowboy Hat",
		text = {
			"Played cards with",
			"{C:attention}numerical{} ranks give",
			" {C:mult}+#1#{} or {C:mult}+#2#{} Mult when scored"
		}
	},
	config = {
		low_mult = 3,
		high_mult = 5
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 4, y = 3 },
	cost = 4,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.low_mult, card.ability.high_mult } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if tonumber(context.other_card.base.value, 10) ~= nil then
				if pseudorandom("cowboy_hat") < 1/2 then
					return {
						mult = card.ability.low_mult
					}
				else
					return {
						mult = card.ability.high_mult
					}
				end
			end
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
	key = "burgerpants",
	loc_txt = {
		name = "Burgerpants",
		text = {
			"Earn {C:money}$#1#{} at",
			"end of round",
			"{C:red}-#2#{} hand size"
		}
	},
	config = {
		extra = 6,
		hand_loss = 1
	},
	rarity = 1,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 5, y = 6 },
	cost = 6,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra } }
	end,
	add_to_deck = function(self, card, from_debuff)
		G.hand:change_size(-card.ability.hand_loss)
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.hand:change_size(card.ability.hand_loss)
	end
}

--bottom
SMODS.Joker {
	key = "glamburger",
	loc_txt = {
		name = "Glamburger",
		text = {
			"{C:green}#6# in #1#{} chance for {C:mult}+#2#{} Mult",
			"{C:green}#6# in #3#{} chance to win {C:money}$#4#{}",
			"{C:green}#6# in #5#{} chance this card is",
			"{C:attention}destroyed{} at end of round"
		}
	},
	config = {
		extra = {
			mult_chance = 3,
			mult = 15,
			bigbucks_chance = 8,
			bigbucks = 10,
			munch_chance = 15
		}
	},
	rarity = 1,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 8, y = 3 },
	cost = 4,
	loc_vars = function(self, info_queue, card)
		return { vars = {
			card.ability.extra.mult_chance,
			card.ability.extra.mult,
			card.ability.extra.bigbucks_chance,
			card.ability.extra.bigbucks,
			card.ability.extra.munch_chance,
			G.GAME.probabilities.normal
		} }
	end,
	calculate = function(self, card, context)
		if context.joker_main and not context.blueprint then
			if pseudorandom("glamburger_mult") < G.GAME.probabilities.normal/card.ability.extra.mult_chance then
				SMODS.calculate_effect({ mult = card.ability.extra.mult }, card)
			end
			if pseudorandom("glamburger_money") < G.GAME.probabilities.normal/card.ability.extra.bigbucks_chance then
				SMODS.calculate_effect({ dollars = card.ability.extra.bigbucks }, card)
			end
		elseif context.end_of_round and not context.blueprint then
			if pseudorandom("glamburger_eaten") < G.GAME.probabilities.normal/card.ability.extra.bigbucks_chance then
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
					message = "Oh no!"
				}
			end
		end
	end
}

SMODS.Joker {
	key = "mettaton",
	loc_txt = {
		name = "Mettaton",
		text = {
			"If {C:attention}first hand{} of round is",
			"a single card of {C:clubs}Club{} suit",
			"destroy it and earn {C:money}$#1#{}"
		}
	},
	config = {
		money = 3
	},
	rarity = 1,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 2, y = 6 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.money } }
	end,
	calculate = function(self, card, context)
		if context.destroying_card and not context.blueprint then
			if #context.full_hand == 1 and context.full_hand[1].base.suit == "Clubs" and G.GAME.current_round.hands_played == 0 then
                SMODS.calculate_effect({ dollars = card.ability.money }, card)
               	return true
            end
            return nil
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