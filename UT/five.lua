--first
SMODS.Joker {
	key = "worn_dagger",
	config = {
		money = 1,
		chips = 20
	},
	attributes = {
		"hearts",
		"suit",
		"economy",
		"chips"
	},
	--unlocked = false
	unlock_condition = { type = 'win_custom' },
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 1, y = 4 },
	cost = 3,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.money, card.ability.chips, localize("Hearts", 'suits_plural') }
		}
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and (context.other_card:is_suit("Hearts") or SMODS.has_any_suit(context.other_card)) then
			if pseudorandom("worn_dagger") < 1 / 2 then
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
	key = "patience",
	config = {
		final_hand = false,
		increased_interest = false
	},
	attributes = {
		"economy",
		"hands",
	},
	--unlocked = false
	unlock_condition = { type = 'win_custom' },
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 9, y = 0 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		if self.icon and self.icon.remove then
			self.icon:remove()
			self.icon = nil
		end
		self.icon = Sprite(0, 0, 0.46, 0.46, G.ASSET_ATLAS["UTDR_souls"], { x = 1, y = 0 })
		local element = {
			n = G.UIT.C,
			config = { align = "cm", padding = 0.1 },
			nodes = {
				{ n = G.UIT.O, config = { object = self.icon } },
			}
		}
		return {
			vars = {
				elements = { element }
			}
		}
	end,
	calculate = function(self, card, context)
		if context.setting_blind and card.ability.increased_interest and not card.getting_sliced and not context.blueprint then
			G.GAME.interest_amount = G.GAME.interest_amount / 2
			card.ability.increased_interest = false
		elseif context.joker_main and G.GAME.current_round.hands_left == 0 and not context.blueprint then
			G.GAME.blind.dollars = G.GAME.blind.dollars * 2
			card.ability.final_hand = true
		elseif context.end_of_round and context.cardarea == G.jokers and card.ability.final_hand and not context.blueprint then
			card.ability.final_hand = false
			G.GAME.interest_amount = G.GAME.interest_amount * 2
			card.ability.increased_interest = true
			return {
				message = "X2",
				colour = G.C.MONEY
			}
		end
	end
}

SMODS.Joker {
	key = "boss_monster_soul",
	config = {
		chips = 0,
		chip_gain = 35,
		increase_count = 0
	},
	attributes = {
		"chips",
		"scaling",
	},
	--unlocked = false
	unlock_condition = { type = 'discard_custom' },
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 5, y = 4 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		if self.icon and self.icon.remove then
			self.icon:remove()
			self.icon = nil
		end
		self.icon = Sprite(0, 0, 0.46, 0.46, G.ASSET_ATLAS["UTDR_souls"], { x = 7, y = 0 })
		local element = {
			n = G.UIT.C,
			config = { align = "cm", padding = 0.1 },
			nodes = {
				{ n = G.UIT.O, config = { object = self.icon } },
			}
		}
		return {
			vars = {
				elements = { element },
				card.ability.chip_gain,
				card.ability.chips
			}
		}
	end,
	locked_loc_vars = function(self, info_queue, card)
		return { vars = localize("Full House", 'poker_hands') }
	end,
	calculate = function(self, card, context)
		if (context.cards_destroyed or context.remove_playing_cards or context.playing_card_added) and not context.blueprint then
			card.ability.increase_count = 0
			if context.cards_destroyed then
				increase_count = card.ability.chip_gain * #context.glass_shattered
			elseif context.remove_playing_cards then
				increase_count = card.ability.chip_gain * #context.removed
			elseif context.playing_card_added then
				increase_count = card.ability.chip_gain * #context.cards
			end
			SMODS.scale_card(card, {
				ref_table = card.ability,
				ref_value = "chips",
				scalar_value = "increase_count",
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
	key = "bravery",
	config = {
		xmult_gain = 0.25,
		xmult = 1,
		bought = false
	},
	attributes = {
		"xmult",
		"scaling",
	},
	loc_vars = function(self, info_queue, card)
		if self.icon and self.icon.remove then
			self.icon:remove()
			self.icon = nil
		end
		self.icon = Sprite(0, 0, 0.46, 0.46, G.ASSET_ATLAS["UTDR_souls"], { x = 4, y = 0 })
		if #SMODS.find_card("j_UTDR_flowery") > 0 then
			self.icon = Sprite(0, 0, 0.46, 0.46, G.ASSET_ATLAS["UTDR_souls"], { x = 4, y = 1 })
		end
		local element = {
			n = G.UIT.C,
			config = { align = "cm", padding = 0.1 },
			nodes = {
				{ n = G.UIT.O, config = { object = self.icon } },
			}
		}
		return {
			vars = {
				elements = { element },
				card.ability.xmult_gain,
				card.ability.xmult
			}
		}
	end,
	locked_loc_vars = function(self, info_queue, card)
		return { vars = localize({ type = 'name_text', set = "Enhanced", key = "m_glass" }) or 'Glass Card' }
	end,
	--unlocked = false
	unlock_condition = { type = 'hand_contents' },
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 4, y = 1 },
	cost = 6,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				xmult = card.ability.xmult
			}
		elseif context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
			card.ability.bought = false
		elseif context.open_booster or context.buying_card and not context.blueprint then
			card.ability.bought = true
		elseif context.ending_shop and not context.blueprint then
			if not card.ability.bought then
				SMODS.scale_card(card, {
					ref_table = card.ability,
					ref_value = "xmult",
					scalar_value = "xmult_gain",
					message_colour = G.C.MULT
				})
			end
		end
	end
}

