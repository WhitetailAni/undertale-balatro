--top
SMODS.Joker {
	key = "true_lab",
	config = {
		mult = 0,
		mult_gain = 10,
	},
	attributes = {
		"scaling",
		"mult",
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "UT_jokers",
	pos = { x = 0, y = 7 },
	cost = 6,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.mult_gain, card.ability.mult } }
	end,
	calculate = function(self, card, context)
		if context.copied_card and not context.blueprint then
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
	key = "burnt_pan",
	config = {
		slots = 2,
		--chips_per = 40,
	},
	attributes = {
		"scaling",
		"chips",
		"passive"
	},
	rarity = 1,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 9, y = 2 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		if G.consumeables then
			return { vars = { --[[card.ability.chips_per,]] card.ability.slots, --[[card.ability.chips_per * #G.consumeables.cards]] } }
		else
			return { vars = { --[[card.ability.chips_per,]] card.ability.slots, --[[0]] } }
		end
	end,
	add_to_deck = function(self, card, from_debuff)
		G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.slots
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.consumeables.config.card_limit = G.consumeables.config.card_limit - card.ability.slots
	end,
	--[[
	calculate = function(self, card, context)
		if context.joker_main and context.cardarea == G.jokers then
			return {
				chips = card.ability.chips_per * #G.consumeables.cards
			}
		end
	end
	]]
}

SMODS.Joker {
	key = "yaoi",
	config = {
		chip_gain = 5,
		chips = 0
	},
	attributes = {
		"scaling",
		"chips",
		"hand_type",
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "UT_jokers",
	pos = { x = 3, y = 6 },
	cost = 4,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.chip_gain,
				G.localization.misc.poker_hands['Pair'],
				card.ability.chips
			}
		}
	end,
	calculate = function(self, card, context)
		if context.before and context.cardarea == G.jokers and next(context.poker_hands['Pair']) and not context.blueprint then
			SMODS.scale_card(card, {
				ref_table = card.ability,
				ref_value = "chips",
				scalar_value = "chip_gain",
				message_colour = G.C.CHIPS
			})
		elseif context.joker_main then
			return {
				chips = card.ability.chips
			}
		end
	end
}

SMODS.Joker {
	key = "stained_apron",
	config = {
		money = 1,
		other_card = false
	},
	attributes = {
		"economy",
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 8, y = 2 },
	cost = 4,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.money
			}
		}
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
	key = "amalgam",
	attributes = {
		"passive",
		"rank",
		"suit"
	},
	rarity = 1,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 3, y = 8 },
	cost = 5,
	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval and #G.hand.cards > 0 then
			for i = 1, #G.hand.cards do
				-- Randomize Suit & Rank
				local suit = pseudorandom_element(SMODS.Suits, 'amalgam_suit')
				local rank = pseudorandom_element(SMODS.Ranks, 'amalgam_rank')

				-- Change them
				G.E_MANAGER:add_event(Event({
					func = function()
						local c = G.hand.cards[i]
						c:juice_up()
						SMODS.change_base(c, suit.key, rank.key)
						return true
					end
				}))
			end

			return {
				message = localize("k_UTDR_upgrade_qu"),
				sound = "UTDR_amalgam",
				pitch = pseudorandom('amalgam_sound') * .5 + .5
			}
		end
	end
}

