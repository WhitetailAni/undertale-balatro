SMODS.Consumable:take_ownership('familiar',
	{
		loc_txt = {
			name = "Queen's Chariot",
			text={
				"Destroy {C:attention}1{} random",
				"card in your hand, add",
				"{C:attention}#1#{} random {C:attention}Enhanced face",
				"{C:attention}cards{} to your hand",
			},
		},
		loc_vars = function(self, info_queue, card)
			if #SMODS.find_card("j_UTDR_shadow_crystal") > 0  then
				return {
					key = "c_UTDR_familiar_crystal",
					vars = { card.ability.extra }
				}
			end
			return { vars = { card.ability.extra } }
		end,
		atlas = "UTDR_consumables",
		pos = { x = 0, y = 4 },
		use = function(self, card, area, copier)
			local used_tarot = copier or card
			if not (#SMODS.find_card("j_UTDR_shadow_crystal") > 0) then
				local destroyed_cards = random_destroy_DR(used_tarot)
				SMODS.calculate_context({ remove_playing_cards = true, removed = destroyed_cards })
			end
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.7,
				func = function()
					local cards = {}
					for i = 1, card.ability.extra do
						-- TODO preserve suit vanilla RNG
						local faces = {}
						for _, v in ipairs(SMODS.Rank.obj_buffer) do
							local r = SMODS.Ranks[v]
							if r.face then table.insert(faces, r) end
						end
						local _suit, _rank =
							pseudorandom_element(SMODS.Suits, pseudoseed('familiar_create')).card_key,
							pseudorandom_element(faces, pseudoseed('familiar_create')).card_key
						local cen_pool = {}
						for k, v in pairs(G.P_CENTER_POOLS["Enhanced"]) do
							if v.key ~= 'm_stone' and not v.overrides_base_rank then
								cen_pool[#cen_pool + 1] = v
							end
						end
						cards[i] = create_playing_card({
							front = G.P_CARDS[_suit .. '_' .. _rank],
							center = pseudorandom_element(cen_pool, pseudoseed('spe_card'))
						}, G.hand, nil, i ~= 1, { G.C.SECONDARY_SET.Spectral })
					end
					playing_card_joker_effects(cards)
					return true
				end
			}))
			delay(0.3)
		end,
	},
	true
)

SMODS.Consumable:take_ownership('grim',
	{
		loc_txt = {
			name = "Flower Man",
			text={
				"Destroy {C:attention}1{} random",
				"card in your hand,",
				"add {C:attention}#1#{} random {C:attention}Enhanced",
				"{C:attention}Aces{} to your hand",
			},
		},
		loc_vars = function(self, info_queue, card)
			if #SMODS.find_card("j_UTDR_shadow_crystal") > 0  then
				return {
					key = "c_UTDR_grim_crystal",
					vars = { card.ability.extra }
				}
			end
			return { vars = { card.ability.extra } }
		end,
		atlas = "UTDR_consumables",
		pos = { x = 1, y = 4 },
        use = function(self, card, area, copier)
            local used_tarot = copier or card
            if not (#SMODS.find_card("j_UTDR_shadow_crystal") > 0) then
				local destroyed_cards = random_destroy_DR(used_tarot)
				SMODS.calculate_context({ remove_playing_cards = true, removed = destroyed_cards })
			end
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.7,
                func = function()
                    local cards = {}
                    for i = 1, card.ability.extra do
                        -- TODO preserve suit vanilla RNG
                        local _suit, _rank =
                            pseudorandom_element(SMODS.Suits, pseudoseed('grim_create')).card_key, 'A'
                        local cen_pool = {}
                        for k, v in pairs(G.P_CENTER_POOLS["Enhanced"]) do
                            if v.key ~= 'm_stone' and not v.overrides_base_rank then
                                cen_pool[#cen_pool + 1] = v
                            end
                        end
                        cards[i] = create_playing_card({
                            front = G.P_CARDS[_suit .. '_' .. _rank],
                            center = pseudorandom_element(cen_pool, pseudoseed('spe_card'))
                        }, G.hand, nil, i ~= 1, { G.C.SECONDARY_SET.Spectral })
                    end
                    playing_card_joker_effects(cards)
                    return true
                end
            }))
            delay(0.3)
        end,
    },
    true
)

