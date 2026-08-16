--beginning
SMODS.Joker {
	key = "hometown",
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
	key = "berdly",
	config = {
		mult = 6,
		bigbucks = 1,
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_lucky
		return { vars = { card.ability.mult, card.ability.bigbucks, localize({ type = 'name_text', set = "Enhanced", key = "m_lucky" }) or 'Lucky Card' } }
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
		elseif context.individual and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, "m_lucky") then
			return {
				mult = card.ability.mult,
				dollars = card.ability.bigbucks
			}
		end
	end
}

SMODS.Joker {
	key = "newsletter",
	config = {
		money = 6,
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
		if G.GAME.blind.boss then
			return card.ability.money
		end
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval and not context.beat_boss then
			local card_type = "Planet"
			if G.GAME.last_blind.name == "Big Blind" then
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
						card:juice_up(0.3, 0.5)
					end
					return true
				end
			}))
		end
	end
}

SMODS.Joker {
	key = "noelle",
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
		info_queue[#info_queue + 1] = G.P_CENTERS.m_glass
		local probabilities_normal, odds = SMODS.get_probability_vars(card, 1, card.ability.odds, "DR_noelle")
		if #SMODS.find_card("j_UTDR_thornring") > 0 then
			return {
			key = "j_UTDR_noelle_side_b",
			vars = {
				localize({ type = 'name_text', set = "Enhanced", key = "m_glass" }) or 'Glass Card',
				card.ability.thorn_ring_xmult,
			} }
		elseif #SMODS.find_card("j_UTDR_susie") > 0 then
			return {
			key = "j_UTDR_suselle",
			vars = {
				localize({ type = 'name_text', set = "Enhanced", key = "m_glass" }) or 'Glass Card',
				card.ability.xmult,
				odds,
			} }
		else
			return { vars = {
				localize({ type = 'name_text', set = "Enhanced", key = "m_glass" }) or 'Glass Card',
				card.ability.xmult,
				probabilities_normal,
				odds,
			} }
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
			if #SMODS.find_card("j_UTDR_susie") > 0 and #SMODS.find_card("j_UTDR_thornring") == 0 then
				return {
					numerator = 0,
					denominator = card.ability.odds
				}
			end
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
	key = "save",
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

--cyber world
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

SMODS.Joker {
	key = "kris",
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 6, y = 1 },
	cost = 10,
	loc_vars = function(self, info_queue, card)
		if card.area and card.area == G.jokers then
			local key = "j_UTDR_kris"
			local element = nil
			if #SMODS.find_card("j_UTDR_you") > 0 then
				if self.icon and self.icon.remove then
					self.icon:remove()
					self.icon = nil
				end
				self.icon = Sprite(0, 0, 0.46, 0.46, G.ASSET_ATLAS["UTDR_souls"], { x = 8, y = 0 })
				element = {
					n = G.UIT.C,
					config = { align = "cm", padding = 0.1 },
					nodes = {
						{ n = G.UIT.O, config = { object = self.icon } },
					}
				}
				key = "j_UTDR_kris_split"
			end
		
            local other_joker = nil

			-- find kris
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    other_joker = G.jokers.cards[i-1]
                    break
                end
            end

			-- create the ui as needed
			local compatible = other_joker and other_joker.config.center.blueprint_compat
			return {
				key = key,
				vars = { elements = { element } },
				main_end = {{n=G.UIT.C, config={align = "bm", mh = 0.4}, nodes={
					{n=G.UIT.C, config={
						ref_table = card,
						align = "m",
						colour = mix_colours(compatible and G.C.GREEN or G.C.RED, G.C.JOKER_GREY, 0.8),
						r = 0.05,
						padding = 0.06,
					}, nodes={
						{n=G.UIT.T, config={
							text = compatible and localize("k_compatible") or localize("k_incompatible"),
							colour = G.C.UI.TEXT_LIGHT,
							scale = 0.32*0.8
						}},
					}}
				}}}
			}
		end
	end,
	calculate = function(self, card, context)
		if G.GAME.current_round.hands_played < 1 then
			local other_joker = nil
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] == card then
					other_joker = G.jokers.cards[i - 1]
					break
				end
			end
			return SMODS.blueprint_effect(card, other_joker, context)
		end
	end
}

