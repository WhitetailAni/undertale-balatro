--unum
SMODS.Joker {
	key = "new_home",
	config = {
		chips = 300
	},
	attributes = {
		"chips",
		"hands"
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 7, y = 6 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.chips } }
	end,
	calculate = function(self, card, context)
		if context.joker_main and G.GAME.current_round.hands_left == 0 then
			return {
				chips = card.ability.chips
			}
		end
	end
}

SMODS.Joker {
	key = "barrier",
	attributes = {
		"passive",
		"debuff"
	},
	--unlocked = false
	unlock_condition = {
		type = 'chip_score',
		chips = 100000000000
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { localize("k_debuffed") } }
	end,
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 9, y = 7 },
	cost = 7,
}

SMODS.Joker {
	key = "the_end",
	config = {
		money = 12,
	},
	attributes = {
		"economy",
		"boss_blind"
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
	calc_dollar_bonus = function(self, card)
		if G.GAME.last_blind.boss then
			return card.ability.money
		end
	end,
}

SMODS.Joker {
	key = "surface",
	config = {
		extra = {
			odds = 2,
			card_type = "Planet",
		}
	},
	attributes = {
		"chance",
		"generation",
		"consumeables",
		"planet",
		"enhancements"
	},
	--unlocked = false
	unlock_condition = { type = 'modify_deck', extra = { count = 5, enhancement = 'Stone Card', e_key = 'm_stone' } },
	loc_vars = function(self, info_queue, card)
		local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'UTDR_surface')
		info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
		return { vars = { 
			numerator, 
			denominator, 
			localize({ type = 'name_text', set = "Enhanced", key = "m_stone" }) ,
			localize("k_" .. string.lower(card.ability.extra.card_type)),
			colours = {
				G.C.SECONDARY_SET[card.ability.extra.card_type] or G.C.FILTER
			}
		} }
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
			if SMODS.has_enhancement(context.other_card, 'm_stone') and SMODS.pseudorandom_probability(card, 'UTDR_surface', 1, card.ability.extra.odds) then
				-- check if should add consumable
			local do_message = false
			if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
				do_message = true
			end
			-- create tarot
			if do_message then
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				return {
					extra = {
						message = localize('k_plus_' .. string.lower(card.ability.extra.card_type)) or ("+1 ".. localize("k_" .. string.lower(card.ability.extra.card_type))),
						colour = G.C.SECONDARY_SET[card.ability.extra.card_type] or G.C.FILTER,
						message_card = card,
						func = function() -- This is for timing purposes, everything here runs after the message
							G.E_MANAGER:add_event(Event({
								func = (function()
									SMODS.add_card {
										set = card.ability.extra.card_type,
										key_append = 'UTDR_surface' -- Optional, useful for manipulating the random seed and checking the source of the creation in `in_pool`.
									}
									G.GAME.consumeable_buffer = 0
									return true
								end)
							}))
						end
					},
				}
			end
			end
		end
	end
}

SMODS.Joker {
	key = "dummy",
	config = {
		chips = 20,
	},
	attributes = {
		"chips",
		"joker_slot"
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
	key = "toby_temmie",
	config = {
		slot_count = 1,
		slotted = false,
		in_build = false,
		odds = 2,
	},
	attributes = {
		"boss_blind",
		"tag"
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = 'tag_voucher', set = 'Tag' }
		local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.odds, 'utdr_toby_temmie')
		return { vars = { card.ability.slot_count, localize { type = 'name_text', set = 'Tag', key = 'tag_voucher' }, numerator, denominator } }
	end,
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 8, y = 8 },
	cost = 6,
	calculate = function(self, card, context)
		if context.end_of_round and context.cardarea == G.jokers and G.GAME.blind.boss and SMODS.pseudorandom_probability(card, 'utdr_toby_temmie', 1, card.ability.odds) then
			card:juice_up(0.3, 0.5)
			local tag = Tag("tag_voucher")
			add_tag(tag)
		end
	end
}

