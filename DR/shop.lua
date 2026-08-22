-- TO-DO LIST:
--      - Shop Tabs
--      - Capsule Machine

-- Run this to manually switch states
-- eval G.STATE, G.STATE_COMPLETE = G.STATES.state_name, false

-- Run this to quick reroll the Catty & Bratty shop while in it
-- eval UTDR_Modules.Shop.reroll_catty_shop() UTDR_Modules.Shop.refresh_cattybratty()

-- Global Table for all Shop related stuff.
UTDR_Modules.Shop = {
	catty_trades = {},
	cheer = false,
	rare_tags = {
		tag_rare = true,
		tag_polychrome = true,
		tag_negative = true,
		tag_handy = true,
		tag_coupon = true,
		tag_UTDR_t_rank = true,
		tag_UTDR_capsule = true,
	},
	excluded_tags = {
		tag_UTDR_glamorous = true
	}
}

-- Code given by @invalid_os, originally from Cryptid
local function calc_text_scale(text)
	local size = 0.9
	local font = G.LANG.font
	local max_text_width = 5
	local calced_text_width = 0
	-- Math reproduced from DynaText:update_text
	for _, c in utf8.chars(text) do
		local tx = font.FONT:getWidth(c) * (0.33 * size) * G.TILESCALE * font.FONTSCALE
			+ 2.7 * 1 * G.TILESCALE * font.FONTSCALE
		calced_text_width = calced_text_width + tx / (G.TILESIZE * G.TILESCALE)
	end
	local scale_fac = calced_text_width > max_text_width and max_text_width / calced_text_width or 1
	return scale_fac
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
		
		if not G.utdr_shop_capsule then
			G.E_MANAGER:add_event(Event{ func = function()
				G.E_MANAGER:add_event(Event{ trigger = 'immediate', func = function()
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
		
		UTDR_Modules.Shop.dialogue = "open"
		UTDR_Modules.Shop.cheer = false

		if not G.utdr_shop_cattybratty then
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
						G.utdr_shop_cattybratty.alignment.offset.y = G.ROOM.T.y + 21.4
				return true end})
			return true end})
		end
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
function UTDR_Modules.Shop.create_UIBox_cattybratty(reload)
	reload = reload or false
	if not G.UTDR_SHOP_SIGN_CATTY then
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
	end

	local tradenodes = {}

	for _,v in ipairs(G.GAME.utdr_trades) do
		if not v.complete then
			local area = CardArea(
				0,
				0,
				G.CARD_W,
				G.CARD_H,
				{card_limit = #v.cards, type = 'title_2', highlight_limit = 0, UTDR_w_space = .6}
			)
			for _, v2 in ipairs(v.cards) do
				local c = SMODS.create_card{key = v2, allow_duplicates=true, bypass_discovery_center=true}
				area:emplace(c)
			end

			local _tag = Tag(v.tag):generate_UI(1)
			local arrow = SMODS.create_sprite(0,0,.6,.6,"UTDR_shop_arrow")

			tradenodes[#tradenodes+1] = {n=G.UIT.C, config={align = "cm", padding = 0.2,colour=G.C.L_BLACK,emboss=.05,r=.1,minw=3.5, minh=4}, nodes={
				{n=G.UIT.R, config={align = "cm", func="utdr_setup_uie_reverse_order"}, nodes = {
					{n=G.UIT.C, config={align = "cm"}, nodes = {{n=G.UIT.O, config={object=area}}}},
					{n=G.UIT.C, config={align = "cm", padding = -.1}, nodes = {
						{n=G.UIT.C, config={align = "cm", padding = .1}, nodes = {
							{n=G.UIT.R, config={align = "cm"}, nodes = {{n=G.UIT.O, config={object=arrow}}}},
							{n=G.UIT.R, config={align = "cm"}, nodes = { _tag }}
						}},
					}},
				}},
				{n=G.UIT.R, config={align = "cm"}, nodes = {
					{n=G.UIT.C, config={ -- Button
						align="cm",
						minw=2.4,
						colour=G.C.RED,
						func="UTDR_cattybratty_tradefunc",
						button="UTDR_cattybratty_trade",
						emboss=.05,
						r=.1,
						padding=.1,
						trade = v
					},nodes={
						{n=G.UIT.T,config={text=localize("b_utdr_cattybratty_trade"),scale=.5,colour=G.C.WHITE}}
					}}
				}}
			}}
		end
	end

	
	local notrades = #tradenodes == 0
	UTDR_Modules.Shop.dialogue = notrades and "sold" or UTDR_Modules.Shop.dialogue or "open"
	local cheer = UTDR_Modules.Shop.cheer and 1 or 0

	local ct = localize("utdr_shopcatty_"..UTDR_Modules.Shop.dialogue)
	local bt = localize("utdr_shopbratty_"..UTDR_Modules.Shop.dialogue)
	--calc_text_scale("Bratty! We're gonna be rich!")
	--calc_text_scale("Yeah! We're gonna be rich!")

	local catty_text = DynaText({ string = ct, float = true, colours = { HEX("DC8DF0") }, pop_in = 0, pop_in_rate = 3, spacing = 1, scale = .5, maxw=4 })
	local bratty_text = DynaText({ string = bt, float = true, colours = { HEX("8DE1BF") }, pop_in = .5, pop_in_rate = 3, spacing = 1, scale = .5, maxw=4 })
	local cb_spr = SMODS.create_sprite(0,0,5.5,5.5*139/215,"UTDR_shop_cattybratty_body",{x=0,y=cheer})

	local t = {n=G.UIT.ROOT, config = {align = 'cl', colour = G.C.CLEAR}, nodes={
		UIBox_dyn_container({
			{n=G.UIT.C, config={align = "cm", padding = 0.2}, nodes={
			{n=G.UIT.C, config={align = "cm"}, nodes={
				{n=G.UIT.R, config={align = "cm", minh = 0.2}, nodes={
					{n=G.UIT.C, config={align = "cr", minw=6, padding=-.03}, nodes = {
						{n=G.UIT.O, config={object = cb_spr}}
					}},
					{n=G.UIT.C, config={align = "cl", minw=5}, nodes = {
						{n=G.UIT.C, config={align = "cl", padding = .3}, nodes = {
							{n=G.UIT.R, config={align = "cm"}, nodes = {{n=G.UIT.O, config={object = catty_text}}}},
							{n=G.UIT.R, config={align = "cm"}, nodes = {{n=G.UIT.O, config={object = bratty_text}}}}
						}}
					}}
				}},
				{n=G.UIT.R, config={align = notrades and "cm" or "cl", minh = 4.45, emboss = 0.05, r = 0.1, colour = G.C.DYN_UI.BOSS_MAIN,padding = .2, minw=11.3}, nodes = tradenodes}
			}}
		}},
		
		}, false)
	}}
	return t
