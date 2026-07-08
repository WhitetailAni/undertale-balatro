--beginning
SMODS.Joker {
	key = "glowshard",
	loc_txt = {
		name = "Glowshard",
		text = {
			"Gains {C:money}$#1#{} of {C:attention}sell value",
			"when a card is sold"
		}
	},
	config = {
		sell_value_gain = 1,
		extra_value = 0
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.sell_value_gain } }
	end,
	rarity = 1,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 1, y = 0 },
	cost = 3,
	calculate = function(self, card, context)
		if context.selling_anything and context.card ~= card and not context.blueprint then
			card.ability.extra_value = card.ability.extra_value + card.ability.sell_value_gain
            card:set_cost()
            return {
				message = localize('k_val_up'),
				colour = G.C.MONEY
			}
        end
	end
}

SMODS.Joker {
	key = "berdly",
	loc_txt = {
		name = "Berdly",
		text = {
			"Played {C:attention}Lucky Cards{}",
			"give {C:mult}+#1#{} Mult and",
			"{C:money}$#2#{} when scored",
			"{C:attention}Lucky Cards{} can",
			"{C:red}no longer trigger"
		}
	},
	config = {
		mult = 6,
		bigbucks = 1,
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.m_lucky
		return { vars = { card.ability.mult, card.ability.bigbucks } }
	end,
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 4, y = 3 },
	cost = 4,
	calculate = function(self, card, context)
		if context.mod_probability and not context.blueprint and context.identifier == "lucky_mult" or context.identifier == "lucky_money" then
			return {
				numerator = 0
			}
		elseif context.individual and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, "m_lucky")  then
			return {
				mult = card.ability.mult,
				dollars = card.ability.bigbucks
			}
		end
	end
}

SMODS.Joker {
	key = "save",
	loc_txt = {
		name = "SAVE",
		text = {
			"After {C:attention}#1#{C:inactive} [#2#]{} rounds,",
			"sell this card for {C:attention}-#3#{} Ante"
		}
	},
	config = {
		turn_cap = 3,
		turns = 0,
		ante_loss = 1
	},
	pixel_size = { w = 70, h = 71 },
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = false,
	atlas = "DR_jokers",
	pos = { x = 2, y = 4 },
	cost = 10,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.turn_cap, card.ability.turns, card.ability.ante_loss } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
			card.ability.turns = card.ability.turns + 1
			if card.ability.turns >= card.ability.turn_cap then
				local eval = function(card)
					return card.ability.turns >= card.ability.turn_cap
				end
				juice_card_until(card, eval, true)
			end
		elseif context.selling_self and card.ability.turns >= card.ability.turn_cap and not context.blueprint then
			ease_ante(-card.ability.ante_loss)
        	G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
        	G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante - card.ability.ante_loss
		end
	end
}

SMODS.Joker {
	key = "noelle",
	loc_txt = {
		name = "Noelle",
		text = {
			"{C:attention}Glass Cards{} give {X:mult,C:white}X#1#{} Mult,",
			"but have a {C:green}#2# in #3#{}",
			"chance to break"
		}
	},
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 9, y = 1 },
	cost = 8,
	config = {
		old_xmult = 0,
		xmult = 3,
		thorn_ring_xmult = 5.5,
		odds = 3,
		ribbon_is_older = false,
		in_build = false
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.m_glass 
		local probabilities_normal, odds = SMODS.get_probability_vars(card, 1, card.ability.odds, "DR_noelle")
		if #SMODS.find_card("j_UTDR_thornring") > 0 then
			return { vars = { card.ability.thorn_ring_xmult, odds, odds } }
		else
			return { vars = { card.ability.xmult, probabilities_normal, odds } }
		end
	end,
	add_to_deck = function(self, card, from_debuff)
		card.ability.in_build = true
		card.ability.old_xmult = G.P_CENTERS.m_glass.config.Xmult
		local thornrings = SMODS.find_card("j_UTDR_thornring")
		if #thornrings > 0 then
			card:set_eternal(true)
			for i = 1, #thornrings do
				thornrings[i]:set_eternal(true)
			end
			play_sound("UTDR_thornring_equip", 1.0, 0.7)
		end
		if #SMODS.find_card("j_UTDR_ribbon") > 0 then
			card.ability.ribbon_is_older = true
		end
	end,
	update = function(self, card, dt)
		if card.ability.in_build then
			if #SMODS.find_card("j_UTDR_thornring") > 0 then
				glass_xmult(card.ability.thorn_ring_xmult)
			else
				glass_xmult(card.ability.xmult)
			end
		end
	end,
	remove_from_deck = function(self, card, from_debuff)
		card.ability.in_build = false
		glass_xmult(card.ability.old_xmult)
	end,
	calculate = function(self, card, context)
		if context.mod_probability and not context.blueprint and context.identifier == "glass" and not card.ability.ribbon_is_older and not context.blueprint then
			return {
				denominator = card.ability.odds
			}
		elseif context.selling_card and context.card.label == "j_UTDR_ribbon" and #SMODS.find_card("j_UTDR_ribbon") == 1 and not context.blueprint then
			card.ability.ribbon_is_older = false
		end
	end
}

