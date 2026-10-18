UTDR_Modules.Shop_Tabs = {	
}

Game.update_UTDR_shop_tabs = function()
	if G.UTDR_shop_tabs then
		G.UTDR_shop_tabs.alignment.offset.y = G.ROOM.T.y + 11.4
	end
	if not G.STATE_COMPLETE then
		stop_use()
	
		if not G.UTDR_shop_tabs then
			G.E_MANAGER:add_event(Event{
				trigger = 'after',
				delay = 0.2,
				func = function()
					play_sound('cancel')
					
					local xOffset = 14.6
					if G.SETTINGS.GRAPHICS.texture_scaling == 2 then
						xOffset = 15
					end
					
					G.UTDR_shop_tabs = UIBox{
						definition = UTDR_Modules.Shop_Tabs.create_shop_tabs("DR"),
						config = {align="cl", offset = {x=G.ROOM.T.x + xOffset,y=G.ROOM.T.y + 30}, major = G.ROOM_ATTACH, bond = 'Weak'}
					}
					
					local remove_hook = G.UTDR_shop_tabs.remove
					function remove(self)
						G.UTDR_shop_tabs.alignment.offset.y = G.shop.alignment.offset.y + 10
						remove_hook(self)
					end
					
					-- Move shop tabs to start of uibox list
					for i, v in ipairs(G.I.UIBOX) do
						if v == G.UTDR_shop_tabs then
							table.remove(G.I.UIBOX,i)
							table.insert(G.I.UIBOX,1,G.UTDR_shop_tabs)
							break
						end
					end
			return true end})
		end
	end
end


