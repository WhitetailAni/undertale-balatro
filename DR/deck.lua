SMODS.Back {
	key = "merciful",
	loc_txt = {
		name = "Merciful Deck",
		text = {
			"{C:blue}Common{} and {C:green}Uncommon{}",
			"Jokers cost {C:attention}75% less",
			"{C:red}Rare{} and {C:legendary}Legendary{}",
			"Jokers cost {C:attention}50% more",
		},
	},
	unlocked = true,
	atlas = "DR_deck",
	pos = { x = 3, y = 0 },
}

SMODS.Back {
	key = "soul",
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
		G.GAME.perscribed_bosses = {}
		G.GAME.perscribed_bosses[1] = 'bl_fish'
		G.GAME.perscribed_bosses[2] = 'bl_flint'
		G.GAME.perscribed_bosses[3] = 'bl_house'
		G.GAME.perscribed_bosses[4] = 'bl_wall'
		G.GAME.perscribed_bosses[5] = 'bl_serpent'
		G.GAME.perscribed_bosses[6] = 'bl_psychic'
		G.GAME.perscribed_bosses[7] = 'bl_final_heart'
	end
}

SMODS.Back {
	key = "dark",
	config = { 
		ante_win = 9
	},
	loc_txt = {
		name = "Dark Deck",
		text = {
			 "Start run with the",
			"{C:tarot,T:v_crystal_ball}#1#{} and",
			"{C:tarot,T:v_omen_globe}#2#{} voucher"
		},
	},
	loc_vars = function(self, info_queue, back)
		return { vars = { localize{ type = 'name_text', key = 'v_crystal_ball', set = 'Voucher'}, localize{ type = 'name_text', key = 'v_omen_globe', set = 'Voucher'} } }
	end,
	unlocked = true,
	atlas = "DR_deck",
	pos = { x = 2, y = 0 },
	apply = function(self, back)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.1,
			func = function()
				if not G.vouchers then return false end
				G.GAME.used_vouchers["v_crystal_ball"] = true
				G.GAME.used_vouchers["v_omen_globe"] = true
				Card.apply_to_run(nil, G.P_CENTERS["v_crystal_ball"])
				Card.apply_to_run(nil, G.P_CENTERS["v_omen_globe"])
				
				G.GAME.starting_voucher_count = (G.GAME.starting_voucher_count or 0) + 2
				return true
			end
		}))
	end
}

SMODS.Back {
	key = "forgotten",
	loc_txt = {
		name = "Forgotten Deck",
		text = {
			"All rerolls cost {C:money}$4"
		},
	},
	unlocked = true,
	atlas = "DR_deck",
	pos = { x = 0, y = 0 },
	apply = function(self)
		G.GAME.starting_params.reroll_cost = 4
	end,
}