function glass_xmult(xmult)
	G.P_CENTERS.m_glass.config.Xmult = xmult
	if G.playing_cards ~= nil then
		for i = 1, #G.playing_cards do
			if G.playing_cards[i].config.center and (SMODS.has_enhancement(G.playing_cards[i], "m_glass")) and not G.playing_cards[i].vampired then 
				G.playing_cards[i].ability.Xmult = xmult
				G.playing_cards[i].ability.x_mult = xmult
			end				
		end
	end
end

SMODS.Joker {
	key = "thornring",
	loc_txt = {
		name = "Thorn Ring",
		text = {
			"Played {C:attention}Glass Cards{}",
			"{S:1.1,C:red,E:2}always{} break, {C:red}and...?{}"
		}
	},
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
		info_queue[#info_queue+1] = G.P_CENTERS.m_glass 
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

--cyber world
SMODS.Joker {
	key = "man",
	loc_txt = {
		name = "Man",
		text = {
			"{C:attention}Not too important,",
			"{C:attention}not too unimportant.",
			"{C:inactive}(Must have room)"
		}
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 4, y = 1 },
	cost = 5,
	calculate = function(self, card, context)
		if context.setting_blind and context.cardarea == G.jokers and #G.jokers.cards < G.jokers.config.card_limit then
			SMODS.add_card( {
				set = "Joker",
				area = G.jokers,
				key = "j_egg"
			})
			card:juice_up(0.3,0.4)
			play_sound("UTDR_egg", 1.0, 1.0)
		end
	end
}

SMODS.Joker {
	key = "kris",
	loc_txt = {
		name = "Kris",
		text = {
			"Copies ability of {C:attention}Joker{}",
			"to the left for",
			"{C:attention}first hand of round"
		}
	},
	config = {
		in_build = false,
		krisprint_compat_string = "incompatible",
	},
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 6, y = 1 },
	cost = 10,
	loc_vars = function(self, info_queue, card)
		if card.ability.in_build then
			local main_end = {
				{n=G.UIT.C, config={align = "bm", minh = 0.4}, nodes={
					{n=G.UIT.C, config={ref_table = card, align = "m", colour = G.C.JOKER_GREY, r = 0.05, padding = 0.075, func = 'krisprint_compat'}, nodes={
						{n=G.UIT.T, config={ref_table = card.ability, ref_value = 'krisprint_compat_string',colour = G.C.UI.TEXT_LIGHT, scale = 0.32*0.8}},
					}}
				}}
			}
			return {
				main_end = main_end
			}
		end
	end,
	krisprint_compat_check = function(card)
		for i = 1, #G.jokers.cards do
			if G.jokers.cards[i] == card then
				local other_joker = G.jokers.cards[i - 1]
				if other_joker and other_joker ~= self and other_joker.config.center.blueprint_compat then
					return true
				else
					return false
				end
			end
		end
	end,
	add_to_deck = function(self, card, from_debuff)
		card.ability.in_build = true
	end,
	remove_from_deck = function(self, card, from_debuff)
		card.ability.in_build = false
	end,
	calculate = function(self, card, context)
		if G.GAME.current_round.hands_played < 1 then
			local other_joker = nil
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] == card then
					other_joker = G.jokers.cards[i - 1]
				end
			end
			return SMODS.blueprint_effect(card, other_joker, context)
		end
	end
}

G.FUNCS.krisprint_compat = function(e)
	local results = e.config.ref_table.config.center.krisprint_compat_check(e.config.ref_table)
	if results then
		e.config.ref_table.ability.krisprint_compat_string = localize("k_compatible")
		e.config.colour = mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8)
	else
		e.config.ref_table.ability.krisprint_compat_string = localize("k_incompatible")
		e.config.colour = mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8)
	end
