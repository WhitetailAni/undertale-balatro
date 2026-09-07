UTDR_Modules.Capsule = {
	bet_amount = 0,
	min_amount = 50
}

function UTDR_Modules.Capsule.add_vouchers()
	for key, value in pairs(G.P_CENTERS) do
		if value.set == "Voucher" then
			G.GAME.capsule.gold_prizes[#G.GAME.capsule.gold_prizes + 1] = key
		end
	end
end



local function did_win_gold(bet)
	local remaining = #G.GAME.capsule.gold_prizes
	local remaining_block = 0.1 + (remaining / 50)
	local oldbet_block = 1 + (G.GAME.capsule.last_bet / 50)
	
	local chance = 5 + (bet - 100) * remaining_block * oldbet_block
	G.GAME.capsule.last_bet = bet
	chance = chance / 100
	return pseudorandom("capsule_gold") > chance
end

local function wow_that_was_so_gold(input, filter)
	local possible_keys = input
	local knightmare = {}
	for _, value in ipairs(filter) do
		knightmare[value] = true
	end
	
	for i = #possible_keys, 1, -1 do
		if knightmare[possible_keys[i]] then
			table.remove(possible_keys, i)
		end
	end
	return possible_keys
end

function UTDR_Modules.Capsule.get_reward(bet)
	if bet == 1225 then
		return {
			key = "j_UTDR_lacquer_triangle",
			december = true			
		}
	elseif did_win_gold(bet) then
		local gold_prize_key = pseudorandom_element(G.GAME.capsule.gold_prizes, "capsule_prize_gold")
		
		--ensure no duplicate gold prizes, unless you got showman!
		while #SMODS.find_card("j_showman") == 0 and #SMODS.find_card(gold_prize_key) > 0 and G.P_CENTERS[gold_prize_key].set == "Joker" do
			gold_prize_key = pseudorandom_element(G.GAME.capsule.gold_prizes, "capsule_prize_gold_attempt_2")
		end
		G.GAME.capsule.gold_prizes[gold_prize_key] = nil
		return {
			key = gold_prize_key,
			gold = true
		}
	end
	
	local possible_keys = { }
	for key, value in pairs(G.P_CENTERS) do
		if value.set == "Tarot" or value.set == "Planet" or value.set == "Spectral" or value.set == "Joker" then
			possible_keys[#possible_keys + 1] = key
		end
	end
	
	--remove gold prize keys, cannot_pull keys
	possible_keys = wow_that_was_so_gold(possible_keys, G.GAME.capsule.gold_prizes)
	possible_keys = wow_that_was_so_gold(possible_keys, G.GAME.capsule.cannot_pull)
	
	--if you put in more than 100 points, remove common jokers/planet cards from the pool
	if bet > 100 then
		for i = 1, #possible_keys do
			if G.P_CENTERS[possible_keys[i]].set == "Planet" or G.P_CENTERS[possible_keys[i]].rarity == 1 then
				possible_keys[i] = nil
			end
		end
	end
	
	--ensure that you cannot pull 2 prizes in a row
	if #SMODS.find_card("j_showman") == 0 then
		for i = 1, #possible_keys do
			if #SMODS.find_card(possible_keys[i]) > 0 and G.P_CENTERS[possible_keys[i]].set == "Joker" then
				possible_keys[i] = nil
			end
		end
	end
	
	return {
		key =  pseudorandom_element(possible_keys, "capsule_prize_broke_ass"),
	}
end

local function pts_button(amnt)
	return {n=G.UIT.R, config={
		align="cm",
		minw=2.4,
		colour=G.C.RED,
		func="UTDR_capsule_addpts_func",
		button="UTDR_capsule_addpts",
		emboss=.05,
		r=.1,
		padding=.1,
		amount = amnt
	},nodes={
		{n=G.UIT.T, config={colour=G.C.WHITE, scale=.4, text = SMODS.signed(amnt)..localize("utdr_points_suffix")}}
	}}
end

function Game:update_utdr_shop_capsule(dt)
	if not G.STATE_COMPLETE then
		stop_use()
		ease_background_colour_blind(G.STATES.UTDR_SHOP_CAPSULE)

		local targets = {
			"UTDR_SHOP_SIGN_CATTY",
			"buttons",
			"utdr_shop_cattybratty"
		}

		for _, v in ipairs(targets) do
			if self[v] then self[v]:remove(); self[v] = nil end
		end

		if G.shop then
			G.E_MANAGER:add_event(Event({
				trigger = 'immediate',
				func = (function()
					G.shop.alignment.offset.y = 10
					G.SHOP_SIGN.alignment.offset.y = -15
					return true
				end)
			}))
		end

		G.E_MANAGER:add_event(Event{ func = function() save_run(); return true end})
		G.STATE_COMPLETE = true
		G.CONTROLLER.interrupt.focus = true

		UTDR_Modules.Capsule.bet_amount = math.min(G.GAME.utdr_points,UTDR_Modules.Capsule.min_amount)
		
		if not G.utdr_shop_capsule then
			G.E_MANAGER:add_event(Event{ func = function()
				G.E_MANAGER:add_event(Event{
					trigger = 'immediate',
					func = function()
						play_sound('cancel')
						G.utdr_shop_capsule = UIBox{
							definition = UTDR_Modules.Capsule.create_UIBox_capsule(),
							config = {align="bmi", offset = {x=0,y=G.ROOM.T.y + 29}, major = G.hand, bond = 'Weak'}
						}
						G.ROOM.jiggle = G.ROOM.jiggle + 3
						G.CONTROLLER.lock_input = false
						G.utdr_shop_capsule.alignment.offset.y = G.ROOM.T.y + 21.4
				return true end})
			return true end})
		end
	end
end

function UTDR_Modules.Capsule.create_UIBox_capsule()
	local shop_sign = AnimatedSprite(0,0, 4.4, 4.4/119*45, G.ANIMATION_ATLAS.UTDR_shopsign_capsule)
	shop_sign:define_draw_steps({
		{shader = 'dissolve', shadow_height = 0.05},
		{shader = 'dissolve'}
	})
	G.UTDR_SHOP_SIGN_CAPSULE = UIBox{
		definition = 
			{n=G.UIT.ROOT, config = {colour = G.C.DYN_UI.MAIN, emboss = 0.05, align = 'cm', r = 0.1, padding = 0.1}, nodes={
				{n=G.UIT.R, config={align = "cm", padding = 0.1, minw = 4.72, minh = 3.1, colour = G.C.DYN_UI.DARK, r = 0.1}, nodes={
					{n=G.UIT.R, config={align = "cm"}, nodes={
						{n=G.UIT.O, config={object = shop_sign}}
					}},
					{n=G.UIT.R, config={align = "cm"}, nodes={
						{n=G.UIT.O, config={object = DynaText({string = {localize('ph_utdr_capsule')}, colours = {lighten(G.C.GOLD, 0.3)},shadow = true, rotate = true, float = true, bump = true, scale = 0.5, spacing = 1, pop_in = 1.5, maxw = 4.3})}}
					}},
				}},
			}},
		config = {
			align="cm",
			offset = {x=0,y=-15},
			major = G.HUD:get_UIE_by_ID('row_blind'),
			bond = 'Weak'
		}
	}
	G.E_MANAGER:add_event(Event({
		trigger = 'immediate',
		func = (function()
			G.UTDR_SHOP_SIGN_CAPSULE.alignment.offset.y = 0
			return true
		end)
	}))

	local capsule_spr = SMODS.create_sprite(0,0,5,156/111*5,"UTDR_shop_capsule")
	local t = {n=G.UIT.ROOT, config = {align = 'cl', colour = G.C.CLEAR}, nodes={
		UIBox_dyn_container({
			{n=G.UIT.C, config={align = "cm", padding = 0.1, emboss = 0.05, r = 0.1, colour = G.C.DYN_UI.BOSS_MAIN}, nodes={
				{n=G.UIT.C, config={align = "cm", minw = 7, padding = .4}, nodes = {
					{n=G.UIT.O, config={object = capsule_spr}}
				}},
				{n=G.UIT.C, config={align = "cm", padding = 0.05}, nodes = {
					{n=G.UIT.R, config={align = "cm", colour=G.C.GREEN, padding = 0.05}, nodes = {
						text
					}},
					
					{n=G.UIT.R, config={align = "cm", emboss = 0.05, r = 0.1, colour=G.C.L_BLACK, padding = 0.2}, nodes = {
						{n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes = {
							pts_button(50),
							pts_button(5),
							{n=G.UIT.R, config={align = "cm", emboss = 0.05, r = 0.1, colour=G.C.BLACK, padding = 0.1}, nodes = {
								{n=G.UIT.R, config={align = "cm", emboss = 0.05, r = 0.1, colour=G.C.L_BLACK, padding = 0.1}, nodes = {
									{n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes = {
										{n=G.UIT.R, config={align = "cm"}, nodes = {
											{n=G.UIT.T, config={colour=G.C.POINTS, scale=1, ref_table = UTDR_Modules.Capsule, ref_value = "bet_amount"}},
											{n=G.UIT.T, config={colour=G.C.POINTS, scale=1, text = localize("utdr_points_suffix")}},
										}},
									}},
								}},
							}},
							pts_button(-5),
							pts_button(-50),
						}},
					}},
					{n=G.UIT.R, config={align = "cm", colour=G.C.YELLOW, padding = 0.05}},

				}}
			}},
				
			--[[{n=G.UIT.R, config={align = "cm", padding = 0.05}, nodes={
				{n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
					{n=G.UIT.R,config={id = 'next_round_button', align = "cm", minw = 2.8, minh = 1.5, r=0.15,colour = G.C.RED, one_press = true, button = 'toggle_shop', hover = true,shadow = true}, nodes = {
						{n=G.UIT.R, config={align = "cm", padding = 0.07, focus_args = {button = 'y', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
							{n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
								{n=G.UIT.T, config={text = localize('b_next_round_1'), scale = 0.4, colour = G.C.WHITE, shadow = true}}
							}},
							{n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
								{n=G.UIT.T, config={text = localize('b_next_round_2'), scale = 0.4, colour = G.C.WHITE, shadow = true}}
							}}
						}},
					}},
					{n=G.UIT.R, config={align = "cm", minw = 2.8, minh = 1.6, r=0.15,colour = G.C.GREEN, button = 'reroll_shop', func = 'can_reroll', hover = true,shadow = true}, nodes = {
						{n=G.UIT.R, config={align = "cm", padding = 0.07, focus_args = {button = 'x', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
							{n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
								{n=G.UIT.T, config={text = localize('k_reroll'), scale = 0.4, colour = G.C.WHITE, shadow = true}},
							}},
							{n=G.UIT.R, config={align = "cm", maxw = 1.3, minw = 1}, nodes={
								{n=G.UIT.T, config={text = localize('$'), scale = 0.7, colour = G.C.WHITE, shadow = true}},
								{n=G.UIT.T, config={ref_table = G.GAME.current_round, ref_value = 'reroll_cost', scale = 0.75, colour = G.C.WHITE, shadow = true}},
							}}
						}}
					}},
				}},
				{n=G.UIT.C, config={align = "cm", padding = 0.2, r=0.2, colour = G.C.L_BLACK, emboss = 0.05, minw = 8.2}, nodes={
						{n=G.UIT.O, config={object = G.shop_jokers}},
				}},
			}},
			{n=G.UIT.R, config={align = "cm", minh = 0.2}, nodes={}},
			{n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
				{n=G.UIT.C, config={align = "cm", padding = 0.15, r=0.2, colour = G.C.L_BLACK, emboss = 0.05}, nodes={
					{n=G.UIT.C, config={align = "cm", padding = 0.2, r=0.2, colour = G.C.BLACK, maxh = G.shop_vouchers.T.h+0.4}, nodes={
						{n=G.UIT.T, config={text = localize{type = 'variable', key = 'ante_x_voucher', vars = {G.GAME.round_resets.ante}}, scale = 0.45, colour = G.C.L_BLACK, vert = true}},
						{n=G.UIT.O, config={object = G.shop_vouchers}},
					}},
				}},
				{n=G.UIT.C, config={align = "cm", padding = 0.15, r=0.2, colour = G.C.L_BLACK, emboss = 0.05}, nodes={
					{n=G.UIT.O, config={object = G.shop_booster}},
				}},
			}}]]
		
		}, false)
	}}
	return t
end

function G.FUNCS.UTDR_capsule_addpts_func(e)
	local target = e.config.amount + UTDR_Modules.Capsule.bet_amount
	local cantrade = target >= 0 and target <= G.GAME.utdr_points

	e.config.colour = cantrade and darken(G.C.RED, e.states.hover.is and .15 or 0) or G.C.UI.BACKGROUND_INACTIVE
	e.config.button = cantrade and 'UTDR_capsule_addpts' or nil
end

function G.FUNCS.UTDR_capsule_addpts(e)
	UTDR_Modules.Capsule.bet_amount = UTDR_Modules.Capsule.bet_amount + e.config.amount
end