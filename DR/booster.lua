SMODS.Booster:take_ownership("arcana_normal_1", {
		atlas = "UTDR_boosters",
		pos = { x = 0, y = 0 },
		in_pool = function(self, args)
			local sheltered = #SMODS.find_card("j_UTDR_sjelter") > 0
			local seamed = #SMODS.find_card("j_UTDR_seam") > 0
			return not (sheltered or seamed)
		end,
	},
	true
)

SMODS.Booster:take_ownership("arcana_normal_2", {
		atlas = "UTDR_boosters",
		pos = { x = 1, y = 0 },
		in_pool = function(self, args)
			local sheltered = #SMODS.find_card("j_UTDR_sjelter") > 0
			local seamed = #SMODS.find_card("j_UTDR_seam") > 0
			return not (sheltered or seamed)
		end,
	},
	true
)

SMODS.Booster:take_ownership("arcana_normal_3", {
		atlas = "UTDR_boosters",
		pos = { x = 2, y = 0 },
		in_pool = function(self, args)
			local sheltered = #SMODS.find_card("j_UTDR_sjelter") > 0
			local seamed = #SMODS.find_card("j_UTDR_seam") > 0
			return not (sheltered or seamed)
		end,
	},
	true
)

SMODS.Booster:take_ownership("arcana_normal_4", {
		atlas = "UTDR_boosters",
		pos = { x = 3, y = 0 },
		in_pool = function(self, args)
			local sheltered = #SMODS.find_card("j_UTDR_sjelter") > 0
			local seamed = #SMODS.find_card("j_UTDR_seam") > 0
			return not (sheltered or seamed)
		end,
	},
	true
)

SMODS.Booster:take_ownership("arcana_jumbo_1", {
		atlas = "UTDR_boosters",
		pos = { x = 0, y = 1 },
		in_pool = function(self, args)
			local sheltered = #SMODS.find_card("j_UTDR_sjelter") > 0
			local seamed = #SMODS.find_card("j_UTDR_seam") > 0
			return not (sheltered or seamed)
		end,
	},
	true
)

SMODS.Booster:take_ownership("arcana_jumbo_2", {
		atlas = "UTDR_boosters",
		pos = { x = 1, y = 1 },
		in_pool = function(self, args)
			local sheltered = #SMODS.find_card("j_UTDR_sjelter") > 0
			local seamed = #SMODS.find_card("j_UTDR_seam") > 0
			return not (sheltered or seamed)
		end,
	},
	true
)

SMODS.Booster:take_ownership("arcana_mega_1", {
		atlas = "UTDR_boosters",
		pos = { x = 2, y = 1 },
		in_pool = function(self, args)
			return #SMODS.find_card("j_UTDR_sjelter") == 0
		end,
	},
	true
)

SMODS.Booster:take_ownership("arcana_mega_2", {
		atlas = "UTDR_boosters",
		pos = { x = 3, y = 1 },
		in_pool = function(self, args)
			return #SMODS.find_card("j_UTDR_sjelter") == 0
		end,
	},
	true
)

SMODS.Booster:take_ownership("spectral_normal_1", {
		atlas = "UTDR_boosters",
		pos = { x = 0, y = 2 },
		loc_txt = {
			 name = "Prophecy Pack",
			 text = {
				"Choose {C:attention}#1#{} of up to",
				"{C:attention}#2# {C:spectral}Prophecy{} cards to",
				"be used immediately",
			},
		},
		in_pool = function(self, args)
			return #SMODS.find_card("j_UTDR_seam") == 0
		end,
	},
	true
)

SMODS.Booster:take_ownership("spectral_normal_2", {
		atlas = "UTDR_boosters",
		pos = { x = 1, y = 2 },
		loc_txt = {
			 name = "Prophecy Pack",
			 text = {
				"Choose {C:attention}#1#{} of up to",
				"{C:attention}#2# {C:spectral}Prophecy{} cards to",
				"be used immediately",
			},
		},
		in_pool = function(self, args)
			return #SMODS.find_card("j_UTDR_seam") == 0
		end,
	},
	true
)

SMODS.Booster:take_ownership("spectral_jumbo_1", {
		atlas = "UTDR_boosters",
		pos = { x = 2, y = 2 },
		loc_txt = {
			name = "Jumbo Prophecy Pack",
			text = {
				"Choose {C:attention}#1#{} of up to",
				"{C:attention}#2# {C:spectral}Prophecy{} cards to",
				"be used immediately",
			},
		},
		in_pool = function(self, args)
			return #SMODS.find_card("j_UTDR_seam") == 0
		end,
	},
	true
)

SMODS.Booster:take_ownership("spectral_mega_1", {
		atlas = "UTDR_boosters",
		pos = { x = 3, y = 2 },
		loc_txt = {
			name = "Mega Prophecy Pack",
			text = {
				"Choose {C:attention}#1#{} of up to",
				"{C:attention}#2# {C:spectral}Prophecy{} cards to",
				"be used immediately",
			},
		},
	},
	true
)


--seam/shelter take_ownership only
SMODS.Booster:take_ownership("celestial_normal_1", {
		in_pool = function(self, args)
			local sheltered = #SMODS.find_card("j_UTDR_sjelter") > 0
			local seamed = #SMODS.find_card("j_UTDR_seam") > 0
			return not (sheltered or seamed)
		end,
	},
	true
)

