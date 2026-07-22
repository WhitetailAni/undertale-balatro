UTDR_Tenna = {
	start_quiz = function(quiz)
		quiz = quiz or pseudorandom_element(UTDR_Tenna.quiz_pool)
		
		local quiz_table = UTDR_Tenna.quizzes[quiz]

		-- Make Quiz UI
		G.FUNCS.overlay_menu{
			definition = UTDR_Tenna.create_UIBox_quiz(),
			config = {no_esc = true}
		}
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = .5,
			blocking = false,
			func = (function()
				if G.OVERLAY_MENU and G.OVERLAY_MENU:get_UIE_by_ID('jimbo_spot') then 
					local tenna = Card_Character({
						x = 0,
						y = 5,
						center = "j_UTDR_tenna",
						tenna = true
					})
					local spot = G.OVERLAY_MENU:get_UIE_by_ID('jimbo_spot')
					spot.config.object:remove()
					spot.config.object = tenna
					tenna.ui_object_updated = true
					tenna:add_speech_bubble('utdr_quiz_'..quiz, nil, {quip = true})
					tenna:say_stuff(10)
					end
				return true
			end)
		}))
	end,
	create_UIBox_quiz = function()
		local t = create_UIBox_generic_options({ padding = 0, colour = G.C.BLACK, outline_colour = G.C.RED, no_back = true, --[[no_esc = true,]] contents = {
			
		}})
		t.nodes[1] = {n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
				{n=G.UIT.C, config={align = "cm", padding = 2}, nodes={
					{n=G.UIT.O, config={padding = 0, id = 'jimbo_spot', object = Moveable(0,0,G.CARD_W*1.1, G.CARD_H*1.1)}},
				}},
				{n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={t.nodes[1]}
			}}
		}
		--t.nodes[1].config.mid = true
		t.config.id = 'UTDR_tenna_quiz_UI'
		return t
	end,
	quizzes = {},
	quiz_pool = {
		"test"
	}
}

UTDR_Tenna.quizzes.test = {
	init = function(self) -- Optional
		
	end,
	cards = function(self) -- Return table of card keys, could also just be table (eg: j_joker)
		
	end
}