SMODS.Joker {
	key = "annoying_dog",
	config = {
		xmult = 3,
		slots = 2,
	},
	attributes = {
		"xmult",
		"passive",
		"UTDR_dog"
	},
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 5, y = 2 },
	cost = 7,
	set_badges = function(self, card, badges)
		badges[#badges + 1] = create_badge(localize("k_dog"), G.C.GASTER, G.C.ANGEL, 1.2)
	end,
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
	key = "mt_ebott",
	config = {
		hand_size = 5
	},
	attributes = {
		"hand_size",
		"passive",
		"discard"
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.hand_size } }
	end,
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 2, y = 7 },
	cost = 7,
	add_to_deck = function(self, card, from_debuff)
		G.hand:change_size(card.ability.hand_size)
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.hand:change_size(-card.ability.hand_size)
	end,
	calculate = function(self, card, context)
		if context.setting_blind and not card.getting_sliced and not context.blueprint then
			ease_discard(-G.GAME.current_round.discards_left, nil, true)
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
	config = {
		mult = 1
	},
	attributes = {
		"mult",
		"joker",
		"generation",
		"UTDR_dog"
	},
	in_pool = function()
		return false
	end,
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 6, y = 2 },
	cost = 1,
	add_to_deck = function(self, card, from_debuff)
		if not from_debuff and pseudorandom("double_negative") < 1 / 1000 then
			G.E_MANAGER:add_event(Event({
				func = function()
					card:set_edition({ negative = true }, true)
					return true
				end
			}))
		end
	end,
	--comment out this function and then start a blind with annoying dog! it's fun!!
	--oooops did i reenable it with a really slim chance..... oops!!! oooops!!!!!!!!
	set_badges = function(self, card, badges)
		badges[#badges + 1] = create_badge(localize("k_dog"), G.C.GASTER, G.C.ANGEL, 1.2)
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.mult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult = card.ability.mult
			}
		end
	end
}

--duo
SMODS.Joker {
	key = "lesser_dog",
	config = {
		mult_gain = 1,
		total_mult = 0
	},
	attributes = {
		"mult",
		"scaling",
		"joker",
		"UTDR_dog"
	},
	--unlocked = false
	unlock_condition = { type = 'hand', count = 20, hand = 'Pair' },
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "DR_jokers",
	pos = { x = 3, y = 12 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.mult_gain, card.ability.total_mult } }
	end,
	locked_loc_vars = function(self, info_queue, card)
		if G.PROFILES[G.SETTINGS.profile].hand_usage["Pair"] then
			return { vars = { G.PROFILES[G.SETTINGS.profile].hand_usage["Pair"].count } }
		else
			return { vars = { 0 } }
		end
	end,
	--unlocked = false
	set_badges = function(self, card, badges)
		badges[#badges + 1] = create_badge(localize("k_dog"), G.C.GASTER, G.C.ANGEL, 1.2)
	end,
	unlock_condition = { type = 'hand', count = 20, hand = 'Pair' },
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult = card.ability.total_mult
			}
		end
	end,
	calculate = function(self, card, context)
		if context.scaling_card and context.card.config.center.key ~= "j_UTDR_lesser_dog" then
			SMODS.scale_card(card, {
				ref_table = card.ability,
				ref_value = "total_mult",
				scalar_value = "mult_gain",
				no_message = true
			})
			
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.3,
				func = function()
					card.children.center:set_sprite_pos({
						x = 3 + math.min(6, math.floor(card.ability.total_mult / 8)), --you can pet lesser dog 55 times in UT, dividing that by the 7 different sprites available, the neck should extend every ~8 mult gains!
						y = 12
					})
					return true
				end
			}))
			
			return {
				post = {
					message = localize("k_upgrade_ex"),
					colour = G.C.MULT
				}
			}
		end
	end
}

