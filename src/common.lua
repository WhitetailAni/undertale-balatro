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
		extra = {
			mult = 10,
			chips = 20
		}
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 1, y = 0 },
	cost = 4,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips, card.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chips = card.ability.extra.chips,
				mult = card.ability.extra.mult
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
		extra = {
			xmult = 1.5,
		}
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 2, y = 0 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				Xmult = card.ability.extra.xmult
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
		extra = {
			mult = 5,
			odds = 4,
		}
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = false,
	atlas = "jokers",
	pos = { x = 3, y = 0 },
	cost = 4,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, G.GAME.probabilities.normal, card.ability.extra.odds } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card.base.value == "Ace" or context.other_card.base.value == "2" or context.other_card.base.value == "3" then
				return {
					mult = card.ability.extra.mult
				}
			end
		elseif context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
			if pseudorandom("monster_candy") < G.GAME.probabilities.normal/self.ability.extra.odds then 
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('tarot1')
						self.T.r = -0.2
						self:juice_up(0.3, 0.4)
						self.states.drag.is = true
						self.children.center.pinch.x = true
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
			"but is {C:attention}destroyed{}",
			"after scoring"
		}
	},
	config = {
		extra = {
			seven = 7,
			nine = 9,
		}
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 4, y = 0 },
	cost = 6,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.seven, card.ability.extra.nine } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card.base.value == "7" then
				return {
					mult = card.ability.extra.seven
				}
			elseif context.other_card.base.value == "9" then
				return {
					mult = card.ability.extra.nine
				}
			end
		elseif context.destroy_card and context.cardarea == G.play and not context.blueprint then
			if context.other_card.base.value == "9" then
				card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Eaten!", colour = G.C.RED})
				return {
					remove = true
				}
			end
		end
	end
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
		extra = {
			mult = 30,
			cycled = 3,
			hands_remaining = 3,
		}
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 6, y = 0 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.cycled, card.ability.extra.hands_remaining } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			if card.ability.extra.hands_remaining == 0 then
				card.ability.extra.hands_remaining = card.ability.extra.cycled
				return {
					mult = card.ability.extra.mult
				}
			end
		elseif context.after then
			if not context.blueprint then
				if card.ability.extra.hands_remaining == 0 then
					local eval = function(card)
						return card.ability.extra.hands_remaining == 0
					end
					juice_card_until(card, eval, true)
				else
					card.ability.extra.hands_remaining = card.ability.extra.hands_remaining - 1
				end
			end
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
	blueprint_compat = true,
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
		if context.joker_main then
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
	atlas = "jokers",
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
		extra = {
			chips = 40,
			nojoker = 0
		}
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 8, y = 4 },
	cost = 4,
	loc_vars = function(self, info_queue, card)
		if G.jokers ~= nil and G.jokers.config ~= nil and G.jokers.cards ~= nil and G.jokers.config.card_limit ~= nil then
			return { vars = {
				card.ability.extra.chips,
				card.ability.extra.chips * (G.jokers.config.card_limit - #G.jokers.cards)
			} }
		else 
			return { vars = {
				card.ability.extra.chips,
				card.ability.extra.chips
			} }
		end
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chips = card.ability.extra.chips * (G.jokers.config.card_limit - #G.jokers.cards)
			}
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
	key = "gerson",
	loc_txt = {
		name = "Gerson",
		text = {
			"All cards and packs in shop",
			"are an additional {C:money}#1#%{} off"
		}
	},
	config = {
		discount = 10
	},
	rarity = 1,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 9, y = 5 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.discount } }
	end,
	add_to_deck = function(self, card, from_debuff)
		G.GAME.discount_percent = G.GAME.discount_percent + card.ability.discount
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.GAME.discount_percent = G.GAME.discount_percent - card.ability.discount
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
	atlas = "jokers",
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
	key = "temmie_flakes",
	loc_txt = {
		name = "Temmie Flakes",
		text = {
			"{C:blue}pLaY twO!!!1!!{}",
			"{C:inactive}[Scored 2's give",
			"{C:chips}+#1#-#2#{C:inactive} Chips, {C:mult}+#3#-#4#{C:inactive} Mult,",
			"{X:mult,C:white}X#5#-#6#{C:inactive} Mult, or {C:money}$#7#-#8#{C:inactive}]"

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
	atlas = "jokers",
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
		chips = 70
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
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
	blueprint_compat = true,
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
			xmult = 3,
			cycled = 3,
			hands_remaining = 3,
			secret_chance = 5,
			super_secret_chance = 15
		},
		spared = false,
		old_bones = ""
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
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
		elseif context.after then
			if not context.blueprint then
				if card.ability.extra.hands_remaining == 0 then
					local eval = function(card)
						return card.ability.extra.hands_remaining == 0
					end
					juice_card_until(card, eval, true)
				else
					card.ability.extra.hands_remaining = card.ability.extra.hands_remaining - 1
				end
			end
		elseif context.selling_self and G.GAME.blind.in_blind and not G.GAME.blind.boss then
			if pseudorandom("punch_card_secret") < G.GAME.probabilities.normal / card.ability.extra.secret_chance then
				card.ability.spared = true
				G.STATE = G.STATES.HAND_PLAYED
				G.STATE_COMPLETE = true
				end_round()
			end
		elseif context.game_over and not G.GAME.blind.boss and card.ability.spared then
			G.localization.misc.dictionary.ph_mr_bones = "Redeemed the Punch Card"
			return {
				message = "Punched!",
				saved = true,
				colour = G.C.RED
			}
		elseif context.ending_shop then
			G.localization.misc.dictionary.ph_mr_bones = card.config.old_bones
        elseif context.end_of_round and context.cardarea == G.jokers and card.ability.extra.hands_remaining == 0 then
        	if pseudorandom("punch_card_super_secret") < G.GAME.probabilities.normal/card.ability.extra.super_secret_chance then
        		SMODS.add_card({ key = "j_UT_nice_cream" })
        		card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Punched!", colour = G.C.ATTENTION })
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
						card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Created!", colour = G.C.SECONDARY_SET.PLANET})
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
		chips = 30
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "jokers",
	pos = { x = 2, y = 2 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.chips } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.hand and (context.other_card.base.suit == "Clubs" or SMODS.has_any_suit(context.other_card)) then
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
	key = "mad_dummy",
	loc_txt = {
		name = "Mad Dummy",
		text = {
			"{C:red}Destroys{} {C:attention}1{} random card",
			"held in hand at end of round"
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
	pos = { x = 8, y = 5 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { G.GAME.probabilities.normal, card.ability.odds, card.ability.money } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.cardarea == G.jokers --[[and not card.ability.destroyed_card]] then
			local knife = pseudorandom_element(G.hand.cards, pseudoseed('mad_dummy'))
			G.E_MANAGER:add_event(Event({
            	trigger = 'after',
            	delay = 0.4,
            	func = function()
					play_sound('timpani')
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
                    if SMODS.has_enhancement(knife, 'm_glass') then
						knife:shatter()
					else
						knife:start_dissolve(nil, false)
					end
                    return true
                end
            }))
			card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Futile!", colour = G.C.RED})
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

