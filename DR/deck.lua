SMODS.Back {
	key = "merciful",
	--[[
	loc_txt = {
		name = "Merciful Deck",
		text = {
			"{C:blue}Common{} and {C:green}Uncommon{}",
			"Jokers cost {C:attention}75% less",
			"{C:red}Rare{} and {C:legendary}Legendary{}",
			"Jokers cost {C:attention}50% more",
		},
	},
	]]
	config = { common_uncommon_multipler = 0.25, rare_legendary_multiplier = 1.5 },
	loc_vars = function(self, info_queue, back)
		--print(localize({ type = 'name_text', set = "Joker", key = self.config.extra_jokers[1] }))
		--print(localize({ type = 'name_text', set = "Joker", key = self.config.extra_jokers[2] }))
		local cum_loc = tostring(((self.config.common_uncommon_multipler < 1 and (1 - self.config.common_uncommon_multipler)) or
				(self.config.common_uncommon_multipler - 1)) * 100) ..
			"% " .. localize((self.config.common_uncommon_multipler < 1) and "k_UTDR_less" or "k_UTDR_more")
		local rlm_loc = tostring(((self.config.rare_legendary_multiplier < 1 and (1 - self.config.rare_legendary_multiplier)) or
				(self.config.rare_legendary_multiplier - 1)) * 100) ..
			"% " .. localize((self.config.rare_legendary_multiplier < 1) and "k_UTDR_less" or "k_UTDR_more")
		return { vars = { localize("k_common"), localize("k_uncommon"), localize("k_rare"), localize("k_legendary"), cum_loc, rlm_loc, colours = { G.C.RARITY.Common, G.C.RARITY.Uncommon, G.C.RARITY.Rare, G.C.RARITY.Legendary } } }
	end,
	unlocked = true,
	atlas = "DR_deck",
	pos = { x = 3, y = 0 },
}

SMODS.Back {
	key = "soul",
	--[[
	loc_txt = {
		name = "Soul Deck",
		text = {
			"Winning Ante is {C:attention}#1#"
		},
	},
	]]
	unlocked = true,
	atlas = "DR_deck",
	pos = { x = 1, y = 0 },
	config = { boss_order = { 'bl_fish', 'bl_flint', 'bl_house', 'bl_wall', 'bl_serpent', 'bl_psychic', 'bl_final_heart' } },
	loc_vars = function(self, info_queue, back)
		return { vars = { #self.config.boss_order } }
	end,
	apply = function(self)
		G.GAME.win_ante = #self.config.boss_order --7
		G.GAME.perscribed_bosses = {}
		--[[
		G.GAME.perscribed_bosses[1] = 'bl_fish'
		G.GAME.perscribed_bosses[2] = 'bl_flint'
		G.GAME.perscribed_bosses[3] = 'bl_house'
		G.GAME.perscribed_bosses[4] = 'bl_wall'
		G.GAME.perscribed_bosses[5] = 'bl_serpent'
		G.GAME.perscribed_bosses[6] = 'bl_psychic'
		G.GAME.perscribed_bosses[7] = 'bl_final_heart'
		]]
		for i, boss in ipairs(self.config.boss_order) do
			G.GAME.perscribed_bosses[i] = boss
		end
	end
}

SMODS.Back {
	key = "dark",
	config = {
		vouchers = { "v_crystal_ball", "v_omen_globe" }
	},
	--[[
	loc_txt = {
		name = "Dark Deck",
		text = {
			"Start run with",
			"{C:tarot,T:v_crystal_ball}#1#{} and",
			"{C:tarot,T:v_omen_globe}#2#{}"
		},
	},
	]]
	loc_vars = function(self, info_queue, back)
		return { vars = { localize { type = 'name_text', key = self.config.vouchers[1], set = 'Voucher' }, localize { type = 'name_text', key = self.config.vouchers[2], set = 'Voucher' } } }
	end,
	unlocked = true,
	atlas = "DR_deck",
	pos = { x = 2, y = 0 },
	apply = function(self, back)
		--[[
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
		]]
	end
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
	end,
}
