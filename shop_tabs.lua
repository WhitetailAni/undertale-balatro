UTDR_Modules.Shop_Tabs = {
	old_volume = 0,
	
}

Game.update_UTDR_shop_tabs = function()
	stop_use()
	if not G.STATE_COMPLETE then
	
		if not G.UTDR_shop_tabs then
			G.E_MANAGER:add_event(Event{ func = function()
				G.E_MANAGER:add_event(Event{
					trigger = 'after',
					delay = 0.2,
					func = function()
						play_sound('cancel')
						G.UTDR_shop_tabs = UIBox{
							definition = UTDR_Modules.Shop_Tabs.create_shop_tabs("DR"),
							config = {align="cl", offset = {x=G.ROOM.T.x + 14,y=G.ROOM.T.y + 30}, major = G.ROOM_ATTACH, bond = 'Weak'}
						}
						G.UTDR_shop_tabs.alignment.offset.y = G.ROOM.T.y + 11.2
				return true end})
			return true end})
		end
	end
end


UTDR_Modules.Shop_Tabs.create_shop_tabs = function(mod_state)
	print(mod_state)
	local t = {n=G.UIT.ROOT, config = {align = 'cl', colour = G.C.CLEAR}, nodes={
    		UIBox_dyn_container({
            	{n=G.UIT.R, config={align = "cm", padding = 0.1, minw = 5.0}, nodes={
					{n=G.UIT.C,config={align = "cm", minw = 2.8, minh = 0.5, r=0.15,colour = G.C.RED, button = 'UTDR_shop_button', hover = true,shadow = true, state = "SHOP"}, nodes = {
					  {n=G.UIT.R, config={align = "cm", padding = 0.07, focus_args = {button = 'y', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
						{n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
						  {n=G.UIT.T, config={text = localize('s_UTDR_shop'), scale = 0.4, colour = G.C.WHITE, shadow = true}}
						}},
					  }},              
					}},
					{n=G.UIT.C, config={align = "cm", minw = 2.8, minh = 0.5, r=0.15,colour = G.C.BRATTY, button = 'UTDR_shop_button', hover = true,shadow = true, state = "UTDR_SHOP_CATTYBRATTY"}, nodes = {
					  {n=G.UIT.R, config={align = "cm", padding = 0.07, focus_args = {button = 'x', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
						{n=G.UIT.R, config={align = "cm", minw = 1.3}, nodes={
						  {n=G.UIT.T, config={text = localize('s_UTDR_cattybratty'), scale = 0.4, colour = G.C.WHITE, shadow = true}},
						}},
					  }}
					}},
					{n=G.UIT.C, config={align = "cm", minw = 2.8, minh = 0.5, r=0.15,colour = G.C.BALLGAME, button = 'UTDR_shop_button', hover = true,shadow = true, state = "UTDR_SHOP_CAPSULE"}, nodes = {
					  {n=G.UIT.R, config={align = "cm", padding = 0.07, focus_args = {button = 'x', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
						{n=G.UIT.R, config={align = "cm", minw = 1.3}, nodes={
						  {n=G.UIT.T, config={text = localize('s_UTDR_ball'), scale = 0.4, colour = G.C.WHITE, shadow = true}},
						}},
					  }}
					}},
				  }
				},
            }, false)
        }}
    return t
end