SMODS.Joker {
	key = "last_dream",
	config = {
		chips = 200
	},
	attributes = {
		"chips",
		"suit",
		"hearts"
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.chips, localize("Hearts", 'suits_singular') } }
	end,
	--unlocked = false
	unlock_condition = { type = 'ante_up', ante = 10, extra = 10 },
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 4, y = 4 },
	soul_pos = { x = 5, y = 7 },
	cost = 8,
	calculate = function(self, card, context)
		if context.joker_main then
			for i = 1, #context.full_hand do
				if not (context.full_hand[i]:is_suit("Hearts") or SMODS.has_any_suit(context.full_hand[i])) then
					return nil
				end
			end
			return {
				chips = card.ability.chips
			}
		end
	end
}

--next
SMODS.Joker {
	key = "justice",
	config = {
		mult = 0,
		mult_gain = 4,
		mult_gained = false
	},
	attributes = {
		"mult",
		"scaling",
	},
	--unlocked = false
	unlock_condition = { type = 'hand_contents' },
	loc_vars = function(self, info_queue, card)
		if self.icon and self.icon.remove then
			self.icon:remove()
			self.icon = nil
		end
		self.icon = Sprite(0, 0, 0.46, 0.46, G.ASSET_ATLAS["UTDR_souls"], { x = 6, y = 0 })
		if #SMODS.find_card("j_UTDR_mettaton") > 0 or #SMODS.find_card("j_UTDR_mettaton_ex") > 0 then
			self.icon = Sprite(0, 0, 0.46, 0.46, G.ASSET_ATLAS["UTDR_souls"], { x = 6, y = 2 })
		elseif #SMODS.find_card("j_UTDR_spamton_neo") > 0 then
			self.icon = Sprite(0, 0, 0.46, 0.46, G.ASSET_ATLAS["UTDR_souls"], { x = 6, y = 1 })
		end
		local element = {
			n = G.UIT.C,
			config = { align = "cm", padding = 0.1 },
			nodes = {
				{ n = G.UIT.O, config = { object = self.icon } },
			}
		}
		return {
			vars = {
				elements = { element },
				card.ability.mult_gain,
				card.ability.mult
			}
		}
	end,
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 0, y = 4 },
	cost = 6,
	calculate = function(self, card, context)
		if context.setting_blind and not context.blueprint then
			card.ability.mult_gained = false
		elseif context.joker_main then
			return {
				mult = card.ability.mult
			}
		elseif context.end_of_round and not context.blueprint and not card.ability.mult_gained and not context.blueprint then
			SMODS.scale_card(card, {
				ref_table = card.ability,
				ref_value = "mult",
				scalar_value = "mult_gain",
				message_colour = G.C.MULT
			})
			card.ability.mult_gained = true
		end
	end
}

