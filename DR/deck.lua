SMODS.Back {
	key = "darkdeck",
	config = { 
		ante_win = 9
	},
	loc_txt = {
		name = "Dark Deck",
		text = {
			
		},
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { self.config.ante_win } }
	end,
	unlocked = true,
	atlas = "DR_deck",
	pos = { x = 2, y = 0 },
	apply = function(self)
		G.GAME.win_ante = 9
		G.E_MANAGER:add_event(Event({
			func = function()
				if G.jokers then
					local bandage = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_UTDR_bandage")
					bandage:add_to_deck()
					bandage:start_materialize()
					G.jokers:emplace(bandage)
					
					local stick = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_UTDR_stick")
					stick:add_to_deck()
					stick:start_materialize()
					G.jokers:emplace(stick)
					
					return true
				end
			end,
		}))
	end
}

SMODS.Back {
	key = "souldeck",
	loc_txt = {
		name = "Soul Deck",
		text = {
			"Winning ante is {C:attention}7"
		},
	},
	unlocked = true,
	atlas = "DR_deck",
	pos = { x = 1, y = 0 },
	apply = function(self)
		G.GAME.win_ante = 7
	end
}