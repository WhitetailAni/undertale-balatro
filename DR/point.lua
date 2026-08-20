SMODS.Voucher {
	key = "rippling_stars",
	atlas = "DR_jokers",
	pos = { x = 0, y = 0 },
	cost = 10,
}

SMODS.Voucher {
	key = "fallen_star",
	atlas = "DR_jokers",
	pos = { x = 1, y = 0 },
	cost = 10,
	requires = { "v_UTDR_rippling_stars" },
	config = {
		points = 100
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.points } }
	end
}

function points_from_rank(rank, max, decrease)
	if rank == "T" then
		return max
	elseif rank == "S" then
		return max - decrease
	elseif rank == "A" then
		return max - (decrease * 2)
	elseif rank == "B" then
		return max - (decrease * 3)
	elseif rank == "C" then
		return max - (decrease * 4)
	end
	return 0
end

function color_for_rank(rank)
	if rank == "T" then
		return G.C.TRANK
	elseif rank == "S" then
		return G.C.SRANK
	elseif rank == "A" then
		return G.C.ARANK
	elseif rank == "B" then
		return G.C.BRANK
	elseif rank == "C" then
		return G.C.CRANK
	end
	return G.C.ZRANK
end

function sfx_for_rank(rank)
	if rank == "T" then
		play_sound("UTDR_points8", 1.0, 0.6)
	elseif rank == "S" then
		play_sound("UTDR_points6", 1.0, 0.6)
	elseif rank == "A" then
		play_sound("UTDR_points4", 1.0, 0.6)
	elseif rank == "B" then
		play_sound("UTDR_points4", 1.0, 0.6)
	elseif rank == "C" then
		play_sound("UTDR_points2", 1.0, 0.6)
	end
	play_sound("UTDR_points1", 1.0, 0.6)
end

function ease_points(mod, instant)
    local function _mod(mod)
    	mod = mod or 0
    	
        local points_UI = G.HUD:get_UIE_by_ID('points_text_UI') --CHANGE
        
        local prefix = '+'
        local col = G.C.POINTS
        if mod < 0 then
            prefix = '-'
            col = G.C.BALLGAME
        else
          --inc_career_stat('c_dollars_earned', mod)
        end
        --Ease from current chips to the new number of chips
        G.GAME.points = G.GAME.points + mod
        --check_and_set_high_score('most_points', G.GAME.points)
       	--check_for_unlock({type = 'points'})
        points_UI.config.object:update() --CHANGE
        G.HUD:recalculate()
        attention_text({
          text = prefix..tostring(math.abs(mod)),
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

function point_gain_sfx(point_gain, max)
	for i = 1, (point_gain / 15) do
		play_sound("UTDR_points", 1.0, 0.5)
		local clock = os.clock
		local t0 = clock()
		while clock() - t0 <= 0.022 do end
	end
end