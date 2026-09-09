UTDR_Modules.Lacquer_Shop = {
	old_volume = 0
}

function Game:update_utdr_shop_lacquer(dt)
	if not G.STATE_COMPLETE then
		stop_use()
		ease_background_colour_blind(G.STATES.UTDR_SHOP_LACQUER)

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
		
		if not G.UTDR_lacquer_shop then
			G.E_MANAGER:add_event(Event{ func = function()
				G.E_MANAGER:add_event(Event{
					trigger = 'immediate',
					func = function()
						UTDR_Modules.Lacquer_Shop.old_volume = G.SETTINGS.SOUND.music_volume
						G.SETTINGS.SOUND.music_volume = 0
						play_sound('cancel')
						G.UTDR_lacquer_shop = UIBox{
							definition = UTDR_Modules.Lacquer_Shop.lacquer_shop(),
							config = {align="bmi", offset = {x=0,y=G.ROOM.T.y + 29}, major = G.hand, bond = 'Weak'}
						}
						
						G.C.DYN_UI.MAIN = G.C.LACQUER_OUTLINE
						
						UTDR_Modules.Lacquer_Shop.create_lacquer_for_shop()
						
						G.ROOM.jiggle = G.ROOM.jiggle + 3
						G.CONTROLLER.lock_input = false
						G.UTDR_lacquer_shop.alignment.offset.y = G.ROOM.T.y + 21.4
				return true end})
			return true end})
		end
	end
	
	G.SETTINGS.SOUND.music_volume = 0
end

function UTDR_Modules.Lacquer_Shop.create_lacquer_for_shop()
	local script_step = G.GAME.UTDR_lacquer_script_step
	
	print(script_step)
	  
	if script_step == 12 then
		local lacquer_triangle = SMODS.create_card({
			key = "j_UTDR_lacquer_triangle"
		})
		UTDR_Modules.Lacquer_Shop.create_lacquer_card_ui(lacquer_triangle)
		G.lacquer_joker:emplace(lacquer_triangle)
	elseif script_step > 12 then
		G.E_MANAGER:add_event(Event({
			func = function()
				G.SETTINGS.SOUND.music_volume = UTDR_Modules.Lacquer_Shop.old_volume
				G.STATE = G.STATES.SHOP
				G.STATE_COMPLETE = false
				return true
			end
		}))
	end
end

function UTDR_Modules.Lacquer_Shop.create_lacquer_card_ui(card, type, area)
      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.43,
        blocking = false,
        blockable = false,
        func = (function()
          local t1 = {
              n=G.UIT.ROOT, config = {minw = 0.6, align = 'tm', colour = darken(G.C.BLACK, 0.2), shadow = true, r = 0.05, padding = 0.05, minh = 1}, nodes={
                  {n=G.UIT.R, config={align = "cm", colour = lighten(G.C.BLACK, 0.1), r = 0.1, minw = 1.2, minh = 0.55, emboss = 0.05, padding = 0.03}, nodes={
                    {n = G.UIT.T, config = {colour=G.C.POINTS, scale=.4, text = "1225 PTs"}}
                  }}
              }}
          local t2 = {
            n=G.UIT.ROOT, config = {ref_table = card, minw = 1.1, maxw = 1.3, padding = 0.1, align = 'bm', colour = G.C.BALLGAME, shadow = true, r = 0.08, minh = 0.94, one_press = true, button = 'buy_lacquer', hover = true}, nodes={
                {n=G.UIT.T, config={text = localize('b_buy'),colour = G.C.WHITE, scale = 0.5}}
            }}
            

          card.children.price = UIBox{
            definition = t1,
            config = {
              align="tm",
              offset = {x=0,y=1.5},
              major = card,
              bond = 'Weak',
              parent = card
            }
          }

          card.children.buy_button = UIBox{
            definition = t2,
            config = {
              align="bm",
              offset = {x=0,y=-0.3},
              major = card,
              bond = 'Weak',
              parent = card
            }
          }

          card.children.price.alignment.offset.y = 0.38

            return true
        end)
      }))
  end
  
  
  
