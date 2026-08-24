UTDR_Modules.Capsule = {}

function UTDR_Modules.Capsule.add_vouchers()
	for key, value in pairs(G.P_CENTERS) do
		if value.set == "Voucher" then
			G.GAME.capsule.gold_prizes[#G.GAME.capsule.gold_prizes + 1] = key
		end
	end
end

local function did_win_gold(bet)
	local remaining = #G.GAME.capsule.gold_prizes
	local remaining_block = 0.1 + (remaining / 50)
	local oldbet_block = 1 + (G.GAME.capsule.last_bet / 50)
	
	local chance = 5 + (bet - 100) * remaining_block * oldbet_block
	G.GAME.capsule.last_bet = bet
	chance = chance / 100
	return pseudorandom("capsule_gold") > chance
end

local function wow_that_was_so_gold(input, filter)
	local possible_keys = input
	local knightmare = {}
	for _, value in ipairs(filter) do
		knightmare[value] = true
	end
	
	for i = #possible_keys, 1, -1 do
		if knightmare[possible_keys[i]] then
			table.remove(possible_keys, i)
		end
	end
	return possible_keys
end

function UTDR_Modules.Capsule.get_reward(bet)
	if bet == 1225 then
		return {
			key = "j_UTDR_lacquer_triangle",
			december = true			
		}
	elseif did_win_gold(bet) then
		local gold_prize_key = pseudorandom_element(G.GAME.capsule.gold_prizes, "capsule_prize_gold")
		
		--ensure no duplicate gold prizes, unless you got showman!
		while #SMODS.find_card("j_showman") == 0 and #SMODS.find_card(gold_prize_key) > 0 and G.P_CENTERS[gold_prize_key].set == "Joker" do
			gold_prize_key = pseudorandom_element(G.GAME.capsule.gold_prizes, "capsule_prize_gold_attempt_2")
		end
		G.GAME.capsule.gold_prizes[gold_prize_key] = nil
		return {
			key = gold_prize_key,
			gold = true
		}
	end
	
	local possible_keys = { }
	for key, value in pairs(G.P_CENTERS) do
		if value.set == "Tarot" or value.set == "Planet" or value.set == "Spectral" or value.set == "Joker" then
			possible_keys[#possible_keys + 1] = key
		end
	end
	
	--remove gold prize keys, cannot_pull keys
	possible_keys = wow_that_was_so_gold(possible_keys, G.GAME.capsule.gold_prizes)
	possible_keys = wow_that_was_so_gold(possible_keys, G.GAME.capsule.cannot_pull)
	
	--if you put in more than 100 points, remove common jokers/planet cards from the pool
	if bet > 100 then
		for i = 1, #possible_keys do
			if G.P_CENTERS[possible_keys[i]].set == "Planet" or G.P_CENTERS[possible_keys[i]].rarity == 1 then
				possible_keys[i] = nil
			end
		end
	end
	
	--ensure that you cannot pull 2 prizes in a row
	if #SMODS.find_card("j_showman") == 0 then
		for i = 1, #possible_keys do
			if #SMODS.find_card(possible_keys[i]) > 0 and G.P_CENTERS[possible_keys[i]].set == "Joker" then
				possible_keys[i] = nil
			end
		end
	end
	
	return {
		key =  pseudorandom_element(possible_keys, "capsule_prize_broke_ass"),
	}
end