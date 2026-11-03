

	SMODS.Back {
		key = "dog",
		unlocked = true,
		atlas = "UT_deck",
		pos = { x = 0, y = 0 },
		config = { win_ante = 9, extra_jokers = { "j_UTDR_bandage", "j_UTDR_stick" } },
		loc_vars = function(self, info_queue, back)
			--print(localize({ type = 'name_text', set = "Joker", key = self.config.extra_jokers[1] }))
			--print(localize({ type = 'name_text', set = "Joker", key = self.config.extra_jokers[2] }))
			return { vars = { localize({ type = 'name_text', set = "Joker", key = self.config.extra_jokers[1] }) or 'Bandage', localize({ type = 'name_text', set = "Joker", key = self.config.extra_jokers[2] }) or 'Stick', self.config.win_ante } }
		end,
		apply = function(self, back)
			G.GAME.win_ante = 9
			for i = 1, #self.config.extra_jokers do
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					func = function()
						SMODS.add_card({ key = self.config.extra_jokers[i], no_edition = true })
						return true
					end
				}))
			end
		end
	}

SMODS.Back {
	key = "merciful",
	config = { common_uncommon_multipler = 0.25, rare_legendary_multiplier = 1.5 },
	loc_vars = function(self, info_queue, back)
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
	unlocked = true,
	atlas = "DR_deck",
	pos = { x = 1, y = 0 },
	config = { boss_order = { 'bl_fish', 'bl_flint', 'bl_house', 'bl_wall', 'bl_serpent', 'bl_psychic', 'bl_final_heart' } },
	loc_vars = function(self, info_queue, back)
		-- uncommenting this won't visually display anything but it'd be really funny if we got this to work somehow
		--[[
		local main_end = {}
		for _, boss in ipairs(self.config.boss_order) do
			if info_queue then
				info_queue[#info_queue + 1] = localize { type = 'name_text', key = boss, set = 'Blind' }
			end
			local thing = {
				n = G.UIT.C,
				config = { align = "bm", minh = 0.4 },
				nodes = {
					{
						n = G.UIT.C,
						config = { align = "m", colour = G.C.CLEAR, r = 0.05, padding = 0.06 },
						nodes = {
							{ n = G.UIT.T, config = { text = localize { type = 'name_text', key = boss, set = 'Blind' }, colour = G.P_BLINDS[boss].boss_colour, scale = 0.32 * 0.9 } },
						}
					}
				}
			}
			table.insert(main_end, thing)
		end
		]]
		--print(main_end)
		return { vars = { #self.config.boss_order } }
	end,
	apply = function(self)
		G.GAME.win_ante = #self.config.boss_order --7
		G.GAME.perscribed_bosses = {}
		for i, boss in ipairs(self.config.boss_order) do
			G.GAME.perscribed_bosses[i] = boss
		end
	end
}