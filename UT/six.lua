--unum
SMODS.Joker {
	key = "dummy",
	config = {
		chips = 20,
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 4, y = 8 },
	cost = 3,
	loc_vars = function(self, info_queue, card)
		if G.jokers ~= nil and G.jokers.cards ~= nil then
			return { vars = { card.ability.chips, card.ability.chips * #G.jokers.cards } }
		else
			return { vars = { card.ability.chips, card.ability.chips } }
		end
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chips = card.ability.chips * #G.jokers.cards
			}
		end
	end
}

SMODS.Joker {
	key = "froggit",
	config = {
		chips = 5,
		mult = 2
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.chips, card.ability.mult } }
	end,
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 5, y = 8 },
	cost = 3,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			return {
				chips = card.ability.chips,
				mult = card.ability.mult
			}
		end
	end
}

SMODS.Joker {
	key = "toby_temmie",
	config = {
		slot_count = 1,
		slotted = false,
		in_build = false
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = 'tag_voucher', set = 'Tag' }
		return { vars = { card.ability.slot_count, localize { type = 'name_text', set = 'Tag', key = 'tag_voucher' } } }
	end,
	rarity = 1,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 8, y = 8 },
	cost = 6,
	calculate = function(self, card, context)
		if context.end_of_round and context.cardarea == G.jokers and G.GAME.blind.boss and not context.blueprint then
			card:juice_up(0.3, 0.5)
			local tag = Tag("tag_voucher")
			add_tag(tag)
		end
	end
}

SMODS.Joker {
	key = "mad_mew_mew",
	config = {
		money = 5,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.money, localize("King", 'ranks') or "King", localize("Jack", 'ranks') or "Jack" } }
	end,
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 7, y = 8 },
	cost = 6,
	calculate = function(self, card, context)
		if context.remove_playing_cards then
			local count = 0
			for i = 1, #context.removed do
				local rank = context.removed[i].base.value
				if rank == "King" or rank == "Jack" then
					count = count + 1
				end
			end
			if count > 0 then
				return {
					dollars = card.ability.money * count
				}
			end
		end
	end
}

SMODS.Joker {
	key = "amalgam",
	rarity = 1,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 3, y = 8 },
	cost = 5,
	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval and #G.hand.cards>0 then
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
				pitch = pseudorandom('amalgam_sound')*.5+.5
			}
		end
	end
}

--duo
SMODS.Joker {
	key = "lesser_dog",
	config = {
		mult_gain = 1,
		mult = 0
	},
	--unlocked = false
	unlock_condition = { type = 'hand', count = 20, hand = 'Pair' },
	rarity = "UTDR_dog",
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 3, y = 12 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.mult_gain, card.ability.mult } }
	end,
	locked_loc_vars = function(self, info_queue, card)
		if G.PROFILES[G.SETTINGS.profile].hand_usage["Pair"] then
			return { vars = { G.PROFILES[G.SETTINGS.profile].hand_usage["Pair"].count } }
		else
			return { vars = { 0 } }
		end
	end,
	--unlocked = false
	unlock_condition = { type = 'hand', count = 20, hand = 'Pair' },
	calc_scaling = function(self, card, other_card, initial_value, scalar_value, args)
		if other_card.config.center.key ~= "j_UTDR_lesser_dog" then
			card.ability.mult = card.ability.mult + card.ability.mult_gain
			G.E_MANAGER:add_event(Event({
				func = function()
					self:set_sprites(card)
					card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize('k_upgrade_ex'), colour = G.C.MULT })
					return true
				end,
			}))
		else
			print("Uh Oh")
		end
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult = card.ability.mult
			}
		end
	end,
	set_sprites = function(self, card, front)
		if card.ability and card.ability.mult and card.ability.mult_gain then
			card.children.center:set_sprite_pos({
				x = 3 + math.min(6, math.floor(card.ability.mult / 8)), --you can pet lesser dog 55 times in UT, dividing that by the 7 different sprites available, the neck should extend every ~8 mult gains!
				y = 3
			})
		end
	end
}

SMODS.Joker {
	key = "CORE",
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

SMODS.Joker {
	key = "barrier",
	config = {
		money = 2,
	},
	--unlocked = false
	unlock_condition = {
		type = 'chip_score',
		chips = 100000000000
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.money, localize("k_debuffed") } }
	end,
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 9, y = 7 },
	cost = 7,
	calculate = function(self, card, context)
		if context.debuffed_individual then
			return {
				dollars = card.ability.money
			}
		end
	end
}

SMODS.Joker {
	key = "surface",
	config = {
		mult = 5,
	},
	--unlocked = false
	unlock_condition = { type = 'modify_deck', extra = { count = 5, enhancement = 'Stone Card', e_key = 'm_stone' } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
		return { vars = { card.ability.mult, localize({ type = 'name_text', set = "Enhanced", key = "m_stone" }) } }
	end,
	locked_loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
		return { vars = { localize({ type = 'name_text', set = "Enhanced", key = "m_stone" }) } }
	end,
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 0, y = 8 },
	cost = 7,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if SMODS.has_enhancement(context.other_card, 'm_stone') then
				return {
					mult = card.ability.mult
				}
			end
		end
	end
}

SMODS.Joker {
	key = "the_end",
	config = {
		money = 12,
		was_boss = false,
	},
	--unlocked = false
	unlock_condition = { type = 'win_stake', stake = 4 },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.money } }
	end,
	locked_loc_vars = function(self, info_queue, card)
		return { vars = { localize { type = 'name_text', set = 'Stake', key = G.P_CENTER_POOLS.Stake[4].key }, colours = { get_stake_col(4) } } }
	end,
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 1, y = 8 },
	cost = 6,
	calculate = function(self, card, context)
		if context.setting_blind and not context.blueprint then
			card.ability.was_boss = G.GAME.blind.boss
		end
	end,
	calc_dollar_bonus = function(self, card)
		if card.ability.was_boss then
			return card.ability.money
		end
	end,
}

