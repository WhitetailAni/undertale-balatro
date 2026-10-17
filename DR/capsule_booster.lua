function Card:capsule_open()
   stop_use()
	G.STATE_COMPLETE = false 
	self.opening = true
	
	self.states.hover.can = false

	booster_obj = self.config.center
	if booster_obj and SMODS.Centers[booster_obj.key] then
		G.STATE = G.STATES.SMODS_BOOSTER_OPENED
		SMODS.OPENED_BOOSTER = self
	end
	G.GAME.pack_choices = 1

	G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
		local card = nil

		G.E_MANAGER:add_event(Event({trigger = 'after', delay = 1.3*math.sqrt(G.SETTINGS.GAMESPEED), blocking = false, func = function()
			local _card_to_spawn = booster_obj:create_card(self, i)
			card = SMODS.create_card(_card_to_spawn)
			card.T.x = self.T.x
			card.T.y = self.T.y
			card:start_materialize({G.C.WHITE, G.C.WHITE}, nil, 1.5*G.SETTINGS.GAMESPEED)
			self.capsule.pop = true
			return true
		end}))

		G.E_MANAGER:add_event(Event({trigger = 'after', delay = 1.3*math.sqrt(G.SETTINGS.GAMESPEED), blocking = false, func = function()
			if G.pack_cards then 
				if G.pack_cards and G.pack_cards.VT.y < G.ROOM.T.h then 
				G.pack_cards:emplace(card)
				return true
				end
			end
		end}))

	return true end }))
end

G.FUNCS.end_capsule = function(e)
	G.pack_cards.cards[1]:start_dissolve(nil, false)
	G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.5, func = function()
		G.booster_pack.alignment.offset.y = G.ROOM.T.y + 29
		G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.5, func = function()
			if G.booster_pack then G.booster_pack:remove(); G.booster_pack = nil end
			if G.pack_cards then G.pack_cards:remove(); G.pack_cards = nil end
			return true
		end}))
		return true
	end}))
	G.FUNCS.end_consumeable(e)
end

local function capsule_UIBox(self)
	--im sorry for removing you G.pack_cards definition	

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
					}},	
				}),}},
			{n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={
				{n=G.UIT.R,config={minh =0.2}, nodes={}},
				{n=G.UIT.R,config={align = "tm",padding = 0.2, minh = 1.2, minw = 1.8, r=0.15,colour = G.C.GREY, one_press = true, button = 'end_capsule', delayfac = 0.0, hover = true,shadow = true}, nodes = {
					{n=G.UIT.T, config={text = localize('b_skip'), scale = 0.5, colour = G.C.WHITE, shadow = true, focus_args = {button = 'y', orientation = 'bm'}, func = 'set_button_pip'}}}}}}}}}}}}
	return t
end

SMODS.Booster {
    key = "capsule_tarot",
    loc_txt = {
    	name = "",
    	description = "",
    },
    atlas = "shop_capsule_ball",
    pos = { x = 0, y = 0 },
    pixel_size = { w = 64, h = 64 },
    config = {
    	extra = 1,
    	choose = 1
    },
    select_button_text = "UTDR_shopball_take",
    create_capsule_UIBox = capsule_UIBox,
    ease_background_colour = function(self)
    	ease_colour(G.C.DYN_UI.MAIN, G.C.RED)
        ease_background_colour{ new_colour = mix_colours(G.C.RED, G.C.BLACK, 0.6) }
    end,
    draw_hand = true,
    in_pool = function(self, args)
    	return false
    end,
    no_collection = true,
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
    atlas = "shop_capsule_ball",
    pos = { x = 0, y = 0 },
    pixel_size = { w = 64, h = 64 },
    config = {
    	extra = 1,
    	choose = 1
    },
    ease_background_colour = function(self)
    	ease_colour(G.C.DYN_UI.MAIN, G.C.RED)
        ease_background_colour{ new_colour = mix_colours(G.C.RED, G.C.BLACK, 0.6) }
    end,
    create_capsule_UIBox = capsule_UIBox,
    draw_hand = false,
    in_pool = function(self, args)
    	return false
    end,
    no_collection = true,
    create_card = function(self, card, i)
        return { key = pseudorandom_element(UTDR_Modules.Capsule.possible_keys_jokers, "capsule_joker"), skip_materialize = true }
    end,
}