end

SMODS.Joker {
	key = "you",
	loc_txt = {
		name = "You",
		text = {
			"Copies abilities of {C:attention}Jokers{}",
			"to the left and right"
		},
		unlock = {
			"{s:1.3}?????",
		}
	},
	config = {
		in_build = false,
		redprint_compat_string = "incompatible"
	},
	unlocked = false,
	unlock_condition = {type = '', extra = '', hidden = true},
	rarity = 4,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 4, y = 7 },
	soul_pos = { x = 3, y = 8 },
	cost = 20,
	loc_vars = function(self, info_queue, card)
		if card.ability.in_build then
			local main_end = {
				{n=G.UIT.C, config={align = "bm", minh = 0.4}, nodes={
					{n=G.UIT.C, config={ref_table = card, align = "m", colour = G.C.JOKER_GREY, r = 0.05, padding = 0.075, func = 'redprint_compat'}, nodes={
						{n=G.UIT.T, config={ref_table = card.ability, ref_value = 'redprint_compat_string',colour = G.C.UI.TEXT_LIGHT, scale = 0.32*0.8}},
					}}
				}}
			}
			return {
				main_end = main_end
			}
		end
	end,
	redprint_compat_check = function(card)
		local left_joker = nil
		local right_joker = nil
		for i = 1, #G.jokers.cards do
			if G.jokers.cards[i] == card then
				left_joker = G.jokers.cards[i-1]
				right_joker = G.jokers.cards[i+1]
			end
		end
		local left_compat = left_joker and left_joker.config.center.blueprint_compat
		local right_compat = right_joker and right_joker.config.center.blueprint_compat
		return {
			left = left_compat,
			right = right_compat
		}
	end,
	add_to_deck = function(self, card, from_debuff)
		card.ability.in_build = true
	end,
	remove_from_deck = function(self, card, from_debuff)
		card.ability.in_build = false
	end,
	calculate = function(self, card, context)
		local left_joker = nil
		local right_joker = nil
		for i = 1, #G.jokers.cards do
			if G.jokers.cards[i] == card then
				left_joker = G.jokers.cards[i-1]
				right_joker = G.jokers.cards[i+1]
			end
		end
		local left_joker_results = SMODS.blueprint_effect(card, left_joker, context)
		local right_joker_results = SMODS.blueprint_effect(card, right_joker, context)
		local results = SMODS.merge_effects({left_joker_results or {}, right_joker_results or {}})
		return results
	end
}

G.FUNCS.redprint_compat = function(e)
	local results = e.config.ref_table.config.center.redprint_compat_check(e.config.ref_table)
	if results["left"] and not results["right"] then
		e.config.ref_table.ability.redprint_compat_string = "left "..localize("k_compatible")
		e.config.colour = mix_colours(G.C.GOLD, G.C.JOKER_GREY, 0.8)
	elseif results["right"] and not results["left"] then
		e.config.ref_table.ability.redprint_compat_string = "right "..localize("k_compatible")
		e.config.colour = mix_colours(G.C.GOLD, G.C.JOKER_GREY, 0.8)
	elseif results["right"] and results["left"] then
		e.config.ref_table.ability.redprint_compat_string = localize("k_compatible")
		e.config.colour = mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8)
	else
		e.config.ref_table.ability.redprint_compat_string = localize("k_incompatible")
		e.config.colour = mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8)
	end
end

SMODS.Joker {
	key = "susie",
	loc_txt = {
		name = "Susie",
		text = {
			"{X:mult,C:white}X#1#{} Mult during {C:attention}Small Blind{}",
			"{X:mult,C:white}X#2#{} Mult during {C:attention}Big Blind{}",
			"{X:mult,C:white}X#3#{} Mult during {C:attention}Boss Blind{}",
		},
	},
	config = {
		xmult_small = 2,
		xmult_big = 3,
		xmult_boss = 4
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult_small, card.ability.xmult_big, card.ability.xmult_boss } }
	end,
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 7, y = 1 },
	cost = 9,
	calculate = function(self, card, context)
		if context.joker_main then
			if G.GAME.blind.name == "Small Blind" then
				return {
					xmult = card.ability.xmult_small
				}
			elseif G.GAME.blind.name == "Big Blind" then
				return {
					xmult = card.ability.xmult_big
				}
			elseif G.GAME.blind.boss then
				return {
					xmult = card.ability.xmult_boss
				}
			else
				return {
					message = "What kinda blind is this???"
				}
			end
		end
	end
}