SMODS.Consumable:take_ownership('incantation',
 	{
 		loc_txt = {
			name = "Lord of Screens",
			 text={
				"Destroy {C:attention}1{} random",
				"card in your hand, add {C:attention}#1#",
				"random {C:attention}Enhanced numbered",
				"{C:attention}cards{} to your hand",
			},
		},
		loc_vars = function(self, info_queue, card)
			if #SMODS.find_card("j_UTDR_shadow_crystal") > 0  then
				return {
					key = "c_UTDR_incantation_crystal",
					vars = { card.ability.extra }
				}
			end
			return { vars = { card.ability.extra } }
		end,
		atlas = "UTDR_consumables",
		pos = { x = 2, y = 4 },
		use = function(self, card, area, copier)
			local used_tarot = copier or card
			if not (#SMODS.find_card("j_UTDR_shadow_crystal") > 0) then
				local destroyed_cards = random_destroy_DR(used_tarot)
				SMODS.calculate_context({ remove_playing_cards = true, removed = destroyed_cards })
			end
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.7,
				func = function()
					local cards = {}
					for i = 1, card.ability.extra do
						-- TODO preserve suit vanilla RNG
						local numbers = {}
						for _, v in ipairs(SMODS.Rank.obj_buffer) do
							local r = SMODS.Ranks[v]
							if v ~= 'Ace' and not r.face then table.insert(numbers, r) end
						end
						local _suit, _rank =
							pseudorandom_element(SMODS.Suits, pseudoseed('incantation_create')).card_key,
							pseudorandom_element(numbers, pseudoseed('incantation_create')).card_key
						local cen_pool = {}
						for k, v in pairs(G.P_CENTER_POOLS["Enhanced"]) do
							if v.key ~= 'm_stone' and not v.overrides_base_rank then
								cen_pool[#cen_pool + 1] = v
							end
						end
						cards[i] = create_playing_card({
							front = G.P_CARDS[_suit .. '_' .. _rank],
							center = pseudorandom_element(cen_pool, pseudoseed('spe_card'))
						}, G.hand, nil, i ~= 1, { G.C.SECONDARY_SET.Spectral })
					end
					playing_card_joker_effects(cards)
					return true
				end
			}))
			delay(0.3)
		end,
	},
	true
)

SMODS.Consumable:take_ownership('talisman',
 	{
 		loc_txt = {
			name = "Four Tones",
			 text={
				"Add a {C:attention}Gold Seal{}",
				"to {C:attention}1{} selected",
				"card in your hand",
			},
		},
		atlas = "UTDR_consumables",
		pos = { x = 3, y = 4 },
	},
	true
)

SMODS.Consumable:take_ownership('aura',
 	{
 		loc_txt = {
			name = "Heaven's Call",
			 text={
				"Add {C:dark_edition}Foil{}, {C:dark_edition}Holographic{},",
				"or {C:dark_edition}Polychrome{} effect to",
				"{C:attention}1{} selected card in hand",
			},
		},
		atlas = "UTDR_consumables",
		pos = { x = 4, y = 4 },
	},
	true
)

SMODS.Consumable:take_ownership('wraith',
 	{
 		loc_txt = {
			name="Jockington",
			text={
				"Creates a random",
				"{C:red}Rare{C:attention} Joker{},",
				"sets money to {C:money}$0",
			},
		},
		loc_vars = function(self, info_queue, card)
			
			if #SMODS.find_card("j_UTDR_shadow_crystal") > 0 then
				if math.fmod(os.time(), 16) == 0 then
					return { key = "c_UTDR_jorkington_crystal" }
				else
					return { key = "c_UTDR_wraith_crystal" }
				end
			elseif math.fmod(os.time(), 16) == 0 then
				return { key = "c_UTDR_jorkington" }
			end
		end,
		atlas = "UTDR_consumables",
		pos = { x = 5, y = 4 },
		use = function(self, card, area, copier)
			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('timpani')
            local carb = create_card('Joker', G.jokers, nil, 0.99, nil, nil, nil, 'wra')
            carb:add_to_deck()
            G.jokers:emplace(carb)
            card:juice_up(0.3, 0.5)
            if not (G.GAME.dollars == 0 or #SMODS.find_card('j_UTDR_shadow_crystal') > 0) then
                ease_dollars(-G.GAME.dollars, true)
            end
            return true end }))
        delay(0.6)
		end
	},
	true
)

