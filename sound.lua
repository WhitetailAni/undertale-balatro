local sounds = {
	"your_taking_too_long",
	"your_too_too",
	"ominous",
	"thornring_equip",
	"ominous_cancel",
	"moss",
	"lvup",
	"bark",
	"meow",
	"dummy",
	"shadowguy_1",
	"shadowguy_2",
	"shadowguy_3",
	"shadowguy_gone",
	"_",
	"egg",
	"pipis_boom",
	"tenna_blip_1",
	"tenna_blip_2",
	"tenna_blip_3",
	"tenna_blip_4",
	"tenna_blip_5",
	"tenna_blip_6",
	"tenna_blip_7",
	"tenna_blip_8",
	"tenna_blip_9",
	"tenna_blip_10",
	"omega_flowey",
	"asriel",
	"gaster",
	"sans",
	"papyrus",
	"alphys",
	"revivemint",
	"ERAM",
	"true_reset",
	"badexplosion",
	"amalgam",
	"netskie",
	"points1",
	"points2",
	"points4",
	"points6",
	"points8",
	"points10",
	"points15",
	"points20",
	"points60",
	"pipis_laugh",
	"win",
	"lose",
	"buy",
	"ralseis",
}

local volume = {
	moss = 1.5,
	pipis_laugh = 1.5
}

local pitch = {
	pipis_laugh = 1.4
}

for i, v in ipairs(sounds) do
	SMODS.Sound {
		key = v,
		path = v..".ogg",
		pitch = pitch[v] or 1.0,
		volume = volume[v] or 0.7
	}
end