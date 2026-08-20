--first sanctuary
SMODS.Joker {
	key = "cupwalker",
	config = {
		chip_gain = 4,
		chips = 0
	},
	attributes = {
		"chips",
		"scaling",
		"hand_type",
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 0, y = 6 },
	cost = 4,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.chip_gain,
				G.localization.misc.poker_hands['High Card'],
				card.ability.chips
			}
		}
	end,
	calculate = function(self, card, context)
		if context.before and context.cardarea == G.jokers and context.scoring_name == "High Card" and not context.blueprint then
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
	key = "bittertear",
	config = {
		bigbucks = 1,
		card_count = 30
	},
	attributes = {
		"food",
		"economy",
		"scaling"
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 6, y = 5 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.card_count, card.ability.bigbucks }
		}
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			card.ability.card_count = card.ability.card_count - 1
			SMODS.calculate_effect({ dollars = card.ability.bigbucks }, context.other_card)
			if card.ability.card_count == 0 then
				card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Drank!" })
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.4,
					func = function()
						play_sound('tarot1')
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 0.3,
							blockable = false,
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
			end
		end
	end
}

SMODS.Joker {
	key = "oldman",
	config = {
		mult_gain = 1,
		mult = 0,
		last_played_hand = nil
	},
	attributes = {
		"hand_type",
		"mult",
		"scaling",
		"reset"
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 2, y = 6 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.mult_gain, card.ability.mult } }
	end,
	calculate = function(self, card, context)
		if context.before and context.cardarea == G.jokers and not context.blueprint then
			if card.ability.last_played_hand == context.scoring_name then
				card.ability.mult = 0
				return {
					card = card,
					message = localize('k_reset'),
					colour = G.C.MULT
				}
			else
				card.ability.last_played_hand = context.scoring_name
				card.ability.mult = card.ability.mult + card.ability.mult_gain
				return {
					message = localize('k_upgrade_ex'),
					colour = G.C.MULT,
					card = card
				}
			end
		elseif context.joker_main then
			return {
				mult = card.ability.mult
			}
		end
	end
}

SMODS.Joker {
	key = "missmizzle",
	attributes = {
		"economy",
		"seals"
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_SEALS['gold_seal'] or G.P_SEALS[SMODS.Seal.badge_to_key['gold_seal'] or '']
		return { vars = { localize { type = 'name_text', set = "Other", key = 'gold_seal' } } }
	end,
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 1, y = 6 },
	cost = 6,
}

SMODS.Joker {
	key = "jackenstein",
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 9, y = 5 },
	cost = 6,
	config = {
		xmult_first = 2,
		xmult_too_long = 0.5
	},
	attributes = {
		"xmult",
		"hands",
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult_first, card.ability.xmult_too_long } }
	end,
	calculate = function(self, card, context)
		if context.before and context.cardarea == G.jokers then
			if G.GAME.current_round.hands_played == 1 then
				return {
					sound = "UTDR_your_taking_too_long",
					message = "YOUR TAKING TOO LONG"
				}
			elseif context.scoring_name == "Pair" and context.scoring_hand[1].base.value == "2" and context.scoring_hand[2].base.value == "2" then
				return {
					sound = "UTDR_your_too_too",
					message = "YOUR     TOO TOO"
				}
			end
		elseif context.joker_main then
			if G.GAME.current_round.hands_played == 0 then
				return {
					xmult = card.ability.xmult_first
				}
			else
				return {
					xmult = card.ability.xmult_too_long
				}
			end
		end
	end
}

SMODS.Joker {
	key = "axe_of_justice",
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 8, y = 5 },
	cost = 6,
	config = {
		xmult = 1.25,
		money_spent = 0
	},
	attributes = {
		"xmult",
	},
	in_pool = function(self, args)
		local money_spent = G.GAME.money_spent or 0
		return money_spent >= 150
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			return {
				xmult = card.ability.xmult
			}
		end
	end
}

SMODS.Joker {
	key = "sanctuary",
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 7, y = 4 },
	soul_pos = { x = 9, y = 7 },
	cost = 5,
	config = {
		mult_per = 0.5
	},
	attributes = {
		"mult",
		"full_deck"
	},
	loc_vars = function(self, info_queue, card)
		if G.deck then
			return { vars = { card.ability.mult_per, card.ability.mult_per * #G.deck.cards } }
		else
			return { vars = { card.ability.mult_per, card.ability.mult_per * 52 } }
		end
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult = card.ability.mult_per * #G.deck.cards
			}
		end
	end
}

