SMODS.Back {
	key = "dark",
	config = {
		vouchers = { "v_crystal_ball", "v_omen_globe" }
	},
	loc_vars = function(self, info_queue, back)
		return { vars = { localize { type = 'name_text', key = self.config.vouchers[1], set = 'Voucher' }, localize { type = 'name_text', key = self.config.vouchers[2], set = 'Voucher' } } }
	end,
	unlocked = true,
	atlas = "DR_deck",
	pos = { x = 2, y = 0 },
}

SMODS.Back {
	key = "forgotten",
	config = {
		reroll_cost = 4
	},
	loc_vars = function(self, info_queue, back)
		return { vars = { self.config.reroll_cost } }
	end,
	--[[
	loc_txt = {
		name = "Forgotten Deck",
		text = {
			"All rerolls cost {C:money}$#1#"
		},
	},
	]]
	unlocked = true,
	atlas = "DR_deck",
	pos = { x = 0, y = 0 },
	apply = function(self)
		G.GAME.starting_params.reroll_cost = 4
		G.GAME.shop_d6ed = true
	end,
}
