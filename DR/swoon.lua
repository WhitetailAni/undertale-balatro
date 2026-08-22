local sounds = {
	"bageldefeat",
	"closet_impact",
	"damage",
	"glassbreak",
	"impact",
	"knight_cut2"
}

for _, v in ipairs(sounds) do
	SMODS.Sound{
		key = "swoon_"..v,
		path = "swoon/"..v..".ogg"
	}
end

UTDR_Modules.Swoon = {
	timer = 0,
	image = love.graphics.newImage(love.image.newImageData(SMODS.NFS.newFileData(SMODS.current_mod.path ..
		"assets/swoon.png"))),
	play = function(len)
		G.E_MANAGER:add_event(Event({func=function()
			UTDR_Modules.Swoon.timer = len
			play_sound("UTDR_swoon_knight_cut2", .06, 8)
			play_sound("UTDR_swoon_knight_cut2", .1, 8)
			play_sound("UTDR_swoon_knight_cut2", .12, 8)
			play_sound("UTDR_swoon_knight_cut2", .18, 8)
			play_sound("UTDR_swoon_knight_cut2", .24, 8)
		return true end}))

		G.E_MANAGER:add_event(Event({func=function() return UTDR_Modules.Swoon.timer == 0 end}))
		G.E_MANAGER:add_event(Event({func=function()
			play_sound("UTDR_swoon_impact")
			play_sound("UTDR_swoon_closet_impact")
			play_sound("UTDR_swoon_closet_impact", .5)
			play_sound("UTDR_swoon_bageldefeat", .8, .8)
			play_sound("UTDR_swoon_damage")
			play_sound("UTDR_swoon_glassbreak", .4, .8)
			play_sound("UTDR_swoon_glassbreak", .3, .6)
		return true end}))
	end
}

SMODS.ScreenShader {
	key = "UTDR_swoon",
	shader = "UTDR_empty", -- Using a screenshader so that other screenshader effects get applied to it
	should_apply = function(self)
		return UTDR_Modules.Swoon.timer > 0
	end,
	order = -1,
	draw = function(self,shader,canvas)
		local w,h = love.graphics.getDimensions()
		local iw,ih = UTDR_Modules.Swoon.image:getDimensions()
		love.graphics.clear(0,0,0)
		love.graphics.setColor(1,1,1)
		love.graphics.draw(UTDR_Modules.Swoon.image,w/2,h/2,0,3,3,iw/2,ih/2)
	end
}

G.E_MANAGER:add_event(Event({func=function()
	local update_hook = love.update
	function love.update(dt)
		update_hook(dt)
		if UTDR_Modules.Swoon.timer > 0 then UTDR_Modules.Swoon.timer = math.max(UTDR_Modules.Swoon.timer - dt,0) end
	end
return true end}))