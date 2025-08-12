SMODS.Back:take_ownership("ghost",
	{
		loc_txt = {
			name = "Ghost Deck",
			text = {
				"{C:spectral}Prophecy{} cards may",
				"appear in the shop, start",
				"with a {C:spectral,T:c_hex}Blackened Knife{} card",
			},
		},
	},
	true
)

SMODS.Joker:take_ownership("ring_master",
	{
		loc_txt = {
			name = "Showman",
			text = {
				"{C:attention}Joker{}, {C:tarot}Tarot{}, {C:planet}Planet{},",
				"and {C:spectral}Prophecy{} cards may",
				"appear multiple times",
			},
			unlock = {
				"Reach Ante",
				"level {E:1,C:attention}#1#",
			},
		}
	},
	true
)

SMODS.Joker:take_ownership("seance",
	{
		loc_txt = {
			name = "Séance",
			text = {
				"If {C:attention}poker hand{} is a",
				"{C:attention}#1#{}, create a",
				"random {C:spectral}Prophecy{} card",
				"{C:inactive}(Must have room)",
			},
		}
	},
	true
)

SMODS.Joker:take_ownership("sixth_sense",
	{
		loc_txt = {
			name="Sixth Sense",
			text={
				"If {C:attention}first hand{} of round is",
				"a single {C:attention}6{}, destroy it and",
				"create a {C:spectral}Prophecy{} card",
				"{C:inactive}(Must have room)",
			},
		}
	},
	true
)

SMODS.Tag:take_ownership("ethereal",
	{
		loc_txt = {
			name = "Ethereal Tag",
			text = {
				"Gives a free",
				"{C:spectral}Prophecy Pack",
			},
		},
	},
	true
)

SMODS.Voucher:take_ownership("omen_globe",
	{
		loc_txt = {
			name = "Omen Globe",
			text = {
				"{C:spectral}Prophecy{} cards may",
				"appear in any of",
				"the {C:attention}Arcana Packs",
			},
			unlock = {
				"Use a total of {C:attention}#1#",
				"{C:tarot}Tarot{} cards from any",
				"{C:tarot}Arcana Pack",
				"{C:inactive}(#2#)",
			},
		},
	},
	true
)