SMODS.Booster {
    key = "capsule_planet",
    loc_txt = {
    	name = "",
    	description = "",
    },
    atlas = "shop_capsule_ball",
    pos = { x = 0, y = 0 },
    pixel_size = { w = 64, h = 64 },
    config = {
    	extra = 1,
    	choose = 1
    },
    ease_background_colour = function(self)
    	ease_colour(G.C.DYN_UI.MAIN, G.C.RED)
        ease_background_colour{ new_colour = mix_colours(G.C.RED, G.C.BLACK, 0.6) }
    end,
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
    atlas = "shop_capsule_ball",
    pos = { x = 0, y = 0 },
    pixel_size = { w = 64, h = 64 },
    config = {
    	extra = 1,
    	choose = 1
    },
    ease_background_colour = function(self)
    	ease_colour(G.C.DYN_UI.MAIN, G.C.RED)
        ease_background_colour{ new_colour = mix_colours(G.C.RED, G.C.BLACK, 0.6) }
    end,
    create_capsule_UIBox = capsule_UIBox,
    draw_hand = true,
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
    atlas = "shop_capsule_ball",
    pos = { x = 1, y = 0 },
    pixel_size = { w = 64, h = 64 },
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
    	ease_colour(G.C.DYN_UI.MAIN, G.C.GOLD)
        ease_background_colour{ new_colour = mix_colours(G.C.GOLD, G.C.BLACK, 0.6) }
    end,
    no_collection = true,
    create_card = function(self, card, i)
    	local gold_prize_key = pseudorandom_element(G.GAME.UTDR_capsule_gold_prizes, "capsule_prize_gold")
		--ensure no duplicate gold prizes, unless you got showman!
		while #SMODS.find_card("j_showman") == 0 and #SMODS.find_card(gold_prize_key) > 0 and G.P_CENTERS[gold_prize_key].set == "Joker" do
			gold_prize_key = pseudorandom_element(G.GAME.UTDR_capsule_gold_prizes, "capsule_prize_gold_attempt_2")
		end
		
		UTDR_Modules.Capsule.wow_that_was_so_gold(G.GAME.UTDR_capsule_gold_prizes, { gold_prize_key })
		
		UTDR_Modules.Capsule.points_bet_total = 0
		
        return { key = gold_prize_key, skip_materialize = true }
    end,
}

SMODS.DrawStep {
    key = "UTDR_capsule",
    order = -67,
    func = function(self)
        if self.capsule and self.capsule.top and self.capsule.bottom and G.pack_cards then
        	local area = G.pack_cards
        	local target = 0
        	if self.capsule.pop then
        		target = 5
        	end
        	if not self.capsule.split then
        		self.capsule.split = 0
        	end
        	
        	self.capsule.x0 = self.capsule.x0 or area.T.x
    		self.capsule.y0 = self.capsule.y0 or area.T.y
    		self.capsule.howOld = (self.capsule.howOld or 0) + (G.real_dt or 0.016)

			self.capsule.t = self.capsule.pop and ((self.capsule.t or 0) + G.real_dt) or 0
			local hsinav = math.min(1, math.max(0, self.capsule.howOld - 0.2) / 0.4)
			local vanish = math.min(1, self.capsule.t)
			local dissolve = math.max(1 - hsinav, vanish)
        	
			local area = G.pack_cards
			local trackX = area.T.x + area.T.w / 2
			local trackY = area.T.y + area.T.h / 2
			local visualTrackX = area.VT.x + area.VT.w / 2
			local visualTrackY = area.VT.y + area.VT.h / 2
			for _, homosexual in ipairs({self.capsule.top, self.capsule.bottom}) do
				homosexual.T.x = visualTrackX - homosexual.T.w / 2
				homosexual.T.y = visualTrackY - homosexual.T.h / 2
				homosexual.VT.x = visualTrackX - homosexual.VT.w / 2
				homosexual.VT.y = visualTrackY - homosexual.VT.h / 2
			end
			
			self.capsule.split = self.capsule.split + (target - self.capsule.split) * math.min(1, 10 * G.real_dt)
			if math.abs(target - self.capsule.split) < 0.001 then
				self.capsule.split = target
			end
			
			--rotate and scale
			local progress = self.capsule.split / 2
			local angle = progress * math.rad(26) --math sucks i hate it
			local inflation = 1 + (progress * 0.3)

			--set all da things
			local topX = self.capsule.top.VT.x
			local bottomX = self.capsule.bottom.VT.x
			local topR = self.capsule.top.VT.r
			local bottomR = self.capsule.bottom.VT.r
			local topS = self.capsule.top.VT.scale
			local bottomS = self.capsule.bottom.VT.scale
	
			self.capsule.top.VT.x = topX - self.capsule.split
			self.capsule.top.VT.r = topR - angle
			self.capsule.top.VT.scale = topS * inflation
			self.capsule.top.dissolve = dissolve
			self.capsule.top:draw_shader('dissolve')
	
			self.capsule.bottom.VT.x = bottomX + self.capsule.split
			self.capsule.bottom.VT.r = bottomR - angle
			self.capsule.bottom.VT.scale = bottomS * inflation
			self.capsule.bottom.dissolve = dissolve
			self.capsule.bottom:draw_shader('dissolve')
			
			self.capsule.bottom.VT.x = bottomX
			self.capsule.bottom.VT.r = bottomR
			self.capsule.bottom.VT.scale = bottomS
			
			self.capsule.top.VT.x = topX
			self.capsule.top.VT.r = topR
			self.capsule.top.VT.scale = topS
        end
    end,
    conditions = { facing = 'front' },
}