function UTDR_Modules.Lacquer_Shop.lacquer_shop()
    G.lacquer_joker = CardArea(
      G.hand.T.x+0,
      G.hand.T.y+G.ROOM.T.y + 9,
      math.min(G.GAME.shop.joker_max*1.02*G.CARD_W,4.08*G.CARD_W),
      1.05*G.CARD_H, 
      {card_limit = 1, type = 'shop', highlight_limit = 1, negative_info = true})

    G.lacquer_voucher = CardArea(
      G.hand.T.x+0,
      G.hand.T.y+G.ROOM.T.y + 9,
      2.1*G.CARD_W,
      1.05*G.CARD_H, 
      {card_limit = 0, type = 'shop', highlight_limit = 1})

    G.lacquer_booster = CardArea(
      G.hand.T.x+0,
      G.hand.T.y+G.ROOM.T.y + 9,
      2.4*G.CARD_W,
      1.15*G.CARD_H, 
      {card_limit = 0, type = 'shop', highlight_limit = 1, card_w = 1.27*G.CARD_W})

	
    local shop_sign = Sprite(0,0, 4.4, 2.2, G.ASSET_ATLAS.UTDR_shopsign_lacquer)--AnimatedSprite(0,0, 4.4, 2.2, G.ANIMATION_ATLAS['shop_sign'])
    --[[shop_sign:define_draw_steps({
      {shader = 'dissolve', shadow_height = 0.05},
      {shader = 'dissolve'}
    })]]
    G.SHOP_SIGN = UIBox{
      definition = 
        {n=G.UIT.ROOT, config = {colour = G.C.DYN_UI.MAIN, emboss = 0.05, align = 'cm', r = 0.1, padding = 0.1}, nodes={
          {n=G.UIT.R, config={align = "cm", padding = 0.1, minw = 4.72, minh = 3.1, colour = G.C.DYN_UI.DARK, r = 0.1}, nodes={
            {n=G.UIT.R, config={align = "cm"}, nodes={
              {n=G.UIT.O, config={object = shop_sign}}
            }},
            {n=G.UIT.R, config={align = "cm"}, nodes={
              {n=G.UIT.O, config={object = DynaText({string = {localize('ph_UTDR_improve')}, colours = {lighten(G.C.LACQUER_OUTLINE, 0.3)},shadow = true, rotate = true, float = true, bump = true, scale = 0.5, spacing = 1, pop_in = 1.5, maxw = 4.3})}}
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
          G.SHOP_SIGN.alignment.offset.y = 0
          return true
      end)
    }))
    local t = {n=G.UIT.ROOT, config = {align = 'cl', colour = G.C.CLEAR}, nodes={
    		UIBox_dyn_container({
                {n=G.UIT.C, config={align = "cm", padding = 0.1, emboss = 0.05, r = 0.1, colour = G.C.DYN_UI.BOSS_MAIN}, nodes={
                    {n=G.UIT.R, config={align = "cm", padding = 0.05}, nodes={
                      {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
                        {n=G.UIT.R,config={id = 'next_round_button', align = "cm", minw = 2.8, minh = 1.5, r=0.15,colour = G.C.RED, one_press = true, button = nil, hover = true,shadow = true}, nodes = {
                          {n=G.UIT.R, config={align = "cm", padding = 0.07, focus_args = {button = 'y', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
                            {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                              {n=G.UIT.T, config={text = localize('b_next_round_1'), scale = 0.4, colour = G.C.WHITE, shadow = true}}
                            }},
                            {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                              {n=G.UIT.T, config={text = localize('b_next_round_2'), scale = 0.4, colour = G.C.WHITE, shadow = true}}
                            }}   
                          }},              
                        }},
                        {n=G.UIT.R, config={align = "cm", padding = 0.1}},
                        {n=G.UIT.R, config={align = "cm", minw = 2.8, minh = 1.6, r=0.15,colour = G.C.GREEN, button = 'reroll_lacquer', hover = true,shadow = true}, nodes = {
                          {n=G.UIT.R, config={align = "cm", padding = 0.07, focus_args = {button = 'x', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
                            {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                              {n=G.UIT.T, config={text = localize('k_reroll'), scale = 0.4, colour = G.C.WHITE, shadow = true}},
                            }},
                            {n=G.UIT.R, config={align = "cm", maxw = 1.3, minw = 1}, nodes={
                              {n=G.UIT.T, config={text = localize('$').."0", scale = 0.7, colour = G.C.WHITE, shadow = true}},
                            }}
                          }}
                        }},
                      }},
                      {n=G.UIT.C, config={align = "cm", padding = 0.2, r=0.2, colour = G.C.L_BLACK, emboss = 0.05, minw = 8.2}, nodes={
                          {n=G.UIT.O, config={object = G.lacquer_joker}},
                      }},
                    }},
                    {n=G.UIT.R, config={align = "cm", minh = 0.2}, nodes={}},
                    {n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
                      {n=G.UIT.C, config={align = "cm", padding = 0.15, r=0.2, colour = G.C.L_BLACK, emboss = 0.05}, nodes={
                        {n=G.UIT.C, config={align = "cm", padding = 0.2, r=0.2, colour = G.C.BLACK, maxh = G.lacquer_voucher.T.h+0.4}, nodes={
                          {n=G.UIT.T, config={text = localize{type = 'variable', key = 'ante_x_voucher', vars = { 0 }}, scale = 0.45, colour = G.C.L_BLACK, vert = true}},
                          {n=G.UIT.O, config={object = G.lacquer_voucher}},
                        }},
                      }},
                      {n=G.UIT.C, config={align = "cm", padding = 0.15, r=0.2, colour = G.C.L_BLACK, emboss = 0.05}, nodes={
                        {n=G.UIT.O, config={object = G.lacquer_booster}},
                      }},
                    }}
                }
              },
              
              }, false)
        }}
    return t
