function ease_points(mod, instant)
    local function _mod(mod)
    	if G.GAME.ante_points >= 700 then return end
        local dollar_UI = G.HUD:get_UIE_by_ID('dollar_text_UI') --CHANGE
        mod = mod or 0
        local text = '+'
        local col = G.C.GREEN
        if mod < 0 then
            text = '-'
            col = G.C.RED              
        else
          --inc_career_stat('c_dollars_earned', mod)
        end
        --Ease from current chips to the new number of chips
        G.GAME.ante_points = G.GAME.ante_points + mod
        --check_and_set_high_score('most_money', G.GAME.dollars)
       -- check_for_unlock({type = 'money'})
        dollar_UI.config.object:update() --CHANGE
        G.HUD:recalculate()
        --Popup text next to the chips in UI showing number of chips gained/lost
        attention_text({
          text = text..tostring(math.abs(mod)),
          scale = 0.8, 
          hold = 0.7,
          cover = dollar_UI.parent, --CHANGE
          cover_colour = col,
          align = 'cm',
          })
        --Play a chip sound
        play_sound('coin1') --SWITCH TO POINTS SOUND (SOUNDS?)
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
end