SMODS.Joker {
	key = "asgore",
	config = {
		xmult_per = 0.75,
		slots = 4
	},
	attributes = {
		"xmult",
		"scaling",
		"passive"
	},
	--unlocked = false
	unlock_condition = { type = 'modify_jokers', extra = { count = 7 } },
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 8, y = 6 },
	cost = 8,
	loc_vars = function(self, info_queue, card)
		if G.consumeables ~= nil and G.consumeables.config ~= nil then
			return { vars = { card.ability.xmult_per, card.ability.slots, 1 + (card.ability.xmult_per * G.consumeables.config.card_count) } }
		else
			return { vars = { card.ability.xmult_per, card.ability.slots, 1 } }
		end
	end,
	add_to_deck = function(self, card, from_debuff)
		G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.slots
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.consumeables.config.card_limit = G.consumeables.config.card_limit - card.ability.slots
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				xmult = 1 + (card.ability.xmult_per * G.consumeables.config.card_count)
			}
		end
	end
}

SMODS.Joker {
	key = "asriel",
	config = {
		xmult = 2.5,
		threshold = 6,
		turns_elapsed = 0
	},
	attributes = {
		"xmult",
		"ranks",
		"ace",
		"hands"
	},
	rarity = 3,
	--unlocked = false
	unlock_condition = { type = 'hand_contents' },
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 1, y = 7 },
	soul_pos = { x = 6, y = 7 },
	cost = 8,
	loc_vars = function(self, info_queue, card)
		local vars = {
			(localize("Ace", 'ranks') or "Ace"),
			card.ability.xmult,
			card.ability.threshold,
			card.ability.turns_elapsed,
		}
		if card.ability.turns_elapsed >= card.ability.threshold then
			return {
				key = "j_UTDR_asriel_active",
				vars = vars
			}
		end
		return { vars = vars }
	end,
	locked_loc_vars = function(self, info_queue, card)
		return { vars = { localize("Ace", 'ranks') or "Ace" } }
	end,
	add_to_deck = function(self, card, from_debuff)
		if #SMODS.find_card("j_UTDR_fallen_human") > 0 then
			card.ability.turns_elapsed = 6
			play_sound("UTDR_asriel", 1.0, 0.7)
			card:juice_up(0.3, 0.5)
		end
	end,
	update = function(self, card, dt)
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and context.other_card.base.value == "Ace" and card.ability.turns_elapsed >= card.ability.threshold then
			return {
				xmult = card.ability.xmult
			}
		elseif context.card_added and context.card.config.center.key == "j_UTDR_fallen_human" then
			card.ability.turns_elapsed = 6
			play_sound("UTDR_asriel", 1.0, 0.7)
			card:juice_up(0.3, 0.5)
		elseif context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
			ease_background_colour { new_colour = SMODS.Gradients["UTDR_asriel_background"] }
			card.ability.turns_elapsed = card.ability.turns_elapsed + 1
			if card.ability.turns_elapsed == card.ability.threshold then
				play_sound("UTDR_asriel", 1.0, 0.7)
				card:juice_up(0.3, 0.5)
			elseif card.ability.turns_elapsed < card.ability.threshold then
				card:juice_up(0.3, 0.4)
			end
		end
	end
}

SMODS.Joker {
	key = "omega_flowey",
	config = {
		required_chips = 50,
		xmult_gain = 1,
		xmult = 1
	},
	attributes = {
		"prevents_death",
		"scaling",
		"xmult",
	},
	check_for_unlock = function(self, args)
		return (args.type == "loss_ante" and args.ante == 8)
	end,
	--unlocked = false
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 9, y = 6 },
	cost = 10,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.required_chips, card.ability.xmult_gain, card.ability.xmult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				xmult = card.ability.xmult
			}
		elseif context.game_over and G.GAME.chips / G.GAME.blind.chips >= card.ability.required_chips / 100 and not context.blueprint then
			SMODS.scale_card(card, {
				ref_table = card.ability,
				ref_value = "xmult",
				scalar_value = "xmult_gain",
				message_colour = G.C.MULT
			})
			G.E_MANAGER:add_event(Event({
				func = function()
					G.hand_text_area.blind_chips:juice_up()
					G.hand_text_area.game_chips:juice_up()
					play_sound('tarot1')
					return true
				end
			}))
			play_sound("UTDR_omega_flowey", 1.0, 0.7)
			return {
				saved = "totem_UTDR_omegaflowey",
			}
		end
	end
}

