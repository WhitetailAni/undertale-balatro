SMODS.Joker {
	key = "the_lake",
	rarity = 1,
	config = {
		rank_increase = 1,
	},
	loc_vars = function(self, info_queue, card)
		if math.fmod(os.time(), 512) == 0 then
			return {
				vars = { card.ability.rank_increase },
				key = "j_UTDR_xaviers_lake",
			}
		end
		return { vars = { card.ability.rank_increase } }
	end,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 4, y = 10 },
	cost = 6,
	calculate = function(self, card, context)
		if context.before then
			local scoring_hand = {}
			for i = 1, #context.scoring_hand do
				scoring_hand[context.scoring_hand[i]] = true
			end

			local unscoring_hand_indexes = {}
			for i = 1, #context.full_hand do
				if not scoring_hand[context.full_hand[i]] then
					table.insert(unscoring_hand_indexes, i)
				end
			end

			for i = 1, #unscoring_hand_indexes do
				G.E_MANAGER:add_event(Event({
					func = function()
						SMODS.modify_rank(context.full_hand[unscoring_hand_indexes[i]], card.ability.rank_increase)
						context.full_hand[unscoring_hand_indexes[i]]:juice_up()
						return true
					end
				}))
			end
		end
	end
}

SMODS.Joker {
	key = "aqua",
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 6, y = 9 },
	cost = 3,
	loc_vars = function(self, info_queue, card)
		if self.icon and self.icon.remove then
			self.icon:remove()
			self.icon = nil
		end
		self.icon = Sprite(0, 0, 0.46, 0.46, G.ASSET_ATLAS["UTDR_flowers"], { x = 0, y = 0 })
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
		if context.individual and context.cardarea == G.play then
			G.E_MANAGER:add_event(Event({
				func = function()
					ease_background_colour{new_colour = G.C.FLOWER_AQUA_BG, contrast = 1}
					return true
				end
			}))
			return {
				mult = (math.floor(pseudorandom("aqua") * 6) + 1),
				card = context.blueprint_card or card
			}
		end
	end
}

