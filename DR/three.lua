--desert board
SMODS.Joker {
	key = "lanino_elnina",
	loc_txt = {
		name = "Lanino & Elnina",
		text = {
			"Upgrades a random",
			"{C:attention}Poker Hand{} when",
			"Blind is selected"
		}
	},
	rarity = 1,
	config = {
		polycule_odds = 3
	},
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 3, y = 4 },
	cost = 4,
	set_ability = function(self, card, initial, delay_sprites)
		card.ability.selected_hand = pseudorandom_element(get_keys(G.GAME.hands), "elnino_lanina")
	end,
	calculate = function(self, card, context)
		if context.setting_blind then
			local selected_hand = pseudorandom_element(get_keys(G.GAME.hands), "elnino_lanina")
			if #SMODS.find_card("j_UTDR_rouxls", true) > 0 and SMODS.pseudorandom_probability(card, "lanino_elnina_rouxls", 1, card.ability.polycule_odds, "DR_lanino_elnina_rouxls") then
				selected_hand = "Three of a Kind"
			end
			card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize('k_upgrade_ex') })
			update_hand_text( {sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, { handname=localize(selected_hand, 'poker_hands'), chips = G.GAME.hands[selected_hand].chips, mult = G.GAME.hands[selected_hand].mult, level=G.GAME.hands[selected_hand].level})
			level_up_hand(card, selected_hand, nil, 1)
			update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
		end
	end
}

SMODS.Joker {
	key = "gingerguard",
	loc_txt = {
		name = "Ginger Guard",
		text = {
			"Played {C:attention}Steel{} cards give",
			"{C:chips}+#1#{} Chips when scored"
		}
	},
	config = {
		chips = 50
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 4, y = 5 },
	cost = 4,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.m_steel 
		return { vars = { card.ability.chips } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and SMODS.has_enhancement( context.other_card, "m_steel") then
			return {
				chips = card.ability.chips
			}
		end
	end
}

SMODS.Joker {
	key = "tenna",
	loc_txt = {
		name = "Mr. (Ant) Tenna",
		text = {
			"Creates a {C:tarot}Tarot{} card when",
			"played hand is a {C:attention}#1#{}",
			"{s:0.8}hand changes at end of round",
			"{C:inactive}(Must have room)"
		}
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 4, y = 4 },
	cost = 6,
	config = {
		selected_hand = "High Card"
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { G.localization.misc.poker_hands[card.ability.selected_hand]} }
	end,
	set_ability = function(self, card, initial, delay_sprites)
		card.ability.selected_hand = pseudorandom_element(get_keys(G.GAME.hands), "tenna")
	end,
	calculate = function(self, card, context)
		if context.before and context.cardarea == G.jokers and context.scoring_name == card.ability.selected_hand then
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.4,
				func = function()
					if G.consumeables.config.card_limit > #G.consumeables.cards then
						play_sound('timpani')
						local new_card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'tenna')
						new_card:add_to_deck()
						G.consumeables:emplace(new_card)
						card:juice_up(0.3, 0.5)
						local number = pseudorandom_element({ "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" }, "tenna_blip")
						play_sound('UTDR_tenna_blip_'..number, 1.0, 0.7)
						card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Amazing!" } )
					end
					return true
				end
			}))
		elseif context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
			card.ability.selected_hand = pseudorandom_element(get_keys(G.GAME.hands), "tenna")
			while not G.GAME.hands[card.ability.selected_hand].visible do
				card.ability.selected_hand = pseudorandom_element(get_keys(G.GAME.hands), "tenna")
			end
		end
	end
}

SMODS.Joker {
	key = "tv_world",
	loc_txt = {
		name = "TV World",
		text = {
			"This Joker gains {C:mult}+#1#{} Mult",
			"per {C:attention}consecutive hand",
			"played with a {V:1}#2#{} card",
			"{s:0.8}suit changes at end of round",
			"{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult)"
		},
	},
	config = {
		mult_gain = 1,
		mult = 0,
		selected_suit = 'Hearts'
	},
	loc_vars = function(self, info_queue, card)
		return { 
			vars = { card.ability.mult_gain,
			localize(card.ability.selected_suit, 'suits_singular'),
			card.ability.mult ,
			colours =  {
				G.C.SUITS[card.ability.selected_suit] }
			}
		}
	end,
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 0, y = 5 },
	cost = 5,
	set_ability = function(self, card, initial, delay_sprites)
		card.ability.selected_suit = pseudorandom_element(get_keys(G.C.SUITS), "tv_world")
	end,
	calculate = function(self, card, context)
		if context.before and context.cardarea == G.jokers and not context.blueprint then
			local suit_count = 0
			for i = 1, #context.scoring_hand do
				if context.scoring_hand[i]:is_suit(card.ability.selected_suit) or SMODS.has_any_suit(context.scoring_hand[i]) then
					suit_count = suit_count + 1
				end
			end
			if suit_count > 0 then
				card.ability.mult = card.ability.mult + card.ability.mult_gain
				return {
					card = card,
					message = localize('k_upgrade_ex'),
					colour = G.C.MULT
				}
			else
				card.ability.mult = 0
				return {
					card = card,
					message = "KILLED",
					colour = G.C.MULT
				}
			end
		elseif context.joker_main then
			return {
				mult = card.ability.mult
			}
		elseif context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
			card.ability.selected_suit = pseudorandom_element(get_keys(G.C.SUITS), "tv_world")
		end
	end
}