SMODS.Joker {
	key = "hometown",
	loc_txt = {
		name = "Hometown",
		text = {
			"Gains {X:mult,C:white}X#1#{} Mult for",
			"{C:attention}each{} scored card",
			"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"
		}
	},
	config = {
		xmult_gain = 0.02,
		xmult = 1,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult_gain, card.ability.xmult } }
	end,
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 3, y = 2 },
	cost = 6,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and not context.blueprint then
			card.ability.xmult = card.ability.xmult + card.ability.xmult_gain
			card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize { type='variable', key='a_xmult', vars = { card.ability.xmult } }, colour = G.C.MULT })
		elseif context.joker_main then
			return {
				xmult = card.ability.xmult
			}
		end
	end
}

--dark night
SMODS.Joker {
	key = "ralsei_dummy",
	loc_txt = {
		name = "Ralsei's Dummy",
		text = {
			"{C:mult}+#1#{} Mult for each",
			"empty {C:attention}Joker{} slot",
			"{s:0.8}Ralsei's Dummy included{}",
			"{C:inactive}(Currently {C:mult}+#2#{} Mult)"
		}
	},
	config = {
		mult_per = 6,
		mult = 0
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 7, y = 6 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		if G.jokers ~= nil and G.jokers.config ~= nil and G.jokers.cards ~= nil and G.jokers.config.card_limit ~= nil then
			return { vars = {
				card.ability.mult_per,
				card.ability.mult
			} }
		else 
			return { vars = {
				card.ability.mult_per,
				card.ability.mult_per
			} }
		end
	end,
	update = function(self, card, dt)
		if G.jokers ~= nil and G.jokers.config ~= nil and G.jokers.cards ~= nil and G.jokers.config.card_limit ~= nil then
			card.ability.mult = math.max((G.jokers.config.card_limit - #G.jokers.cards) * card.ability.mult_per, 0)
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i].label == 'j_UTDR_ralsei_dummy' then
					card.ability.mult = card.ability.mult + card.ability.mult_per
				end
			end
		end
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult = card.ability.mult
			}
		end
	end
}

SMODS.Joker {
	key = "FRIEND",
	loc_txt = {
		name = "_FRIEND",
		text = {
			"{C:FRIEND}Creates a {C:FRIEND_PINK}Prophecy{C:FRIEND} card",
			"{C:FRIEND}after {C:FRIEND_YELLOW}#1# {C:FRIEND_PINK}[#2#]{C:FRIEND} cards",
			"{C:FRIEND}are {C:FRIEND_YELLOW}destroyed{}",
			"{C:FRIEND}(Must have room)"
		}
	},
	config = {
		cards_destroyed = 2,
		deer_kidnapped = 0
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.cards_destroyed, card.ability.deer_kidnapped } }
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
									local carb = create_card("Spectral",G.consumeables, nil, nil, nil, nil, nil, "_")
									carb:add_to_deck()
									G.consumeables:emplace(carb)
									G.GAME.consumeable_buffer = 0
								return true
							end)}))
                		card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "__", colour = G.C.SECONDARY_SET.Spectral})
						card:juice_up(0.3, 0.4)
					end
				end
			end
		end
	end
}

SMODS.Joker {
	key = "ralsei",
	loc_txt = {
		name = "Ralsei",
		text = {
			"{C:attention}Retrigger{} each played",
			"{V:1}#1# of #2#{C:attention} #3#{} times ",
			"{s:0.8}rank and suit change at end of round",
		},
	},
	config = {
		selected_rank = 'Jack',
		selected_suit = 'Hearts',
		repetitions = 2
	},
	loc_vars = function(self, info_queue, card)
		return { 
			vars = { 
				card.ability.selected_rank,
				card.ability.selected_suit,
				card.ability.repetitions,
				colours =  {
					G.C.SUITS[card.ability.selected_suit] }
				}
			}
	end,
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 8, y = 1 },
	cost = 9,
	set_ability = function(self, card, initial, delay_sprites)
		card.ability.selected_suit = "Spades"
		card.ability.selected_rank = "Queen"
		if G.playing_cards then
			local selected_card = pseudorandom_element(G.playing_cards, "ralsei")
			if selected_card and selected_card.base and selected_card.base.suit and selected_card.base.value then
				card.ability.selected_suit = selected_card.base.suit
				card.ability.selected_rank = selected_card.base.value
			end
		end
	end,
	calculate = function(self, card, context)
		if context.repetition and context.cardarea == G.play and (context.other_card:is_suit(card.ability.selected_suit) or SMODS.has_any_suit(context.other_card)) and context.other_card.base.value == card.ability.selected_rank then
			return {
				message = localize('k_again_ex'),
				repetitions = card.ability.repetitions,
				card = context.blueprint_card or card
			}
		elseif context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
			local selected_card = pseudorandom_element(G.playing_cards, "ralsei")
			card.ability.selected_suit = selected_card.base.suit
			card.ability.selected_rank = selected_card.base.value
		end
	end
}

