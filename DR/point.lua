--ante_points is never shown to the player, its just for internal tracking. if it ever hits 700, no more point gain. end of story!
--it goes up every time points does
--every ante, it resets to 0 to allow more point gain.

function ease_points(mod, instant)
    local function _mod(mod)
    	mod = mod or 0
    	--ensure 700 per-ante cap
    	local potential_man = G.GAME.points_ante + mod
    	if potential_man >= 700 then
    		mod = mod - (potential_man - 700)
    	end
    	
        local points_UI = G.HUD:get_UIE_by_ID('points_text_UI') --CHANGE
        
        local prefix = '+'
        local suffix = " PTs"
        local col = G.C.POINTS
        if mod < 0 then
            prefix = '-'
            col = G.C.RED              
        else
          --inc_career_stat('c_dollars_earned', mod)
        end
        --Ease from current chips to the new number of chips
        G.GAME.points_ante = G.GAME.points_ante + mod
        G.GAME.points = G.GAME.points + mod
        --check_and_set_high_score('most_points', G.GAME.points)
       	--check_for_unlock({type = 'points'})
        points_UI.config.object:update() --CHANGE
        G.HUD:recalculate()
        attention_text({
          text = prefix..tostring(math.abs(mod))..suffix,
          scale = 0.8, 
          hold = 0.7,
          cover = points_UI.parent,
          cover_colour = col,
          align = 'cm',
          })
        --Play a chip sound
       	
        --play_sound('coin1') --SWITCH TO POINTS SOUND (SOUNDS?)
        
    end
    if instant then
        _mod(mod)
    else
        G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            _mod(mod)
            return true
        end
        }))
    end
    --point_gain_sfx(mod)
    --cant get this to work without lagging game UI..
end

function point_gain_sfx(point_gain)
	for i = 1, (point_gain / 15) do
		play_sound("UTDR_points", 1.0, 0.5)
		local clock = os.clock
		local t0 = clock()
		while clock() - t0 <= 0.022 do end
	end
end