end

G.FUNCS.reroll_lacquer = function(e) 
    stop_use()
    G.CONTROLLER.locks.shop_reroll = true
    if G.CONTROLLER:save_cardarea_focus('lacquer_joker') then G.CONTROLLER.interrupt.focus = true end
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
        	G.GAME.UTDR_lacquer_script_step = G.GAME.UTDR_lacquer_script_step + 1
        	UTDR_Modules.Lacquer_Shop.create_lacquer_for_shop()
          
        	return true
        end
      }))
      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.3,
        func = function()
        G.E_MANAGER:add_event(Event({
          func = function()
            G.CONTROLLER.interrupt.focus = false
            G.CONTROLLER.locks.shop_reroll = false
            G.CONTROLLER:recall_cardarea_focus('lacquer_joker')
            return true
          end
        }))
        return true
      end
    }))
    G.E_MANAGER:add_event(Event({ func = function() save_run(); return true end}))
  end
  
  G.FUNCS.buy_lacquer = function(e)
    local c1 = e.config.ref_table
    if c1 and c1:is(Card) then
      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.1,
        func = function()
			c1.from_area = c1.area
			c1.area:remove_card(c1)
			c1:add_to_deck()
			if c1.children.price then c1.children.price:remove() end
			c1.children.price = nil
			if c1.children.buy_button then c1.children.buy_button:remove() end
			c1.children.buy_button = nil
			remove_nils(c1.children)
			G.jokers:emplace(c1)
			  --Tallies for unlocks
			G.GAME.round_scores.cards_purchased.amt = G.GAME.round_scores.cards_purchased.amt + 1
			G.GAME.current_round.jokers_purchased = G.GAME.current_round.jokers_purchased + 1
	
			SMODS.calculate_context({buying_card = true, card = c1})
	
			play_sound('card1')
			UTDR_Modules.Capsule.ease_points(-1225)
			G.CONTROLLER:save_cardarea_focus('jokers')
			G.CONTROLLER:recall_cardarea_focus('jokers')
			
			G.E_MANAGER:add_event(Event({
				func = function()
					G.SETTINGS.SOUND.music_volume = UTDR_Modules.Lacquer_Shop.old_volume
					G.STATE = G.STATES.SHOP
					G.STATE_COMPLETE = false
					return true
				end
			}))
	
			return true
        end
      }))
    end
end