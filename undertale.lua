local lovely = require("lovely")

assert(SMODS.load_file('src/one.lua'))()
assert(SMODS.load_file('src/two.lua'))()
assert(SMODS.load_file('src/three.lua'))()
assert(SMODS.load_file('src/four.lua'))()
assert(SMODS.load_file('src/five.lua'))()

SMODS.Atlas {
    key = "jokers",
    path = "joker.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "modicon",
    path = "icon.png",
    px = 28,
    py = 28
}

SMODS.Atlas {
    key = "deck",
    path = "deck.png",
    px = 71,
    py = 95
}

SMODS.Back {
	key = "dogdeck",
	pos = { x = 0, y = 0 },
	config = { 
		ante_win = 9
	},
	loc_txt = {
		name = "Dogdeck",
		text={
			"Start run with",
			"{C:attention}Bandage{} and {C:attention}Stick{}",
			"Winning ante is {C:attention}#1#"
		},
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { self.config.ante_win } }
	end,
	unlocked = true,
	atlas = "deck",
	pos = { x = 0, y = 0 },
	apply = function(self)
		G.GAME.win_ante = 9
		G.E_MANAGER:add_event(Event({
			func = function()
				if G.jokers then
					local bandage = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_UT_bandage")
					bandage:add_to_deck()
					bandage:start_materialize()
					G.jokers:emplace(bandage)
					
					local stick = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_UT_stick")
					stick:add_to_deck()
					stick:start_materialize()
					G.jokers:emplace(stick)
					
					return true
				end
			end,
		}))
	end
}