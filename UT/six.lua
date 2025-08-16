--unum
SMODS.Joker {
	key = "dummy",
	loc_txt = {
		name = "Dummy",
		text = {
			"{C:chips}+#1#{} Chips for",
			"each {C:attention}Joker{}",
			"{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)"
		}
	},
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
	loc_txt = {
		name = "Froggit",
		text = {
			"Each played card",
			"gives {C:chips}+#1#{} Chips and",
			"{C:mult}+#2#{} Mult when scored"
		},
	},
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
	loc_txt = {
		name = "Toby and Temmie",
		text = {
			"Creates a {C:purple}Voucher Tag",
			"when {C:attention}Boss Blind is defeated"
		},
	},
	config = {
		slot_count = 1,
		slotted = false,
		in_build = false
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.slot_count } }
	end,
	rarity = 1,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 8, y = 8 },
	cost = 6,
	calculate = function(self, card, context)
		if context.end_of_round and context.cardarea == G.jokers and G.GAME.blind.boss and not context.blueprint then
			card:juice_up(0.3,0.5)
			local tag = Tag("tag_voucher")
			add_tag(tag)
		end
	end
}

SMODS.Joker {
	key = "mad_mew_mew",
	loc_txt = {
		name = "Mad Mew Mew",
		text = {
			"Earn {C:money}$#1#{} when a {C:attention}King{}",
			"or {C:attention}Jack{} is destroyed"
		},
	},
	config = {
		money = 5,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.money } }
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
	loc_txt = {
		name = "Amalgamates",
		text = {
			"{C:attention}Wild Cards{} give {C:mult}+#1#{}",
			"Mult when scored"
		},
	},
	config = {
		mult = 5,
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.m_wild 
		return { vars = { card.ability.mult } }
	end,
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 3, y = 8 },
	cost = 4,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, 'm_wild') then
			return {
				mult = card.ability.mult
			}
		end
	end
}

--duo
SMODS.Joker {
	key = "micro_froggit",
	loc_txt = {
		name = "Micro Froggit",
		text = {
			"Each played {C:attention}7{} or",
			"{C:attention}2{} gives {C:mult}+#1#{} Mult",
			"when scored"
		},
		unlock = {
			"Play {E:1,C:attention}20{} Pairs {C:inactive}[#1#]"
		}
	},
	config = {
		mult = 7
	},
	--unlocked = false
	unlock_condition = {type = 'hand', count = 20, hand = 'Pair'},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 6, y = 8 },
	display_size = { w = 33.5, h = 47.5 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.mult } }
	end,
	locked_loc_vars = function(self, info_queue, card)
		if G.PROFILES[G.SETTINGS.profile].hand_usage["Pair"] then
			return { vars = { G.PROFILES[G.SETTINGS.profile].hand_usage["Pair"].count } }
		else
			return { vars = { 0 }}
		end
	end,
	--unlocked = false
	unlock_condition = {type = 'hand', count = 20, hand = 'Pair'},
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card.base.value == "7" or context.other_card.base.value == "2" then
				return {
					mult = card.ability.mult
				}
			end
		end
	end
}

SMODS.Joker {
	key = "CORE",
	loc_txt = {
		name = "CORE",
		text = {
			"{C:attention}#1#s{} count as",
			"{C:attention}#2#es{}"
		},
		unlock = {
			"Discard a",
			"{E:1,C:attention}#1#"
		}
	},
	--unlocked = false
	unlock_condition = {type = 'discard_custom'},
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
	loc_txt = {
		name = "The Barrier",
		text = {
			"{C:attention}Debuffed cards{} give",
			"{C:money}$#1#{} when scored"
		},
		unlock = {
			"In one hand,",
			"earn at least",
			"{E:1,C:attention}1e11{} chips"
		},
	},
	config = {
		money = 2,
	},
	--unlocked = false
	unlock_condition = {
		type = 'chip_score',
		chips = 100000000000
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.money } }
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
	loc_txt = {
		name = "The Surface",
		text = {
			"Played {C:attention}Stone Cards{} give",
			"{C:mult}+#1#{} Mult when scored"
		},
		unlock = {
			"Have at least {E:1,C:attention}5",
			"{E:1,C:attention}Stone Cards{} in",
			"your deck",
		},
	},
	config = {
		mult = 5,
	},
	--unlocked = false
	unlock_condition = { type = 'modify_deck', extra = { count = 5, enhancement = 'Stone Card', e_key = 'm_stone' } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.m_stone 
		return { vars = { card.ability.mult } }
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
	key = "end",
	loc_txt = {
		name = "The End",
		text = {
			"Earn {C:money}$12{} when",
			"{C:attention}Boss Blind{} is defeated"
		},
		unlock = {
			"Win a run with any",
			"deck on at least",
			"{E:1,V:1}#1#{} difficulty",
		},
	},
	config = {
		extra = 12,
		was_boss = false,
	},
	--unlocked = false
	unlock_condition = { type = 'win_stake', stake = 4 },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.mult } }
	end,
	locked_loc_vars = function(self, info_queue, card)
		return { vars = { localize{ type = 'name_text', set = 'Stake', key = G.P_CENTER_POOLS.Stake[4].key }, colours = {get_stake_col(4) } } }
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
	end
}