SMODS.Joker {
	key = "watercooler",
	loc_txt = {
		name = "Watercooler",
		text = {
			"Played {C:attention}Wild Cards{} give",
			"{C:money}$#1#{} when scored",
			"{s:0.8,C:watercooler}#2#        "
		}
	},
	config = {
		bigbucks = 2,
		said_buble = false
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 5, y = 5 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.m_wild 
		local quote = pseudorandom_element({
			"Bable",
			"Beble",
			"Bible",
			"Boble",
			"Buble",
			"Buble",
			"Booble",
			"Babie",
			"Bebie",
			"Bibie",
			"Bobie",
			"Bubie",
			"Bubie",
			"Boobie"
		}, "watercooler")
		if not card.ability.said_buble then
			quote = "Buble"
			card.ability.said_buble = true
		end
		return { vars = { card.ability.bigbucks, quote } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, "m_wild") then
			return {
				dollars = card.ability.bigbucks
			}
		end
	end
}

--island board
SMODS.Joker {
	key = "mike",
	loc_txt = {
		name = "Mike",
		text = {
			"Gives {C:money}$#1#{} if played",
			"hand contains a",
			"{C:attention}#2#{}",
		}
	},
	config = {
		bigbucks = 5,
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 8, y = 6 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = {
			card.ability.bigbucks,
			G.localization.misc.poker_hands['Three of a Kind']
		} }
	end,
	calculate = function(self, card, context)
		if context.before and context.cardarea == G.jokers and next(context.poker_hands['Three of a Kind']) then
			return {
				dollars = card.ability.bigbucks
			}
		end
	end
}

SMODS.Joker {
	key = "knight",
	loc_txt = {
		name = "The Roaring Knight",
		text = {
			"At end of round, destroy",
			"{C:red}all cards held in hand",
			"and gain {X:mult,C:white}X#1#{} Mult",
			"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"
		}
	},
	config = {
		xmult_gain = 0.25,
		xmult = 1
	},
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 6, y = 4 },
	soul_pos = { x = 8, y = 7 },
	cost = 8,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult_gain, card.ability.xmult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				xmult = card.ability.xmult
			}
		elseif context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
			local cards_destroyed = G.hand.cards
			card_eval_status_text(card, 'extra', nil, nil, nil, { message = "SWOON", colour = G.C.RED })
			G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.1,
					func = function()
						play_sound("UTDR_swoon", 1.0, 1.0)
						return true
					end
				}))
			for i = 1, #G.hand.cards do
				local knife = G.hand.cards[i]
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.1,
					func = function()
						card:juice_up(0.3, 0.5)
						return true
					end
				}))
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.1,
					func = function() 
						if SMODS.has_enhancement(knife, "m_glass") then
							knife:shatter()
						else
							knife:start_dissolve(nil, false)
						end						
						return true
					end
				}))
            end
            card.ability.xmult = card.ability.xmult + card.ability.xmult_gain
			SMODS.calculate_context({remove_playing_cards = true, removed = cards_destroyed })
        end
	end
}

SMODS.Joker {
	key = "shelter",
	loc_txt = {
		name = "Shelter",
		text = {
			"{C:gaster}. . .{}"
		}
	},
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
	key = "blackshard",
	loc_txt = {
		name = "BlackShard",
		text = {
			"During {C:attention}Boss Blind{}, give",
			"{X:mult,C:white}X#1#{} Mult and played cards",
			"are {C:attention}retriggered{} when scored"
		}
	},
	config = {
		xmult = 2
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 2, y = 5 },
	cost = 8,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main and G.GAME.blind.boss then
			return {
				xmult = card.ability.xmult
			}
		elseif context.repetition and context.cardarea == G.play and G.GAME.blind.boss then
			return {
				message = localize('k_again_ex'),
				repetitions = 1,
				card = context.blueprint_card or card
			}
		end
	end
}


SMODS.Joker {
	key = "shadowguy",
	loc_txt = {
		name = "Shadowguy",
		text = {
			"{C:attention}Poker hands{} gain an",
			"additional {C:chips}+#1#{} Chips and",
			"{C:mult}+#2#{} Mult on level up"
		}
	},
	config = {
		chip_gain = 5,
		mult_gain = 2
	},
	rarity = 1,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 2, y = 7 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.chip_gain, card.ability.mult_gain } }
	end,
}

