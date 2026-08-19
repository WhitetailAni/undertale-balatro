UTDR_Modules.Tenna = {
	start_quiz = function(quiz, card)
		if UTDR_Modules.Tenna.playing then return end
		quiz = quiz or pseudorandom_element(UTDR_Modules.Tenna.quiz_pool)
		
		UTDR_Modules.Tenna.playing = true
		local quiz_table = UTDR_Modules.Tenna.quizzes[quiz]

		-- Make Quiz UI
		G.FUNCS.overlay_menu{
			definition = UTDR_Modules.Tenna.create_UIBox_quiz(quiz_table),
			config = {no_esc = true}
		}
		if quiz_table.init then quiz_table:init() end
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			blocking = false,
			func = (function()
				if G.OVERLAY_MENU and G.OVERLAY_MENU:get_UIE_by_ID('tenna_spot') then 
					local tenna = Card_Character({
						x = 0,
						y = 5,
						center = "j_UTDR_tenna",
						tenna = true
					})
					local spot = G.OVERLAY_MENU:get_UIE_by_ID('tenna_spot')
					spot.config.object:remove()
					spot.config.object = tenna
					tenna.ui_object_updated = true
					tenna:add_speech_bubble('tennaquiz_'..quiz, nil, {quip = true})
					tenna:say_stuff(5)
				end

				UTDR_Modules.Tenna.timer = 12
				UTDR_Modules.Tenna.won = false

				-- Start Events
				G.E_MANAGER:add_event(Event({func = function()
					return UTDR_Modules.Tenna.timer <= 0 or UTDR_Modules.Tenna.won
				end}))

				G.E_MANAGER:add_event(Event({func = function()
					G.FUNCS.exit_overlay_menu()
					UTDR_Modules.Tenna.playing = false
					play_sound(UTDR_Modules.Tenna.won and "UTDR_win" or "UTDR_lose") -- Temporary sounds, pls replace
				return true end}))
		return true end)}))
	end,
	create_UIBox_quiz = function(quiz)
		local area = CardArea(
			0,
			0,
			3.6*G.CARD_W,
			1.05*G.CARD_H, 
			{card_limit = 4, type = 'title', highlight_limit = 0}
		)

		local cards = type(quiz.cards) == "function" and quiz:cards() or quiz.cards or {}

		for _, v in ipairs(cards) do
			local c = SMODS.create_card(type(v) == "table" and v or {key=v, area = area, no_edition = true, soulable = false})
			area:emplace(c)
		end

		if quiz.card_post then quiz:card_post(area) end

		for _, v in ipairs(area.cards) do
			v.no_ui = true -- No hover description
			v.states.drag.can = false -- No dragging
		end

		local a = #area.cards == 0
		if a then
			area:remove()
		end

		local question_nodes = {}

		local questions = quiz.questions and quiz:questions(area) or {{"ERROR",true}} -- No questions means no winning, so add a fallback question

		for _, v in ipairs(questions) do
			local n = { n=G.UIT.R, config={align = "cm", minw = 3.4*G.CARD_W, padding = 0.1, r = 0.1, hover = true, colour = G.C.BLUE, button = "utdr_tenna_button", shadow = true, question = v}, nodes={
				{ n=G.UIT.R, config={align = "cm", padding = 0.1, no_fill = true}, nodes={
					{ n=G.UIT.T, config={text = v[1], scale = 0.5, colour = G.C.UI.TEXT_LIGHT}}}}}}
			
			question_nodes[#question_nodes+1] = n
		end

		local slider = create_slider({w = 3*G.CARD_W, max = 12, ref_table = UTDR_Modules.Tenna, ref_value = "timer"})
		slider.nodes[1].config.func = "utdr_tenna_timer"

		local t = create_UIBox_generic_options({ padding = 0, colour = G.C.BLACK, outline_colour = G.C.RED, no_back = true, no_esc = true, contents = {
			not a and {n=G.UIT.R, nodes={{n=G.UIT.O, config={padding = -1, object = area}}}} or nil,
			{n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes=question_nodes},
			{n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={slider}}
		}})
		t.nodes[1] = {n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
				{n=G.UIT.C, config={align = "cm", padding = 2}, nodes={
					{n=G.UIT.O, config={padding = 0, id = 'tenna_spot', object = Moveable(0,0,G.CARD_W*1.1, G.CARD_H*1.1)}},
				}},
				{n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={t.nodes[1]}
		}}}
		--t.nodes[1].config.mid = true
		--t.config.id = 'UTDR_tenna_quiz_UI'
		return t
	end,
	quizzes = {},
	quiz_pool = {},
	timer = 0,
	won = false,
	Quiz = function(t)
		local key = SMODS.current_mod.prefix.."_"..t.key
		t.key = nil
		UTDR_Modules.Tenna.quiz_pool[#UTDR_Modules.Tenna.quiz_pool+1] = key
		UTDR_Modules.Tenna.quizzes[key] = t
		return t
	end,
	FakerQuiz = function(t)
		function t:cards()
			local cards = {}
			local fakeable_count = 0

			for i = 1, t.count do
				cards[#cards+1] = pseudorandom_element(G.P_CENTER_POOLS[t.pool], "UTDR_quiz_fakes", {in_pool = function(v, args)
					if t.in_pool and not t:in_pool(v,args) then return false end -- Force fakers in if not enough have appeared
					for _, v2 in ipairs(cards) do if v.key == v2 then return false end end
					if t.count-i < t.faker_count-fakeable_count then return t.fake.cards[v.key] or false end -- Force fakers in if not enough have appeared
					return true
				end}).key
				
				fakeable_count = fakeable_count + (t.fake.cards[cards[#cards] ] and 1 or 0)
			end
			return cards
		end

		local old_post = t.card_post or function() end
		function t:card_post(area)
			area:shuffle("UTDR_quizarea")

			-- Set Non-Faker sprites
			if t.not_fake then
				for i, v in ipairs(area.cards) do
					if t.not_fake.cards[v.config.center_key] then
					v.children.center.atlas = G.ASSET_ATLAS[t.not_fake.atlas]
					v.children.center:set_sprite_pos(t.not_fake.cards[v.config.center_key])
					end
				end
			end

			-- Set Faker
			for i = 1, t.faker_count do
				if t.fake then
					local c = pseudorandom_element(area.cards,"UTDR_quiz_set_fakes", {in_pool = function(v,args)
						return t.fake.cards[v.config.center_key] and not v.fake
					end})
					
					c.children.center.atlas = G.ASSET_ATLAS[t.fake.atlas]
					c.children.center:set_sprite_pos(t.fake.cards[c.config.center_key])
					
					c.fake = true
				end
			end

			old_post(area)
		end

		local old_q = t.questions
		function t:questions(area)
			if old_q then return old_q(area) end
			
			local qu = {}
			for i, v in ipairs(area.cards) do
				qu[#qu+1] = {localize({type = 'name_text', key = v.config.center_key, set = v.config.center.set}),v.fake or false}
			end
			return qu
		end

		return UTDR_Modules.Tenna.Quiz(t)
	end,

	fakers = {
		jokers = {
			atlas = "UTDR_fakers",
			cards = {
				j_wrathful_joker = {x=4,y=2},
				j_selzer = {x=5,y=2},
				j_sock_and_buskin = {x=0,y=3},
				j_blueprint = {x=1,y=3},
				j_lucky_cat = {x=2,y=3},
				j_madness = {x=3,y=3},
				j_drunkard = {x=4,y=3},
				j_hit_the_road = {x=5,y=3},
				j_flash = {x=0,y=4},
				j_oops = {x=1,y=4},
				j_half = {x=2,y=4},
				j_swashbuckler = {x=3,y=4},
				j_order = {x=4,y=4},
				j_gift = {x=5,y=4},
				j_sixth_sense = {x=0,y=5},
				j_credit_card = {x=1,y=5},
				j_mr_bones = {x=2,y=5},
				j_pareidolia = {x=3,y=5},
				j_hanging_chad = {x=4,y=5},
				j_loyalty_card = {x=5,y=5},
				j_scholar = {x=0,y=6},
				j_8_ball = {x=1,y=6},
				j_castle = {x=2,y=6},
				j_abstract = {x=3,y=6},
				j_runner = {x=4,y=6},
				j_acrobat = {x=5,y=6},
			}
		},
		tarot = {
			atlas = "UTDR_fakers",
			cards = {
				c_justice = {x=0,y=0},
				c_wheel_of_fortune = {x=1,y=0},
				c_hermit = {x=2,y=0},
				c_high_priestess = {x=3,y=0},
				c_death = {x=4,y=0},
				c_emperor = {x=5,y=0},
				c_devil = {x=0,y=1},
				c_magician = {x=1,y=1},
				c_tower = {x=2,y=1},
			}
		},
		spectral = {
			atlas = "UTDR_fakers",
			cards = {
				c_anch = {x=3,y=1},
				c_ouija = {x=4,y=1},
				c_aura = {x=5,y=1},
				c_medium = {x=0,y=2},
				c_familiar = {x=1,y=2},
				c_sigil = {x=2,y=2},
				c_talisman = {x=3,y=2},
			}
		},
		tarot_vanilla = { -- For using Vanilla Tarot sprites
			atlas = "Tarot",
			cards = {
				c_fool = {x=0,y=0},
				c_magician = {x=1,y=0},
				c_high_priestess = {x=2,y=0},
				c_empress = {x=3,y=0},
				c_emperor = {x=4,y=0},
				c_heirophant = {x=5,y=0},
				c_lovers = {x=6,y=0},
				c_chariot = {x=7,y=0},
				c_justice = {x=8,y=0},
				c_hermit = {x=9,y=0},
				c_wheel_of_fortune = {x=0,y=1},
				c_strength = {x=1,y=1},
				c_hanged_man = {x=2,y=1},
				c_death = {x=3,y=1},
				c_temperance = {x=4,y=1},
				c_devil = {x=5,y=1},
				c_tower = {x=6,y=1},
				c_star = {x=7,y=1},
				c_moon = {x=8,y=1},
				c_sun = {x=9,y=1},
				c_judgement = {x=0,y=2},
				c_world = {x=1,y=2},
			}
		},
		spectral_vanilla = { -- For using Vanilla Tarot sprites
			atlas = "Spectral",
			cards = {
				c_familiar = {x=0,y=4},
				c_grim = {x=1,y=4},
				c_incantation = {x=2,y=4},
				c_talisman = {x=3,y=4},
				c_aura = {x=4,y=4},
				c_wraith = {x=5,y=4},
				c_sigil = {x=6,y=4},
				c_ouija = {x=7,y=4},
				c_ectoplasm = {x=8,y=4},
				c_immolate = {x=9,y=4},
				c_ankh = {x=0,y=5},
				c_deja_vu = {x=1,y=5},
				c_hex = {x=2,y=5},
				c_trance = {x=3,y=5},
				c_medium = {x=4,y=5},
				c_cryptid = {x=5,y=5},
			}
		},
		spectral_names = {
			c_familiar = "Familiar",
			c_grim = "Grim",
			c_incantation = "Incantation",
			c_talisman = "Talisman",
			c_aura = "Aura",
			c_wraith = "Wraith",
			c_sigil = "Sigil",
			c_ouija = "Ouija",
			c_ectoplasm = "Ectoplasm",
			c_immolate = "Immolate",
			c_ankh = "Ankh",
			c_deja_vu = "Deja Vu",
			c_hex = "Hex",
			c_trance = "Trance",
			c_medium = "Medium",
			c_cryptid = "Cryptid",
		}
	}
}

-- Modified version of slider to act as a timer instead
function G.FUNCS.utdr_tenna_timer(e)
	local c = e.children[1]
	
	local rt = c.config.ref_table
	rt.text = string.format("%."..tostring(rt.decimal_places).."f", rt.ref_table[rt.ref_value])
	c.T.w = (rt.ref_table[rt.ref_value] - rt.min)/(rt.max - rt.min)*rt.w
	c.config.w = c.T.w
	if G.CONTROLLER and G.CONTROLLER.dragging.target and
		(G.CONTROLLER.dragging.target == e or
		G.CONTROLLER.dragging.target == c) then
			local rt = c.config.ref_table
			rt.ref_table[rt.ref_value] = math.min(rt.max,math.max(rt.min, rt.min + (rt.max - rt.min)*(G.CURSOR.T.x - e.parent.T.x - G.ROOM.T.x)/e.T.w))
			rt.text = string.format("%."..tostring(rt.decimal_places).."f", rt.ref_table[rt.ref_value])
			c.T.w = (rt.ref_table[rt.ref_value] - rt.min)/(rt.max - rt.min)*rt.w
			c.config.w = c.T.w
			if rt.callback then G.FUNCS[rt.callback](rt) end
	end
end

function G.FUNCS.utdr_tenna_button(e)
	UTDR_Modules.Tenna.won = e.config.question[2]
	UTDR_Modules.Tenna.timer = 0
end

-- Hooking base love functions acts weird sometimes lol
if not love.update then function love.update(dt) end end
local oldgameupdate = love.update
function love.update(dt)
    local g = oldgameupdate(dt)
    if G.OVERLAY_MENU and G.OVERLAY_MENU:get_UIE_by_ID('tenna_spot') then
		UTDR_Modules.Tenna.timer = UTDR_Modules.Tenna.timer - dt
	end
end

--[[
UTDR_Modules.Tenna.Quiz{
	key = "example",
	init = function(self) end, -- Add behaviour at start of quiz load
	cards = function(self) -- Return table of card keys or SMODS.create_card tables, could also just be table (eg: j_joker)
		return {"j_joker"}
	end,
	card_post = function(self, area) end, -- Stuff to do after adding the cards, can be used for more control over created cards
	questions = function(self, area) -- Return table of questions to be answered with format {text(string), correct(bool)}
		return {
			{"A", true},
			{"B", false},
			{"C", false},
			{"D", false}
		}
	end
}
]]

UTDR_Modules.Tenna.Quiz{
	key = "tvtime",
	questions = function(self, area)
		return {
			{"TV-Thirty!", true},
			{"TV Time!!!", true},
			{"Past Midnight", true},
			{os.date("%A",os.time()+86430), false} -- Adds 24h+30s to the date to get tomorrow after timer up (similar to in Deltarune)
		}
	end
}

UTDR_Modules.Tenna.Quiz{
	key = "ralsei",
	cards = function(self) return {"j_UTDR_ralsei"} end,
	questions = function(self, area)
		return {
			{"Higher", true},
			{"Lower", false},
			{"Priceless", false},
			{"$"..G.P_CENTERS.j_UTDR_ralsei.cost..".00 MSRP", true} -- Use Ralsei's actual price, even if rebalanced later
		}
	end
}

UTDR_Modules.Tenna.Quiz{
	key = "tennaname",
	questions = function(self, area)
		return {
			{"Mr. TV Guy", false},
			{"Mr. Tenna", true},
			{"Mr. Lil' Nose", false},
			{"Mr. Email", false}
		}
	end
}

UTDR_Modules.Tenna.Quiz{
	key = "lancer",
	cards = function(self) return {"j_UTDR_lancer"} end,
	questions = function(self, area)
		return {
			{"Lancer", true},
			{"Dancer", false},
			{"Prancer", false},
			{"Mr. Generosity", false}
		}
	end
}

-- These need more effort to make
UTDR_Modules.Tenna.FakerQuiz{
	key = "jokers",
	fake = UTDR_Modules.Tenna.fakers.jokers,
	count = 4,
	faker_count = 1,
	pool = "Joker",
	in_pool = function(self,v,args) return not v.mod end -- Vanilla Jokers Only
}

UTDR_Modules.Tenna.FakerQuiz{
	key = "tarot",
	fake = UTDR_Modules.Tenna.fakers.tarot,
	not_fake = UTDR_Modules.Tenna.fakers.tarot_vanilla,
	count = 4,
	faker_count = 1,
	pool = "Tarot",
	in_pool = function(self,v,args) return not v.mod end -- Vanilla Tarots Only
}

UTDR_Modules.Tenna.FakerQuiz{
	key = "spectral",
	fake = UTDR_Modules.Tenna.fakers.spectral,
	not_fake = UTDR_Modules.Tenna.fakers.spectral_vanilla,
	count = 4,
	faker_count = 1,
	pool = "Spectral",
	in_pool = function(self,v,args) return not (v.mod or v.key == "c_soul" or v.key == "c_black_hole") end, -- Vanilla Spectrals Only, no rares
	questions = function(area)
		local qu = {}
		for i, v in ipairs(area.cards) do
			qu[#qu+1] = {UTDR_Modules.Tenna.fakers.spectral_names[v.config.center_key] or localize({type = 'name_text', key = v.config.center_key, set = v.config.center.set}),v.fake or false}
		end
		return qu
	end
}

--[[
UTDR_Modules.Tenna.Quiz{
	key = "tarot"
}
UTDR_Modules.Tenna.Quiz{
	key = "spectral"
}]]

UTDR_Modules.Tenna.Quiz{
	key = "satellite",
	cards = function(self) return {
		"j_supernova",
		"j_satellite",
		"j_constellation",
		"j_astronomer",
	} end,
	questions = function(self, area)
		return {
			{"Supernova", false},
			{"Satellite", true},
			{"Constellation", false},
			{"Astronomer", false}
		}
	end
}

UTDR_Modules.Tenna.Quiz{
	key = "jimbo",
	cards = function(self) return { "j_joker" } end,
	questions = function(self, area)
		return {
			{"+4 Chips", false},
			{"$4 at End of Round", false},
			{"+4 Mult", true},
			{"X4 Mult", false}
		}
	end
}

UTDR_Modules.Tenna.Quiz{
	key = "balala",
	questions = function(self, area)
		return {
			{"Joker Poker", false},
			{"Fool's Gambit", false},
			{"Rogue Poker", false},
			{"Balatro", true}
		}
	end
}

UTDR_Modules.Tenna.Quiz{
	key = "dev",
	pool = "Joker",
	card_post = function(self, area)
		-- I don't wanna add 4 new hidden Jokers for this. The descriptions are hidden anyways
		for i = 0, 3 do
			local c = SMODS.create_card({key="j_square", area = area, no_edition = true})
			c.children.center.atlas = G.ASSET_ATLAS.UTDR_devs
			c.children.center:set_sprite_pos({x=i%2,y=math.floor(i/2)})
			area:emplace(c)
		end
	end,
	questions = function(self, area)
		return {
			{"Vio Marks", true},
			{"WhitetailAni", false},
			{"J8-Bit", false},
			{"slimestuff.", false}
		}
	end
}

UTDR_Modules.Tenna.Quiz{
	key = "jokercount",
	questions = function(self, area)
		local count = 0 -- Keep Joker count correct even when more are added
		for i, v in ipairs(G.P_CENTER_POOLS.Joker) do
			local a = v.mod and v.mod.id == "UTDR" and not v.no_collection
			count = a and count + 1 or count
		end

		return {
			{"At least 4", true},
			{"90", false},
			{"165", false},
			{tostring(count), true}
		}
	end
}

UTDR_Modules.Tenna.Quiz{
	key = "reskins",
	questions = function(self, area)
		return {
			{"Planet Cards", true},
			{"Tarot Cards", false},
			{"Spectral Cards", false}
		}
	end
}