SMODS.Booster:take_ownership("celestial_normal_2", {
		in_pool = function(self, args)
			local sheltered = #SMODS.find_card("j_UTDR_sjelter") > 0
			local seamed = #SMODS.find_card("j_UTDR_seam") > 0
			return not (sheltered or seamed)
		end,
	},
	true
)

SMODS.Booster:take_ownership("celestial_normal_3", {
		in_pool = function(self, args)
			local sheltered = #SMODS.find_card("j_UTDR_sjelter") > 0
			local seamed = #SMODS.find_card("j_UTDR_seam") > 0
			return not (sheltered or seamed)
		end,
	},
	true
)

SMODS.Booster:take_ownership("celestial_normal_4", {
		in_pool = function(self, args)
			local sheltered = #SMODS.find_card("j_UTDR_sjelter") > 0
			local seamed = #SMODS.find_card("j_UTDR_seam") > 0
			return not (sheltered or seamed)
		end,
	},
	true
)

SMODS.Booster:take_ownership("celestial_jumbo_1", {
		in_pool = function(self, args)
			local sheltered = #SMODS.find_card("j_UTDR_sjelter") > 0
			local seamed = #SMODS.find_card("j_UTDR_seam") > 0
			return not (sheltered or seamed)
		end,
	},
	true
)

SMODS.Booster:take_ownership("celestial_jumbo_2", {
		in_pool = function(self, args)
			local sheltered = #SMODS.find_card("j_UTDR_sjelter") > 0
			local seamed = #SMODS.find_card("j_UTDR_seam") > 0
			return not (sheltered or seamed)
		end,
	},
	true
)

SMODS.Booster:take_ownership("celestial_mega_1", {
		in_pool = function(self, args)
			return #SMODS.find_card("j_UTDR_sjelter") == 0
		end,
	},
	true
)

SMODS.Booster:take_ownership("celestial_mega_2", {
		in_pool = function(self, args)
			return #SMODS.find_card("j_UTDR_sjelter") == 0
		end,
	},
	true
)

SMODS.Booster:take_ownership("standard_normal_1", {
		in_pool = function(self, args)
			local sheltered = #SMODS.find_card("j_UTDR_sjelter") > 0
			local seamed = #SMODS.find_card("j_UTDR_seam") > 0
			return not (sheltered or seamed)
		end,
	},
	true
)

SMODS.Booster:take_ownership("standard_normal_2", {
		in_pool = function(self, args)
			local sheltered = #SMODS.find_card("j_UTDR_sjelter") > 0
			local seamed = #SMODS.find_card("j_UTDR_seam") > 0
			return not (sheltered or seamed)
		end,
	},
	true
)

SMODS.Booster:take_ownership("standard_normal_3", {
		in_pool = function(self, args)
			local sheltered = #SMODS.find_card("j_UTDR_sjelter") > 0
			local seamed = #SMODS.find_card("j_UTDR_seam") > 0
			return not (sheltered or seamed)
		end,
	},
	true
)

SMODS.Booster:take_ownership("standard_normal_4", {
		in_pool = function(self, args)
			local sheltered = #SMODS.find_card("j_UTDR_sjelter") > 0
			local seamed = #SMODS.find_card("j_UTDR_seam") > 0
			return not (sheltered or seamed)
		end,
	},
	true
)

SMODS.Booster:take_ownership("standard_jumbo_1", {
		in_pool = function(self, args)
			local sheltered = #SMODS.find_card("j_UTDR_sjelter") > 0
			local seamed = #SMODS.find_card("j_UTDR_seam") > 0
			return not (sheltered or seamed)
		end,
	},
	true
)

SMODS.Booster:take_ownership("standard_jumbo_2", {
		in_pool = function(self, args)
			local sheltered = #SMODS.find_card("j_UTDR_sjelter") > 0
			local seamed = #SMODS.find_card("j_UTDR_seam") > 0
			return not (sheltered or seamed)
		end,
	},
	true
)

SMODS.Booster:take_ownership("standard_mega_1", {
		in_pool = function(self, args)
			return #SMODS.find_card("j_UTDR_sjelter") == 0
		end,
	},
	true
)

SMODS.Booster:take_ownership("standard_mega_2", {
		in_pool = function(self, args)
			return #SMODS.find_card("j_UTDR_sjelter") == 0
		end,
	},
	true
)

SMODS.Booster:take_ownership("buffoon_normal_1", {
		in_pool = function(self, args)
			local sheltered = #SMODS.find_card("j_UTDR_sjelter") > 0
			local seamed = #SMODS.find_card("j_UTDR_seam") > 0
			return not (sheltered or seamed)
		end,
	},
	true
)

SMODS.Booster:take_ownership("buffoon_normal_2", {
		in_pool = function(self, args)
			local sheltered = #SMODS.find_card("j_UTDR_sjelter") > 0
			local seamed = #SMODS.find_card("j_UTDR_seam") > 0
			return not (sheltered or seamed)
		end,
	},
	true
)

SMODS.Booster:take_ownership("buffoon_jumbo_1", {
		in_pool = function(self, args)
			local sheltered = #SMODS.find_card("j_UTDR_sjelter") > 0
			local seamed = #SMODS.find_card("j_UTDR_seam") > 0
			return not (sheltered or seamed)
		end,
	},
	true
)

SMODS.Booster:take_ownership("buffoon_mega_1", {
		in_pool = function(self, args)
			return #SMODS.find_card("j_UTDR_sjelter") == 0
		end,
	},
	true
)