SMODS.Joker {
	key = "you",
	unlocked = false,
	unlock_condition = { type = '', extra = '', hidden = true },
	rarity = 4,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 4, y = 7 },
	soul_pos = { x = 3, y = 8 },
	cost = 20,
	loc_vars = function(self, info_queue, card)
		if card.area and card.area == G.jokers then
            local nodes = {}
            local jokers = {}

			-- find you
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    jokers[1] = G.jokers.cards[i-1]
                    jokers[2] = G.jokers.cards[i+1]
                    break
                end
            end

			-- create the ui
            for i = 1, 2 do
                local other_joker = jokers[i]
                local compatible = other_joker and other_joker.config.center.blueprint_compat
                nodes[#nodes+1] = {n=G.UIT.C, config={
					ref_table = card,
					align = "m",
					colour = mix_colours(compatible and G.C.GREEN or G.C.RED, G.C.JOKER_GREY, 0.8),
					r = 0.05,
					padding = 0.06,
				}, nodes={
					{n=G.UIT.T, config={
						text = compatible and localize("k_compatible") or localize("k_incompatible"),
						colour = G.C.UI.TEXT_LIGHT,
						scale = 0.32*0.8
					}},
				}}

				-- create a spacer node if we aren't on the last node
                if i ~= 2 then nodes[#nodes+1] = {n=G.UIT.B, config={align = "m", h = 0.4, w = 0.12}} end
            end

			return {
				main_end = {{n=G.UIT.C, config={align = "bm", mh = 0.4}, nodes=nodes}}
			}
		end
	end,
	calculate = function(self, card, context)
		local left_joker_results, right_joker_results
		for i = 1, #G.jokers.cards do
			if G.jokers.cards[i] == card then
				local left_joker = G.jokers.cards[i-1]
                local right_joker = G.jokers.cards[i+1]

				-- copy left joker
                -- also check for if we're trying to copy context.blueprint_card; if so, don't copy it
				if left_joker and left_joker ~= context.blueprint_copier then
                    left_joker_results = SMODS.blueprint_effect(card, left_joker, context)
                end

                -- copy right joker
                -- again, check for if we're trying to copy context.blueprint_card
                if right_joker and right_joker ~= context.blueprint_copier then
                    right_joker_results = SMODS.blueprint_effect(card, right_joker, context)
                end

				-- stop the loop; we've found what we need
                break
			end
		end
		
		local results = SMODS.merge_effects({ left_joker_results or {}, right_joker_results or {} })
		return results
	end
}

