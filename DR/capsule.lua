UTDR_Modules.Capsule = {
	points_bet_total = 0,
	gold_chance_percent = "5%",
	
	bet_amount = 0,
	min_amount = 50,
	
	possible_keys_jokers = { },
	possible_keys_tarot = { },
	possible_keys_planet = { },
	possible_keys_spectral = { },
	was_gold_prize = false,
	
	cannot_pull = {
		"j_UTDR_thorn_ring",
		"j_UTDR_shelter",
		"j_UTDR_vessel",
		"j_UTDR_weird_deard_gaster",
		"j_UTDR_survey_program",
		"j_UTDR_fun_value",
		"j_UTDR_chara",
		"j_UTDR_eram",
		"j_UTDR_undyne_the_undying",
		"j_UTDR_lacquer_triangle",
		"j_UTDR_real_knife",
	}
}

function Game:update_UTDR_shop_capsule(dt)
	if not G.STATE_COMPLETE then
		stop_use()
		ease_background_colour_blind(G.STATES.UTDR_SHOP_CAPSULE)

		local targets = {
			"UTDR_SHOP_SIGN_CATTY",
			"UTDR_SHOP_SIGN_LACQUER",
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
		G.CONTROLLER.interrupt.focus = true

		UTDR_Modules.Capsule.bet_amount = math.min(G.GAME.UTDR_points,UTDR_Modules.Capsule.min_amount)
		
		--if not G.UTDR_shop_capsule then
			G.E_MANAGER:add_event(Event{ func = function()
				G.E_MANAGER:add_event(Event{
					trigger = 'immediate',
					func = function()
						play_sound('cancel')
						G.UTDR_shop_capsule = UIBox{
							definition = UTDR_Modules.Capsule.create_UIBox_capsule(),
							config = {align="bmi", offset = {x=0,y=G.ROOM.T.y + 29.25}, major = G.hand, bond = 'Weak'}
						}
						G.ROOM.jiggle = G.ROOM.jiggle + 3
						G.CONTROLLER.lock_input = false
						-- for some reason it's slightly different from G.SHOP's 21.4 to get to the same height
						G.UTDR_shop_capsule.alignment.offset.y = G.ROOM.T.y + 21.55
				return true end})
			return true end})
		--end
	end
	
	G.STATE_COMPLETE = true
end

function UTDR_Modules.Capsule.gold_chance(bet, no_modify)
	local remaining = #G.GAME.UTDR_capsule_gold_prizes
	
	if remaining == 0 then
		return 0
	end
	
	local remaining_block = 0.1 + (remaining / 50)
	local oldbet_block = 1 + (UTDR_Modules.Capsule.points_bet_total / 50)

	local chance = 0.000004 * (UTDR_Modules.Capsule.points_bet_total + 50) * (0.002 * UTDR_Modules.Capsule.total_gold_prizes * #G.GAME.UTDR_capsule_gold_prizes + 5) * (bet - 100) + 0.05
	--local chance = (((5 + #G.GAME.UTDR_capsule_gold_prizes) * (50 + UTDR_Modules.Capsule.points_bet_total) + 250) / 5000 + bet) / 10
	
	if chance == -0.05 then
		chance = 0.05
	end
	
	chance = chance * 100
	
	if not no_modify then
		UTDR_Modules.Capsule.points_bet_total = UTDR_Modules.Capsule.points_bet_total + bet
	end
	
	local integer = chance + (2^52 + 2^51) - (2^52 + 2^51)
	
	local above_zero = math.max(integer, 0) --make sure we don't have a negative percentage. oops
	
	return math.min(above_zero, 100)
end

--filters tables. provide 2 tables, removes all keys present in table 2 from table 1
function UTDR_Modules.Capsule.wow_that_was_so_gold(input, filter)
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

function UTDR_Modules.Capsule.set_goldpercent_text()
	UTDR_Modules.Capsule.gold_chance_percent = tostring(UTDR_Modules.Capsule.gold_chance(UTDR_Modules.Capsule.bet_amount, true)) .. localize("UTDR_shopball_chance0")
end

function UTDR_Modules.Capsule.get_reward(bet)
	UTDR_Modules.Capsule.was_gold_prize = false
	UTDR_Modules.Capsule.gold_chance_percent = tostring(UTDR_Modules.Capsule.gold_chance(bet, true)) .. localize("UTDR_shopball_chance0")

	if bet == 1225 then
		return {
			december = true			
		}
	elseif pseudorandom("capsule_gold") < (UTDR_Modules.Capsule.gold_chance(bet) / 100) then
		
		UTDR_Modules.Capsule.points_bet_total = 0
		
		return "p_UTDR_capsule_gold"
	end
	
	local possible_keys = { }
	
	UTDR_Modules.Capsule.possible_keys_jokers = { }
	UTDR_Modules.Capsule.possible_keys_tarot = { }
	UTDR_Modules.Capsule.possible_keys_planet = { }
	UTDR_Modules.Capsule.possible_keys_spectral = { }
	for key, value in pairs(G.P_CENTERS) do
		if value.set == "Joker" then
			UTDR_Modules.Capsule.possible_keys_jokers[#UTDR_Modules.Capsule.possible_keys_jokers + 1] = key
		elseif value.set == "Tarot" then
			UTDR_Modules.Capsule.possible_keys_tarot[#UTDR_Modules.Capsule.possible_keys_tarot + 1] = key
		elseif value.set == "Planet" then
			UTDR_Modules.Capsule.possible_keys_planet[#UTDR_Modules.Capsule.possible_keys_planet + 1] = key
		elseif value.set == "Spectral" then
			UTDR_Modules.Capsule.possible_keys_spectral[#UTDR_Modules.Capsule.possible_keys_spectral + 1] = key
		end
	end
	
	--remove gold prize keys, cannot_pull keys
	UTDR_Modules.Capsule.possible_keys_jokers = UTDR_Modules.Capsule.wow_that_was_so_gold(UTDR_Modules.Capsule.possible_keys_jokers, G.GAME.UTDR_capsule_gold_prizes)
	UTDR_Modules.Capsule.possible_keys_spectral = UTDR_Modules.Capsule.wow_that_was_so_gold(UTDR_Modules.Capsule.possible_keys_spectral, G.GAME.UTDR_capsule_gold_prizes)
	
	UTDR_Modules.Capsule.possible_keys_jokers = UTDR_Modules.Capsule.wow_that_was_so_gold(UTDR_Modules.Capsule.possible_keys_jokers,UTDR_Modules.Capsule.cannot_pull)
	
	--if you put in more than 100 points, remove common jokers/planet cards from the pool
	if bet >= 100 then
		UTDR_Modules.Capsule.possible_keys_tarot = {
			"c_fool",
			"c_emperor",
			"c_hermit",
			"c_hanged_man",
			"c_death",
			"c_temperance",
			"c_judgement"        
		}
	end
	
	if bet >= 200 then
		for i = 1, #UTDR_Modules.Capsule.possible_keys_jokers do
			local key = UTDR_Modules.Capsule.possible_keys_jokers[i]
			local center = G.P_CENTERS[UTDR_Modules.Capsule.possible_keys_jokers[i]] or { rarity = "fuck" }
			local rarity = center.rarity or nil
			if rarity == 1 then
				table.remove(UTDR_Modules.Capsule.possible_keys_jokers, i)
			end
		end
	end
	
	--ensure that you cannot pull 2 prizes in a row
	if #SMODS.find_card("j_showman") == 0 then
		for i = 1, #UTDR_Modules.Capsule.possible_keys_jokers do
			if #SMODS.find_card(UTDR_Modules.Capsule.possible_keys_jokers[i]) > 0 and G.P_CENTERS[UTDR_Modules.Capsule.possible_keys_jokers[i]].set == "Joker" then
				table.remove(UTDR_Modules.Capsule.possible_keys_jokers, i)
			end
		end
	end
	
	local winning_set = ""
	print(winning_set)
	if bet < 100 then
		winning_set = pseudorandom_element({
			"p_UTDR_capsule_joker",
			"p_UTDR_capsule_tarot",
			"p_UTDR_capsule_planet",
			"p_UTDR_capsule_spectral",
		}, "capsule_prize_set_super_broke_ass")
	else
		pseudorandom_element({
			"p_UTDR_capsule_joker",
			"p_UTDR_capsule_tarot",
			"p_UTDR_capsule_spectral",
		}, "capsule_prize_set_broke_ass")
	end
	print(winning_set)
	
	return winning_set
end

local function add_pts_button(amnt)
	return {n=G.UIT.R, config={
		align="cm",
		minw=3,
		colour=G.C.RED,
		func="UTDR_capsule_deltapts_func",
		button="UTDR_capsule_deltapts",
		emboss=.05,
		r=.1,
		padding=.1,
		amount = amnt
	},nodes={
		{n=G.UIT.T, config={colour=G.C.WHITE, scale=.4, text = SMODS.signed(amnt)..localize("utdr_points_suffix")}}
	}}
end

local function remove_pts_button(amnt)
	return {n=G.UIT.R, config={
		align="cm",
		minw=3,
		colour=G.C.RED,
		func="UTDR_capsule_deltapts_func",
		button="UTDR_capsule_deltapts",
		emboss=.05,
		r=.1,
		padding=.1,
		amount = amnt
	},nodes={
		{n=G.UIT.T, config={colour=G.C.WHITE, scale=.4, text = SMODS.signed(amnt)..localize("utdr_points_suffix")}}
	}}
end

function UTDR_Modules.Capsule.create_UIBox_capsule()
	local shop_sign = AnimatedSprite(0,0, 4.4, 4.4/119*45, G.ANIMATION_ATLAS.UTDR_shopsign_capsule)
	shop_sign:define_draw_steps({
		{shader = 'dissolve', shadow_height = 0.05},
		{shader = 'dissolve'}
	})
	G.UTDR_SHOP_SIGN_CAPSULE = UIBox{
		definition = 
			{n=G.UIT.ROOT, config = {id = "UTDR_shop_capsule", colour = G.C.DYN_UI.MAIN, emboss = 0.05, align = 'cm', r = 0.1, padding = 0.1}, nodes={
				{n=G.UIT.R, config={align = "cm", padding = 0.1, minw = 4.72, minh = 3.1, colour = G.C.DYN_UI.DARK, r = 0.1}, nodes={
					{n=G.UIT.R, config={align = "cm"}, nodes={
						{n=G.UIT.O, config={object = shop_sign}}
					}},
					{n=G.UIT.R, config={align = "cm"}, nodes={
						{n=G.UIT.O, config={object = DynaText({string = {localize('ph_utdr_capsule')}, colours = { lighten(G.C.DYN_UI.MAIN, 0.3) },shadow = true, rotate = true, float = true, bump = true, scale = 0.5, spacing = 1, maxw = 4.3})}}
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

	local t = {n=G.UIT.ROOT, config = {align = 'cl', colour = G.C.CLEAR}, nodes={
		UIBox_dyn_container({
			{n=G.UIT.C, config={align = "cm", padding = 0.1, emboss = 0.05, r = 0.1, colour = G.C.DYN_UI.BOSS_MAIN}, nodes={
				{n=G.UIT.C, config={align = "cr", minw = 6.5, padding = .4}, nodes = {
					{n=G.UIT.O, config={object = SMODS.create_sprite(0,0,5,156/111*5,"UTDR_shop_capsule"), colour = G.C.BALLGAME }},
				}},
				{n=G.UIT.C, config={align = "cm", padding = 0.05}, nodes = {
					{n=G.UIT.R, config={align = "cm", colour=G.C.CLEAR, padding = 0.05}, nodes = {
						{n=G.UIT.R, config={align = "cm"}, nodes = {
							{n=G.UIT.O,config={object=DynaText({ string = {{ref_table = UTDR_Modules.Capsule, ref_value = "gold_chance_percent", colour = G.C.GOLD}}, float = true, colours = { G.C.GOLD }, pop_in = 0, pop_in_rate = 3, spacing = 1, scale = .5, maxw=4 })}},
							{n=G.UIT.O,config={object=DynaText({ string = localize("UTDR_shopball_chance1"), float = true, colours = { G.C.POINTS }, pop_in = 0, pop_in_rate = 3, spacing = 1, scale = .5, maxw=4 })}},
						}},
						{n=G.UIT.R, config={align="cm"},nodes={{n=G.UIT.O,config={object=DynaText({ string = localize("UTDR_shopball_chance2"), float = true, colours = { G.C.POINTS }, pop_in = 0, pop_in_rate = 3, spacing = 1, scale = .5, maxw=4 })}}}},
					}},
					
					{n=G.UIT.R, config={align = "cm", minw=4,emboss = 0.05, r = 0.1, colour=G.C.L_BLACK, padding = 0.2}, nodes = {
						{n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes = {
							{n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes = {
								add_pts_button(50),
								add_pts_button(5),
							}},
							{n=G.UIT.R, config={align = "cm", minw=3, maxw=3, emboss = 0.05, r = 0.1, colour=G.C.BLACK, padding = 0.1}, nodes = {
								{n=G.UIT.R, config={align = "cm", minw=3, emboss = 0.05, r = 0.1, colour=G.C.L_BLACK, padding = 0.1}, nodes = {
									{n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes = {
										{n=G.UIT.R, config={align = "cm"}, nodes = {
											{n=G.UIT.T, config={colour=G.C.POINTS, scale=1, ref_table = UTDR_Modules.Capsule, ref_value = "bet_amount", shadow = true}},
											{n=G.UIT.T, config={colour=G.C.POINTS, scale=1, shadow = true, text = localize("utdr_points_suffix")}},
										}},
									}},
								}},
							}},
							{n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes = {
								remove_pts_button(-5),
								remove_pts_button(-50),
							}},
						}},
					}},
					
					{n=G.UIT.R, config={
						align="cm",
						minw=2.4,
						colour=G.C.RED,
						func="UTDR_capsule_trade_func",
						button="UTDR_capsule_trade",
						emboss=.05,
						r=.1,
						padding=.1,
					},nodes = {
						{n = G.UIT.T, config = {colour=G.C.WHITE, scale=.6, text = localize("UTDR_shopball_trade")}}
					}}
				}}
			}},
		}, false)
	}}
	return t
end

function G.FUNCS.UTDR_capsule_deltapts_func(e)
	local target = UTDR_Modules.Capsule.bet_amount + e.config.amount
	local valid_result = G.GAME.UTDR_points >= target
	
	local can_press = (valid_result or e.config.amount <= 0) and target >= 0

	e.config.colour = can_press and darken(G.C.RED, e.states.hover.is and .15 or 0) or G.C.UI.BACKGROUND_INACTIVE
	e.config.button = can_press and 'UTDR_capsule_deltapts' or nil
end

function G.FUNCS.UTDR_capsule_deltapts(e)
	UTDR_Modules.Capsule.bet_amount = UTDR_Modules.Capsule.bet_amount + e.config.amount
	UTDR_Modules.Capsule.set_goldpercent_text()
end

function G.FUNCS.UTDR_capsule_trade_func(e)
	local can_trade = UTDR_Modules.Capsule.bet_amount >= UTDR_Modules.Capsule.min_amount and G.GAME.UTDR_points >= UTDR_Modules.Capsule.bet_amount

	e.config.colour = can_trade and darken(G.C.ORANGE, e.states.hover.is and .15 or 0) or G.C.UI.BACKGROUND_INACTIVE
	e.config.button = can_trade and 'UTDR_capsule_trade' or nil
end

function G.FUNCS.UTDR_capsule_trade(e)
	local reward = UTDR_Modules.Capsule.get_reward(UTDR_Modules.Capsule.bet_amount)
	
	if reward.december and G.GAME.UTDR_lacquer_script_step == 0 then
		ease_background_colour { new_colour = G.C.LACQUER, contrast = 1 }
		G.E_MANAGER:add_event(Event({
			func = function()
				G.STATE = G.STATES.UTDR_SHOP_LACQUER
				G.STATE_COMPLETE = false
				return true
			end
		}))
	else
		local bet_amount = UTDR_Modules.Capsule.bet_amount
		if bet_amount >= 1000 then
			play_sound("UTDR_points20", 1.0, 0.67)
		elseif bet_amount >= 500 then
			play_sound("UTDR_points20", 1.0, 0.67)
		elseif bet_amount >= 200 then
			play_sound("UTDR_points10", 1.0, 0.67)
		elseif bet_amount >= 100 then
			play_sound("UTDR_points6", 1.0, 0.67)
		else
			play_sound("UTDR_points4", 1.0, 0.67)
		end
		
		UTDR_Modules.Capsule.ease_points(-bet_amount)
		
		--the actual card's only job is to create the booster UI lmao. get yo sprite out of here!!!!
		G.pack_cards = CardArea(
			G.ROOM.T.x + 9 + G.hand.T.x, G.hand.T.y,
			G.CARD_W*1.1,
			1.05*G.CARD_H,
			{card_limit = 1, type = 'consumeable', highlight_limit = 1, negative_info = true}
		)
		
		local pack = SMODS.create_card({
			key = reward
		})
		pack.children.center.states.visible = false
		
		local scale_factor = 1.4
		pack.capsule = {}
		pack.capsule.bottom = SMODS.create_sprite(pack.T.x, pack.T.y, G.CARD_W * scale_factor, G.CARD_H * scale_factor, "UTDR_shop_capsule_ball", { x = 5, y = 0 })
		pack.capsule.top = SMODS.create_sprite(pack.T.x, pack.T.y, G.CARD_W * scale_factor , G.CARD_H * scale_factor, "UTDR_shop_capsule_ball", { x = 4, y = 0 })
		
		G.E_MANAGER:add_event(Event({
			func = function()
				pack:capsule_open()
				return true
			end
		}))
	end
end
	
