SMODS.Joker {
	key = "thornring",
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 1, y = 1 },
	cost = 6,
	config = {
		glasses_are_older = false,
		in_build = false
	},
	attributes = {
		"mod_chance",
		"enhancements"
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_glass
		return { vars = { localize({ type = 'name_text', set = "Enhanced", key = "m_glass" }) } }
	end,
	add_to_deck = function(self, card, from_debuff)
		card.ability.in_build = true
		if not from_debuff then
			if #SMODS.find_card("j_UTDR_glasses") > 0 then
				card.ability.glasses_are_older = true
			end
			local noelles = SMODS.find_card("j_UTDR_noelle")
			if #noelles > 0 then
				card:set_eternal(true)
				for i = 1, #noelles do
					noelles[i]:set_eternal(true)
				end
				play_sound("UTDR_thornring_equip", 1.0, 0.7)
			else
				play_sound("UTDR_ominous", 1.0, 0.9)
			end
		end
	end,
	update = function(self, card, dt)
		if card.ability.in_build then
			G.PITCH_MOD = 0.5
		end
	end,
	remove_from_deck = function(self, card, from_debuff)
		card.ability.in_build = true
		if not from_debuff then
			play_sound("UTDR_ominous_cancel", 1.0, 0.9)
		end
	end,
	calculate = function(self, card, context)
		if context.mod_probability and not context.blueprint and context.identifier == "glass" and not card.ability.glasses_are_older then
			return {
				numerator = context.denominator
			}
		elseif context.selling_card and context.card.label == "j_UTDR_glasses" and #SMODS.find_card("j_UTDR_glasses") == 1 and not context.blueprint then
			card.ability.glasses_are_older = false
		end
	end
}

SMODS.Joker {
	key = "carol",
	attributes = {
		"passive",
		"rank"
	},
	rarity = 3,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 8, y = 10 },
	cost = 5,
}

SMODS.Joker {
	key = "find_her_dogg_girl",
	attributes = {
		"passive",
		"joker"
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { localize("k_common") } }
	end,
	rarity = 3,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 5, y = 10 },
	cost = 8,
	add_to_deck = function(self, card, from_debuff)
		joker_rarity(0, 0.25, 0.05, 0)
		card.ability.in_build = true
	end,
	update = function(self, card, dt)
		if card.ability.in_build then
			joker_rarity(0, 0.25, 0.05, 0)
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
	key = "lacquer_triangle",
	config = {
		attempted_to_forget = false
	},
	attributes = {
		"passive",
		"hands"
	},
	--unlocked = false,
	rarity = 3,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 7, y = 11 },
	cost = 12,
	in_pool = function(self, args)
		return false
	end,
	loc_vars = function(self, info_queue, card)
		if card.ability.attempted_to_forget then
			return {
				key = "j_UTDR_lacquer_washing_of_hands",
			}
		end
	end,
	calculate = function(self, card, context)
		if context.setting_blind and context.cardarea == G.jokers and G.GAME.blind.name ~= "The Needle" and not context.blueprint then
			ease_hands_played(-(G.GAME.round_resets.hands - 1))
		end
	end
}

SMODS.Joker {
	key = "shadow_crystal",
	config = {
		joker_slots = 1,
		old_ouija = "",
		old_ectoplasm = "",
		old_familiar = "",
		old_grim = "",
		old_incantation = "",
		old_wraith = "",
		old_ankh = "",
		old_hex = "",
		old_immolate = "",
	},
	attributes = {
		"passive",
		"spectral"
	},
	rarity = 3,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 3, y = 1 },
	soul_pos = { x = 5, y = 7 },
	cost = 8,
	loc_vars = function(self, info_queue, card)
		return { vars = { localize("k_spectral") } }
	end,
}