SMODS.Joker {
	key = "petal_feather",
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 2, y = 9 },
	soul_pos = { x = 2, y = 12 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		local h = math.floor(pseudorandom("utdr_petal_feather_preview") * #G.handlist + 1)

		local rets = { G.handlist[h] }
		rets[#rets + 1] = G.handlist[h - 1]
		rets[#rets + 1] = G.handlist[h + 1]

		return { vars = rets, key = self.key .. (#rets == 2 and "_1hand" or "") }
	end,
	calculate = function(self, card, context)
		if context.evaluate_poker_hand then
			local t = SMODS.shallow_copy(context.poker_hands)

			for i, v in ipairs(G.handlist) do
				if v == context.scoring_name then
					local next = { G.handlist[i - 1], G.handlist[i + 1] }

					for _, v2 in ipairs(next) do
						t[v2] = t[v]
					end
				end
			end

			return {
				replace_poker_hands = t
			}
		end
	end
}

SMODS.Joker {
	key = "seth",
	config = {
		levelup_chance = 5,
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 5, y = 9 },
	cost = 6,
	loc_vars = function(self, info_queue, card)
		local probabilities_normal, levelup_chance = SMODS.get_probability_vars(card, 1, card.ability.levelup_chance,
			"DR_seth")
	
		if self.icon and self.icon.remove then
			self.icon:remove()
			self.icon = nil
		end
		self.icon = Sprite(0, 0, 0.46, 0.46, G.ASSET_ATLAS["UTDR_flowers"], { x = 4, y = 0 })
		local element = {
			n = G.UIT.C,
			config = { align = "cm", padding = 0.1 },
			nodes = {
				{ n = G.UIT.O, config = { object = self.icon } },
			}
		}
		
		return {
			vars = {
				probabilities_normal,
				levelup_chance,
				localize("k_planet"),
				elements = { element }
			}
		}
	end,
	calculate = function(self, card, context)
		if context.using_consumeable and context.consumeable.config.center.set == "Planet" and SMODS.pseudorandom_probability(card, "seth_levelup", 1, card.ability.levelup_chance, "DR_seth_levelup") then
			local most_played_count = 0
			local most_played = "Pair"
			for key, value in pairs(G.GAME.hands) do
				if value.played >= most_played_count and value.visible then
					most_played = key
					most_played_count = value.played
				end
			end
			
			G.E_MANAGER:add_event(Event({
				func = function()
					ease_background_colour{new_colour = G.C.FLOWER_SETH_BG, contrast = 1}
					return true
				end
			}))
			
			return {
				level_up = 1,
				level_up_hand = most_played,
				message = localize("k_upgrade_ex")
			}
		end
	end
}

SMODS.Joker {
	key = "festival",
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.booster_mod } }
	end,
	blueprint_compat = false,
	perishable_compat = true,
	eternal_compat = true,
	attributes = {
		"passive",
	},
	rarity = 1,
	cost = 5,
	atlas = "DR_jokers",
	pos = { x = 1, y = 10 },
	config = {
		booster_mod = 1
	},
	add_to_deck = function(self, card, from_debuff)
		G.GAME.modifiers.booster_size_mod = (G.GAME.modifiers.booster_size_mod or 0) + card.ability.booster_mod
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.GAME.modifiers.booster_size_mod = (G.GAME.modifiers.booster_size_mod or 0) - card.ability.booster_mod
	end
}

SMODS.Joker {
	key = "yellow",
	config = {
		required_suit_num = 2,
		xmult = 2,
		all_punishments_worse_than_burying = false
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = false,
	atlas = "DR_jokers",
	pos = { x = 3, y = 9 },
	cost = 6,
	loc_vars = function(self, info_queue, card)
		if self.icon and self.icon.remove then
			self.icon:remove()
			self.icon = nil
		end
		self.icon = Sprite(0, 0, 0.46, 0.46, G.ASSET_ATLAS["UTDR_flowers"], { x = 5, y = 0 })
		local element = {
			n = G.UIT.C,
			config = { align = "cm", padding = 0.1 },
			nodes = {
				{ n = G.UIT.O, config = { object = self.icon } },
			}
		}
		if #SMODS.find_card("j_UTDR_blue") > 0 then
			return { vars = {
				card.ability.xmult,
				card.ability.required_suit_num,
				elements = { element }
			}, key = "j_UTDR_yellow_gay" }
		end
		return { vars = {
			card.ability.xmult,
			card.ability.required_suit_num,
			elements = { element }
		} }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			local suits = {}
			local suit_count = 0
			for i = 1, #context.scoring_hand do
				if not context.scoring_hand[i].debuff then
					suits[context.scoring_hand[i].base.suit] = (suits[context.scoring_hand[i].base.suit] or 0) + 1
					if (suits[context.scoring_hand[i].base.suit] == 1) then
						suit_count = suit_count + 1
					end
				end
			end
			if suit_count == card.ability.required_suit_num then
				if not context.blueprint then
					card.ability.all_punishments_worse_than_burying = true
				end
				G.E_MANAGER:add_event(Event({
				func = function()
					ease_background_colour{new_colour = G.C.FLOWER_YELLOW_BG, contrast = 1}
					return true
				end
			}))
				return {
					xmult = card.ability.xmult
				}
			end
		end
		if context.ante_change and not context.blueprint and #SMODS.find_card("j_UTDR_blue") == 0 then
			if card.ability.all_punishments_worse_than_burying then
				card.ability.all_punishments_worse_than_burying = false
			else
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
								return true;
							end
						}))
						return true
					end
				}))
				return {
					message = localize("k_UTDR_yellow_thanks"),
					message_colour = G.C.YELLOW,
				}
			end
		end
	end
}

SMODS.Joker {
	key = "flower_castle",
	config = {
		chips = 0,
		chip_gain = 2
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.chip_gain, localize("Clubs", 'suits_singular'), card.ability.chips } }
	end,
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 2, y = 10 },
	cost = 3,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and (context.other_card.base.suit == "Clubs" or SMODS.has_any_suit(context.other_card)) then
			SMODS.scale_card(card, {
				ref_table = card.ability,
				ref_value = "chips",
				scalar_value = "chip_gain",
				message_colour = G.C.CHIPS
			})
		elseif context.joker_main then
			return {
				chips = card.ability.chips
			}
		end
	end
}

--flowery has been imprisoned in his own lua file for his crimes
assert(SMODS.load_file('DR/flowery.lua'))()

