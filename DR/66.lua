SMODS.Joker {
	key = "thornring",
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 1, y = 1 },
	cost = 6,
	config = {
		xmult_first = 2,
		xmult_too_long = 0.5,
		glasses_are_older = false,
		in_build = false
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
	rarity = 3,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 8, y = 10 },
	cost = 5,
}

SMODS.Joker {
	key = "find_her_dogg_girl",
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
		hands_lost = 1,
	},
	unlocked = false,
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
		return { vars = { card.ability.hands_lost } }
	end,
	add_to_deck = function(self, card, from_debuff)
		ease_hands_played(-card.ability.hands_lost)
	end,
	remove_from_deck = function(self, card, from_debuff)
		ease_hands_played(card.ability.hands_lost)
	end,
	calculate = function(self, card, context)
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
	add_to_deck = function(self, card, from_debuff)
		card.ability.old_ouija = G.localization.descriptions.Spectral.c_ouija.text
		G.localization.descriptions.Spectral.c_ouija.text = { "Converts all cards", "in hand to a single",
			"random {C:attention}rank" }

		card.ability.old_ectoplasm = G.localization.descriptions.Spectral.c_ectoplasm.text
		G.localization.descriptions.Spectral.c_ectoplasm.text = { "Add {C:dark_edition}Negative{} to",
			"a random {C:attention}Joker" }

		card.ability.old_familiar = G.localization.descriptions.Spectral.c_familiar.text
		G.localization.descriptions.Spectral.c_familiar.text = { "Add {C:attention}#1#{} random {C:attention}Enhanced",
			"{C:attention}face cards{} to your hand" }

		card.ability.old_grim = G.localization.descriptions.Spectral.c_grim.text
		G.localization.descriptions.Spectral.c_grim.text = { "Add {C:attention}#1#{} random {C:attention}Enhanced",
			"{C:attention}Aces{} to your hand" }

		card.ability.old_incantation = G.localization.descriptions.Spectral.c_incantation.text
		G.localization.descriptions.Spectral.c_incantation.text = { "Add {C:attention}#1# random",
			"{C:attention}Enhanced numbered", "{C:attention}cards{} to your hand" }

		card.ability.old_wraith = G.localization.descriptions.Spectral.c_wraith.text
		G.localization.descriptions.Spectral.c_wraith.text = { "Creates a random", "{C:red}Rare{C:attention} Joker{}" }

		card.ability.old_ankh = G.localization.descriptions.Spectral.c_ankh.text
		G.localization.descriptions.Spectral.c_ankh.text = { "Create a copy of a", "random {C:attention}Joker{}" }

		card.ability.old_hex = G.localization.descriptions.Spectral.c_hex.text
		G.localization.descriptions.Spectral.c_hex.text = { "Add {C:dark_edition}Polychrome{} to",
			"a random {C:attention}Joker{}" }

		card.ability.old_immolate = G.localization.descriptions.Spectral.c_immolate.text
		G.localization.descriptions.Spectral.c_immolate.text = { "Gain {C:money}$#2#" }
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.localization.descriptions.Spectral.c_ouija.text = card.ability.old_ouija
		G.localization.descriptions.Spectral.c_ectoplasm.text = card.ability.old_ectoplasm
		G.localization.descriptions.Spectral.c_familiar.text = card.ability.old_familiar
		G.localization.descriptions.Spectral.c_grim.text = card.ability.old_grim
		G.localization.descriptions.Spectral.c_incantation.text = card.ability.old_incantation
		G.localization.descriptions.Spectral.c_wraith.text = card.ability.old_wraith
		G.localization.descriptions.Spectral.c_ankh.text = card.ability.old_ankh
		G.localization.descriptions.Spectral.c_hex.text = card.ability.old_hex
		G.localization.descriptions.Spectral.c_immolate.text = card.ability.old_immolate
	end,
}

SMODS.Joker {
	key = "dogcheck",
	config = {
		totem_chance = 6,
	},
	--unlocked = false
	rarity = "UTDR_dog",
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 9, y = 11 },
	cost = 6,
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
	config = {
		in_build = false,
		old_volume = 0
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
				key = "j_UTDR_sjelter",
			}
		end
	end,
	add_to_deck = function(self, card, from_debuff)
		card.ability.in_build = true
		if not from_debuff then
			card.ability.old_volume = G.SETTINGS.SOUND.music_volume
		end
	end,
	update = function(self, card, dt)
		if card.ability.in_build then
			G.SETTINGS.SOUND.music_volume = 0
		end
	end,
	remove_from_deck = function(self, card, from_debuff)
		card.ability.in_build = false
		if not from_debuff then
			G.SETTINGS.SOUND.music_volume = card.ability.old_volume
		end
	end
}

SMODS.Joker {
	key = "roots",
	config = {
		old_tarot_rate = 0,
		old_planet_rate = 0,
		old_spectral_rate = 0
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
	loc_vars = function(self, info_queue, card)
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

				if card.ability.deer_kidnapped == 2 then
					card.ability.deer_kidnapped = 0
					play_sound("UTDR__", 1.0, 1.0)
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
						card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
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

SMODS.Joker {
	key = "man",
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