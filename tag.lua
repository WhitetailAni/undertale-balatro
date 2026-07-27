SMODS.Tag {
	key = "annoying",
	atlas = "tag",
	pos = { x = 0, y = 0 },
	apply = function(self, tag, context)
		tag:yep("+", G.C.DOG)
		local key = pseudorandom_element({
			"j_UTDR_annoying_dog",
			"j_UTDR_dog_residue",
			"j_UTDR_hot_dog",
			"j_UTDR_dog_shrine",
			"j_UTDR_lesser_dog",
			"j_UTDR_doghole",
			"j_UTDR_dogcheck"
		}, "annoying_tag")
		local card = SMODS.add_card({
			set = "Joker",
			rarity = "UTDR_dog",
			key_append = "tag_annoying",
		})
		card:juice_up()
		play_sound("UTDR_bark", 1.0, 0.7)
		tag.triggered = true
	end
}

SMODS.Tag {
	key = "glamorous",
	atlas = "tag",
	pos = { x = 1, y = 0 },
	apply = function(self, tag, context)
		local color = pseudorandom_element({
			G.C.BRATTY,
			G.C.CATTY
		})
		tag:yep("+", color)
		print("we applyin out here")
		tag.triggered = true
	end
}

SMODS.Tag {
	key = "capsule",
	atlas = "tag",
	pos = { x = 2, y = 0 },
	apply = function(self, tag, context)
		tag:yep("+", G.C.GOLD)
		print("we applyin out here")
		tag.triggered = true
	end
}

SMODS.Tag {
	key = "t_rank",
	config = {
		points = 400,
	},
	atlas = "tag",
	pos = { x = 3, y = 0 },
	loc_vars = function(self, info_queue, tag)
		return { vars = { tag.config.points } }
	end,
	apply = function(self, tag, context)
		if context.type == "eval" and G.GAME.last_blind and G.GAME.last_blind.boss then
			tag:yep("+", G.C.POINTS)
			--probably switch to a "give POINTs on blind cashout screen? but this works for now"
			ease_points(tag.config.points)
			tag.triggered = true
		end
	end
}