UTDR_Modules.Shop_Tabs.create_shop_tabs = function(mod_state)
	--dont forget we need to disable catty bratty/ball machin for different mod states!
	local config = UTDR_Modules.UTDR_config
	--could i have done this better SURE!! but this works. and thats my criteria. it works
	local ut = {n=G.UIT.ROOT, config = {align = 'cl', colour = G.C.CLEAR}, nodes={
    		UIBox_dyn_container({
            	{n=G.UIT.R, config={align = "cm", padding = 0.1, minw = 5.0}, nodes={
					{n=G.UIT.C,config={align = "cm", minw = 4.725, minh = 0.5, r=0.15,colour = G.C.RED, button = 'UTDR_shop_button', hover = true,shadow = true, state = "SHOP"}, nodes = {
					  {n=G.UIT.R, config={align = "cm", padding = 0.07, focus_args = {button = 'y', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
						{n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
							{n=G.UIT.O, config={object = SMODS.create_sprite(0, 0, 0.4, 0.4, "UTDR_shop_icons", { x = 0, y = 0 }) }},
							{n=G.UIT.B, config={h = 0.01, w = 0.03 }},
						  	{n=G.UIT.T, config={text = localize('s_UTDR_shop'), scale = 0.4, colour = G.C.WHITE, shadow = true}}
						}},
					  }},              
					}},
					{n=G.UIT.C, config={align = "cm", minw = 4.725, minh = 0.5, r=0.15,colour = HEX('d789c7'), button = 'UTDR_shop_button', hover = true,shadow = true, state = "UTDR_SHOP_CATTYBRATTY"}, nodes = {
					  {n=G.UIT.R, config={align = "cm", padding = 0.07, focus_args = {button = 'x', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
						{n=G.UIT.R, config={align = "cm", minw = 1.3}, nodes={
							{n=G.UIT.O, config={object = SMODS.create_sprite(0, 0, 0.4, 0.4, "UTDR_shop_icons", { x = 2, y = 0 }) }},
							{n=G.UIT.B, config={h = 0.01, w = 0.03 }},
						  	{n=G.UIT.T, config={text = localize('s_UTDR_cattybratty'), scale = 0.4, colour = G.C.WHITE, shadow = true}},
						}},
					  }}
					}},
				  }
				},
            }, false)
        }}
        
        local dr = {n=G.UIT.ROOT, config = {align = 'cl', colour = G.C.CLEAR}, nodes={
    		UIBox_dyn_container({
            	{n=G.UIT.R, config={align = "cm", padding = 0.1, minw = 5.0}, nodes={
					{n=G.UIT.C,config={align = "cm", minw = 4.725, minh = 0.5, r=0.15,colour = G.C.RED, button = 'UTDR_shop_button', hover = true,shadow = true, state = "SHOP"}, nodes = {
					  {n=G.UIT.R, config={align = "cm", padding = 0.07, focus_args = {button = 'y', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
						{n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
							{n=G.UIT.O, config={object = SMODS.create_sprite(0, 0, 0.4, 0.4, "UTDR_shop_icons", { x = 0, y = 0 }) }},
							{n=G.UIT.B, config={h = 0.01, w = 0.03 }},
						  	{n=G.UIT.T, config={text = localize('s_UTDR_shop'), scale = 0.4, colour = G.C.WHITE, shadow = true}}
						}},
					  }},              
					}},
					{n=G.UIT.C, config={align = "cm", minw = 4.725, minh = 0.5, r=0.15,colour = HEX('68bc9a'), button = 'UTDR_shop_button', hover = true,shadow = true, state = "UTDR_SHOP_CAPSULE"}, nodes = {
					  {n=G.UIT.R, config={align = "cm", padding = 0.07, focus_args = {button = 'x', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
						{n=G.UIT.R, config={align = "cm", minw = 1.3}, nodes={
							{n=G.UIT.O, config={object = SMODS.create_sprite(0, 0, 0.4, 0.4, "UTDR_shop_icons", { x = 1, y = 0 }) }},
							{n=G.UIT.B, config={h = 0.01, w = 0.07 }},
						  	{n=G.UIT.T, config={text = localize('s_UTDR_ball'), scale = 0.4, colour = G.C.WHITE, shadow = true}},
						}},
					  }}
					}},
				  }
				},
            }, false)
        }}
	
	local utdr = {n=G.UIT.ROOT, config = {align = 'cl', colour = G.C.CLEAR}, nodes={
    		UIBox_dyn_container({
            	{n=G.UIT.R, config={align = "cm", padding = 0.1, minw = 5.0}, nodes={
					{n=G.UIT.C,config={align = "cm", minw = 3.15, minh = 0.5, r=0.15,colour = G.C.RED, button = 'UTDR_shop_button', hover = true,shadow = true, state = "SHOP"}, nodes = {
					  {n=G.UIT.R, config={align = "cm", padding = 0.07, focus_args = {button = 'y', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
						{n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
							{n=G.UIT.O, config={object = SMODS.create_sprite(0, 0, 0.4, 0.4, "UTDR_shop_icons", { x = 0, y = 0 }) }},
							{n=G.UIT.B, config={h = 0.01, w = 0.03 }},
						  	{n=G.UIT.T, config={text = localize('s_UTDR_shop'), scale = 0.4, colour = G.C.WHITE, shadow = true}}
						}},
					  }},              
					}},
					{n=G.UIT.C, config={align = "cm", minw = 3.15, minh = 0.5, r=0.15,colour = HEX('d789c7'), button = 'UTDR_shop_button', hover = true,shadow = true, state = "UTDR_SHOP_CATTYBRATTY"}, nodes = {
					  {n=G.UIT.R, config={align = "cm", padding = 0.07, focus_args = {button = 'x', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
						{n=G.UIT.R, config={align = "cm", minw = 1.3}, nodes={
							{n=G.UIT.O, config={object = SMODS.create_sprite(0, 0, 0.4, 0.4, "UTDR_shop_icons", { x = 2, y = 0 }) }},
							{n=G.UIT.B, config={h = 0.01, w = 0.03 }},
						  	{n=G.UIT.T, config={text = localize('s_UTDR_cattybratty'), scale = 0.4, colour = G.C.WHITE, shadow = true}},
						}},
					  }}
					}},
					{n=G.UIT.C, config={align = "cm", minw = 3.15, minh = 0.5, r=0.15,colour = HEX('68bc9a'), button = 'UTDR_shop_button', hover = true,shadow = true, state = "UTDR_SHOP_CAPSULE"}, nodes = {
					  {n=G.UIT.R, config={align = "cm", padding = 0.07, focus_args = {button = 'x', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
						{n=G.UIT.R, config={align = "cm", minw = 1.3}, nodes={
							{n=G.UIT.O, config={object = SMODS.create_sprite(0, 0, 0.4, 0.4, "UTDR_shop_icons", { x = 1, y = 0 }) }},
							{n=G.UIT.B, config={h = 0.01, w = 0.07 }},
						  	{n=G.UIT.T, config={text = localize('s_UTDR_ball'), scale = 0.4, colour = G.C.WHITE, shadow = true}},
						}},
					  }}
					}},
				  }
				},
            }, false)
        }}
    if config.undertale and not config.deltarune then
    	return ut
    elseif config.deltarune and not config.undertale then
    	return dr
    end
    return utdr
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
			"UTDR_SHOP_SIGN_LACQUER",
			"utdr_shop_cattybratty",
			"UTDR_shop_capsule",
		}

		for _, v in ipairs(targets) do
			if self[v] then
				self[v]:remove(); self[v] = nil
			end
		end
	end
	update_shop_hook(self, dt)
end

G.FUNCS.UTDR_shop_button = function(e)
	if G.STATE ~= G.STATES[e.config.state] then
		G.E_MANAGER:add_event(Event({
			func = function()
				if G.STATE ~= G.STATES.UTDR_SHOP_CATTYBRATTY then
					G.UTDR_CATTY_BRATTY_MAIN_SPRITE = nil
					G.UTDR_CATTY_ARM_SPRITE = nil
					G.UTDR_BRATTY_ARM_SPRITE = nil
				end
				G.STATE = G.STATES[e.config.state]
				G.STATE_COMPLETE = false
				return true
			end
		}))
	end
end