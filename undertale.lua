local lovely = require("lovely")

assert(SMODS.load_file('src/one.lua'))()
assert(SMODS.load_file('src/two.lua'))()
assert(SMODS.load_file('src/three.lua'))()
assert(SMODS.load_file('src/four.lua'))()
assert(SMODS.load_file('src/five.lua'))()
assert(SMODS.load_file('src/six.lua'))()

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

SMODS.Atlas {
	key = "splash",
	path = "splash.png",
	px = 312,
	py = 169,
	atlas_table = "ASSET_ATLAS"
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

--if the joker you display on the title screen isn't discovered it renders the "pls discover this joker" texture which is very funny
--so here's my solution!
SMODS.Joker {
	key = "sans_title",
	discovered = true,
	rarity = 4,
	atlas = "jokers",
	pos = { x = 1, y = 5 },
	no_collection = true,
	in_pool = function(self, args)
		return false
	end,
}

function played_secret_hand(played_hands)
	local base = false
	local problematic = false
	local cryptid = false
	local bunco = false
	local sixsuits = false
	
	if next(played_hands["Five of a Kind"]) or
	next(played_hands["Flush Five"]) or
	next(played_hands["Flush House"]) then
		base = true
	end
	
	if (SMODS.Mods["TWT"] or {}).can_load then
		if next(played_hands["TWT_greaterpolycule"]) then
			 problematic = true
		end
	end
	if (SMODS.Mods["Cryptid"] or {}).can_load then
		if next(played_hands["cry_Bulwark"]) or
		next(played_hands["cry_Clusterfuck"]) or
		next(played_hands["cry_UltPair"]) or
		next(played_hands["cry_WholeDeck"]) then
			cryptid = true
		end
	end
	
	if (SMODS.Mods["Bunco"] or {}).can_load then
		if next(played_hands["bunc_Spectrum"]) or
		next(played_hands["bunc_Straight Spectrum"]) or
		next(played_hands["bunc_Spectrum House"]) or
		next(played_hands["bunc_Spectrum Five"]) then
			bunco = true
		end
	end
	
	if (SMODS.Mods["SixSuits"] or {}).can_load then
		if next(played_hands["six_Spectrum House"]) or
		next(played_hands["six_Spectrum Five"]) then
			sixsuits = true
		end
	end
	
	return base or problematic or cryptid or bunco or sixsuits
end