SMODS.Joker {
	key = "dogcheck",
	config = {
		totem_chance = 5,
	},
	attributes = {
		"chance",
		"prevents_death",
		"tag",
		"UTDR_dog"
	},
	--unlocked = false
	rarity = 1,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 9, y = 11 },
	cost = 6,
	set_badges = function(self, card, badges)
		badges[#badges + 1] = create_badge(localize("k_dog"), G.C.GASTER, G.C.ANGEL, 1.2)
	end,
	loc_vars = function(self, info_queue, card)
		local probabilities_normal, odds = SMODS.get_probability_vars(card, 1, card.ability.totem_chance, 'DR_dogcheck')
		return { vars = { probabilities_normal, odds } }
	end,
	calculate = function(self, card, context)
		if context.game_over and SMODS.pseudorandom_probability(card, "dogcheck", 1, card.ability.totem_chance, "DR_dogcheck") and not context.blueprint then
			G.E_MANAGER:add_event(Event({
				func = function()
					local tag = Tag(get_next_tag_key("dogcheck"))
					if tag.name == "Orbital Tag" then
						local _poker_hands = {}
						for k, v in pairs(G.GAME.hands) do
							if v.visible then
								_poker_hands[#_poker_hands + 1] = k
							end
						end
						tag.ability.orbital_hand = pseudorandom_element(_poker_hands, pseudoseed("dogcheck_orbital"))
					end
					if tag.name == "Boss Tag" then
						i = i - 1 --reroll tags can break if a booster pack tag is generated
					else
						add_tag(tag)
					end
					return true
				end
			}))
			return {
				saved = "totem_UTDR_dogcheck",
			}
		end
	end
}

SMODS.Joker {
	key = "shelter_code",
	loc_vars = function(self, info_queue, card)
		return { vars = { localize("k_uncommon"), localize("k_rare") } }
	end,
	attributes = {
		"passive",
		"joker"
	},
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 0, y = 11 },
	cost = 8,
	add_to_deck = function(self, card, from_debuff)
		joker_rarity(0.7, 0.5, 0.1, 0)
		card.ability.in_build = true
	end,
	update = function(self, card, dt)
		if card.ability.in_build then
			joker_rarity(0.7, 0.5, 0.1, 0)
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
	key = "sjelter",
	attributes = {
		"passive",
	},
	rarity = 3,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 3, y = 7 },
	cost = 9,
	loc_vars = function(self, info_queue, card)
		if math.fmod(os.time(), 256) == 0 then
			return {
				key = "j_UTDR_sjelter_sjelter",
			}
		end
	end,
	add_to_deck = function(self, card, from_debuff)
		G.GAME.listen_and_learn_big_G_is_talking = G.GAME.listen_and_learn_big_G_is_talking + 1
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.GAME.listen_and_learn_big_G_is_talking = G.GAME.listen_and_learn_big_G_is_talking - 1
	end,
}

SMODS.Joker {
	key = "ROOTS",
	config = {
		old_tarot_rate = 0,
		old_planet_rate = 0,
		old_spectral_rate = 0
	},
	attributes = {
		"passive",
	},
	--unlocked = false
	rarity = 3,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 9, y = 10 },
	cost = 7,
	add_to_deck = function(self, card, from_debuff)
		card.ability.old_tarot_rate = G.GAME.tarot_rate
		card.ability.old_planet_rate = G.GAME.planet_rate
		card.ability.old_spectral_rate = G.GAME.spectral_rate

		G.GAME.tarot_rate = 0
		G.GAME.planet_rate = 0
		G.GAME.spectral_rate = 0
	end,
	update = function(self, card, dt)
		if not (card.area and card.area.config.collection) then
			G.GAME.tarot_rate = 0
			G.GAME.planet_rate = 0
			G.GAME.spectral_rate = 0
		end
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.GAME.tarot_rate = card.ability.old_tarot_rate
		G.GAME.planet_rate = card.ability.old_planet_rate
		G.GAME.spectral_rate = card.ability.old_spectral_rate
	end,
	calculate = function(self, card, context)
		if context.voucher_redeem then
			local voucher_key = context.voucher.config.center.key
			if voucher_key == "v_planet_tycoon" or voucher_key == "v_planet_merchant" then
				--keep track of what the rate SHOULD be if planet/tarot tycoon/merchant were bought. dont let those effects go to waste! just delay em some
				card.ability.old_planet_rate = card.ability.old_planet_rate * context.voucher.config.center.config.extra
			end
			if voucher_key == "v_tarot_tycoon" or voucher_key == "v_tarot_merchant" then
				card.ability.old_tarot_rate = card.ability.old_tarot_rate * context.voucher.config.center.config.extra
			end
		elseif context.starting_shop or context.reroll_shop then
			G.GAME.tarot_rate = 0
			G.GAME.planet_rate = 0
			G.GAME.spectral_rate = 0
		end
	end,
}

