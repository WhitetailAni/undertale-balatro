SMODS.Joker {
	key = "tension_gem",
	config = {
		tag_count = 3,
		slotted = false,
		in_build = false
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = 'tag_charm', set = 'Tag' }
		if math.fmod(os.time(), 16) == 0 then
			return {
				key = "j_UTDR_tension_slop",
				vars = { card.ability.tag_count, localize { type = 'name_text', set = 'Tag', key = 'tag_charm' } }
			}
		end
		return { vars = { card.ability.tag_count, localize { type = 'name_text', set = 'Tag', key = 'tag_charm' } } }
	end,
	rarity = 1,
	blueprint_compat = false,
	eternal_compat = false,
	atlas = "DR_jokers",
	pos = { x = 1, y = 11 },
	cost = 6,
	calculate = function(self, card, context)
		if context.selling_self then
			for i = 1, card.ability.tag_count do
				card:juice_up(0.3, 0.5)
				local tag = Tag("tag_charm")
				add_tag(tag)
			end
		end
	end
}

-- is it stealing from another mod when the mod developer is working on this one
--its not i promise




SMODS.Joker {
	key = "lord_of_hammer",
	config = {
		xmult = 2,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult } }
	end,
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 2, y = 11 },
	cost = 6,
	calculate = function(self, card, context)
		if context.joker_main and G.jokers.config.card_limit == #G.jokers.cards then
			return {
				xmult = card.ability.xmult
			}
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
	key = "shelter_code",
	loc_vars = function(self, info_queue, card)
		return { vars = { localize("k_uncommon"), localize("k_rare") } }
	end,
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 2, y = 9 },
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
	key = "dogcheck",
	config = {
		totem_chance = 6,
	},
	--unlocked = false
	rarity = 1,
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
	key = "sound_of_justice",
	config = {
		retrigger_chance = 4,
	},
	--unlocked = false
	rarity = 3,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 0, y = 9 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		local probabilities_normal, odds = SMODS.get_probability_vars(card, 3, card.ability.retrigger_chance, 'DR_sound_of_justice')
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
	key = "newsletter",
	config = {
		money = 6,
		boss_type = ""
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.money } }
	end,
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 3, y = 10 },
	cost = 5,
	calc_dollar_bonus = function(self, card)
		return card.ability.money
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			if G.GAME.blind.boss then
				boss_type = "boss"
			else
				boss_type = G.GAME.blind.name
			end
		elseif context.end_of_round then
			if not context.beat_boss then
				local card_type = "Planet"
				if boss_type == "Big Blind" then
					card_type = "Tarot"
				end
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.4,
					func = function()
						if G.consumeables.config.card_limit > #G.consumeables.cards then
							play_sound('timpani')
							local new_card = create_card(card_type, G.consumeables, nil, nil, nil, nil, nil, 'newsletter')
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
}

SMODS.Joker {
	key = "lightners_live",
	config = {
		ranks = {
			"7",
			"4"
		},
		mult_inc = 2,
		mult = 0
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "DR_jokers",
	pos = { x = 8, y = 11 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		local vars = { card.ability.mult_inc, card.ability.mult }
		for _, rank in ipairs(card.ability.ranks) do
			table.insert(vars, localize(rank, "ranks"))
		end
		return { vars = vars }
	end,
	calculate = function(self, card, context)
		if context.before and not context.blueprint then
			local found_rank = false
			for _, playing_card in ipairs(context.scoring_hand) do
				for i, rank in ipairs(card.ability.ranks) do
					if playing_card.base.value == rank and not playing_card.debuff then
						found_rank = true
						break
					end
				end
				if found_rank then
					break
				end
			end
			if found_rank then
				SMODS.scale_card(card, {
					ref_table = card.ability,
					ref_value = "mult",
					scalar_value = "mult_inc",
					scaling_message = {
						message = localize("k_upgrade_ex"),
						colour = G.C.MULT
					}
				})
			else
				card.ability.mult = 0
				return {
					message = localize("k_reset"),
					colour = G.C.MULT
				}
			end
		end
		if context.joker_main then
			return {
				mult = card.ability.mult
			}
		end
	end
}