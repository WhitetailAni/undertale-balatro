UTDR_Modules.Capsule = {
	points_bet_total = 0,
	gold_chance_percent = "5%",
	
	bet_amount = 0,
	min_amount = 50,
	
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
		UTDR_Modules.Capsule.set_goldpercent_text()
	
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
		
		SMODS.calculate_context({ UTDR_capsule_start = true })
		G.STATE_COMPLETE = true
	end
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
	if not G.UTDR_SHOP_SIGN_CAPSULE then
		G.UTDR_SHOP_SIGN_CAPSULE = UIBox{
			definition = 
				{n=G.UIT.ROOT, config = {id = "UTDR_shop_capsule", colour = G.C.DYN_UI.MAIN, emboss = 0.05, align = 'cm', r = 0.1, padding = 0.1}, nodes={
					{n=G.UIT.R, config={align = "cm", padding = 0.1, minw = 4.72, minh = 3.1, colour = G.C.DYN_UI.DARK, r = 0.1}, nodes={
						{n=G.UIT.R, config={align = "cm"}, nodes={
							{n=G.UIT.O, config={object = shop_sign}}
						}},
						{n=G.UIT.R, config={align = "cm"}, nodes={
							{n=G.UIT.O, config={object = DynaText({string = {localize('ph_utdr_capsule')}, colours = { HEX('FFE664') },shadow = true, rotate = true, float = true, bump = true, scale = 0.5, spacing = 1, pop_in = 1.5, maxw = 4.3})}}
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
	end
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
					{n=G.UIT.O, config={object = SMODS.create_sprite(0,0,5,156/111*5,"UTDR_shop_capsule") }},
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

function UTDR_Modules.Capsule.gold_chance(bet, no_modify)
	local remaining = #G.GAME.UTDR_capsule_gold_prizes_voucher +  #G.GAME.UTDR_capsule_gold_prizes_nonvoucher
	
	if remaining == 0 then
		return 0
	end
	
	local remaining_block = 0.1 + (remaining / 50)
	local oldbet_block = 1 + (UTDR_Modules.Capsule.points_bet_total / 50)

	local chance = 0.000004 * (UTDR_Modules.Capsule.points_bet_total + 50) * (0.002 * UTDR_Modules.Capsule.total_gold_prizes * (#G.GAME.UTDR_capsule_gold_prizes_voucher +  #G.GAME.UTDR_capsule_gold_prizes_nonvoucher) + 5) * (bet - 100) + 0.05
	--local chance = (((5 + #G.GAME.UTDR_capsule_gold_prizes) * (50 + UTDR_Modules.Capsule.points_bet_total) + 250) / 5000 + bet) / 10
	
	chance = chance * 100
	
	if not no_modify then
		UTDR_Modules.Capsule.points_bet_total = UTDR_Modules.Capsule.points_bet_total + bet
	end
	
	local found_tag = nil
	for i = 1, #G.GAME.tags do
		if G.GAME.tags[i].key == "tag_UTDR_capsule" then
			found_tag = G.GAME.tags[i]
		end
	end
	
	local integer = chance + (2^52 + 2^51) - (2^52 + 2^51)
	
	local above_zero = math.max(integer, 5) --make sure we don't have a negative percentage. oops
	--also ensures gold chance is always at least 5%, since in deltarune it's always at least 5%
	
	local chance = math.min(above_zero, 100)
	
	if #SMODS.find_card("j_UTDR_lacquer_triangle") > 0 and bet >= 300 then
		chance = 100
	end
	if found_tag then
		chance = 100
	end
	
	SMODS.calculate_context({ UTDR_capsule_gold_chance = true, chance = chance })
	return chance
end

--filters tables. provide 2 tables, removes all keys present in table 2 from table 1
function UTDR_Modules.Capsule.wow_that_was_so_gold(input, filter)
	if not filter then return input end
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
		
		for i = 1, #G.GAME.tags do
			if G.GAME.tags[i].key == "tag_UTDR_capsule" then
				G.GAME.tags[i]:yep("+", G.C.GOLD)
				G.GAME.tags[i].triggered = true
				break
			end
		end
		
		return {
			key = "p_UTDR_capsule_gold",
			gold = true
		}
	end
	
	local winning_set = ""
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
	
	return { key = winning_set }
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
	local cant_use = (G.GAME.STOP_USE and G.GAME.STOP_USE > 0)
	local can_trade = UTDR_Modules.Capsule.bet_amount >= UTDR_Modules.Capsule.min_amount and G.GAME.UTDR_points >= UTDR_Modules.Capsule.bet_amount and not cant_use

	e.config.colour = can_trade and darken(G.C.ORANGE, e.states.hover.is and .15 or 0) or G.C.UI.BACKGROUND_INACTIVE
	e.config.button = can_trade and 'UTDR_capsule_trade' or nil
end

function G.FUNCS.UTDR_capsule_trade(e)
	stop_use()

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
		SMODS.calculate_context({ UTDR_capsule_reward = true, is_gold = reward.gold })
	
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
			key = reward.key
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
	