SMODS.Joker {
	key = "shadow_crystal",
	loc_txt = {
		name = "Shadow Crystal",
		text = {
			"Removes the {C:attention}negative",
			"{C:attention}effects{} of all",
			"{C:spectral}Prophecy{} cards"
		}
	},
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
	add_to_deck = function(self, card, from_debuff)
		card.ability.old_ouija = G.localization.descriptions.Spectral.c_ouija.text
		G.localization.descriptions.Spectral.c_ouija.text = { "Converts all cards", "in hand to a single", "random {C:attention}rank" }
		
		card.ability.old_ectoplasm = G.localization.descriptions.Spectral.c_ectoplasm.text
		G.localization.descriptions.Spectral.c_ectoplasm.text = { "Add {C:dark_edition}Negative{} to", "a random {C:attention}Joker" }
		
		card.ability.old_familiar = G.localization.descriptions.Spectral.c_familiar.text
		G.localization.descriptions.Spectral.c_familiar.text = { "Add {C:attention}#1#{} random {C:attention}Enhanced", "{C:attention}face cards{} to your hand" }
		
		card.ability.old_grim = G.localization.descriptions.Spectral.c_grim.text
		G.localization.descriptions.Spectral.c_grim.text = { "Add {C:attention}#1#{} random {C:attention}Enhanced", "{C:attention}Aces{} to your hand" }
		
		card.ability.old_incantation = G.localization.descriptions.Spectral.c_incantation.text
		G.localization.descriptions.Spectral.c_incantation.text = { "Add {C:attention}#1# random", "{C:attention}Enhanced numbered", "{C:attention}cards{} to your hand" }
		
		card.ability.old_wraith = G.localization.descriptions.Spectral.c_wraith.text
		G.localization.descriptions.Spectral.c_wraith.text = { "Creates a random", "{C:red}Rare{C:attention} Joker{}" }
		
		card.ability.old_ankh = G.localization.descriptions.Spectral.c_ankh.text
		G.localization.descriptions.Spectral.c_ankh.text = { "Create a copy of a", "random {C:attention}Joker{}" }
		
		card.ability.old_hex = G.localization.descriptions.Spectral.c_hex.text
		G.localization.descriptions.Spectral.c_hex.text = { "Add {C:dark_edition}Polychrome{} to", "a random {C:attention}Joker{}" }
		
		card.ability.old_immolate = G.localization.descriptions.Spectral.c_immolate.text
		G.localization.descriptions.Spectral.c_immolate.text = { "Gain {C:money}$#2#" }
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.localization.descriptions.Spectral.c_ouija.text = card.ability.old_ouija
		G.localization.descriptions.Spectral.c_ectoplasm.text = card.ability.old_ectoplasm
		G.localization.descriptions.Spectral.c_familiar.text = card.ability.old_familiar
		G.localization.descriptions.Spectral.c_grim.text = card.ability.old_grim
		G.localization.descriptions.Spectral.c_incantation.text =card.ability.old_incantation
		G.localization.descriptions.Spectral.c_wraith.text = card.ability.old_wraith
		G.localization.descriptions.Spectral.c_ankh.text = card.ability.old_ankh
		G.localization.descriptions.Spectral.c_hex.text = card.ability.old_hex
		G.localization.descriptions.Spectral.c_immolate.text = card.ability.old_immolate
	end,
}

SMODS.Joker {
	key = "moss",
	loc_txt = {
		name = "Moss",
		text = {
			"{S:1.1,C:dark_edition,E:2}You found it!{}",
		}
	},
	config = {
		joker_slots = 1
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.joker_slots } }
	end,
	rarity = 1,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 5, y = 1 },
	cost = 10,
	add_to_deck = function(self, card, from_debuff)
		play_sound("UTDR_moss", 1.0, 1.5)
		G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.joker_slots
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.joker_slots
	end,
}