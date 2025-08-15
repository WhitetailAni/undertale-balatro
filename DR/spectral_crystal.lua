SMODS.Consumable {
	key = "familiar_crystal",
	set = 'Spectral',
	loc_txt = {
		 name="Queen's Chariot",
		text={
			"Add {C:attention}#1#{} random {C:attention}Enhanced",
			"{C:attention}face cards{} to your hand",
		},
	},
	no_collection = true,
	in_pool = function(self, args)
		return false
	end
}

SMODS.Consumable {
	key = "grim_crystal",
	set = 'Spectral',
	loc_txt = {
		name="Flower Man",
		text={
			"Add {C:attention}#1#{} random {C:attention}Enhanced",
			"{C:attention}Aces{} to your hand",
		},
	},
	no_collection = true,
	in_pool = function(self, args)
		return false
	end
}

SMODS.Consumable {
	key = "incantation_crystal",
	set = 'Spectral',
	loc_txt = {
		 name="Lord of Screens",
		text = {
			"Add {C:attention}#1# random",
			"{C:attention}Enhanced numbered",
			"{C:attention}cards{} to your hand",
		},
	},
	no_collection = true,
	in_pool = function(self, args)
		return false
	end
}

SMODS.Consumable {
	key = "wraith_crystal",
	set = 'Spectral',
	loc_txt = {
		name="Jockington",
		text={
			"Creates a random",
			"{C:red}Rare{C:attention} Joker{}"
		},
	},
	no_collection = true,
	in_pool = function(self, args)
		return false
	end
}

SMODS.Consumable {
	key = "jorkington",
	set = 'Spectral',
	loc_txt = {
		name="Jorkington",
		text={
			"Creates a random",
			"{C:red}Rare{C:attention} Joker{}"
		},
	},
	no_collection = true,
	in_pool = function(self, args)
		return false
	end
}

SMODS.Consumable {
	key = "jorkington_crystal",
	set = 'Spectral',
	loc_txt = {
		name="Jorkington",
		text={
			"Creates a random",
			"{C:red}Rare{C:attention} Joker{}"
		},
	},
	no_collection = true,
	in_pool = function(self, args)
		return false
	end
}

SMODS.Consumable {
	key = "ouija_crystal",
	set = 'Spectral',
	loc_txt = {
		name="Darkened Eyes",
		text={
			"Converts all cards",
			"in hand to a single",
			"random {C:attention}rank"
		},
	},
	no_collection = true,
	in_pool = function(self, args)
		return false
	end
}

SMODS.Consumable {
	key = "ectoplasm_crystal",
	set = 'Spectral',
	loc_txt = {
		name="Three Heroes",
		text={
			"Add {C:dark_edition}Negative{} to",
			"a random {C:attention}Joker"
		},
	},
	no_collection = true,
	in_pool = function(self, args)
		return false
	end
}

SMODS.Consumable {
	key = "immolate_crystal",
	set = 'Spectral',
	loc_txt = {
		name="Final Tragedy",
		text={
			"Gain {C:money}$#2#",
		},
	},
	no_collection = true,
	in_pool = function(self, args)
		return false
	end
}

SMODS.Consumable {
	key = "ankh_crystal",
	set = 'Spectral',
	loc_txt = {
		name="Pointy-Headed",
		text={
			"Create a copy of a",
			"random {C:attention}Joker{}"
		},
	},
	no_collection = true,
	in_pool = function(self, args)
		return false
	end
}

SMODS.Consumable {
	key = "hex_crystal",
	set = 'Spectral',
	loc_txt = {
		name="Blackened Knife",
		text={
			"Add {C:dark_edition}Polychrome{} to",
			"a random {C:attention}Joker{}"
		},
	},
	no_collection = true,
	in_pool = function(self, args)
		return false
	end
}