SMODS.Joker {
	key = "hot_dog",
	config = {
		in_build = false
	},
	attributes = {
		"tarot",
		"generation",
		"on_sell",
		"food",
		"UTDR_dog"
	},
	rarity = 1,
	blueprint_compat = false,
	eternal_compat = false,
	atlas = "UT_jokers",
	pos = { x = 1, y = 3 },
	cost = 4,
	set_badges = function(self, card, badges)
		badges[#badges + 1] = create_badge(localize("k_dog"), G.C.GASTER, HEX('ffffff'), 1.2)
	end,
	loc_vars = function(self, info_queue, card)
		if card.ability.in_build then
			return { vars = { G.consumeables.config.card_limit, localize("k_tarot") } }
		else
			return { vars = { localize("k_tarot") } }
		end
	end,
	add_to_deck = function(self, card, from_debuff)
		card.ability.in_build = true
	end,
	remove_from_deck = function(self, card, from_debuff)
		card.ability.in_build = false
	end,
	calculate = function(self, card, context)
		if context.selling_self and not context.blueprint then
			play_sound("UTDR_bark", 1, 0.7)
			for i = 1, G.consumeables.config.card_limit - #G.consumeables.cards do
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
	key = "glamburger",
	config = {
		mult_chance = 3,
		mult = 15,
		bigbucks_chance = 8,
		bigbucks = 10,
		munch_chance = 10
	},
	attributes = {
		"mult",
		"economy",
		"chance",
		"food"
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = false,
	atlas = "UT_jokers",
	pos = { x = 8, y = 3 },
	cost = 4,
	loc_vars = function(self, info_queue, card)
		local probabilities_normal, mult_chance = SMODS.get_probability_vars(card, 1, card.ability.mult_chance,
			"UT_glamburger_mult")
		local _, bigbucks_chance = SMODS.get_probability_vars(card, 1, card.ability.bigbucks_chance,
			"UT_glamburger_money")
		local _, munch_chance = SMODS.get_probability_vars(card, 1, card.ability.munch_chance, "UT_glamburger_munch")
		return {
			vars = {
				mult_chance,
				card.ability.mult,
				bigbucks_chance,
				card.ability.bigbucks,
				munch_chance,
				probabilities_normal
			}
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			if SMODS.pseudorandom_probability(card, "glamburger_mult", 1, card.ability.mult_chance, "UT_glamburger_mult") then
				SMODS.calculate_effect({ mult = card.ability.mult }, card)
			end
			if SMODS.pseudorandom_probability(card, "glamburger_money", 1, card.ability.bigbucks_chance, "UT_glamburger_money") then
				SMODS.calculate_effect({ dollars = card.ability.bigbucks }, card)
			end
		elseif context.end_of_round and not context.blueprint then
			if SMODS.pseudorandom_probability(card, "glamburger_munch", 1, card.ability.munch_chance, "UT_glamburger_munch") then
				card:start_dissolve()
				return {
					message = localize("k_UTDR_oh_no_ex")
				}
			end
		end
	end
}

SMODS.Joker {
	key = "muffet",
	config = {
		hand_size = 2,
		dollars = 30,
		size_increased = false,
		in_build = false
	},
	attributes = {
		"hand_size",
	},
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 4, y = 6 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.hand_size, card.ability.dollars } }
	end,
	add_to_deck = function(self, card, from_debuff)
		card.ability.in_build = true
	end,
	update = function(self, card, dt)
		if card.ability.in_build then
			if G.GAME.dollars >= card.ability.dollars then
				if not size_increased then
					G.hand:change_size(card.ability.hand_size)
					size_increased = true
				end
			else
				if size_increased then
					G.hand:change_size(-card.ability.hand_size)
					size_increased = false
				end
			end
		end
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.hand:change_size(-card.ability.hand_size)
		card.ability.in_build = false
	end
}

SMODS.Joker {
	key = "mettaton_steak",
	config = {
		mult = 15,
		has_scored = false
	},
	attributes = {
		"food",
		"face",
		"mult"
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 9, y = 3 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.mult, localize("k_face_cards") } }
	end,
	calculate = function(self, card, context)
		if context.before and context.cardarea == G.jokers and not context.blueprint then
			card.ability.has_scored = false
		elseif context.individual and context.cardarea == G.hand and context.other_card:is_face() and not card.ability.has_scored then
			return {
				mult = card.ability.mult
			}
		elseif context.after and context.cardarea == G.jokers and not context.blueprint then
			card.ability.has_scored = true
		end
	end
}

