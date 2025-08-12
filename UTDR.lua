local lovely = require("lovely")

assert(SMODS.load_file('atlas.lua'))()
assert(SMODS.load_file('sound.lua'))()

UTDR = SMODS.current_mod
if NFS.read(SMODS.current_mod.path.."config.lua") then
    local file = STR_UNPACK(NFS.read(SMODS.current_mod.path.."config.lua"))
    UTDR.config_file = file
end

UTDR.config_tab = function()
		tal_nodes = {
			{
				n = G.UIT.R,
				config = { align = "cm" },
				nodes = {
		 			{
		 				n = G.UIT.O,
		 				config = { 
		 					object = DynaText({
		 						string = "Requires game restart to apply",
		 						colours = {G.C.WHITE},
		 						shadow = true,
		 						scale = 0.4
		 					}
		 				)
		 			}
		 		},
			}
		},
		create_toggle(
			{
				align = "tl",
				label = "UNDERTALE",
				ref_table = UTDR.config_file,
				ref_value = "undertale",
				callback = function(_set_toggle)
					NFS.write(lovely.mod_dir .. "/UTDR/config.lua", STR_PACK(UTDR.config_file))
				end
			}
		),
		create_toggle(
			{
				align = "tl",
				label = "DELTARUNE",
				ref_table = UTDR.config_file,
				ref_value = "deltarune",
				callback = function(_set_toggle)
					NFS.write(lovely.mod_dir .. "/UTDR/config.lua", STR_PACK(UTDR.config_file))
				end
			}
		),
	}
	return {
	n = G.UIT.ROOT,
	config = {
		emboss = 0.05,
		r = 0.1,
		align = "tl",
		padding = 0.2,
		colour = G.C.BLACK
	},
	nodes = tal_nodes
	}
end

--if the joker you display on the title screen isn't discovered it renders the "pls discover this joker" texture which is very funny
--so here's my solution!
SMODS.Joker {
	key = "sans_title",
	discovered = true,
	atlas = "UT_jokers",
	pos = { x = 1, y = 5 },
	no_collection = true,
	in_pool = function(self, args)
		return false
	end,
}

SMODS.Joker {
	key = "tv_world_title",
	discovered = true,
	atlas = "DR_jokers",
	pos = { x = 0, y = 5 },
	no_collection = true,
	in_pool = function(self, args)
		return false
	end,
}

SMODS.Joker {
	key = "chara_title",
	discovered = true,
	atlas = "UT_jokers",
	pos = { x = 4, y = 7 },
	soul_pos = { x = 7, y = 7 },
	no_collection = true,
	in_pool = function(self, args)
		return false
	end,
}

-- load UT
if UTDR.config_file['undertale'] then
	assert(SMODS.load_file('UT/one.lua'))()
	assert(SMODS.load_file('UT/two.lua'))()
	assert(SMODS.load_file('UT/three.lua'))()
	assert(SMODS.load_file('UT/four.lua'))()
	assert(SMODS.load_file('UT/five.lua'))()
	assert(SMODS.load_file('UT/six.lua'))()
	
	SMODS.Back {
		key = "dog",
		loc_txt = {
			name = "Dogdeck",
			text = {
				"Start run with",
				"{C:attention}Bandage{} and {C:attention}Stick{}",
				"Winning ante is {C:attention}9"
			},
		},
		unlocked = true,
		atlas = "UT_deck",
		pos = { x = 0, y = 0 },
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
end

-- load DR
if UTDR.config_file.deltarune then
	assert(SMODS.load_file('DR/one.lua'))()
	assert(SMODS.load_file('DR/two.lua'))()
	assert(SMODS.load_file('DR/three.lua'))()
	assert(SMODS.load_file('DR/four.lua'))()
	assert(SMODS.load_file('DR/five.lua'))()
	
	assert(SMODS.load_file('DR/deck.lua'))()
	assert(SMODS.load_file('DR/booster.lua'))()
	assert(SMODS.load_file('DR/prophecy.lua'))()
	assert(SMODS.load_file('DR/tarot.lua'))()
	assert(SMODS.load_file('DR/spectral.lua'))()
	assert(SMODS.load_file('DR/spectral_crystal.lua'))()
	become_prophecy()
end

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

 function get_keys(t)
  local keys={}
  for key,_ in pairs(t) do
    table.insert(keys, key)
  end
  return keys
end