SMODS.Joker {
	key = "integrity",
	config = {
		chips = 150
	},
	attributes = {
		"chips",
		"enhancements",
	},
	loc_vars = function(self, info_queue, card)
		if self.icon and self.icon.remove then
			self.icon:remove()
			self.icon = nil
		end
		self.icon = Sprite(0, 0, 0.46, 0.46, G.ASSET_ATLAS["UTDR_souls"], { x = 5, y = 0 })
		if #SMODS.find_card("j_UTDR_papyrus") > 0 then
			self.icon = Sprite(0, 0, 0.46, 0.46, G.ASSET_ATLAS["UTDR_souls"], { x = 5, y = 3 })
		elseif #SMODS.find_card("j_UTDR_weird_deard_gaster") > 0 then
			self.icon = Sprite(0, 0, 0.46, 0.46, G.ASSET_ATLAS["UTDR_souls"], { x = 5, y = 2 })
		elseif #SMODS.find_card("j_UTDR_sans") > 0 then
			self.icon = Sprite(0, 0, 0.46, 0.46, G.ASSET_ATLAS["UTDR_souls"], { x = 5, y = 1 })
		end
		local element = {
			n = G.UIT.C,
			config = { align = "cm", padding = 0.1 },
			nodes = {
				{ n = G.UIT.O, config = { object = self.icon } },
			}
		}
		return {
			vars = {
				elements = { element },
				card.ability.chips
			}
		}
	end,
	--unlocked = false
	unlock_condition = { type = 'hand', count = 25 },
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 9, y = 1 },
	cost = 7,
	calculate = function(self, card, context)
		if context.joker_main and context.cardarea == G.jokers then
			local enhancement = context.full_hand[1].config.center_key
			for i = 2, #context.full_hand do
				if context.full_hand[i].config.center_key ~= enhancement then
					return nil
				end
			end
			return {
				chips = card.ability.chips
			}
		end
	end
}

--last
SMODS.Joker {
	key = "real_knife",
	--unlocked = false
	unlock_condition = { type = 'modify_deck' },
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 2, y = 4 },
	cost = 9,
	config = {
		xmult_gain = 0.6,
		xmult = 1,
		total_gain = 0,
	},
	attributes = {
		"suit",
		"hearts",
		"scaling",
		"xmult"
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
			card.ability.total_gain = 0
			local hearts = 0
			for i = 1, #context.removed do
				if context.removed[i]:is_suit("Hearts") or SMODS.has_any_suit(context.removed[i]) then
					hearts = hearts + 1
				end
			end

			card.ability.total_gain = hearts * card.ability.xmult_gain
			SMODS.scale_card(card, {
				ref_table = card.ability,
				ref_value = "xmult",
				scalar_value = "total_gain",
				message_colour = G.C.MULT
			})
			play_sound("UTDR_lvup", 1.0, 0.7)
			return
		end
	end
}

SMODS.Joker {
	key = "kindness",
	config = {
		foil = 100,
		holo = 25,
		poly = 2.5,

		old_foil = 0,
		old_holo = 0,
		old_poly = 0,

		in_build = false
	},
	attributes = {
		"editions",
		"chips",
		"mult",
		"xmult"
	},
	--unlocked = false
	unlock_condition = { type = 'round_win' },
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 3, y = 3 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		if self.icon and self.icon.remove then
			self.icon:remove()
			self.icon = nil
		end
		self.icon = Sprite(0, 0, 0.46, 0.46, G.ASSET_ATLAS["UTDR_souls"], { x = 3, y = 0 })
		local element = {
			n = G.UIT.C,
			config = { align = "cm", padding = 0.1 },
			nodes = {
				{ n = G.UIT.O, config = { object = self.icon } },
			}
		}
		return {
			vars = {
				elements = { element },
				G.localization.descriptions.Edition.e_foil.name,
				card.ability.foil,
				G.localization.descriptions.Edition.e_holo.name,
				card.ability.holo,
				G.localization.descriptions.Edition.e_polychrome.name,
				card.ability.poly
			}
		}
	end,
	add_to_deck = function(self, card, from_debuff)
		card.ability.old_foil = G.P_CENTERS.e_foil.config.chips
		card.ability.old_holo = G.P_CENTERS.e_holo.config.mult
		card.ability.old_poly = G.P_CENTERS.e_polychrome.config.x_mult

		card.ability.in_build = true

		edition_values(card.ability.foil, card.ability.holo, card.ability.poly, true)
	end,
	update = function(self, card, dt)
		if card.ability.in_build then
			edition_values(card.ability.foil, card.ability.holo, card.ability.poly)
		end
	end,
	remove_from_deck = function(self, card, from_debuff)
		card.ability.in_build = false
		edition_values(card.ability.old_foil, card.ability.old_holo, card.ability.old_poly, true)
	end,
	calculate = function(self, card, context)
		if context.game_over and not context.blueprint then
			card.ability.in_build = false
			edition_values(card.ability.old_foil, card.ability.old_holo, card.ability.old_poly)
		end
	end
}