--tres

SMODS.Joker {
	key = "fun_value",
	loc_txt = {
		name = "fun value",
		text = {
			"Each Joker has a {C:green}#1# in #2#",
			"chance to give {X:mult,C:white}X#3#{} Mult"
		},
		unlock = {
			"{E:1,C:green}#1# in 10{} chance to unlock",
			"after {E:1,C:attention}winning{} a run",
		},
	},
	config = {
		xmult = 1.5,
		odds = 3
	},
	--unlocked = false
	unlock_condition = { type = 'win_custom' },
	loc_vars = function(card, info_queue, card)
		return { vars = { G.GAME.probabilities.normal, card.ability.odds, card.ability.xmult } }
	end,
	locked_loc_vars = function(self, info_queue, card)
		return { vars = { G.GAME.probabilities.normal } }
	end,
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "UT_jokers",
	pos = { x = 9, y = 8 },
	cost = 8,
	calculate = function(self, card, context)
		if context.other_joker and pseudorandom("fun_value") < G.GAME.probabilities.normal/card.ability.odds then
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
	loc_txt = {
		name = "True Reset",
		text = {
			"{C:attention}Sell{} this card to {S:1.1,C:red,E:2}destroy all",
			"{S:1.1,C:red,E:2}Jokers{} and create an equal",
			"number of {C:dark_edition}Negative{} Tags",
		},
		unlock = {
			"Beat the {E:1,C:attention}Ante{}",
			"{E:1,C:attention}0{} Boss Blind"
		}
	},
	--unlocked = false
	unlock_condition = { type = 'round_win' },
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = false,
	atlas = "UT_jokers",
	pos = { x = 2, y = 8 },
	cost = 7,
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
	loc_txt = {
		name = "______",
		text = {
			"{C:gaster}WELCOME.",
			"{C:gaster}HAVE YOU BEEN LOOKING FOR ME?",
			"{C:gaster}HOW WONDERFUL.",
			"{C:gaster}I HAVE BEEN LOOKING FOR YOU AS WELL."
		},
		unlock = {
			"{C:gaster}AT THAT TIME,",
			"{C:gaster}I WILL ASK YOU",
			"{C:gaster}A FEW QUESTIONS."
		}
	},
	--unlocked = false
	unlock_condition = {type = 'win_custom'},
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
	key = "SURVEY_PROGRAM",
	loc_txt = {
		name = "SURVEY_PROGRAM",
		text = {
			"Gains {X:mult,C:white}X#1#{} Mult when",
			"a {C:spectral}Spectral{} card is used",
			"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"
		},
		unlock = {
			"Win {E:1,C:attention}5{} runs {C:inactive}[#1#]"
		}
	},
	config = {
		xmult_gain = 0.5,
		xmult = 1
	},
	loc_vars = function(self, info_queue, card)
		if UTDR.config_file.deltarune then
			return { key = "j_UTDR_SURVEY_PROGRAM_DR", vars = { card.ability.xmult_gain, card.ability.xmult } }
		end
		return { vars = { card.ability.xmult_gain, card.ability.xmult } }
	end,
	locked_loc_vars = function(self, info_queue, card)
		return { vars = { G.PROFILES[G.SETTINGS.profile].career_stats.c_wins } }
	end,
	--unlocked = false
	unlock_condition = {type = 'win_custom', count = 5},
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
						card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize { type='variable', key='a_xmult', vars = { card.ability.xmult } }, colour = G.C.MULT });
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
	key = "SURVEY_PROGRAM_DR",
	loc_txt = {
		name = "SURVEY_PROGRAM",
		text = {
			"Gains {X:mult,C:white}X#1#{} Mult when",
			"a {C:spectral}Prophecy{} card is used",
			"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"
		},
		unlock = {
			"Win {E:1,C:attention}5{} runs {C:inactive}[#1#]"
		}
	},
	no_collection = true,
	in_pool = function(self, args)
		return false
	end,
	atlas = "UT_jokers",
}

SMODS.Joker {
	key = "vessel",
	loc_txt = {
		name = "VESSEL",
		text = {
			"Gains {X:mult,C:white}X#1#{} Mult",
			"for each sold {C:attention}Joker",
			"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"
		},
		unlock = {
			"Sell {E:1,C:attention}30{} Jokers"
		}
	},
	config = {
		xmult_gain = 0.15,
		xmult = 1
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult_gain, card.ability.xmult } }
	end,
	--unlocked = false
	unlock_condition = {type = 'money'},
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
	cost = 7,
	calculate = function(self, card, context)
		if context.selling_card and context.card ~= card and context.card.ability.set == "Joker" and not context.blueprint then
			card.ability.xmult = card.ability.xmult + card.ability.xmult_gain
			G.E_MANAGER:add_event(
				Event({
					func = function()
						card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.xmult } }, colour = G.C.MULT });
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