SMODS.Joker {
	key = "hot_cat",
	config = {
		in_build = false
	},
	attributes = {
		"planet",
		"generation",
		"on_sell",
		"food"
	},
	rarity = 1,
	blueprint_compat = false,
	eternal_compat = false,
	atlas = "UT_jokers",
	pos = { x = 2, y = 3 },
	cost = 3,
	loc_vars = function(self, info_queue, card)
		if card.ability.in_build then
			return { vars = { G.consumeables.config.card_limit, localize("k_planet") } }
		else
			return { vars = { localize("k_planet") } }
		end
	end,
	add_to_deck = function(self, card, from_debuff)
		card.ability.in_build = true
	end,
	remove_from_deck = function(self, card, from_debuff)
		card.ability.in_build = false
	end,
	calculate = function(self, card, context)
		if context.selling_self and not context.blueprint then
			play_sound("UTDR_meow", 1.12, 0.7)
			for i = 1, G.consumeables.config.card_limit do
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
	key = "burgerpants",
	config = {
		money = 6,
		hand_loss = 1
	},
	attributes = {
		"economy",
		"hand_size",
	},
	rarity = 1,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 5, y = 6 },
	cost = 6,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.money, card.ability.hand_loss } }
	end,
	add_to_deck = function(self, card, from_debuff)
		G.hand:change_size(-card.ability.hand_loss)
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.hand:change_size(card.ability.hand_loss)
	end,
	calc_dollar_bonus = function(self, card)
		return card.ability.money
	end,
}

SMODS.Joker {
	key = "cowboy_hat",
	config = {
		low_mult = 3,
		high_mult = 5
	},
	attributes = {
		"chance",
		"mult",
		"rank",
		"two",
		"three",
		"four",
		"five",
		"six",
		"seven",
		"eight",
		"nine",
		"ten"
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 4, y = 3 },
	cost = 4,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.low_mult, card.ability.high_mult } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if tonumber(context.other_card.base.value, 10) ~= nil and not SMODS.has_enhancement(context.other_card, "m_stone") then
				if pseudorandom("cowboy_hat") < 1 / 2 then
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
	key = "mettaton_ex",
	config = {
		xmult_per = 0.1,
		money = 5
	},
	attributes = {
		"xmult",
	},
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 6, y = 6 },
	cost = 8,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult_per, card.ability.money, (1 + card.ability.xmult_per * math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0)) / card.ability.money)) } }
	end,
	calculate = function(self, card, context)
		if context.joker_main and math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0)) / card.ability.money) >= 1 then
			return {
				xmult = 1 +
					card.ability.xmult_per *
					math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0)) / card.ability.money)
			}
		end
	end
}

SMODS.Joker {
	key = "empty_gun",
	attributes = {
		"hand_type",
		"hands",
		"retrigger"
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 5, y = 3 },
	cost = 3,
	calculate = function(self, card, context)
		if context.repetition and context.cardarea == G.play and G.GAME.current_round.hands_played == 0 then
			if played_secret_hand(context.poker_hands) then
				return {
					repetitions = 1,
				}
			end
		end
	end
}

SMODS.Joker {
	key = "CORE",
	attributes = {
		"hand_type",
		"passive",
	},
	--unlocked = false
	unlock_condition = { type = 'discard_custom' },
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 8, y = 7 },
	cost = 8,
	loc_vars = function(self, info_queue, card)
		return { vars = { G.localization.misc.poker_hands['Straight'], G.localization.misc.poker_hands['Straight Flush'] } }
	end,
	locked_loc_vars = function(self, info_queue, card)
		return { vars = { G.localization.misc.poker_hands['Straight'] } }
	end,
	calculate = function(self, card, context)
		if context.evaluate_poker_hand and context.scoring_name == "Straight" and not context.blueprint then
			context.poker_hands["Flush"] = context.poker_hands["Straight"]
			return {
				replace_scoring_name = "Straight Flush"
			}
		end
	end
}