end

function UTDR_Modules.Shop.refresh_cattybratty()
	if G.utdr_shop_cattybratty then
		G.utdr_shop_cattybratty:remove()
		G.utdr_shop_cattybratty = nil
		G.utdr_shop_cattybratty = UIBox{
			definition = UTDR_Modules.Shop.create_UIBox_cattybratty(true),
			config = {align="bmi", offset = {x=0,y=G.ROOM.T.y + 21.4}, major = G.hand, bond = 'Weak'}
		}
	end
end

-- Copied from Mallatro bc I'm not reinventing a weel I already invented
local achook = CardArea.align_cards
function CardArea.align_cards(self)
	if self.config.UTDR_w_space then
		self.T.x = self.T.x-self.config.UTDR_w_space
		self.T.w = self.T.w+self.config.UTDR_w_space*2
		
		achook(self)
		
		self.T.x = self.T.x+self.config.UTDR_w_space
		self.T.w = self.T.w-self.config.UTDR_w_space*2
	else achook(self) end
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

function UTDR_Modules.Shop.add_catty_trade(args, refresh)
	args.cards = args.cards or {"c_fool"}
	args.tag = args.tag or SMODS.poll_object({
		type = "Tag",
		filter = function(pool)
			--if args.rare_tag or G.GAME.used_vouchers["v_UTDR_attack"] then return pool end -- Only restrict pool if not 3rd or don't have voucher
			local ret = {}
			for _,v in ipairs(pool) do
				if not UTDR_Modules.Shop.excluded_tags[v.key] and (
					(args.rare_tag == (UTDR_Modules.Shop.rare_tags[v.key]))
				) then
					ret[#ret+1] = v
				end
			end
			return ret
		end
	})

	G.GAME.utdr_trades[#G.GAME.utdr_trades+1] = args

	if refresh then UTDR_Modules.Shop.refresh_cattybratty() end
end

function UTDR_Modules.Shop.reroll_catty_shop()
	G.GAME.utdr_trades = {}
	
	SMODS.poll_object{ type = "Tarot" } -- For some reason this keeps being polled as The Fool
	-- Hook here to add more trades :3
	UTDR_Modules.Shop.add_catty_trade{
		cards = {
			SMODS.poll_object{ type = "Tarot" }
		}
	}
	UTDR_Modules.Shop.add_catty_trade{
		cards = {
			SMODS.poll_object{ type = "Planet" }
		}
	}
	UTDR_Modules.Shop.add_catty_trade{
		cards = {
			SMODS.poll_object{ type = "Tarot" },
			SMODS.poll_object{ type = "Planet" }
		},
		rare_tag = true
	}
end

local reset_blinds_hook = reset_blinds
function reset_blinds(...)
	if G.GAME.round_resets.blind_states.Boss == "Defeated" then
		UTDR_Modules.Shop.reroll_catty_shop()
	end

	reset_blinds_hook(...)
end

function G.FUNCS.UTDR_cattybratty_tradefunc(e)
	local cantrade = not e.config.trade.complete
	local checked = {}
	if cantrade then
		for _, v in ipairs(e.config.trade.cards) do
			for _, v2 in ipairs(SMODS.find_card(v)) do -- In case you want a trade that asks for 2 of the same card
				--cantrade = cantrade and v2.utdr_trade_target
				if not v2.utdr_trade_target then
					v2.utdr_trade_target = true
					checked[#checked+1] = v2
					break
				end
			end
		end
		cantrade = #checked == #e.config.trade.cards
		for _, v in ipairs(checked) do
			v.utdr_trade_target = false
		end
	end
	
	e.config.colour = cantrade and G.C.RED or G.C.UI.BACKGROUND_INACTIVE
	e.config.button = cantrade and 'UTDR_cattybratty_trade' or nil
end

function G.FUNCS.UTDR_cattybratty_trade(e)
	local cards = {}
	for _, v in ipairs(e.config.trade.cards) do
		for _, v2 in ipairs(SMODS.find_card(v)) do -- In case you want a trade that asks for multiple of the same card
			if not v2.utdr_trade_target then
				v2.utdr_trade_target = true
				cards[#cards+1] = v2
				break
			end
		end
	end

	SMODS.destroy_cards(cards)
	add_tag({key = e.config.trade.tag})
	e.config.trade.complete = true

	UTDR_Modules.Shop.dialogue = "buy"
	UTDR_Modules.Shop.cheer = true
	UTDR_Modules.Shop.refresh_cattybratty()
	play_sound("UTDR_buy")
	-- Saving is rly buggy and messes up trade functionality
	--G.E_MANAGER:add_event(Event{ func = function() save_run(); return true end})
end

-- Code by @sleepy.g11 on Discord
G.FUNCS.utdr_setup_uie_reverse_order = function(e)
    e.config.func = nil
    function e:draw_children()
        if self.states.visible then
            -- Draw children in reverse order
            for k = #self.children, 1, -1 do
                local v = self.children[k]
                if not v.config.draw_layer and k ~= "h_popup" and k ~= "alert" then
                    if v.draw_self and not v.config.draw_after then v:draw_self() else v:draw() end
                    if v.draw_children then v:draw_children() end
                    if v.draw_self and v.config.draw_after then v:draw_self() else v:draw() end
                end
            end
        end
    end
end