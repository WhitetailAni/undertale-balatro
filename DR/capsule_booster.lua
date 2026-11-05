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
			card.states.visible = false
			card:start_materialize({G.C.WHITE, G.C.WHITE}, nil, 1.5*G.SETTINGS.GAMESPEED)
			self.capsule.pop = true
			return true
		end}))

		G.E_MANAGER:add_event(Event({trigger = 'after', delay = 1.3*math.sqrt(G.SETTINGS.GAMESPEED), blocking = false, func = function()
			if G.pack_cards then 
				if G.pack_cards and G.pack_cards.VT.y < G.ROOM.T.h then 
				UTDR_Modules.Capsule.you_can_skip_now = true
				G.pack_cards:emplace(card)
				return true
				end
			end
		end}))

	return true end }))
end

G.FUNCS.end_capsule = function(e)
	--if G.booster_pack then
	G.booster_pack.REMOVED = true
	--end
	stop_use()

	if #G.pack_cards.cards > 0 then
		G.pack_cards.cards[1]:start_dissolve(nil, false)
	end
	
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

function G.FUNCS.can_end_capsule(e)
	local can_use = (G.GAME.STOP_USE and G.GAME.STOP_USE == 0) and UTDR_Modules.Capsule.you_can_skip_now

	e.config.colour = can_use and darken(G.C.GREY, e.states.hover.is and .15 or 0) or G.C.UI.BACKGROUND_INACTIVE
	e.config.button = can_use and 'end_capsule' or nil
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
				{n=G.UIT.R,config={align = "tm",padding = 0.2, minh = 1.2, minw = 1.8, r=0.15,colour = G.C.GREY, one_press = true, func = "can_end_capsule", button = 'end_capsule', delayfac = 0.0, hover = true,shadow = true}, nodes = {
					{n=G.UIT.T, config={text = localize('b_skip'), scale = 0.5, colour = G.C.WHITE, shadow = true, focus_args = {button = 'y', orientation = 'bm'}, func = 'set_button_pip'}}}}}}}}}}}}
	return t
end

SMODS.Booster {
    key = "capsule_tarot",
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
    	play_sound("UTDR_applause", 1.0, 0.7)
        return {
    		set = "Tarot",
			area = G.pack_cards,
    		skip_materialize = true,
    		key_append = "capsule_tarot"
    	}
    end,
}

SMODS.Booster {
    key = "capsule_joker",
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
    	play_sound("UTDR_applause", 1.0, 0.7)
    	return {
    		set = "Joker",
			area = G.pack_cards,
    		skip_materialize = true,
    		key_append = "capsule_joker"
    	}
    end,
}

SMODS.Booster {
    key = "capsule_planet",
    atlas = "shop_capsule_ball",
    pos = { x = 0, y = 0 },
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
    	play_sound("UTDR_aww", 1.0, 0.7)
    	return {
    		set = "Planet",
			area = G.pack_cards,
    		skip_materialize = true,
    		key_append = "capsule_planet"
    	}
    end,
}

SMODS.Booster {
    key = "capsule_spectral",
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
    	play_sound("UTDR_applause", 1.0, 0.7)
        return {
    		set = "Spectral",
			area = G.pack_cards,
    		skip_materialize = true,
    		key_append = "capsule_spectral"
    	}
    end,
}

SMODS.Booster {
    key = "capsule_gold",
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
    	play_sound("UTDR_applause2", 1.0, 0.7)
    	UTDR_Modules.Capsule.points_bet_total = 0
    	if 0.5 < pseudorandom("is_gold_prize_voucher") then
    		local voucher_dummy = SMODS.create_card({ set = "Voucher" })
    		local key = voucher_dummy.config.center.key
    		voucher_dummy:remove()
    		
    		if G.shop_vouchers then
				for i = 1, #G.shop_vouchers.cards do
					while key == G.shop_vouchers.cards[i].config.center.key do
						voucher_dummy = SMODS.create_card({ set = "Voucher" })
						key = voucher_dummy.config.center.key
						voucher_dummy:remove()
					end
				end
    		end
    		
    		UTDR_Modules.Capsule.wow_that_was_so_gold(G.GAME.UTDR_capsule_gold_prizes_voucher, { key })
    		return { key = key, skip_materialize = true }
    	else
			local gold_prize_key = pseudorandom_element(G.GAME.UTDR_capsule_gold_prizes_nonvoucher, "capsule_prize_gold_nonvoucher")
			--ensure no duplicate gold prizes, unless you got showman!
			while #SMODS.find_card("j_showman") == 0 and #SMODS.find_card(gold_prize_key) > 0 and G.P_CENTERS[gold_prize_key].set == "Joker" do
				gold_prize_key = pseudorandom_element(G.GAME.UTDR_capsule_gold_prizes_nonvoucher, "capsule_prize_gold_nonvoucher_attempt_2")
			end
			
			UTDR_Modules.Capsule.wow_that_was_so_gold(G.GAME.UTDR_capsule_gold_prizes_nonvoucher, { gold_prize_key })
			
			return { key = gold_prize_key, skip_materialize = true }
        end
    end,
}

SMODS.DrawStep {
    key = "UTDR_capsule",
    order = -67,
    func = function(self)
        if self.capsule and self.capsule.top and self.capsule.bottom and G.pack_cards and G.pack_cards.VT.x < 10 then
        	local area = G.pack_cards
        	local dt = (G.real_dt * G.SETTINGS.GAMESPEED) / 2 --i forgot about game speed when designing this, so everything was timed off 4x. lmao
        	self.capsule.howOld = (self.capsule.howOld or 0) + dt
        	local hsinav = math.min(1, math.max(0, self.capsule.howOld - 0.4) / 0.2)
        	
        	local target = 0
        	
        	if self.capsule.pop and hsinav >= 1 then
        		target = 4
        	end
        	if not self.capsule.split then
        		self.capsule.split = 0
        	end
        	
        	self.capsule.x0 = self.capsule.x0 or area.T.x
    		self.capsule.y0 = self.capsule.y0 or area.T.y
    		
			self.capsule.t = self.capsule.pop and ((self.capsule.t or 0) + dt) or 0
			
			local vanish = math.min(1, self.capsule.t)
			local dissolve = math.max(1 - hsinav, vanish)
        	
			local area = G.pack_cards
			local trackX = area.T.x + area.T.w / 2
			local trackY = area.T.y + area.T.h / 2
			local visualTrackX = area.VT.x + area.VT.w / 2
			local visualTrackY = area.VT.y + area.VT.h / 2
			for _, homosexual in ipairs({self.capsule.top, self.capsule.bottom}) do
				homosexual.T.x = trackX - homosexual.T.w / 2
				homosexual.T.y = trackY - homosexual.T.h / 2
				homosexual.VT.x = trackX - homosexual.VT.w / 2
				homosexual.VT.y = trackY - homosexual.VT.h / 2
			end
			
			self.capsule.split = self.capsule.split + (target - self.capsule.split) * (1 - math.exp(-10 * dt))
			if math.abs(target - self.capsule.split) < 0.001 then
				self.capsule.split = target
			end
			
			if self.capsule.pop and hsinav >= 1 and not self.capsule.card_anim and self.capsule.split == 0.4 then
        		self.capsule.card_anim = true
        		area.cards[1].states.visible = true
        		area.cards[1]:start_materialize({G.C.WHITE, G.C.WHITE}, nil, 1.5*G.SETTINGS.GAMESPEED)
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