--big city board
SMODS.Joker {
	key = "oddcontroller",
	loc_txt = {
		name = "Odd Controller",
		text = {
			"{C:green}Uncommon{} and {C:red}Rare",
			"Jokers in shop are {C:attention}free"
		},
	},
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 0, y = 7 },
	cost = 8,
	add_to_deck = function(self, card, from_debuff)
		G.E_MANAGER:add_event(Event({
			func = function()
				for k, v in pairs(G.I.CARD) do
					if v.set_cost then v:set_cost() end
				end
				return true
			end
		}))
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.E_MANAGER:add_event(Event({
			func = function()
				for k, v in pairs(G.I.CARD) do
					if v.set_cost then v:set_cost() end
				end
				return true
			end
		}))
	end
}

SMODS.Joker {
	key = "hero_sword",
	loc_txt = {
		name = "HERO_SWORD",
		text = {
			"Creates a {C:tarot}Tarot{} card when a",
			"a {C:attention}playing card{} is destroyed",
			"{C:inactive}(Must have room)"
		},
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 1, y = 7 },
	cost = 6,
	calculate = function(self, card, context)
		if context.remove_playing_cards and not context.blueprint then
			for i = 1, #context.removed do
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.4,
					func = function()
						if G.consumeables.config.card_limit > #G.consumeables.cards then
							play_sound('timpani')
							local new_card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'HERO_SWORD')
							new_card:add_to_deck()
							G.consumeables:emplace(new_card)
							card:juice_up(0.3, 0.5)
							card_eval_status_text(card, 'extra', nil, nil, nil, { message = "GOT STRONGER" } )
						end
						return true
					end
				}))
			end
		end
	end
}

SMODS.Joker {
	key = "ramb",
	loc_txt = {
		name = "Ramb",
		text = {
			"Creates a {C:tarot}Tarot{} or {C:planet}Planet",
			"card at end of round",
			"{C:inactive}(Must have room)"
		},
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 5, y = 4 },
	cost = 5,
	calculate = function(self, card, context)
		if context.end_of_round and context.cardarea == G.jokers then
			G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.4,
					func = function()
						if G.consumeables.config.card_limit > #G.consumeables.cards then
							play_sound('timpani')
							local new_card = create_card(pseudorandom_element({'Tarot', 'Planet'}, "ramb"), G.consumeables, nil, nil, nil, nil, nil, 'ramb')
							new_card:add_to_deck()
							G.consumeables:emplace(new_card)
							card:juice_up(0.3, 0.5)
							card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Nice, luv." } )
						end
						return true
					end
				}))
		end
	end
}

SMODS.Joker {
	key = "ERAM",
	loc_txt = {
		name = "ERAM",
		text = {
			"{C:attention}Discarded{} cards have",
			"a {C:green}#1# in #2#{} chance to",
			"be {C:red}destroyed"
		}
	},
	config = {
		odds = 15
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 3, y = 5 },
	soul_pos = { x = 1, y = 8 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		local probabilities_normal, odds = SMODS.get_probability_vars(card, 1, card.ability.odds, "DR_ERAM")
		if math.fmod(os.time(), 16) == 0  then
			return {
				key = "j_UTDR_john_mantle",
				vars = { probabilities_normal, odds }
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

--dummy joker so ERAM can say john mantle some of the time
SMODS.Joker {
	key = "john_mantle",
	loc_txt = {
		name = "John Mantle",
		text = {
			"{C:attention}Discarded{} cards have",
			"a {C:green}#1# in #2#{} chance to",
			"be {C:red}destroyed"
		}
	},
	no_collection = true,
	in_pool = function(self, args)
		return false
	end,
}

SMODS.Joker {
	key = "shadow_mantle",
	loc_txt = {
		name = "Shadow Mantle",
		text = {
			"Gain {C:blue}+#1#{} Hands",
			"and {C:red}+#2#{} Discards",
			"during {C:attention}Boss Blind{}"
		}
	},
	config = {
		hands = 2,
		discards = 2
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 3, y = 5 },
	soul_pos = { x = 1, y = 5 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.hands, card.ability.discards } }
	end,
	calculate = function(self, card, context)
		if context.setting_blind and G.GAME.blind.boss then
			ease_hands_played(card.ability.hands)
			card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize{type = 'variable', key = 'a_hands', vars = {card.ability.hands}}, colour = G.C.BLUE })
            ease_discard(card.ability.discards)
            card_eval_status_text(card, 'extra', nil, nil, nil, { message = "+"..card.ability.discards.." "..G.localization.misc.dictionary.k_hud_discards, colour = G.C.RED })
		end
	end
}