SMODS.Consumable:take_ownership('sigil',
 	{
 		loc_txt = {
			name = "Gallery",
			  text={
				"Converts all cards",
				"in hand to a single",
				"random {C:attention}suit",
			},
		},
		atlas = "UTDR_consumables",
		pos = { x = 6, y = 4 },
	},
	true
)

SMODS.Consumable:take_ownership('ouija',
	{
		loc_txt = {
			name="Darkened Eyes",
			 text={
				"Converts all cards",
				"in hand to a single",
				"random {C:attention}rank",
				"{C:red}-1{} hand size",
			},
		},
		loc_vars = function(self, info_queue, card)
			if #SMODS.find_card("j_UTDR_shadow_crystal") > 0  then
				return { key = "c_UTDR_ouija_crystal" }
			end
		end,
		atlas = "UTDR_consumables",
		pos = { x = 7, y = 4 },
		use = function(self, card, area, copier)
			local used_tarot = copier or card
			juice_flip_DR(used_tarot)
			local _rank = pseudorandom_element(SMODS.Ranks, pseudoseed('ouija'))
			for i = 1, #G.hand.cards do
				G.E_MANAGER:add_event(Event({
					func = function()
						local _card = G.hand.cards[i]
						assert(SMODS.change_base(_card, nil, _rank.key))
						return true
					end
				}))
			end
			if not (#SMODS.find_card("j_UTDR_shadow_crystal") > 0) then
				G.hand:change_size(-1)
			end
			for i = 1, #G.hand.cards do
				local percent = 0.85 + (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.15,
					func = function()
						G.hand.cards[i]:flip(); play_sound('tarot2', percent, 0.6); G.hand.cards[i]:juice_up(0.3, 0.3); return true
					end
				}))
			end
			delay(0.5)
		end,
	},
	true
)

SMODS.Consumable:take_ownership('ectoplasm',
 	{
 		loc_txt = {
			name="Three Heroes",
			 text={
				"Add {C:dark_edition}Negative{} to",
				"a random {C:attention}Joker,",
				"{C:red}-#1#{} hand size",
			},
		},
		loc_vars = function(self, info_queue, card)
			if #SMODS.find_card("j_UTDR_shadow_crystal") > 0  then
				return { key = "c_UTDR_ectoplasm_crystal", vars = { G.GAME.ecto_minus } }
			end
			return { vars = { G.GAME.ecto_minus } }
		end,
		atlas = "UTDR_consumables",
		pos = { x = 8, y = 4 },
		use = function(self, card, area, copier)
			local eligible_card = pseudorandom_element(card.eligible_editionless_jokers, pseudoseed('ectoplasm'))
			eligible_card:set_edition({ negative = true }, true)
			check_for_unlock({type = 'have_edition'})
			if card.ability.name == 'Ectoplasm' and not (#SMODS.find_card('j_UTDR_shadow_crystal') > 0) then
				G.GAME.ecto_minus = G.GAME.ecto_minus or 1
				G.hand:change_size(-G.GAME.ecto_minus)
				G.GAME.ecto_minus = G.GAME.ecto_minus + 1
			end
		end
	},
	true
)

SMODS.Consumable:take_ownership('immolate',
 	{
 		loc_txt = {
			name="Final Tragedy",
			 text={
				"Destroys {C:attention}#1#{} random",
				"cards in hand,",
				"gain {C:money}$#2#",
			},
		},
		loc_vars = function(self, info_queue, card)
			if #SMODS.find_card("j_UTDR_shadow_crystal") > 0  then
				return {
					key = "c_UTDR_immolate_crystal",
					vars = { card.ability.extra.destroy, card.ability.extra.dollars }
				}
			end
			return { vars = { card.ability.extra.destroy, card.ability.extra.dollars } }
		end,
		atlas = "UTDR_consumables",
		pos = { x = 9, y = 4 },
		use = function(self, card, area, copier)
			local destroyed_cards = {}
			local temp_hand = {}
            for k, v in ipairs(G.hand.cards) do temp_hand[#temp_hand+1] = v end
            table.sort(temp_hand, function (a, b) return not a.playing_card or not b.playing_card or a.playing_card < b.playing_card end)
            pseudoshuffle(temp_hand, pseudoseed('immolate'))
			
			if #SMODS.find_card('j_UTDR_shadow_crystal') > 0 then
				card.ability.extra.destroy = 0
			end
            for i = 1, card.ability.extra.destroy do destroyed_cards[#destroyed_cards+1] = temp_hand[i] end

            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true end
            }))
            if not (#SMODS.find_card('j_UTDR_shadow_crystal') > 0) then
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.1,
					func = function() 
						for i=#destroyed_cards, 1, -1 do
							local carb = destroyed_cards[i]
							if SMODS.shatters(carb) then
								carb:shatter()
							else
								carb:start_dissolve(nil, i == #destroyed_cards)
							end
						end
						return true end
					}))
                end
            delay(0.5)
            ease_dollars(card.ability.extra.dollars)
            if not (#SMODS.find_card("j_UTDR_shadow_crystal") > 0) then
				SMODS.calculate_context({ remove_playing_cards = true, removed = destroyed_cards })
			end
		end
	},
	true
)