function edition_values(foil, holo, poly)
	G.P_CENTERS.e_foil.config.chips = foil
	G.P_CENTERS.e_holo.config.mult = holo
	G.P_CENTERS.e_polychrome.config.x_mult = poly

	if add_remove then
		for i = 1, #G.playing_cards do
			local card = G.playing_cards[i]
			if card.edition then
				if card.edition.key == "e_foil" then
					card.edition.chips = foil
				elseif card.edition.key == "e_holo" then
					card.edition.mult = holo
				elseif card.edition.key == "e_polychrome" then
					card.edition.x_mult = poly
				end
			end
		end
	end
end

SMODS.Joker {
	key = "heart_locket",
	config = {
		mult = 15
	},
	attributes = {
		"enhancements",
		"mult",
	},
	--unlocked = false
	unlock_condition = { type = 'modify_deck', extra = { count = 5, enhancement = 'Steel Card', e_key = 'm_steel' } },
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 3, y = 4 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_steel
		return { vars = { G.GAME.probabilities.normal, card.ability.odds, card.ability.mult, localize({ type = 'name_text', set = "Enhanced", key = "m_steel" }) } }
	end,
	locked_loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_steel
		return { vars = { localize({ type = 'name_text', set = "Enhanced", key = "m_steel" }) } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, "m_steel") then
			return {
				mult = card.ability.mult
			}
		end
	end
}

SMODS.Joker {
	key = "perseverance",
	config = {
		enhancement_count = 0,
		cap = 8,
		xmult = 2
	},
	attributes = {
		"enhancements",
		"xmult",
		"full_deck"
	},
	--unlocked = false
	unlock_condition = { type = 'win_custom' },
	loc_vars = function(self, info_queue, card)
		if self.icon and self.icon.remove then
			self.icon:remove()
			self.icon = nil
		end
		self.icon = Sprite(0, 0, 0.46, 0.46, G.ASSET_ATLAS["UTDR_souls"], { x = 2, y = 0 })
		local element = {
			n = G.UIT.C,
			config = { align = "cm", padding = 0.1 },
			nodes = {
				{ n = G.UIT.O, config = { object = self.icon } },
			}
		}
		return {
			vars = {
				elements = { element },
				card.ability.xmult,
				card.ability.cap,
				card.ability.enhancement_count,
				string.lower(localize("b_full_deck"))
			}
		}
	end,
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 7, y = 2 },
	cost = 5,
	update = function(self, card, dt)
		card.ability.enhancement_count = 0
		if G.playing_cards ~= nil then
			for k, v in pairs(G.playing_cards) do
				if v.config.center and (v.config.center.name ~= "Default Base") then
					card.ability.enhancement_count = card.ability.enhancement_count + 1
				end
			end
		end
	end,
	calculate = function(self, card, context)
		if context.joker_main and card.ability.enhancement_count <= card.ability.cap then
			return {
				xmult = card.ability.xmult
			}
		end
	end
}

SMODS.Joker {
	key = "chara",
	config = {
		xmult = 5,
		hand_loss = 3
	},
	attributes = {
		"xmult",
		"hand_size"
	},
	--unlocked = false
	unlock_condition = { type = 'hand_contents' },
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 4, y = 7 },
	soul_pos = { x = 7, y = 7 },
	cost = 9,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult, card.ability.hand_loss, G.PROFILES[G.SETTINGS.profile].name } }
	end,
	add_to_deck = function(self, card, from_debuff)
		G.hand:change_size(-card.ability.hand_loss)
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.hand:change_size(card.ability.hand_loss)
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				xmult = card.ability.xmult
			}
		end
	end
}