SMODS.Joker {
	key = "motherfucking_gerson_boom",
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 9, y = 4 },
	cost = 6,
	config = {
		xmult_gain = 0.25,
		xmult = 1
	},
	attributes = {
		"mult",
		"scaling"
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult_gain, card.ability.xmult, localize("k_voucher") } }
	end,
	set_ability = function(self, card, initial, delay_sprites)
		card.ability.xmult = card.ability.xmult + card.ability.xmult_gain * #get_keys(G.GAME.used_vouchers)
	end,
	calculate = function(self, card, context)
		if context.voucher_redeem and not context.blueprint then
			card.ability.xmult = card.ability.xmult + card.ability.xmult_gain
			return {
				card = card,
				message = localize('k_upgrade_ex'),
				colour = G.C.MULT
			}
		elseif context.joker_main then
			return {
				xmult = card.ability.xmult
			}
		end
	end
}

--no, THIS is the second sanctuary. dumbass
SMODS.Joker {
	key = "second_sanctuary",
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 8, y = 4 },
	soul_pos = { x = 0, y = 8 },
	cost = 6,
	config = {
		xmult_gain = 0.05,
		xmult = 1,
	},
	attributes = {
		"mult",
		"scaling"
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult_gain, card.ability.xmult } }
	end,
	calculate = function(self, card, context)
		if context.drawing_cards then
			for i = 1, context.amount do
				SMODS.scale_card(card, {
					ref_table = card.ability,
					ref_value = "xmult",
					scalar_value = "xmult_gain",
					no_message = true
				})
			end
			card_eval_status_text(card, 'extra', nil, nil, nil,
				{ message = localize('k_upgrade_ex'), colour = G.C.MULT, blocking = false })
		elseif context.joker_main then
			return {
				xmult = card.ability.xmult
			}
		end
	end
}

SMODS.Joker {
	key = "sound_of_justice",
	config = {
		retrigger_chance = 4,
	},
	attributes = {
		"chance",
		"retrigger",
		"passive"
	},
	--unlocked = false
	rarity = 3,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 0, y = 9 },
	cost = 7,
	add_to_deck = function(self, card, from_debuff)
		self:change_blind_text()
	end,
	remove_from_deck = function(self, card, from_debuff)
		self:change_blind_text()
	end,
	change_blind_text = function(self)
		G.FUNCS.blind_chip_UI_scale(G.hand_text_area.blind_chips) --set the blind text during/after a round back

		--set the blind text on selection screen back
		if G.blind_select_opts then --make sure the game wont attempt to get a nonexistent UI element
			--we have to do it 1 for each blind. if you add more than the standard small, big, boss blinds, tough luck!
			--i tried to do it programatic by looping over G.blind_select_opts, but wasn't able to get it working reliably.
			local small_baby = G.blind_select_opts.small.parent
			G.blind_select_opts.small = nil
			G.blind_select_opts.small = UIBox {
				T = { small_baby.T.x, 0, 0, 0, },
				definition =
				{ n = G.UIT.ROOT, config = { align = "cm", colour = G.C.CLEAR }, nodes = {
					UIBox_dyn_container({ create_UIBox_blind_choice('Small') }, false, get_blind_main_colour('Small'), mix_colours(G.C.BLACK, get_blind_main_colour('Boss'), 0.8))
				} },
				config = { align = "bmi",
					offset = { x = 0, y = G.ROOM.T.y + 9 },
					major = small_baby,
					xy_bond = 'Weak'
				}
			}

			local big_baby = G.blind_select_opts.big.parent
			G.blind_select_opts.big = nil
			G.blind_select_opts.big = UIBox {
				T = { big_baby.T.x, 0, 0, 0, },
				definition =
				{ n = G.UIT.ROOT, config = { align = "cm", colour = G.C.CLEAR }, nodes = {
					UIBox_dyn_container({ create_UIBox_blind_choice('Big') }, false, get_blind_main_colour('Big'), mix_colours(G.C.BLACK, get_blind_main_colour('Boss'), 0.8))
				} },
				config = { align = "bmi",
					offset = { x = 0, y = G.ROOM.T.y + 9 },
					major = big_baby,
					xy_bond = 'Weak'
				}
			}

			local boss_baby = G.blind_select_opts.boss.parent
			G.blind_select_opts.boss = nil
			G.blind_select_opts.boss = UIBox {
				T = { boss_baby.T.x, 0, 0, 0, },
				definition =
				{ n = G.UIT.ROOT, config = { align = "cm", colour = G.C.CLEAR }, nodes = {
					UIBox_dyn_container({ create_UIBox_blind_choice('Boss') }, false, get_blind_main_colour('Boss'), mix_colours(G.C.BLACK, get_blind_main_colour('Boss'), 0.8))
				} },
				config = { align = "bmi",
					offset = { x = 0, y = G.ROOM.T.y + 9 },
					major = boss_baby,
					xy_bond = 'Weak'
				}
			}
		end
	end,
	loc_vars = function(self, info_queue, card)
		local probabilities_normal, odds = SMODS.get_probability_vars(card, 3, card.ability.retrigger_chance,
			'DR_sound_of_justice')
		return { vars = { probabilities_normal, odds } }
	end,
	calculate = function(self, card, context)
		if context.repetition and context.cardarea == G.play and SMODS.pseudorandom_probability(card, "sound_of_justice", 3, card.ability.retrigger_chance, "DR_sound_of_justice") then
			return {
				repetitions = 1,
			}
		elseif context.selling_self then
			G.GAME.blind:set_text(true)
		end
	end,
}

