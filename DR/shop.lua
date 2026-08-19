-- TO-DO LIST:
--      - State switching
--      - 

-- Run this to manually switch states
-- eval G.STATE, G.STATE_COMPLETE = G.STATES[state], false

-- Global Table for all Shop related stuff.
UTDR_Modules.Shop = {

}

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

		G.E_MANAGER:add_event(Event({
			trigger = 'immediate',
			func = (function()
				G.shop.alignment.offset.y = 10
				G.SHOP_SIGN.alignment.offset.y = -15
				return true
			end)
		}))

		G.E_MANAGER:add_event(Event{ func = function() save_run(); return true end})
		G.STATE_COMPLETE = true
		G.CONTROLLER.interrupt.focus = true
		
		G.E_MANAGER:add_event(Event{ func = function()
			G.E_MANAGER:add_event(Event{
				trigger = 'immediate',
				func = function()
					play_sound('cancel')
					G.utdr_shop_capsule = UIBox{
						definition = UTDR_Modules.Shop.create_UIBox_capsule(),
						config = {align="bmi", offset = {x=0,y=G.ROOM.T.y + 29}, major = G.hand, bond = 'Weak'}
					}
					G.ROOM.jiggle = G.ROOM.jiggle + 3
					G.CONTROLLER.lock_input = false
					for i = 1, #G.GAME.tags do
						G.GAME.tags[i]:apply_to_run({type = 'immediate'})
					end
			return true end})
		return true end})
	end
end

function Game:update_utdr_shop_cattybratty(dt)
	if not G.STATE_COMPLETE then
		stop_use()
		ease_background_colour_blind(G.STATES.UTDR_SHOP_CATTYBRATTY)

		local targets = {
			"UTDR_SHOP_SIGN_CAPSULE",
			"buttons",
			"utdr_shop_capsule"
		}

		for _, v in ipairs(targets) do
			if self[v] then self[v]:remove(); self[v] = nil end
		end

		G.E_MANAGER:add_event(Event({
			trigger = 'immediate',
			func = (function()
				G.shop.alignment.offset.y = 10
				G.SHOP_SIGN.alignment.offset.y = -15
				return true
			end)
		}))

		G.E_MANAGER:add_event(Event{ func = function() save_run(); return true end})
		G.STATE_COMPLETE = true
		G.CONTROLLER.interrupt.focus = true
		
		G.E_MANAGER:add_event(Event{ func = function()
			G.E_MANAGER:add_event(Event{
				trigger = 'immediate',
				func = function()
					play_sound('cancel')
					G.utdr_shop_cattybratty = UIBox{
						definition = UTDR_Modules.Shop.create_UIBox_cattybratty(),
						config = {align="bmi", offset = {x=0,y=G.ROOM.T.y + 29}, major = G.hand, bond = 'Weak'}
					}
					G.ROOM.jiggle = G.ROOM.jiggle + 3
					G.CONTROLLER.lock_input = false
					for i = 1, #G.GAME.tags do
						G.GAME.tags[i]:apply_to_run({type = 'immediate'})
					end
			return true end})
		return true end})
	end
end

function UTDR_Modules.Shop.create_UIBox_capsule()
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

	local t = {n=G.UIT.ROOT, config = {align = 'cl', colour = G.C.CLEAR}, nodes={
		UIBox_dyn_container({
			{n=G.UIT.C, config={align = "cm", padding = 0.1, emboss = 0.05, r = 0.1, colour = G.C.DYN_UI.BOSS_MAIN}, nodes={
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
			}
		},
		
		}, false)
	}}
	return t
end
function UTDR_Modules.Shop.create_UIBox_cattybratty()
	local shop_sign = Sprite(0,0, 4.4, 2.2, G.ASSET_ATLAS.UTDR_shopsign_cattybratty)
	shop_sign:define_draw_steps({
		{shader = 'dissolve', shadow_height = 0.05},
		{shader = 'dissolve'}
	})
	G.UTDR_SHOP_SIGN_CATTY = UIBox{
		definition = 
			{n=G.UIT.ROOT, config = {colour = G.C.DYN_UI.MAIN, emboss = 0.05, align = 'cm', r = 0.1, padding = 0.1}, nodes={
				{n=G.UIT.R, config={align = "cm", padding = 0.1, minw = 4.72, minh = 3.1, colour = G.C.DYN_UI.DARK, r = 0.1}, nodes={
					{n=G.UIT.R, config={align = "cm"}, nodes={
						{n=G.UIT.O, config={object = shop_sign}}
					}},
					{n=G.UIT.R, config={align = "cm"}, nodes={
						{n=G.UIT.O, config={object = DynaText({string = {localize('ph_utdr_cattybratty')}, colours = {lighten(G.C.GOLD, 0.3)},shadow = true, rotate = true, float = true, bump = true, scale = 0.5, spacing = 1, pop_in = 1.5, maxw = 4.3})}}
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
			G.UTDR_SHOP_SIGN_CATTY.alignment.offset.y = 0
			return true
		end)
	}))

	local t = {n=G.UIT.ROOT, config = {align = 'cl', colour = G.C.CLEAR}, nodes={
		UIBox_dyn_container({
			{n=G.UIT.C, config={align = "cm", padding = 0.1, emboss = 0.05, r = 0.1, colour = G.C.DYN_UI.BOSS_MAIN}, nodes={
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
			}
		},
		
		}, false)
	}}
	return t
end

local update_shop_hook = Game.update_shop
function Game:update_shop(dt)
	if not G.STATE_COMPLETE then
		if G.SHOP_SIGN then
			G.E_MANAGER:add_event(Event({
				trigger = 'immediate',
				func = (function()
					G.SHOP_SIGN.alignment.offset.y = 0
					return true
				end)
			}))
		end
		
		local targets = {
			"UTDR_SHOP_SIGN_CATTY",
			"UTDR_SHOP_SIGN_CAPSULE",
			"utdr_shop_cattybratty",
			"utdr_shop_capsule",
		}

		for _, v in ipairs(targets) do
			if self[v] then self[v]:remove(); self[v] = nil end
		end
	end
	update_shop_hook(self,dt)
end

-- handles state-related bg/ui color changes
local ease_background_colour_blind_hook = ease_background_colour_blind
function ease_background_colour_blind(state, blind_override, ...)
	if state == G.STATES.UTDR_SHOP_CAPSULE then
		ease_colour(G.C.DYN_UI.MAIN, HEX("ffd601"))
		ease_background_colour{new_colour = HEX("42d4a3"), special_colour = HEX("799f97"), contrast = 3}
	elseif state == G.STATES.UTDR_SHOP_CATTYBRATTY then
		ease_colour(G.C.DYN_UI.MAIN, HEX("dc8df0"))
		ease_background_colour{new_colour = G.C.PURPLE, special_colour = G.C.L_BLACK, contrast = 3}
	else
		ease_background_colour_blind_hook(state, blind_override, ...)
	end
end