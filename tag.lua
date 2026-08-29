UTDR = SMODS.current_mod
local my_config = UTDR.config

--if my_config["undertale"] or my_config["deltarune"] then
SMODS.Tag {
	key = "annoying",
	atlas = "tag",
	pos = { x = 0, y = 0 },
	apply = function(self, tag, context)
		tag:yep("+", G.C.DOG)
		local key = pseudorandom_element(SMODS.get_attribute_pool("UTDR_dog"), "annoying_tag")
		local card = SMODS.add_card({
			set = "Joker",
			key = key,
			key_append = "tag_annoying",
		})
		card:juice_up()
		play_sound("UTDR_bark", 1.0, 0.7)
		tag.triggered = true
	end
}
--end

--if my_config["undertale"] then
SMODS.Tag {
	key = "glamorous",
	atlas = "tag",
	pos = { x = 1, y = 0 },
	apply = function(self, tag, context)
		if context.type == 'utdr_glamorous_tag' then
			local color = pseudorandom_element({
				G.C.BRATTY,
				G.C.CATTY
			})
			tag:yep("+", color)
			tag.triggered = true
			return true
		end
	end
}
--end

--if my_config["deltarune"] then
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
}
--end