G.FUNCS.get_unscored_cards = function(context)
	local scored_map = {}
	for _, v in ipairs(context.scoring_hand) do scored_map[v] = true end
	local unscored_cards = {}
	for _, v in ipairs(context.full_hand) do
		if not scored_map[v] then
			table.insert(unscored_cards, v)
		end
	end
	return unscored_cards
end

SMODS.Joker {
	key = "flowery_scarf",
	atlas = "DR_jokers",
	pos = { x = 6, y = 10 },
	config = { extra = { old = {} } },
	cost = 1,
	rarity = 1,
	blueprint_compat = false,
	perishable_compat = true,
	calculate = function(self, card, context)
		if context.before and not context.blueprint then
			local cards_to_enhance = {}
			for _, playing_card in ipairs(G.FUNCS.get_unscored_cards(context)) do
				if not playing_card.debuff then
					table.insert(cards_to_enhance, playing_card)
				end
			end
			if #cards_to_enhance > 0 then
				return {
					message = localize('k_upgrade_ex'),
					colour = G.C.SECONDARY_SET.Enhanced,
					func = function()
						for i, playing_card in ipairs(cards_to_enhance) do
							local new_enhancement = SMODS.poll_enhancement { key = "UTDR_flowery_scarf", guaranteed = true }
							local percent = 0.85 + (i - 0.999) / (#G.play.cards - 0.998) * 0.3
							local idx = 0
							for k, v in pairs(context.full_hand) do
								if v == playing_card then
									idx = k
									if not card.ability.extra.old[k] then
										card.ability.extra.old[k] = {
											cen = playing_card.config.center,
											vis = playing_card:should_hide_front(),
										}
									end
									break
								end
							end
							playing_card:set_ability(new_enhancement, nil, false)
							local new = {
								cen = playing_card.config.center,
								vis = playing_card:should_hide_front(),
							}
							if idx ~= 0 then
								local old = card.ability.extra.old[idx]
								playing_card:set_sprites(old.cen, nil)
								playing_card.front_hidden = old.vis
							end
							G.E_MANAGER:add_event(Event({
								trigger = 'immediate',
								func = function()
									play_sound('card1', percent)
									playing_card:flip()
									return true
								end
							}))
							G.E_MANAGER:add_event(Event({
								trigger = 'after',
								delay = 0.2,
								func = function()
									playing_card:set_sprites(new.cen, nil)
									playing_card.front_hidden = new.vis
									card.ability.extra.old[idx] = nil
									return true
								end
							}))
							G.E_MANAGER:add_event(Event({
								trigger = 'after',
								delay = 0.2,
								func = function()
									play_sound('tarot2', percent)
									playing_card:flip()
									return true
								end
							}))
						end
						return true
					end
				}
			end
		end
	end
}

SMODS.Joker {
	key = "blue",
	config = {
		required_chips = 75,
	},
	--unlocked = false
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 4, y = 9 },
	cost = 10,
	loc_vars = function(self, info_queue, card)
		if self.icon and self.icon.remove then
			self.icon:remove()
			self.icon = nil
		end
		self.icon = Sprite(0, 0, 0.46, 0.46, G.ASSET_ATLAS["UTDR_flowers"], { x = 1, y = 0 })
		local element = {
			n = G.UIT.C,
			config = { align = "cm", padding = 0.1 },
			nodes = {
				{ n = G.UIT.O, config = { object = self.icon } },
			}
		}
	
		return {
			vars = {
				card.ability.required_chips,
				elements = { element }
			}
		}
	end,
	calculate = function(self, card, context)
		if context.game_over and G.GAME.chips / G.GAME.blind.chips >= card.ability.required_chips / 100 and not context.blueprint then
			ease_background_colour{new_colour = G.C.FLOWER_BLUE, contrast = 1}
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.4,
				func = function()
					if G.consumeables.config.card_limit > #G.consumeables.cards then
						play_sound('timpani')
						local new_card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'blue_tarot')
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
			G.E_MANAGER:add_event(Event({
				func = function()
					G.hand_text_area.blind_chips:juice_up()
					G.hand_text_area.game_chips:juice_up()
					play_sound('tarot1')
					return true
				end
			}))
			return {
				saved = "totem_UTDR_blue",
			}
		elseif context.end_of_round and context.main_eval and not context.game_over then
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.4,
				func = function()
					if G.consumeables.config.card_limit > #G.consumeables.cards then
						play_sound('timpani')
						local new_card = create_card('Planet', G.consumeables, nil, nil, nil, nil, nil, 'blue_planet') --wow didnt know he was mormon
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
}