SMODS.Joker {
	key = "doghole",
	config = {
		values = {
			chips_count = 90,
			mult_count = 15,
			xmult_count = 1.5,
			dollars_count = 2,
		},

		states = {
			chips = false,
			mult = false,
			xmult = false,
			money = false,
		}
	},
	attributes = {
		"mult",
		"chips",
		"xmult",
		"economy",
		"UTDR_dog"
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 4, y = 11 },
	cost = 8,
	set_badges = function(self, card, badges)
		badges[#badges + 1] = create_badge(localize("k_dog"), G.C.GASTER, G.C.ANGEL, 1.2)
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.values.chips_count,
				card.ability.values.mult_count,
				card.ability.values.xmult_count,
				card.ability.values.dollars_count
			}
		}
	end,
	calculate = function(self, card, context)
		if context.setting_blind and not card.getting_sliced then
			local rand = pseudorandom("doghole")

			local zeroth = 0
			local first = 1 / 4
			local second = 2 / 4
			local third = 3 / 4
			local fourth = 4 / 4

			if zeroth < rand and rand < first then
				card.ability.states.chips = true
			elseif first < rand and rand < second then
				card.ability.states.mult = true
			elseif second < rand and rand < third then
				card.ability.states.xmult = true
			elseif third < rand and rand < fourth then
				card.ability.states.money = true
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
		elseif context.individual and context.cardarea == G.play then
			return {
				dollars = card.ability.dollars_count
			}
		elseif context.end_of_round and context.cardarea == G.jokers then
			if card.ability.states.chips then
				card.ability.states.chips = false
			elseif card.ability.states.mult then
				card.ability.states.mult = false
			elseif card.ability.states.xmult then
				card.ability.states.xmult = false
			end
		end
	end
}

SMODS.Joker {
	key = "dog_shrine",
	attributes = {
		"passive",
		"UTDR_dog"
	},
	rarity = 1,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 3, y = 11 },
	pixel_size = { h = 77 },
	config = {
		money = 1,
		extra_boosters = 1
	},
	set_badges = function(self, card, badges)
		badges[#badges + 1] = create_badge(localize("k_dog"), G.C.GASTER, G.C.ANGEL, 1.2)
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.money } }
	end,
	calc_dollar_bonus = function(self, card)
		return -card.ability.money
	end,
	add_to_deck = function(self, card, from_debuff)
		SMODS.change_booster_limit(card.ability.extra_boosters)
	end,
	remove_from_deck = function(self, card, from_debuff)
		SMODS.change_booster_limit(-card.ability.extra_boosters)
	end
}

SMODS.Joker {
	key = "true_reset",
	attributes = {
		"on_sell",
		"tag",
		"destroy_card"
	},
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
				if not carb.ability.eternal then
					carb:start_dissolve()
					add_tag(Tag("tag_negative"))
				end
			end
		end
	end
}

SMODS.Joker {
	key = "mysterious_artifact",
	attributes = {
		"destroy_card",
		"generation"
	},
	rarity = 3,
	blueprint_compat = false,
	eternal_compat = false,
	atlas = "DR_jokers",
	pos = { x = 5, y = 11 },
	cost = 12,
	add_to_deck = function(self, card, from_debuff)
		play_sound("UTDR_badexplosion", 1.0, 0.7)

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
						SMODS.add_card({ key = "j_UTDR_annoying_dog" })
						return true;
					end
				}))
				return true
			end
		}))
	end
}

SMODS.Joker {
	key = "check_it_out_im_in_the_house_like_carpet",
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	cost = 3,
	pos = { x = 6, y = 11 },
	config = { extra = { hands = 0, hands_required = 3, consumable_type = "Planet" } },
	attributes = {
		"planet",
		"generation",
		"hands"
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.hands,
				card.ability.extra.hands_required,
				localize("k_" .. string.lower(card.ability.extra.consumable_type)),
			}
		}
	end,
	calculate = function(self, card, context)
		if context.after then
			local create_new_card = false
			if not context.blueprint then
				card.ability.extra.hands = card.ability.extra.hands + 1
				if card.ability.extra.hands >= card.ability.extra.hands_required then
					create_new_card = true
					card.ability.extra.hands = 0
				end
			end
			if create_new_card then
				if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
					G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
					return {
						extra = {
							message = localize('k_plus_' .. string.lower(card.ability.extra.consumable_type)),
							colour = G.C.SECONDARY_SET[card.ability.extra.consumable_type] or G.C.FILTER,
							message_card = card,
							func = function() -- This is for timing purposes, everything here runs after the message
								G.E_MANAGER:add_event(Event({
									func = (function()
										SMODS.add_card {
											set = card.ability.extra.consumable_type,
											key_append = 'UTDR_roast_chicken'
										}
										G.GAME.consumeable_buffer = 0
										return true
									end)
								}))
							end
						},
					}
				else
					-- no room
				end
			else
				if not context.blueprint then
					return {
						message = tostring(card.ability.extra.hands) ..
							"/" .. tostring(card.ability.extra.hands_required),
						colour = G.C.SECONDARY_SET[card.ability.extra.consumable_type] or G.C.FILTER
					}
				end
			end
		end
	end
}