SMODS.Joker {
	key = "FRIEND",
	config = {
		cards_destroyed = 2,
		deer_kidnapped = 0
	},
	attributes = {
		"spectral",
		"generation",
		"scaling",
		"reset"
	},
	loc_vars = function(self, info_queue, card)
		if #SMODS.find_card("j_UTDR_vessel") > 0 then
			return {
				key = "j_UTDR_VESSEL_FRIEND",
				vars = { card.ability.cards_destroyed, card.ability.deer_kidnapped, localize("k_spectral")
				}
			}
		end
		return { vars = { card.ability.cards_destroyed, card.ability.deer_kidnapped, localize("k_spectral") } }
	end,
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 5, y = 6 },
	cost = 10,
	calculate = function(self, card, context)
		if context.remove_playing_cards then
			for i = 1, #context.removed do
				card.ability.deer_kidnapped = card.ability.deer_kidnapped + 1

				if card.ability.deer_kidnapped == 2 or #SMODS.find_card("j_UTDR_vessel") > 0 then
					card.ability.deer_kidnapped = 0
					G.E_MANAGER:add_event(Event({
						func = (function()
							play_sound("UTDR__", 1.0, 1.0)
							return true
						end)
					}))
					if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
						G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
						G.E_MANAGER:add_event(Event({
							trigger = "before",
							delay = 0.0,
							func = (function()
								local carb = create_card("Spectral", G.consumeables, nil, nil, nil, nil, nil, "_")
								carb:add_to_deck()
								G.consumeables:emplace(carb)
								G.GAME.consumeable_buffer = 0
								return true
							end)
						}))
						card_eval_status_text(card, 'extra', nil, nil, nil,
							{ message = "__", colour = G.C.SECONDARY_SET.Spectral })
						card:juice_up(0.3, 0.4)
					end
				end
			end
		end
	end
}