SMODS.Joker {
	key = "netskie",
	config = {
		mult = 8,
		in_build = false,
		chosen_joker = {
			joker_key = "j_UTDR_netskie", --have a default in case some Really Weird state stuff happens
			atlas_key = "Joker",
			center_pos = { x = 7, y = 10 },
			should_floating = false,
			floating_pos = { x = 1, y = 12 }
		},
	},
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 7, y = 10 },
	soul_pos = { x = 1, y = 12 },
	cost = 4,
	choose_disguise = function(card)
		local keys = {}
		--used to use G.localization.descriptions.Joker, but not all entries in here are actual jokers. so if netskie picked a key that wasnt a real card, the game would crash :()
		for key, value in pairs(G.P_CENTERS) do
			keys[#keys + 1] = key
		end
		
		local j = 1
		for i = 1, #keys do
			if keys[i]:sub(1, 2) == "j_" then
				keys[j] = keys[i]
				j = j + 1
			end
		end
		for i = j, #keys do
			keys[i] = nil
		end

		--set key
		card.config.chosen_joker.joker_key = pseudorandom_element(keys, "netskie_joker")
		
		--set atlases
		local center = G.P_CENTERS[card.config.chosen_joker.joker_key]
		if center.original_mod then
			card.config.chosen_joker.atlas_key = G.P_CENTERS[card.config.chosen_joker.joker_key].atlas
		end
		
		--set sprite pos
		card.config.chosen_joker.center_pos = center.pos
		if center.soul_pos then
			card.config.chosen_joker.should_floating = true
			card.config.chosen_joker.floating_pos = center.soul_pos
		end
	end,
	disguise = function(base_card)
		--if netskie chooses itself to disguise as, it gets Very Very Confused. it thinks it isnt disguised, so it will disguise itself again. and then it will think it isnt disguised again, so it will disguise itself again. and Again. and AGAIN. until balatro crashes.
		--so we fix that by making it disguise itself as... Close To Itself! manually. its textbox is very slightly different :D
		if base_card.config.chosen_joker.joker_key == "j_UTDR_netskie" then
			G.localization.descriptions.Joker["j_UTDR_netskie_disguise"].name = G.localization.descriptions.Joker
			["j_UTDR_netskie_bad_disguise"].name
			G.localization.descriptions.Joker["j_UTDR_netskie_disguise"].name_parsed = G.localization.descriptions.Joker
			["j_UTDR_netskie_bad_disguise"].name_parsed
		
			G.localization.descriptions.Joker["j_UTDR_netskie_disguise"].text = G.localization.descriptions.Joker
			["j_UTDR_netskie_bad_disguise"].text
			G.localization.descriptions.Joker["j_UTDR_netskie_disguise"].text_parsed = G.localization.descriptions.Joker
			["j_UTDR_netskie_bad_disguise"].text_parsed
		
			base_card.config.chosen_joker.atlas_key = "UTDR_DR_jokers"
			return { base_card.config.mult }
		end

		--reset to default "Kee kee~"
		G.localization.descriptions.Joker["j_UTDR_netskie_disguise"].text = G.localization.descriptions.Joker
			["j_UTDR_netskie_disguise_base"].text
		G.localization.descriptions.Joker["j_UTDR_netskie_disguise"].text_parsed = G.localization.descriptions.Joker
			["j_UTDR_netskie_disguise_base"].text_parsed

		--put the desired text before the "Kee kee~" since parsing the text hard and ill just have the game do it
		G.localization.descriptions.Joker["j_UTDR_netskie_disguise"].text = prepend_to_table(
			G.localization.descriptions.Joker["j_UTDR_netskie_disguise"].text,
			G.localization.descriptions.Joker[base_card.config.chosen_joker.joker_key].text)
		G.localization.descriptions.Joker["j_UTDR_netskie_disguise"].text_parsed = prepend_to_table(
			G.localization.descriptions.Joker["j_UTDR_netskie_disguise"].text_parsed,
			G.localization.descriptions.Joker[base_card.config.chosen_joker.joker_key].text_parsed)

		--idk if we Need to copy over the base .text and .name but ill do it in case theres any sneaky detection jokers.
		G.localization.descriptions.Joker["j_UTDR_netskie_disguise"].name = G.localization.descriptions.Joker
			[base_card.config.chosen_joker.joker_key].name
		G.localization.descriptions.Joker["j_UTDR_netskie_disguise"].name_parsed = G.localization.descriptions.Joker
			[base_card.config.chosen_joker.joker_key].name_parsed

		local center = G.P_CENTERS[base_card.config.chosen_joker.joker_key]
		local dummy = SMODS.create_card({
			key = base_card.config.chosen_joker.joker_key,
			skip_materialize = true,
			set = "Joker",
			no_edition = true
		})
	
		local can_localize = true
		
		--modded jokers work differently from vanilla jokers - each modded joker has its own separate loc_vars function, or, if they dont need it, none! so we have to check if there is one.
		--however, vanilla jokers dont - Card has a global function that just checks each applicable jokers and returns what's appropriate, which could be nothing. so we can safely assume :generate_UIBox_ability_table can be called!
		if center.original_mod then
			can_localize = false
			--base_card.config.chosen_joker.atlas_key = G.P_CENTERS[base_card.config.chosen_joker.joker_key].atlas
			for key, value in pairs(center) do
				if key == "loc_vars" then
					can_localize = true
				end
			end
		end
		
		--modded jokers have loc_vars on their center, while vanilla jokers have generate_UIBox_ability_table on the global *Card*. thankfully, we create a card object, so we can just call it!!
		local vars = { }
		if can_localize then
			local card = dummy.config.center
			card.ability = dummy.config.center.config
			if center.original_mod then
				local raw = center:loc_vars({}, card)
				if raw["vars"] then
					vars = raw["vars"]
				end
			else
				vars = dummy:generate_UIBox_ability_table(true)
			end
		end
		dummy:remove()
		
		return vars
	end,
	loc_vars = function(self, info_queue, card)
		if not (card.ability.in_build or (card and card.area and card.area.config.collection)) then
			return {
				vars = self:disguise(card),
				key = "j_UTDR_netskie_disguise",
			}
		end
		return { vars = { card.ability.mult } }
	end,
	add_to_deck = function(self, card, from_debuff)
		card.ability.in_build = true
		G.E_MANAGER:add_event(Event({
			func = function()
				play_sound("UTDR_netskie", 1.0, 0.7)
				card:juice_up(1, 1)
				card.children.center.atlas = G.ASSET_ATLAS["UTDR_DR_jokers"]
				card.children.center:set_sprite_pos({ x = 7, y = 10 })
				card.children.floating_sprite.atlas = G.ASSET_ATLAS["UTDR_DR_jokers"]
				card.children.floating_sprite:set_sprite_pos({ x = 1, y = 12 })
				card:set_cost()
				return true
			end
		}))
	end,
	remove_from_deck = function(self, card, from_debuff)
		card.ability.in_build = false
	end,
	set_badges = function(self, card, badges)
		badges[#badges] = create_badge("Kee kee~", G.C.GASTER, G.C.NETSKIE, 1.2)
	end,
	set_ability = function(self, card, initial, delay_sprites)
		--have to put this in an event, otherwise it doesnt work in collection tab
		G.E_MANAGER:add_event(Event({
			func = function()
				if not (card and card.area and card.area.config.collection) then
					self:choose_disguise(card)
					
					card:set_cost_value(card.config.center.config.chosen_joker.joker_key)
				
					card.children.center.atlas = G.ASSET_ATLAS[card.config.center.config.chosen_joker.atlas_key]
					card.children.center:set_sprite_pos(card.config.center.config.chosen_joker.center_pos)
					
					if card.config.center.config.chosen_joker.should_floating then
						card.children.floating_sprite.atlas = G.ASSET_ATLAS[card.config.center.config.chosen_joker.atlas_key]
						card.children.floating_sprite:set_sprite_pos(card.config.center.config.chosen_joker.floating_pos)
					end
				end
				return true
			end
		}))
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			keys = {}
			for key, value in pairs(SMODS.get_enhancements(context.other_card)) do
				keys[#keys + 1] = key
			end
			if #keys > 0 then
				return {
					mult = card.ability.mult
				}
			end
		end
	end
}

function prepend_to_table(tabble, new_items)
	local tabbble = {}
	for _, v in ipairs(new_items) do
		table.insert(tabbble, v)
	end
	table.insert(tabbble, tabble[1])
	return tabbble
end

SMODS.Joker {
	key = "orange",
	config = {
		mult = 40,
		card_was_sold = false,
		all_flowers = false
	},
	loc_vars = function(self, info_queue, card)
		if self.icon and self.icon.remove then
			self.icon:remove()
			self.icon = nil
		end
		self.icon = Sprite(0, 0, 0.46, 0.46, G.ASSET_ATLAS["UTDR_flowers"], { x = 3, y = 0 })
		local element = {
			n = G.UIT.C,
			config = { align = "cm", padding = 0.1 },
			nodes = {
				{ n = G.UIT.O, config = { object = self.icon } },
			}
		}
	
		return {
			vars = {
				card.ability.mult,
				elements = { element },
			},
		}
	end,
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 8, y = 9 },
	cost = 5,
	calculate = function(self, card, context)
		if context.selling_card and not card.ability.card_was_sold then
			card.ability.card_was_sold = true
			local eval = function(card)
				return not card.ability.card_was_sold
			end
			juice_card_until(card, eval, true)
			return {
				message = localize('k_active_ex'),
				colour = G.C.FILTER
			}
		elseif context.joker_main and card.ability.card_was_sold and not card.ability.all_flowers then
			G.E_MANAGER:add_event(Event({
				func = function()
					ease_background_colour{new_colour = G.C.FLOWER_ORANGE, contrast = 1}
					return true
				end
			}))
			return {
				mult = card.ability.mult
			}
		elseif context.end_of_round and context.main_eval and card.ability.card_was_sold then
			card.ability.card_was_sold = false
			return {
				message = localize('k_reset')
			}
		end
	end
}

SMODS.Joker {
	key = "pink",
	config = {
		odds = 4,
		suit = "Hearts",
		card_type = "Tarot"
	},
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	atlas = "DR_jokers",
	pos = { x = 0, y = 10 },
	cost = 8,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { type = 'name_text', key = "e_negative_consumable", set = "Edition", config = { extra = 1 } }
		local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.odds, 'pink')
		if #SMODS.find_card("j_UTDR_you") > 0 then
		vars = {
			numerator,
			denominator,
			localize("k_" .. string.lower(card.ability.card_type)),
			localize(card.ability.suit, 'suits_singular') or "Heart",
			localize { type = 'name_text', key = "e_negative_consumable", set = "Edition", config = { extra = 1 } },
			colours = {
				G.C.SUITS[card.ability.suit],
				G.C.SECONDARY_SET[card.ability.card_type] or G.C.FILTER
			},
			key = "j_UTDR_pink_you",
		}
		end
		return {
			vars = {
				numerator,
				denominator,
				localize("k_" .. string.lower(card.ability.card_type)),
				localize(card.ability.suit, 'suits_singular') or "Heart",
				localize { type = 'name_text', key = "e_negative_consumable", set = "Edition", config = { extra = 1 } },
				colours = {
					G.C.SUITS[card.ability.suit],
					G.C.SECONDARY_SET[card.ability.card_type] or G.C.FILTER
				}
			}
		}
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and (context.other_card:is_suit(card.ability.suit) or SMODS.has_any_suit(context.other_card)) and SMODS.pseudorandom_probability(card, 'j_UTDR_pink', 1, card.ability.odds) then
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
						message = localize('k_plus_' .. string.lower(card.ability.card_type)),
						colour = G.C.SECONDARY_SET[card.ability.card_type] or G.C.FILTER,
						message_card = card,
						func = function() -- This is for timing purposes, everything here runs after the message
							G.E_MANAGER:add_event(Event({
								func = (function()
									SMODS.add_card {
										set = card.ability.card_type,
										edition = "e_negative",
										key_append = 'UTDR_pink' -- Optional, useful for manipulating the random seed and checking the source of the creation in `in_pool`.
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
	end,
}

SMODS.Joker {
	key = "green",
	atlas = "DR_jokers",
	pos = { x = 7, y = 9 },
	blueprint_compat = true,
	perishable_compat = true,
	cost = 5,
	rarity = 1,
	config = {
		extra = {
			card_type = "Tarot",
			booster_counter = 0,
			booster_requirement = 2,
		}
	},
	loc_vars = function(self, info_queue, card)
		if self.icon and self.icon.remove then
			self.icon:remove()
			self.icon = nil
		end
		self.icon = Sprite(0, 0, 0.45, 0.45, G.ASSET_ATLAS["UTDR_flowers"], { x = 2, y = 0 })
		local element = {
			n = G.UIT.C,
			config = { align = "cm", padding = 0.1 },
			nodes = {
				{ n = G.UIT.O, config = { object = self.icon } },
			}
		}
	
		info_queue[#info_queue + 1] = { type = 'name_text', key = "e_negative_consumable", set = "Edition", config = { extra = 1 } }
		return {
			vars = {
				card.ability.extra.booster_counter,
				card.ability.extra.booster_requirement,
				localize("k_" .. string.lower(card.ability.extra.card_type)),
				localize { type = 'name_text', key = "e_negative_consumable", set = "Edition", config = { extra = 1 } },
				colours = {
					G.C.SUITS[card.ability.extra.suit],
					G.C.SECONDARY_SET[card.ability.extra.card_type] or G.C.FILTER
				},
				elements = { element },
			},
		}
	end,
	calculate = function(self, card, context)
		if context.ending_booster then
			local do_create = false
			if not context.blueprint then
				card.ability.extra.booster_counter = card.ability.extra.booster_counter + 1
				if card.ability.extra.booster_counter >= card.ability.extra.booster_requirement then
					card.ability.extra.booster_counter = 0
					do_create = true
				end
			end
			if do_create then
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
							message = localize('k_plus_' .. string.lower(card.ability.extra.card_type)),
							colour = G.C.SECONDARY_SET[card.ability.extra.card_type] or G.C.FILTER,
							message_card = card,
							func = function() -- This is for timing purposes, everything here runs after the message
								G.E_MANAGER:add_event(Event({
									func = (function()
										ease_background_colour{new_colour = G.C.FLOWER_GREEN, contrast = 1}
										SMODS.add_card {
											set = card.ability.extra.card_type,
											edition = "e_negative",
											key_append = 'UTDR_green' -- Optional, useful for manipulating the random seed and checking the source of the creation in `in_pool`.
										}
										G.GAME.consumeable_buffer = 0
										G.E_MANAGER:add_event(Event({
											trigger = 'after',
											delay = 0.7,
											func = function()
												ease_background_colour_blind(G.STATES.SHOP)
												return true
											end
										}))
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
	key = "susies_idea",
	blueprint_compat = true,
	rarity = 2,
	cost = 5,
	pos = { x = 1, y = 9 },
	atlas = "DR_jokers",
	loc_vars = function(self, info_queue, card)
		if self.susie and self.susie.remove then
			self.susie:remove()
			self.susie = nil
		end
		self.susie = Sprite(0, 0, 0.5,
			0.5 * (G.ASSET_ATLAS["UTDR_susies_idea"].py / G.ASSET_ATLAS["UTDR_susies_idea"].px),
			G.ASSET_ATLAS["UTDR_susies_idea"], { x = 0, y = 0 })
		local element = {
			n = G.UIT.C,
			config = { align = "cm", padding = 0.1 },
			nodes = {
				{ n = G.UIT.O, config = { object = self.susie } },
			}
		}
		return {
			vars = {
				elements = { element }
			}
		}
	end,
	calculate = function(self, card, context)
		if context.first_hand_drawn then
			local new_card = SMODS.create_card {
				set = "Enhanced",
				enhancement = SMODS.poll_enhancement { key = "UTDR_susies_idea", guaranteed = true },
				area = G.discard,
				key_append = "UTDR_susies_idea" }
			G.playing_card = (G.playing_card and G.playing_card + 1) or 1
			new_card.playing_card = G.playing_card
			table.insert(G.playing_cards, new_card)

			G.E_MANAGER:add_event(Event({
				func = function()
					G.hand:emplace(new_card)
					new_card:start_materialize()
					G.GAME.blind:debuff_card(new_card)
					G.hand:sort()
					if context.blueprint_card then
						context.blueprint_card:juice_up()
					else
						card:juice_up()
					end
					SMODS.calculate_context({ playing_card_added = true, cards = { new_card } })
					save_run()
					return true
				end
			}))

			return nil, true -- This is for Joker retrigger purposes
		end
	end,
}