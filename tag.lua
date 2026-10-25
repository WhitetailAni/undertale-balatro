UTDR = SMODS.current_mod

--if my_config["undertale"] or my_config["deltarune"] then
SMODS.Tag {
	key = "annoying",
	atlas = "tag",
	pos = { x = 0, y = 0 },
	apply = function(self, tag, context)
		if #G.jokers.cards >= G.jokers.config.card_limits.total_slots then return end
		--COME BACK TO THIS WHEN YOU ARENT WIPED AFTER AN >10HR WORKDAY KATIE
		G.E_MANAGER:add_event(Event({
			func = (function()
				local key = pseudorandom_element(SMODS.get_attribute_pool("UTDR_dog"), "annoying_tag")
				for i = 1, #G.jokers.cards do
					while G.jokers.cards[i].config.center.key == key do
						key = pseudorandom_element(SMODS.get_attribute_pool("UTDR_dog"), "annoying_tag")
					end
				end
				local card = SMODS.add_card({
					set = "Joker",
					key = key,
					key_append = "tag_annoying",
				})
				card:juice_up()
				return true
			end)
		}))
		tag:yep("+", G.C.DOG)
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