SMODS.Joker {
	key = "fun_value",
	config = {
		xmult = 1.5,
		odds = 3,
		unlock_chance = 10
	},
	attributes = {
		"xmult",
		"joker",
		"chance",
	},
	--unlocked = false
	unlock_condition = { type = 'win_custom' },
	loc_vars = function(card, info_queue, card)
		local probabilities_normal, odds = SMODS.get_probability_vars(card, 1, card.ability.odds, 'DR_fun_value')
		return { vars = { probabilities_normal, odds, card.ability.xmult } }
	end,
	locked_loc_vars = function(self, info_queue, card)
		local probabilities_normal, odds = SMODS.get_probability_vars(card, 1, card.ability.unlock_chance,
			'DR_fun_value_locked')
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
	key = "SURVEY_PROGRAM",
	config = {
		xmult_gain = 0.5,
		xmult = 1
	},
	attributes = {
		"xmult",
		"scaling",
		"spectral",
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
	key = "weird_deard_gaster",
	config = {
		in_build = false
	},
	attributes = {
		"passive",
		"joker"
	},
	--unlocked = false
	unlock_condition = { type = 'win_custom' },
	rarity = 3,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 2, y = 9 },
	soul_pos = { x = 3, y = 9 },
	cost = 12,
	set_card_type_badge = function(self, card, badges)
		badges[#badges] = create_badge(localize("k_him"), G.C.GASTER, G.C.ANGEL, 1.2)
	end,
	loc_vars = function(self, info_queue, card)
		local pop_in = 500
		local pop_in_rate = 500
		local pop_delay = 1
		local scale = 0.44
		local silent = true
		local min_cycle_time = 0
		local main_start = {}
		if card.ability.in_build then
			main_start = {
				{
					n = G.UIT.C,
					config = { minw = 5, minh = 0, padding = 0.01, align = "cm" },
					nodes = {
						{
							n = G.UIT.R,
							config = { minw = 0, minh = 0, padding = 0.01, align = "cm" },
							nodes = {
								{
									n = G.UIT.O,
									config = {
										object = DynaText({
											string = {
												{ string = ' ', colour = G.C.ANGEL },
											},
											colours = { G.C.ANGEL },
											pop_in = pop_in,
											pop_in_rate = pop_in_rate,
											silent = silent,
											pop_delay = pop_delay,
											scale = scale,
											min_cycle_time = min_cycle_time
										})
									}
								},
							}
						},
						{
							n = G.UIT.R,
							config = { minw = 0, minh = 0, padding = 0.01, align = "cm" },
							nodes = {
								{
									n = G.UIT.O,
									config = {
										object = DynaText({
											string = {
												{ string = 'I SHALL', colour = G.C.ANGEL },
												{ string = 'I SHALL', colour = G.C.ANGEL },
												{ string = 'I SHALL', colour = G.C.ANGEL },
												{ string = 'I SHALL', colour = G.C.ANGEL },
												{ string = 'I SHALL', colour = G.C.ANGEL },
												{ string = 'I SHALL', colour = G.C.ANGEL },
												{ string = 'I SHALL', colour = G.C.ANGEL },
	
												{ string = 'IN',      colour = G.C.ANGEL },
												{ string = 'IN',      colour = G.C.ANGEL },
												{ string = 'IN',      colour = G.C.ANGEL },
												{ string = 'IN',      colour = G.C.ANGEL },
												{ string = 'IN',      colour = G.C.ANGEL },
												{ string = 'IN',      colour = G.C.ANGEL },
												{ string = 'IN',      colour = G.C.ANGEL },
	
												{ string = ' ',        colour = G.C.ANGEL },
												{ string = ' ',        colour = G.C.ANGEL },
												
												{ string = ' ',         colour = G.C.ANGEL },
												{ string = ' ',         colour = G.C.ANGEL },
												{ string = ' ',         colour = G.C.ANGEL },
												{ string = ' ',         colour = G.C.ANGEL },
	
												{ string = 'ALL JOKERS',        colour = G.C.ANGEL },
												{ string = 'ALL JOKERS',        colour = G.C.ANGEL },
												{ string = 'ALL JOKERS',        colour = G.C.ANGEL },
												{ string = 'ALL JOKERS',        colour = G.C.ANGEL },
												{ string = 'ALL JOKERS',        colour = G.C.ANGEL },
												{ string = 'ALL JOKERS',        colour = G.C.ANGEL },
												{ string = 'ALL JOKERS',        colour = G.C.ANGEL },
												
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = ' ',          colour = G.C.ANGEL },
	
												{ string = 'IN MATTERS',  colour = G.C.ANGEL },
												{ string = 'IN MATTERS',  colour = G.C.ANGEL },
												{ string = 'IN MATTERS',  colour = G.C.ANGEL },
												{ string = 'IN MATTERS',  colour = G.C.ANGEL },
												{ string = 'IN MATTERS',  colour = G.C.ANGEL },
												{ string = 'IN MATTERS',  colour = G.C.ANGEL },
												{ string = 'IN MATTERS',  colour = G.C.ANGEL },
	
												{ string = ' ',        colour = G.C.ANGEL },
												{ string = ' ',        colour = G.C.ANGEL },
												{ string = ' ',        colour = G.C.ANGEL },
												{ string = ' ',        colour = G.C.ANGEL },
											},
											colours = { G.C.ANGEL },
											pop_in_rate = pop_in_rate,
											silent = silent,
											pop_delay = pop_delay,
											scale = scale,
											min_cycle_time = min_cycle_time
										})
									}
								},
							}
						},
						{
							n = G.UIT.R,
							config = { minw = 0, minh = 0, padding = 0.01, align = "cm" },
							nodes = {
								{
									n = G.UIT.O,
									config = {
										object = DynaText({
											string = {
												{ string = ' ',         colour = G.C.ANGEL },
												{ string = ' ',         colour = G.C.ANGEL },
												{ string = 'NOW',      colour = G.C.ANGEL },
												{ string = 'NOW',      colour = G.C.ANGEL },
												{ string = 'NOW',      colour = G.C.ANGEL },
												{ string = 'NOW',      colour = G.C.ANGEL },
												{ string = 'NOW',      colour = G.C.ANGEL },
												
												{ string = ' ',         colour = G.C.ANGEL },
												{ string = ' ',         colour = G.C.ANGEL },
												{ string = 'YOUR',         colour = G.C.ANGEL },
												{ string = 'YOUR',         colour = G.C.ANGEL },
												{ string = 'YOUR',         colour = G.C.ANGEL },
												{ string = 'YOUR',         colour = G.C.ANGEL },
												{ string = 'YOUR',         colour = G.C.ANGEL },
												
												{ string = ' ',         colour = G.C.ANGEL },
												{ string = ' ',         colour = G.C.ANGEL },
												
												{ string = 'FROM HERE ON,',   colour = G.C.ANGEL },
												{ string = 'FROM HERE ON,',   colour = G.C.ANGEL },
												{ string = 'FROM HERE ON,',   colour = G.C.ANGEL },
												{ string = 'FROM HERE ON,',   colour = G.C.ANGEL },
	
												{ string = ' ',         colour = G.C.ANGEL },
												{ string = ' ',         colour = G.C.ANGEL },
												{ string = 'ARE TREATED',         colour = G.C.ANGEL },
												{ string = 'ARE TREATED',         colour = G.C.ANGEL },
												{ string = 'ARE TREATED',         colour = G.C.ANGEL },
												{ string = 'ARE TREATED',         colour = G.C.ANGEL },
												{ string = 'ARE TREATED',         colour = G.C.ANGEL },
												
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = ' ',          colour = G.C.ANGEL },
	
												{ string = ' ',         colour = G.C.ANGEL },
												{ string = ' ',         colour = G.C.ANGEL },
												{ string = 'OF',        colour = G.C.ANGEL },
												{ string = 'OF',        colour = G.C.ANGEL },
												{ string = 'OF',        colour = G.C.ANGEL },
												{ string = 'OF',        colour = G.C.ANGEL },
												{ string = 'OF',        colour = G.C.ANGEL },
	
												{ string = ' ',         colour = G.C.ANGEL },
												{ string = ' ',         colour = G.C.ANGEL },
												{ string = ' ',         colour = G.C.ANGEL },
												{ string = ' ',         colour = G.C.ANGEL },
											},
											colours = { G.C.ANGEL },
											pop_in = pop_in,
											pop_in_rate = pop_in_rate,
											silent = silent,
											pop_delay = pop_delay,
											scale = scale,
											min_cycle_time = min_cycle_time
										})
									}
								},
							}
						},
						{
							n = G.UIT.R,
							config = { minw = 0, minh = 0, padding = 0.01, align = "cm" },
							nodes = {
								{
									n = G.UIT.O,
									config = {
										object = DynaText({
											string = {
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = 'ASSIST',    colour = G.C.ANGEL },
												{ string = 'ASSIST',    colour = G.C.ANGEL },
												{ string = 'ASSIST',    colour = G.C.ANGEL },
	
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = ' ', 		  colour = G.C.ANGEL },
												{ string = 'ENDEAVORS.', colour = G.C.ANGEL },
												{ string = 'ENDEAVORS.', colour = G.C.ANGEL },
												{ string = 'ENDEAVORS.', colour = G.C.ANGEL },
	
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = ' ',          colour = G.C.ANGEL },
												
												{ string = ' ',         colour = G.C.ANGEL },
												{ string = ' ',         colour = G.C.ANGEL },
												{ string = ' ',         colour = G.C.ANGEL },
												{ string = ' ',         colour = G.C.ANGEL },
	
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = 'AS EQUALS',    colour = G.C.ANGEL },
												{ string = 'AS EQUALS',    colour = G.C.ANGEL },
												{ string = 'AS EQUALS',    colour = G.C.ANGEL },
												
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = ' ',          colour = G.C.ANGEL },
	
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = 'RARITY.',      colour = G.C.ANGEL },
												{ string = 'RARITY.',      colour = G.C.ANGEL },
												{ string = 'RARITY.',      colour = G.C.ANGEL },
	
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = ' ',          colour = G.C.ANGEL },
											},
											colours = { G.C.ANGEL },
											pop_in = pop_in,
											pop_in_rate = pop_in_rate,
											silent = silent,
											pop_delay = pop_delay,
											scale = scale,
											min_cycle_time = min_cycle_time
										})
									}
								},
							}
						},
						{
							n = G.UIT.R,
							config = { minw = 0, minh = 0, padding = 0.01, align = "cm" },
							nodes = {
								{
									n = G.UIT.O,
									config = {
										object = DynaText({
											string = {
												{ string = ' ', colour = G.C.ANGEL },
											},
											colours = { G.C.ANGEL },
											pop_in = pop_in,
											pop_in_rate = pop_in_rate,
											silent = silent,
											pop_delay = pop_delay,
											scale = scale,
											min_cycle_time = min_cycle_time
										})
									}
								},
							}
						}
					}
				}
			}
		else
			main_start = {
				{
					n = G.UIT.C,
					config = { minw = 5, minh = 0, padding = 0.01, align = "cm" },
					nodes = {
						{
							n = G.UIT.R,
							config = { minw = 0, minh = 0, padding = 0.01, align = "cm" },
							nodes = {
								{
									n = G.UIT.O,
									config = {
										object = DynaText({
											string = {
												{ string = ' ', colour = G.C.ANGEL },
											},
											colours = { G.C.ANGEL },
											pop_in = pop_in,
											pop_in_rate = pop_in_rate,
											silent = silent,
											pop_delay = pop_delay,
											scale = scale,
											min_cycle_time = min_cycle_time
										})
									}
								},
							}
						},
						{
							n = G.UIT.R,
							config = { minw = 0, minh = 0, padding = 0.01, align = "cm" },
							nodes = {
								{
									n = G.UIT.O,
									config = {
										object = DynaText({
											string = {
												{ string = ' ',        colour = G.C.ANGEL },
												{ string = ' ',        colour = G.C.ANGEL },
												{ string = ' ',        colour = G.C.ANGEL },
	
												{ string = ' ',        colour = G.C.ANGEL },
												{ string = ' ',        colour = G.C.ANGEL },
	
												{ string = 'HAVE YOU', colour = G.C.ANGEL },
												{ string = 'HAVE YOU', colour = G.C.ANGEL },
												{ string = 'HAVE YOU', colour = G.C.ANGEL },
												{ string = 'HAVE YOU', colour = G.C.ANGEL },
												{ string = 'HAVE YOU', colour = G.C.ANGEL },
												{ string = 'HAVE YOU', colour = G.C.ANGEL },
												{ string = 'HAVE YOU', colour = G.C.ANGEL },
	
												{ string = ' ',        colour = G.C.ANGEL },
												{ string = ' ',        colour = G.C.ANGEL },
												{ string = ' ',        colour = G.C.ANGEL },
												{ string = ' ',        colour = G.C.ANGEL },
	
												{ string = ' ',        colour = G.C.ANGEL },
												{ string = ' ',        colour = G.C.ANGEL },
	
												{ string = 'HOW',      colour = G.C.ANGEL },
												{ string = 'HOW',      colour = G.C.ANGEL },
												{ string = 'HOW',      colour = G.C.ANGEL },
												{ string = 'HOW',      colour = G.C.ANGEL },
												{ string = 'HOW',      colour = G.C.ANGEL },
												{ string = 'HOW',      colour = G.C.ANGEL },
												{ string = 'HOW',      colour = G.C.ANGEL },
	
												{ string = ' ',        colour = G.C.ANGEL },
												{ string = ' ',        colour = G.C.ANGEL },
	
												{ string = 'I',        colour = G.C.ANGEL },
												{ string = 'I',        colour = G.C.ANGEL },
												{ string = 'I',        colour = G.C.ANGEL },
												{ string = 'I',        colour = G.C.ANGEL },
												{ string = 'I',        colour = G.C.ANGEL },
												{ string = 'I',        colour = G.C.ANGEL },
												{ string = 'I',        colour = G.C.ANGEL },
	
												{ string = ' ',        colour = G.C.ANGEL },
												{ string = ' ',        colour = G.C.ANGEL },
	
												{ string = 'FOR YOU',  colour = G.C.ANGEL },
												{ string = 'FOR YOU',  colour = G.C.ANGEL },
												{ string = 'FOR YOU',  colour = G.C.ANGEL },
												{ string = 'FOR YOU',  colour = G.C.ANGEL },
												{ string = 'FOR YOU',  colour = G.C.ANGEL },
												{ string = 'FOR YOU',  colour = G.C.ANGEL },
												{ string = 'FOR YOU',  colour = G.C.ANGEL },
	
												{ string = ' ',        colour = G.C.ANGEL },
												{ string = ' ',        colour = G.C.ANGEL },
												{ string = ' ',        colour = G.C.ANGEL },
												{ string = ' ',        colour = G.C.ANGEL },
											},
											colours = { G.C.ANGEL },
											pop_in_rate = pop_in_rate,
											silent = silent,
											pop_delay = pop_delay,
											scale = scale,
											min_cycle_time = min_cycle_time
										})
									}
								},
							}
						},
						{
							n = G.UIT.R,
							config = { minw = 0, minh = 0, padding = 0.01, align = "cm" },
							nodes = {
								{
									n = G.UIT.O,
									config = {
										object = DynaText({
											string = {
												{ string = 'WELCOME.',  colour = G.C.ANGEL },
												{ string = 'WELCOME.',  colour = G.C.ANGEL },
												{ string = 'WELCOME.',  colour = G.C.ANGEL },
	
												{ string = ' ',         colour = G.C.ANGEL },
												{ string = ' ',         colour = G.C.ANGEL },
	
												{ string = ' ',         colour = G.C.ANGEL },
												{ string = ' ',         colour = G.C.ANGEL },
												{ string = 'BEEN',      colour = G.C.ANGEL },
												{ string = 'BEEN',      colour = G.C.ANGEL },
												{ string = 'BEEN',      colour = G.C.ANGEL },
												{ string = 'BEEN',      colour = G.C.ANGEL },
												{ string = 'BEEN',      colour = G.C.ANGEL },
	
												{ string = 'FOR ME?',   colour = G.C.ANGEL },
												{ string = 'FOR ME?',   colour = G.C.ANGEL },
												{ string = 'FOR ME?',   colour = G.C.ANGEL },
												{ string = 'FOR ME?',   colour = G.C.ANGEL },
	
												{ string = ' ',         colour = G.C.ANGEL },
												{ string = ' ',         colour = G.C.ANGEL },
	
												{ string = ' ',         colour = G.C.ANGEL },
												{ string = ' ',         colour = G.C.ANGEL },
												{ string = ' ',         colour = G.C.ANGEL },
												{ string = ' ',         colour = G.C.ANGEL },
												{ string = ' ',         colour = G.C.ANGEL },
												{ string = ' ',         colour = G.C.ANGEL },
												{ string = ' ',         colour = G.C.ANGEL },
	
												{ string = ' ',         colour = G.C.ANGEL },
												{ string = ' ',         colour = G.C.ANGEL },
	
												{ string = ' ',         colour = G.C.ANGEL },
												{ string = ' ',         colour = G.C.ANGEL },
												{ string = 'HAVE BEEN', colour = G.C.ANGEL },
												{ string = 'HAVE BEEN', colour = G.C.ANGEL },
												{ string = 'HAVE BEEN', colour = G.C.ANGEL },
												{ string = 'HAVE BEEN', colour = G.C.ANGEL },
												{ string = 'HAVE BEEN', colour = G.C.ANGEL },
	
												{ string = ' ',         colour = G.C.ANGEL },
												{ string = ' ',         colour = G.C.ANGEL },
	
												{ string = ' ',         colour = G.C.ANGEL },
												{ string = ' ',         colour = G.C.ANGEL },
												{ string = 'AS',        colour = G.C.ANGEL },
												{ string = 'AS',        colour = G.C.ANGEL },
												{ string = 'AS',        colour = G.C.ANGEL },
												{ string = 'AS',        colour = G.C.ANGEL },
												{ string = 'AS',        colour = G.C.ANGEL },
	
												{ string = ' ',         colour = G.C.ANGEL },
												{ string = ' ',         colour = G.C.ANGEL },
												{ string = ' ',         colour = G.C.ANGEL },
												{ string = ' ',         colour = G.C.ANGEL },
											},
											colours = { G.C.ANGEL },
											pop_in = pop_in,
											pop_in_rate = pop_in_rate,
											silent = silent,
											pop_delay = pop_delay,
											scale = scale,
											min_cycle_time = min_cycle_time
										})
									}
								},
							}
						},
						{
							n = G.UIT.R,
							config = { minw = 0, minh = 0, padding = 0.01, align = "cm" },
							nodes = {
								{
									n = G.UIT.O,
									config = {
										object = DynaText({
											string = {
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = ' ',          colour = G.C.ANGEL },
	
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = ' ',          colour = G.C.ANGEL },
	
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = 'LOOKING',    colour = G.C.ANGEL },
												{ string = 'LOOKING',    colour = G.C.ANGEL },
												{ string = 'LOOKING',    colour = G.C.ANGEL },
	
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = ' ',          colour = G.C.ANGEL },
	
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = ' ',          colour = G.C.ANGEL },
	
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = 'WONDERFUL.', colour = G.C.ANGEL },
												{ string = 'WONDERFUL.', colour = G.C.ANGEL },
												{ string = 'WONDERFUL.', colour = G.C.ANGEL },
												{ string = 'WONDERFUL.', colour = G.C.ANGEL },
	
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = ' ',          colour = G.C.ANGEL },
	
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = 'LOOKING',    colour = G.C.ANGEL },
												{ string = 'LOOKING',    colour = G.C.ANGEL },
												{ string = 'LOOKING',    colour = G.C.ANGEL },
	
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = ' ',          colour = G.C.ANGEL },
	
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = 'WELL.',      colour = G.C.ANGEL },
												{ string = 'WELL.',      colour = G.C.ANGEL },
												{ string = 'WELL.',      colour = G.C.ANGEL },
	
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = ' ',          colour = G.C.ANGEL },
												{ string = ' ',          colour = G.C.ANGEL },
											},
											colours = { G.C.ANGEL },
											pop_in = pop_in,
											pop_in_rate = pop_in_rate,
											silent = silent,
											pop_delay = pop_delay,
											scale = scale,
											min_cycle_time = min_cycle_time
										})
									}
								},
							}
						},
						{
							n = G.UIT.R,
							config = { minw = 0, minh = 0, padding = 0.01, align = "cm" },
							nodes = {
								{
									n = G.UIT.O,
									config = {
										object = DynaText({
											string = {
												{ string = ' ', colour = G.C.ANGEL },
											},
											colours = { G.C.ANGEL },
											pop_in = pop_in,
											pop_in_rate = pop_in_rate,
											silent = silent,
											pop_delay = pop_delay,
											scale = scale,
											min_cycle_time = min_cycle_time
										})
									}
								},
							}
						}
					}
				}
			}
		end
		return { main_start = main_start, background_colour = G.C.CLEAR }
	end,
	add_to_deck = function(self, card, from_debuff)
		joker_rarity(0.666, 0.666, 0.666, 0.006)
		play_sound("UTDR_gaster", 1.0, 0.7)
		card.ability.in_build = true
		ease_background_colour { new_colour = G.C.GASTER, contrast = 1 }
	end,
	update = function(self, card, dt)
		if card.ability.in_build then
			joker_rarity(0.666, 0.666, 0.666, 0.006)
			ease_background_colour { new_colour = G.C.GASTER, contrast = 1 }
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
	key = "vessel",
	config = {
		xmult_gain = 0.15,
		xmult_loss = -0.5,
		xmult = 1
	},
	attributes = {
		"scaling",
		"xmult",
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult_gain, -1 * card.ability.xmult_loss, card.ability.xmult } }
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
	get_weight = function(self, weight)
		local protein_count = #SMODS.find_card("j_egg")
		local multiplier = 1
		if protein_count == 1 then
			multiplier = 4
		elseif protein_count == 2 then
			multiplier = 7
		elseif protein_count == 3 then
			multiplier = 9
		elseif protein_count >= 4 then
			multiplier = 10
		end
		return weight * multiplier
	end,
	calculate = function(self, card, context)
		if context.selling_card and context.card ~= card and context.card.ability.set == "Joker" and not context.blueprint then
			SMODS.scale_card(card, {
				ref_table = card.ability,
				ref_value = "xmult",
				scalar_value = "xmult_gain",
				message_colour = G.C.MULT
			})
		end
		if context.end_of_round and context.game_over == false and context.main_eval and context.beat_boss and not context.blueprint then
			SMODS.scale_card(card, {
				ref_table = card.ability,
				ref_value = "xmult",
				scalar_value = "xmult_loss",
				message_colour = G.C.MULT,
				scaling_message = {
					message = localize("k_downgrade_ex"),
					colour = G.C.MULT,
				}
			})
			if card.ability.xmult < 1.0 then
				card.ability.xmult = 1.0
			end
		end
		if context.joker_main then
			return {
				xmult = card.ability.xmult
			}
		end
	end
}

SMODS.Joker {
	key = "man",
	attributes = {
		"generation",
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 4, y = 1 },
	cost = 5,
	calculate = function(self, card, context)
		if context.setting_blind and context.cardarea == G.jokers and #G.jokers.cards < G.jokers.config.card_limit then
			SMODS.add_card({
				set = "Joker",
				area = G.jokers,
				key = "j_egg"
			})
			card:juice_up(0.3, 0.4)
			play_sound("UTDR_egg", 1.0, 1.0)
		end
	end
}