SMODS.Consumable:take_ownership('ankh',
 	{
 		loc_txt = {
			name="Pointy-Headed",
			  text={
				"Create a copy of a",
				"random {C:attention}Joker{}, destroy",
				"all other Jokers",
			},
		},
		loc_vars = function(self, info_queue, card)
			if #SMODS.find_card("j_UTDR_shadow_crystal") > 0  then
				return { key = "c_UTDR_ankh_crystal" }
			end
		end,
		atlas = "UTDR_consumables",
		pos = { x = 0, y = 5 },
		use = function(self, card, area, copier)
			local deletable_jokers = {}
			for k, v in pairs(G.jokers.cards) do
				if not SMODS.is_eternal(v, self) then deletable_jokers[#deletable_jokers + 1] = v end
			end
			if #SMODS.find_card('j_UTDR_shadow_crystal') > 0 then
				deletable_jokers = {}
			end
			local chosen_joker = pseudorandom_element(G.jokers.cards, pseudoseed('ankh_choice'))
			local _first_dissolve = nil
			G.E_MANAGER:add_event(Event({trigger = 'before', delay = 0.75, func = function()
				for k, v in pairs(deletable_jokers) do
					if v ~= chosen_joker then 
						v:start_dissolve(nil, _first_dissolve)
						_first_dissolve = true
					end
				end
				return true end
			}))
			G.E_MANAGER:add_event(Event({trigger = 'before', delay = 0.4, func = function()
				local card = copy_card(chosen_joker, nil, nil, nil, chosen_joker.edition and chosen_joker.edition.negative, true)
				card:start_materialize()
				card:add_to_deck()
				if card.edition and card.edition.negative then
					card:set_edition(nil, true)
				end
				G.jokers:emplace(card)
				return true end
			}))
		end
	},
	true
)

SMODS.Consumable:take_ownership('deja_vu',
 	{
 		loc_txt = {
			name = "The Girl",
			text={
				"Add a {C:red}Red Seal{}",
				"to {C:attention}1{} selected",
				"card in your hand",
			},
		},
		atlas = "UTDR_consumables",
		pos = { x = 1, y = 5 },
	},
	true
)

SMODS.Consumable:take_ownership('hex',
 	{
 		loc_txt = {
			name="Blackened Knife",
			text={
				"Add {C:dark_edition}Polychrome{} to a",
				"random {C:attention}Joker{}, destroy",
				"all other Jokers",
			},
		},
		loc_vars = function(self, info_queue, card)
			if #SMODS.find_card("j_UTDR_shadow_crystal") > 0  then
				return { key = "c_UTDR_hex_crystal" }
			end
		end,
		atlas = "UTDR_consumables",
		pos = { x = 2, y = 5 },
		use = function(self, card, area, copier)
			local eligible_card = pseudorandom_element(card.eligible_editionless_jokers, pseudoseed('hex'))
			eligible_card:set_edition({ polychrome = true }, true)
			check_for_unlock({type = 'have_edition'})
			local _first_dissolve = nil
			if not (#SMODS.find_card('j_UTDR_shadow_crystal') > 0) then
				for k, v in pairs(G.jokers.cards) do
					if v ~= eligible_card and (not SMODS.is_eternal(v, self)) then v:start_dissolve(nil, _first_dissolve);_first_dissolve = true end
				end
			end
		end
	},
	true
)

SMODS.Consumable:take_ownership('trance',
 	{
 		loc_txt = {
			name="The Cage",
			text={
				"Add a {C:blue}Blue Seal{}",
				"to {C:attention}1{} selected",
				"card in your hand",
			},
		},
		atlas = "UTDR_consumables",
		pos = { x = 3, y = 5 }
	},
	true
)

SMODS.Consumable:take_ownership('medium',
 	{
 		loc_txt = {
			name="The Prince",
			text={
				"Add a {C:purple}Purple Seal{}",
				"to {C:attention}1{} selected",
				"card in your hand",
			},
		},
		atlas = "UTDR_consumables",
		pos = { x = 4, y = 5 }
	},
	true
)

SMODS.Consumable:take_ownership('cryptid',
 	{
 		loc_txt = {
			name="Tail of Hell",
			text={
				"Create {C:attention}#1#{} copies of",
				"{C:attention}1{} selected card",
				"in your hand",
			},
		},
		loc_vars = function(self, info_queue, card)
			return { vars = { card.ability.extra } }
		end,
		atlas = "UTDR_consumables",
		pos = { x = 5, y = 5 }
	},
	true
)

SMODS.Consumable:take_ownership('soul',
 	{
 		loc_txt = {
			name="DELTARUNE",
			 text={
				"Creates a",
				"{C:legendary,E:1}Legendary{} Joker",
				"{C:inactive}(Must have room)",
			},
		},
		atlas = "UTDR_consumables",
		pos = { x = 2, y = 2 }
	},
	true
)

function become_prophecy()
	G.localization.misc.achievement_descriptions.clairvoyance = "Discover every Prophecy card"
	G.localization.misc.dictionary.b_spectral_cards = "Prophecy Cards"
	G.localization.misc.dictionary.b_stat_spectrals = "Prophecies"
	G.localization.misc.dictionary.k_plus_spectral = "+1 Prophecy"
	G.localization.misc.dictionary.k_spectral = "Prophecy"
    G.localization.misc.dictionary.k_spectral_pack = "Prophecy Pack"
end

function juice_flip_DR(used_tarot)
	G.E_MANAGER:add_event(Event({
		trigger = 'after',
		delay = 0.4,
		func = function()
			play_sound('tarot1')
			used_tarot:juice_up(0.3, 0.5)
			return true
		end
	}))
	for i = 1, #G.hand.cards do
		local percent = 1.15 - (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.15,
			func = function()
				G.hand.cards[i]:flip(); play_sound('card1', percent); G.hand.cards[i]:juice_up(0.3, 0.3); return true
			end
		}))
	end
end

function random_destroy_DR(used_tarot)
	local destroyed_cards = {}
	destroyed_cards[#destroyed_cards + 1] = pseudorandom_element(G.hand.cards, pseudoseed('random_destroy'))
	G.E_MANAGER:add_event(Event({
		trigger = 'after',
		delay = 0.4,
		func = function()
			play_sound('tarot1')
			used_tarot:juice_up(0.3, 0.5)
			return true
		end
	}))
	G.E_MANAGER:add_event(Event({
		trigger = 'after',
		delay = 0.1,
		func = function()
			for i = #destroyed_cards, 1, -1 do
				local card = destroyed_cards[i]
				if card.ability.name == 'Glass Card' then
					card:shatter()
				else
					card:start_dissolve(nil, i ~= #destroyed_cards)
				end
			end
			return true
		end
	}))
	return destroyed_cards
end