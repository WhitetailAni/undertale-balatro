function Card:capsule_open()
   stop_use()
	G.STATE_COMPLETE = false 
	self.opening = true

	if not self.config.center.discovered then
		discover_card(self.config.center)
	end
	self.states.hover.can = false

	booster_obj = self.config.center
	if booster_obj and SMODS.Centers[booster_obj.key] then
		G.STATE = G.STATES.SMODS_BOOSTER_OPENED
		SMODS.OPENED_BOOSTER = self
		UTDR_Modules.Capsule.PrizePack = self
	end
	G.GAME.pack_choices = 1

	G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
		self:explode()
		
		local card = nil

		G.E_MANAGER:add_event(Event({trigger = 'after', delay = 1.3*math.sqrt(G.SETTINGS.GAMESPEED), blockable = false, blocking = false, func = function()
			local _card_to_spawn = booster_obj:create_card(self, i)
			card = SMODS.create_card(_card_to_spawn)
			card.T.x = self.T.x
			card.T.y = self.T.y
			card:start_materialize({G.C.WHITE, G.C.WHITE}, nil, 1.5*G.SETTINGS.GAMESPEED)
			return true
		end}))

		G.E_MANAGER:add_event(Event({trigger = 'after', delay = 1.3*math.sqrt(G.SETTINGS.GAMESPEED), blockable = false, blocking = false, func = function()
			if G.pack_cards then 
				if G.pack_cards and G.pack_cards.VT.y < G.ROOM.T.h then 
				G.pack_cards:emplace(card)
				return true
				end
			end
		end}))

	return true end }))
end

G.FUNCS.end_prize = function(e, delayfac)
	print("GM")
    delayfac = delayfac or 1
    stop_use()
    if G.booster_pack then
      if G.booster_pack_sparkles then G.booster_pack_sparkles:fade(1*delayfac) end
      if G.booster_pack_stars then G.booster_pack_stars:fade(1*delayfac) end
      if G.booster_pack_meteors then G.booster_pack_meteors:fade(1*delayfac) end
      G.booster_pack.alignment.offset.y = G.ROOM.T.y + 9

      G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.2*delayfac,blocking = false, blockable = false,
      func = function()
          G.booster_pack:remove()
          G.booster_pack = nil
        return true
      end}))
      G.E_MANAGER:add_event(Event({trigger = 'after',delay = 1*delayfac,blocking = false, blockable = false,
      func = function()
        if G.booster_pack_sparkles then G.booster_pack_sparkles:remove(); G.booster_pack_sparkles = nil end
        if G.booster_pack_stars then G.booster_pack_stars:remove(); G.booster_pack_stars = nil end
        if G.booster_pack_meteors then G.booster_pack_meteors:remove(); G.booster_pack_meteors = nil end
        return true
      end}))
    end

    delay(0.2*delayfac)
    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.2*delayfac,
    func = function()
      G.FUNCS.draw_from_hand_to_deck()
      G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.2*delayfac,
          func = function()
                G.STATE_COMPLETE = false
                G.STATE = G.STATES.UTDR_SHOP_CAPSULE
                --G.CONTROLLER.interrupt.focus = true
                
                --[[G.E_MANAGER:add_event(Event({func = function()        
                    if G.UTDR_shop_capsule then G.CONTROLLER:snap_to({node = G.UTDR_shop_capsule:get_UIE_by_ID('next_round_button')}) end
                return true end }))]]
                --G.STATE = G.STATES.UTDR_SHOP_CAPSULE
                --ease_background_colour_blind(G.GAME.PACK_INTERRUPT)
                --G.GAME.PACK_INTERRUPT = nil
          return true
      end}))

      G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.2*delayfac,
          func = function()
            save_run()
            return true
      end}))

      return true
    end}))
  end

local function capsule_UIBox(self)
	print("create")
	G.pack_cards = CardArea(
		G.ROOM.T.x + 9 + G.hand.T.x, G.hand.T.y,
		G.CARD_W*1.1,
		1.05*G.CARD_H,
		{card_limit = 1, type = 'consumeable', highlight_limit = 1, negative_info = true})

	local t = {n=G.UIT.ROOT, config = {align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15}, nodes={
		{n=G.UIT.R, config={align = "cl", colour = G.C.CLEAR,r=0.15, padding = 0.1, minh = 2, shadow = true}, nodes={
			{n=G.UIT.R, config={align = "cm"}, nodes={
			{n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
				{n=G.UIT.C, config={align = "cm", r=0.2, colour = G.C.CLEAR, shadow = true}, nodes={
					{n=G.UIT.O, config={object = G.pack_cards}},}}}}}},
		{n=G.UIT.R, config={align = "cm"}, nodes={}},
		{n=G.UIT.R, config={align = "tm"}, nodes={
			{n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={}},
			{n=G.UIT.C,config={align = "tm", padding = 0.05}, nodes={
				UIBox_dyn_container({
					{n=G.UIT.C, config={align = "cm", padding = 0.05, minw = 4}, nodes={
						{n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
							{n=G.UIT.O, config={object = DynaText({string = localize('UTDR_shopball_prize'), colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.7, maxw = 4, pop_in = 0.5})}}
						}},
						{n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
							{n=G.UIT.O, config={object = DynaText({string = "Gold", colours = { G.C.GOLD },shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, maxw = 4, pop_in = 0.5})}},
						}},
					}},	
				}),}},
			{n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={
				{n=G.UIT.R,config={minh =0.2}, nodes={}},
				{n=G.UIT.R,config={align = "tm",padding = 0.2, minh = 1.2, minw = 1.8, r=0.15,colour = G.C.GREY, one_press = true, button = 'end_prize', hover = true,shadow = true}, nodes = {
					{n=G.UIT.T, config={text = localize('b_skip'), scale = 0.5, colour = G.C.WHITE, shadow = true, focus_args = {button = 'y', orientation = 'bm'}, func = 'set_button_pip'}}}}}}}}}}}}
	return t