--tres

SMODS.Joker {
	key = "fun_value",
	config = {
		xmult = 1.5,
		odds = 3,
		unlock_chance = 10
	},
	--unlocked = false
	unlock_condition = { type = 'win_custom' },
	loc_vars = function(card, info_queue, card)
		local probabilities_normal, odds = SMODS.get_probability_vars(card, 1, card.ability.odds, 'DR_fun_value')
		return { vars = { probabilities_normal, odds, card.ability.xmult } }
	end,
	locked_loc_vars = function(self, info_queue, card)
		local probabilities_normal, odds = SMODS.get_probability_vars(card, 1, card.ability.unlock_chance, 'DR_fun_value_locked')
		return { vars = { probabilities_normal, odds } }
	end,
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 9, y = 8 },
	cost = 8,
	calculate = function(self, card, context)
		if context.other_joker and pseudorandom("fun_value") < G.GAME.probabilities.normal / card.ability.odds then
			G.E_MANAGER:add_event(Event({
				func = function()
					context.other_joker:juice_up(0.5, 0.5)
					return true
				end,
			}))
			return {
				xmult = card.ability.xmult
			}
		end
	end,
}

SMODS.Joker {
	key = "true_reset",
	--unlocked = false
	unlock_condition = { type = 'round_win' },
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = false,
	atlas = "UT_jokers",
	pos = { x = 2, y = 8 },
	cost = 7,
	loc_vars = function(card, info_queue, card)
		info_queue[#info_queue + 1] = { key = 'tag_negative', set = 'Tag' }
		return { vars = { localize { type = 'name_text', set = 'Tag', key = 'tag_negative' } } }
	end,
	calculate = function(self, card, context)
		if context.selling_self and not context.blueprint then
			play_sound("UTDR_true_reset", 1.0, 1.5)
			for i = 1, #G.jokers.cards do
				local carb = G.jokers.cards[i]
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('tarot1')
						carb.T.r = -0.2
						carb:juice_up(0.3, 0.4)
						carb.states.drag.is = true
						carb.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 0.3,
							blockable = false,
							func = function()
								G.jokers:remove_card(carb)
								carb:remove()
								self = nil
								return true;
							end
						}))
						return true
					end
				}))
				add_tag(Tag("tag_negative"))
			end
		end
	end
}

SMODS.Joker {
	key = "gaster",
	--unlocked = false
	unlock_condition = { type = 'win_custom' },
	rarity = 3,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 2, y = 9 },
	soul_pos = { x = 3, y = 9 },
	cost = 12,
	add_to_deck = function(self, card, from_debuff)
		joker_rarity(0.666, 0.666, 0.666, 0.006)
		play_sound("UTDR_gaster", 1.0, 0.7)
		card.ability.in_build = true
	end,
	update = function(self, card, dt)
		if card.ability.in_build then
			joker_rarity(0.666, 0.666, 0.666, 0.006)
		end
	end,
	remove_from_deck = function(self, card, from_debuff)
		card.ability.in_build = false

		joker_rarity(0.7, 0.25, 0.05, 0)
	end,
	calculate = function(self, card, context)
		if context.game_over and not context.blueprint then
			card.ability.in_build = false

			joker_rarity(0.7, 0.25, 0.05, 0)
		end
	end
}

SMODS.Joker {
	key = "SURVEY_PROGRAM",
	config = {
		xmult_gain = 0.5,
		xmult = 1
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult_gain, card.ability.xmult, localize("k_spectral") } }
	end,
	locked_loc_vars = function(self, info_queue, card)
		return { vars = { G.PROFILES[G.SETTINGS.profile].career_stats.c_wins } }
	end,
	--unlocked = false
	unlock_condition = { type = 'win_custom', count = 5 },
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 0, y = 9 },
	pixel_size = { w = 71, h = 77 },
	cost = 7,
	calculate = function(self, card, context)
		if context.using_consumeable and not context.blueprint and (context.consumeable.ability.set == "Spectral") then
			card.ability.xmult = card.ability.xmult + card.ability.xmult_gain
			G.E_MANAGER:add_event(
				Event({
					func = function()
						card_eval_status_text(card, 'extra', nil, nil, nil,
							{
								message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.xmult } },
								colour =
									G.C.MULT
							});
						return true
					end
				})
			)
			return
		elseif context.joker_main then
			return {
				xmult = card.ability.xmult
			}
		end
	end
}

SMODS.Joker {
	key = "vessel",
	config = {
		xmult_gain = 0.15,
		xmult = 1
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult_gain, card.ability.xmult } }
	end,
	--unlocked = false
	unlock_condition = { type = 'money' },
	check_for_unlock = function(self, args)
		if args.type == 'money' then
			if G.PROFILES[G.SETTINGS.profile].career_stats.c_jokers_sold >= 30 then
				return true
			end
		end
	end,
	--unlock_condition = {type = 'win_custom'},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 1, y = 9 },
	cost = 6,
	calculate = function(self, card, context)
		if context.selling_card and context.card ~= card and context.card.ability.set == "Joker" and not context.blueprint then
			SMODS.scale_card(card, {
				ref_table = card.ability,
				ref_value = "xmult",
				scalar_value = "xmult_gain",
				message_colour = G.C.MULT
			})
		elseif context.joker_main then
			return {
				xmult = card.ability.xmult
			}
		end
	end
}
