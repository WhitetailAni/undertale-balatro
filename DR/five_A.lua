SMODS.Joker {
	key = "tension_gem",
	config = {
		tag_count = 3,
		slotted = false,
		in_build = false
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = 'tag_charm', set = 'Tag' }
		local probabilities_normal, odds = SMODS.get_probability_vars(card, 1, card.ability.odds, "DR_TGEM")
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
	atlas = "DR_jokers_2",
	pos = { x = 1, y = 2 },
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
	atlas = "DR_jokers_2",
	pos = { x = 2, y = 2 },
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
	atlas = "DR_jokers_2",
	pos = { x = 8, y = 1 },
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
	atlas = "DR_jokers_2",
	pos = { x = 5, y = 1 },
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
	atlas = "DR_jokers_2",
	pos = { x = 2, y = 0 },
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

function joker_rarity(common, uncommon, rare, legendary)
	SMODS.ObjectTypes["Joker"].rarities[1].weight = common
	SMODS.ObjectTypes["Joker"].rarities[2].weight = uncommon
	SMODS.ObjectTypes["Joker"].rarities[3].weight = rare
	if legendary == 0 then
		SMODS.ObjectTypes["Joker"].rarities[4] = nil
	else
		SMODS.ObjectTypes["Joker"].rarities[4] = { key = "Legendary", weight = legendary }
	end
end

SMODS.Joker {
	key = "netskie",
	config = {
		mult = 8
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers_2",
	pos = { x = 7, y = 1 },
	soul_pos = { x = 1, y = 8 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		local probabilities_normal, odds = SMODS.get_probability_vars(card, 1, card.ability.odds, "DR_ERAM")
		if math.fmod(os.time(), 16) == 0 then
			return {
				key = "j_UTDR_mantle_holder",
				vars = { probabilities_normal, odds } -- TODO: this should get the variables for the actual joker
			}
		end
		return { vars = { probabilities_normal, odds } }
	end,
	calculate = function(self, card, context)
		if context.discard and SMODS.pseudorandom_probability(card, "eram", 1, card.ability.odds, "DR_eram") then
			card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Burned!" })
			play_sound("UTDR_ERAM", 1.0, 0.7)
			return {
				remove = true,
				removed = context.other_card
			}
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
	atlas = "DR_jokers_2",
	pos = { x = 9, y = 2 },
	cost = 6,
	loc_vars = function(self, info_queue, card)
		return { vars = { G.GAME.probabilities.normal, card.ability.totem_chance } }
	end,
	calculate = function(self, card, context)
		if context.game_over and pseudorandom("dogcheck") > 0.83 and not context.blueprint then
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
	key = "newsletter",
	config = {
		extra = 6,
		boss_type = ""
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra } }
	end,
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers_2",
	pos = { x = 3, y = 1 },
	cost = 5,
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