SMODS.Joker {
	key = "scarlixir",
	config = {
		money = 8,
		hole_in_my_pocket = 2,
		first_round = true
	},
	attributes = {
		"food",
		"economy",
		"scaling"
	},
	rarity = 1,
	blueprint_compat = false,
	eternal_compat = false,
	atlas = "DR_jokers",
	pos = { x = 9, y = 6 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.money, card.ability.hole_in_my_pocket } }
	end,
	calc_dollar_bonus = function(self, card)
		return card.ability.money
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
			if card.ability.first_round then
				card.ability.first_round = false
			elseif not ((card.ability.money - card.ability.hole_in_my_pocket) > 0) then
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('tarot1')
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 0.3,
							blockable = false,
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
					message = "Drank!"
				}
			else
				card.ability.money = card.ability.money - card.ability.hole_in_my_pocket
				return {
					message = "-$" .. card.ability.hole_in_my_pocket,
					colour = G.C.RED,
					sound = "coin6",
					card = card
				}
			end
		end
	end
}

SMODS.Joker {
	key = "spawn",
	config = {
		mult_gain = 2,
		mult = 0
	},
	attributes = {
		"scaling",
		"mult",
		"enhancements"
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 3, y = 6 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
		return { vars = { card.ability.mult_gain, card.ability.mult, localize({ type = 'name_text', set = "Enhanced", key = "m_stone" }) or "Stone Card" } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, "m_stone") and not context.blueprint then
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
	key = "titan",
	config = {
		repetitions = 4
	},
	attributes = {
		"enhancements",
		"retrigger"
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
		return { vars = { card.ability.repetitions, localize({ type = 'name_text', set = "Enhanced", key = "m_stone" }) or "Stone Card" } }
	end,
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 7, y = 5 },
	soul_pos = { x = 2, y = 8 },
	cost = 9,
	calculate = function(self, card, context)
		if context.repetition and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, "m_stone") then
			return {
				repetitions = card.ability.repetitions,
			}
		end
	end
}

SMODS.Joker {
	key = "princess_ribbon",
	config = {
		chips = 50
	},
	attributes = {
		"enhancements",
		"chips"
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_glass
		return { vars = { card.ability.chips, localize({ type = 'name_text', set = "Enhanced", key = "m_glass" }) or 'Glass Card' } }
	end,
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 4, y = 6 },
	cost = 5,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, "m_glass") then
			return {
				chips = card.ability.chips
			}
		end
	end
}

SMODS.Joker {
	key = "philosopher",
	attributes = {
		"passive",
		"planet"
	},
	rarity = 1,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 6, y = 6 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { localize("k_planet"), localize({ type = 'name_text', key = "p_arcana_normal", set = 'Other' }) } }
	end,
}