SMODS.Joker {
	key = "susie",
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

--dark night
SMODS.Joker {
	key = "ralsei_dummy",
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
			return {
				vars = {
					card.ability.mult_per,
					card.ability.mult,
					localize({ type = 'name_text', set = "Joker", key = "j_UTDR_ralsei_dummy" })
				}
			}
		else
			return {
				vars = {
					card.ability.mult_per,
					card.ability.mult_per,
					localize({ type = 'name_text', set = "Joker", key = "j_UTDR_ralsei_dummy" })
				}
			}
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
	key = "castle_town",
	config = {
		mult_per = 5
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 1, y = 2 },
	cost = 6,
	loc_vars = function(self, info_queue, card)
		if G.playing_cards then
			if #G.playing_cards > G.GAME.starting_deck_size then
				return { vars = { card.ability.mult_per, G.GAME.starting_deck_size, (card.ability.mult_per * (#G.playing_cards - G.GAME.starting_deck_size)), string.lower(localize("b_full_deck")) } }
			else
				return { vars = { card.ability.mult_per, 52, 0, string.lower(localize("b_full_deck")) } }
			end
		else
			return { vars = { card.ability.mult_per, G.GAME.starting_deck_size, (card.ability.mult_per * (52 - G.GAME.starting_deck_size)), string.lower(localize("b_full_deck")) } }
		end
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult = (card.ability.mult_per * (G.playing_cards and (#G.playing_cards - G.GAME.starting_deck_size) or 0))
			}
		end
	end
}

SMODS.Joker {
	key = "ralsei",
	config = {
		repetitions = 2
	},
	loc_vars = function(self, info_queue, card)
		local ralseis = true
		if not ralseis then
			return {
				key = "j_UTDR_ralseis",
				vars = {
					G.GAME.current_round.ralsei_card.selected_rank or "Queen",
					G.GAME.current_round.ralsei_card.selected_suit or "Hearts",
					card.ability.repetitions,
					colours = {
						G.C.SUITS[G.GAME.current_round.ralsei_card.selected_suit or "Hearts"] }
				}
			}
		end
		return {
			vars = {
				G.GAME.current_round.ralsei_card.selected_rank or "Queen",
				G.GAME.current_round.ralsei_card.selected_suit or "Hearts",
				card.ability.repetitions,
				colours = {
					G.C.SUITS[G.GAME.current_round.ralsei_card.selected_suit or "Hearts"] }
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
		if G.GAME.current_round and #SMODS.find_card("j_UTDR_ralsei") == 0 then --check to ensure a duplicated ralsei will not change the ralsei card
			G.GAME.current_round.ralsei_card = { }
			G.GAME.current_round.ralsei_card.selected_suit = "Hearts"
			G.GAME.current_round.ralsei_card.selected_rank = "Queen"
			if G.playing_cards then
				local selected_card = pseudorandom_element(G.playing_cards, "ralsei")
				if selected_card and selected_card.base and selected_card.base.suit and selected_card.base.value then
					G.GAME.current_round.ralsei_card.selected_suit = selected_card.base.suit
					G.GAME.current_round.ralsei_card.selected_rank = selected_card.base.value
				end
			end
		end
	end,
	calculate = function(self, card, context)
		if context.repetition and context.cardarea == G.play and (context.other_card:is_suit(G.GAME.current_round.ralsei_card.selected_suit) or SMODS.has_any_suit(context.other_card)) and context.other_card.base.value == G.GAME.current_round.ralsei_card.selected_rank then
			local ralseis = true
			if not ralseis then
				return {
					message = "",
					repetitions = card.ability.repetitions
				}
			end
			return {
				repetitions = card.ability.repetitions
			}
		elseif context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
			local selected_card = pseudorandom_element(G.playing_cards, "ralsei")
			G.GAME.current_round.ralsei_card.selected_suit = selected_card.base.suit
			G.GAME.current_round.ralsei_card.selected_rank = selected_card.base.value
		end
	end
}

SMODS.Joker {
	key = "dark_fountain",
	config = {
		turn_cap = 3,
		turns = 0
	},
	rarity = 3,
	blueprint_compat = false,
	eternal_compat = false,
	atlas = "DR_jokers",
	pos = { x = 2, y = 2 },
	soul_pos = { x = 6, y = 7 },
	cost = 8,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
		return { vars = { card.ability.turn_cap, card.ability.turns, G.localization.descriptions.Edition.e_negative.name } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
			card.ability.turns = card.ability.turns + 1
			card:juice_up(0.3, 0.4)
			if card.ability.turns >= card.ability.turn_cap then
				local eval = function(card)
					return card.ability.turns >= card.ability.turn_cap
				end
				juice_card_until(card, eval, true)
			end
		elseif context.selling_self and #G.jokers.cards > 1 and card.ability.turns >= card.ability.turn_cap and not context.blueprint then
			local joker = nil
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] == card then
					joker = G.jokers.cards[i + 1]
				end
			end
			if joker then
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.4,
					func = function()
						joker:set_edition("e_negative", true)
						return true
					end
				}))
			end
		end
	end
}

SMODS.Joker {
	key = "moss",
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