end

SMODS.Booster {
    key = "capsule_tarot",
    --weight = 1,
    loc_txt = {
    	name = "",
    	description = "",
    },
    --cost = 4,
    --atlas = "DR_joker",
    pos = { x = 0, y = 0 },
    config = {
    	extra = 1,
    	choose = 1
    },
    select_button_text = "UTDR_shopball_take",
    create_capsule_UIBox = capsule_UIBox,
    --group_key = "k_arcana_pack", -- Delete this if you're using `group_name` in `loc_txt`
    draw_hand = true,
    in_pool = function(self, args)
    	return false
    end,
    no_collection = true,
    --[[ease_background_colour = function(self)
        ease_background_colour_blind(G.STATES.TAROT_PACK)
    end,]]
    --[[particles = function(self)
        G.booster_pack_sparkles = Particles(1, 1, 0, 0, {
            timer = 0.015,
            scale = 0.2,
            initialize = true,
            lifespan = 1,
            speed = 1.1,
            padding = -1,
            attach = G.ROOM_ATTACH,
            colours = { G.C.WHITE, lighten(G.C.PURPLE, 0.4), lighten(G.C.PURPLE, 0.2), lighten(G.C.GOLD, 0.2) },
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,]]
    create_card = function(self, card, i)
        return { key = pseudorandom_element(UTDR_Modules.Capsule.possible_keys_tarot, "capsule_tarot"), skip_materialize = true }
    end,
}

SMODS.Booster {
    key = "capsule_joker",
    loc_txt = {
    	name = "",
    	description = "",
    },
    --atlas = "DR_joker",
    pos = { x = 0, y = 0 },
    config = {
    	extra = 1,
    	choose = 1
    },
    create_capsule_UIBox = capsule_UIBox,
    draw_hand = false,
    in_pool = function(self, args)
    	return false
    end,
    no_collection = true,
    create_card = function(self, card, i)
        return { key = pseudorandom_element(UTDR_Modules.Capsule.possible_keys_joker, "capsule_joker"), skip_materialize = true }
    end,
}

SMODS.Booster {
    key = "capsule_planet",
    loc_txt = {
    	name = "",
    	description = "",
    },
    --atlas = "DR_joker",
    pos = { x = 0, y = 0 },
    config = {
    	extra = 1,
    	choose = 1
    },
    create_capsule_UIBox = capsule_UIBox,
    draw_hand = false,
    in_pool = function(self, args)
    	return false
    end,
    no_collection = true,
    create_card = function(self, card, i)
        return { key = pseudorandom_element(UTDR_Modules.Capsule.possible_keys_planet, "capsule_planet"), skip_materialize = true }
    end,
}

SMODS.Booster {
    key = "capsule_spectral",
    loc_txt = {
    	name = "",
    	description = "",
    },
    --atlas = "DR_joker",
    pos = { x = 0, y = 0 },
    config = {
    	extra = 1,
    	choose = 1
    },
    create_capsule_UIBox = capsule_UIBox,
    draw_hand = false,
    in_pool = function(self, args)
    	return false
    end,
    no_collection = true,
    create_card = function(self, card, i)
        return { key = pseudorandom_element(UTDR_Modules.Capsule.possible_keys_spectral, "capsule_spectral"), skip_materialize = true }
    end,
}

SMODS.Booster {
    key = "capsule_gold",
    loc_txt = {
    	name = "",
    	description = "",
    },
    --atlas = "DR_joker",
    pos = { x = 0, y = 0 },
    config = {
    	extra = 1,
    	choose = 1
    },
    select_button_text = "UTDR_shopball_take",
    create_capsule_UIBox = capsule_UIBox,
    draw_hand = false,
    in_pool = function(self, args)
    	return false
    end,
    ease_background_colour = function(self)
        ease_background_colour_blind(G.C.GOLD)
    end,
    no_collection = true,
    create_card = function(self, card, i)
    	local gold_prize_key = pseudorandom_element(G.GAME.UTDR_capsule_gold_prizes, "capsule_prize_gold")
		--ensure no duplicate gold prizes, unless you got showman!
		while #SMODS.find_card("j_showman") == 0 and #SMODS.find_card(gold_prize_key) > 0 and G.P_CENTERS[gold_prize_key].set == "Joker" do
			gold_prize_key = pseudorandom_element(G.GAME.UTDR_capsule_gold_prizes, "capsule_prize_gold_attempt_2")
		end
		
		UTDR_Modules.Capsule.wow_that_was_so_gold(G.GAME.UTDR_capsule_gold_prizes, { gold_prize_key })
		
        return { key = gold_prize_key, skip_materialize = true }
    end,
}