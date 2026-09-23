local dr = UTDR.config["deltarune"]

return {
	descriptions = {
		Blind = {
			bl_wheel = {
				text = {
					"#1# in #2# cards get",
				},
			},
		},
		Voucher = {
			v_UTDR_rippling_stars = {
				name = "Rippling Stars",
				text = {
					"{C:z_rank}Z-Rank{} is",
					"{C:attention}no longer earnable",
					"at end of ante",
				},
			},
			v_UTDR_fallen_star = {
				name = "Fallen Star",
				text = {
					"{C:t_rank}T-Rank{} and {C:s_rank}S-Rank",
					"grant {C:points}100 POINTs",
					"{C:attention}extra{} at end of ante",
				},
			}
		},
		Joker = {
			j_UTDR_froggit = {
				name = "Froggit",
				text = {
					"Each played card",
					"gives {C:chips}+#1#{} Chips and",
					"{C:mult}+#2#{} Mult when scored",
				},
			},
			j_UTDR_toy_knife = {
				name = "Toy Knife",
				text = {
					"{C:mult}+#1#{} Mult every",
					"{C:attention}#2#{} hands played",
					"{C:inactive}#3# remaining",
				},
			},
			j_UTDR_flowey = {
				name = "Flowey",
				text = {
					"{C:mult}+#1#{} Mult",
					"{C:red}-#2#{} hand size",
				},
			},
			j_UTDR_flowey_yaoi = {
				name = "Yaoi",
				text = {
					"{C:mult}+#1#{} Mult",
					"{C:red}-#2#{} hand size",
				},
			},
			j_UTDR_ribbon = {
				name = "Faded Ribbon",
				text = {
					"{C:attention}#3#s{} have a",
					"{C:green}#1# in #2#{} chance to be",
					"destroyed",
				},
			},
			j_UTDR_napstablook = {
				name = "Napstablook",
				text = {
					"{C:chips}+#1#{} Chips for each",
					"empty {C:attention}Joker{} slot",
					"{s:0.8}#3# included{}",
					"{C:inactive}(Currently {C:chips}+#2#{} Chips)",
				},
			},
			j_UTDR_candy = {
				name = "Monster Candy",
				text = {
					"Each played {C:attention}Ace{}, {C:attention}2{}, or {C:attention}3{}",
					"gives {C:mult}+#1#{} Mult when scored",
					"{C:green}#2# in #3#{} chance this card is",
					"destroyed at end of round",
				},
			},
			j_UTDR_bandage = {
				name = "Bandage",
				text = {
					"{C:chips}+#1#{} Chips",
					"and {C:mult}+#2#{} Mult",
				},
			},
			j_UTDR_fallen_human = {
				name = "{element:1}Fallen Human",
				text = {
					"{C:attention}+#1#{} hand size for",
					"each {C:attention}Joker{} card",
					"{C:inactive}(Currently {C:attention}+#2#{C:inactive} hand size)",
				},
			},
			j_UTDR_stick = {
				name = "Stick",
				text = {
					"{X:mult,C:white}X#1#{} Mult",
				},
			},
			j_UTDR_spider_donut = {
				name = "Spider Donut",
				text = {
					"Each played {C:attention}#3#{} gives",
					"{C:mult}+#1#{} Mult when scored",
					"Each played {C:attention}#4#{} gives",
					"{C:mult}+#2#{} Mult when scored",
					"and {C:attention}destroys{} this",
					"Joker after scoring",
				},
			},
			j_UTDR_ruins = {
				name = "Ruins",
				text = {
					"{C:chips}+#1#{} Chips if played",
					"hand contains",
					"{C:attention}4{} or fewer cards",
				},
			},
			["j_UTDR_butterscotch-cinnamon_pie"] = {
				name = "Butterscotch-Cinnamon Pie",
				text = {
					"Sell this card to",
					"{C:attention}end{} the current Blind",
					"without {C:money}cashing out{}",
					"{C:inactive}(Excludes {C:attention}Boss Blinds{C:inactive})",
				},
			},
			j_UTDR_toriel = {
				name = "Toriel",
				text = {
					"When {C:attention}Boss Blind{} is",
					"selected, create an",
					"{C:green}#2#{} or {C:red}#3#{} {C:attention}Joker{}",
					"{C:inactive}(Must have room){}",
				},
			},
			j_UTDR_snail_pie = {
				name = "Snail Pie",
				text = {
					"Sell this card to",
					"apply {C:dark_edition}#1#{}, {C:dark_edition}#2#{},",
					"or {C:dark_edition}#3#{} to",
					"{C:attention}#4#{} random Jokers",
				},
			},
			j_UTDR_home = {
				name = "Home",
				text = {
					"{C:chips}Chips{} are rounded up to",
					"next multiple of {C:attention}#1#{}",
					"{C:mult}Mult{} is rounded up to",
					"next multiple of {C:attention}#2#{}",
				},
			},

			j_UTDR_monster_kid = {
				name = "Monster Kid",
				text = {
					"{C:green}#1# in #2#{} chance for {C:mult}+#3#{} Mult",
					"{C:green}#1# in #2#{} chance for {C:chips}-#4#{} Chips",
				},
			},
			j_UTDR_manly_bandana = {
				name = "Manly Bandana",
				text = {
					"{C:mult}+#1#{} Mult for each",
					"remaining {C:blue}Hand{}",
				},
			},
			j_UTDR_snowman_piece = {
				name = "Snowman Piece",
				text = {
					"Gains {C:chips}+#1#{} Chips at end of round,",
					"{C:red}self-destructs{} after {C:attention}#2#{} {C:inactive}[#3#]{} rounds",
					"{C:inactive}(Currently {C:chips}+#4#{C:inactive} Chips)",
				},
			},
			j_UTDR_tough_glove = {
				name = "Tough Glove",
				text = {
					"Gains {C:mult}+#1#{} Mult",
					"if played hand",
					"contains a {C:attention}#2#{}",
					"{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult)",
				},
			},
			j_UTDR_nice_cream = {
				name = "Nice Cream",
				text = {
					"{C:green}#1# in #2#{} chance to {C:attention}create{} a {C:tarot}#4#{}",
					"card when a {C:planet}#5#{} card is used",
					"{C:green}#1# in #3#{} chance to be {C:attention}destroyed{}",
					"when a {C:planet}#5#{} card is used",
					"{C:inactive}(Must have room){}",
				},
			},
			j_UTDR_silver_key = {
				name = "Silver Key",
				text = {
					"Create a {C:spectral}#1#{} card",
					"when {C:attention}Boss Blind{}",
					"is defeated",
					"{C:inactive}(Must have room){}",
				},
			},
			j_UTDR_sans = {
				name = "{f:UTDR_ComicSansUT}sans.",
				text = {
					"{X:mult,C:white,f:UTDR_ComicSansUT} x#1# {f:UTDR_ComicSansUT} mult if played",
					"{f:UTDR_ComicSansUT}hand is a {f:UTDR_ComicSansUT,C:attention}#2#{f:UTDR_ComicSansUT}",
				},
			},
			j_UTDR_snowdin = {
				name = "Snowdin",
				text = {
					"Creates a {C:planet}#2#{}",
					"Card if played hand",
					"contains a {C:attention}#1#{}",
					"{C:inactive}(Must have room){}",
				},
			},
			j_UTDR_papyrus = {
				name = "{f:UTDR_PapyrusUT}THE GREAT PAPYRUS!",
				text = {
					"{f:UTDR_PapyrusUT}RETRIGGER ALL SCORED",
					"{f:UTDR_PapyrusUT}CARDS IF PLAYED HAND",
					"{f:UTDR_PapyrusUT}CONTAINS A {f:UTDR_PapyrusUT,C:attention}#1#{f:UTDR_PapyrusUT}!!!",
				},
			},
			j_UTDR_mad_mew_mew = {
				name = "Mad Mew Mew",
				text = {
					"Earn {C:money}$#1#{} when a {C:attention}#2#{}",
					"or {C:attention}#3#{} is destroyed",
				},
			},
			j_UTDR_echo_flower = {
				name = "Echo Flower",
				text = {
					"Retriggers {C:attention}every{}",
					"{C:attention}other{} scored card",
				},
			},
			j_UTDR_old_tutu = {
				name = "Old Tutu",
				text = {
					"Retrigger all",
					"played {C:attention}#1#s{}",
				},
			},
			j_UTDR_undyne = {
				name = "Undyne",
				text = {
					"Each card of {C:spades}#2#{}",
					"suit held in hand",
					"gives {X:mult,C:white}X#1#{} Mult",
				},
			},
			j_UTDR_ballet_shoes = {
				name = "Ballet Shoes",
				text = {
					"Gains {C:chips}+#1#{} Chips",
					"when a {C:attention}playing card{}",
					"is destroyed",
					"{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)",
				},
			},
			j_UTDR_waterfall = {
				name = "Waterfall",
				text = {
					"Each card of {C:diamonds}#4#{}",
					"suit held in hand has a",
					"{C:green}#1# in #2#{} chance to give {C:money}$#3#{}",
				},
			},

			j_UTDR_sea_tea = {
				name = "Sea Tea",
				text = {
					"{C:chips}+#1#{} Chips",
					"{C:chips}#2#{} Chips per",
					"round played",
				},
			},
			j_UTDR_cloudy_glasses = {
				name = "Cloudy Glasses",
				text = {
					"{C:attention}#1#s{} can",
					"{C:attention}no longer break",
				},
			},
			j_UTDR_gerson = {
				name = "Gerson",
				text = {
					"All cards and packs",
					"in shop are {C:money}$#1#{} cheaper",
				},
			},
			j_UTDR_torn_notebook = {
				name = "Torn Notebook",
				text = {
					"Each card of {C:clubs}#2#{}",
					"suit held in hand",
					"gives {C:chips}+#1#{} Chips",
				},
			},
			j_UTDR_abandoned_quiche = {
				name = "Abandoned Quiche",
				text = {
					"{C:green}#1# in #2#{} chance this card is",
					"{C:attention}destroyed{} at end of round",
					"and creates {C:attention}#3#{} Tags",
				},
			},
			j_UTDR_punch_card = {
				name = "Punch Card",
				text = {
					"{X:mult,C:white}X#1#{} Mult every",
					"{C:attention}#2#{} hands played",
					"{C:inactive}#3# remaining",
				},
			},
			j_UTDR_temmie_flakes = {
				name = "Temmie Flakes",
				text = {
					"{C:blue}pLaY twO!!!1!!{}",
				},
			},
			j_UTDR_mad_dummy = {
				name = "Mad Dummy",
				text = {
					"{C:red}Destroys{} {C:attention}#1#{} random card",
					"held in hand at end of round",
				},
			},
			j_UTDR_temmie_armor = {
				name = "Temmie Armor",
				text = {
					"Played {C:attention}Enhanced #2#s{} each",
					"give {X:mult,C:white}X#1#{} Mult when scored",
				},
			},
			j_UTDR_mystery_key = {
				name = "Mystery Key",
				text = {
					"If {C:attention}first hand{} of round is",
					"a pair of {C:attention}#1#s{}, destroy one",
					"and create a {C:spectral}#2#{} card",
					"{C:inactive}(Must have room){}",
				},
			},
			j_UTDR_hotland = {
				name = "Hotland",
				text = {
					"If {C:attention}first hand{} of round has",
					"only one played card, add a",
					"random {C:attention}Seal{} to it",
				},
			},
			j_UTDR_instant_noodles = {
				name = "Instant Noodles",
				text = {
					"{X:mult,C:white}X#1#{} Mult",
					"Destroyed when",
					"{C:attention}Boss Blind{} is defeated",
				},
			},
			j_UTDR_undyne_the_undying = {
				name = "Undyne the Undying",
				text = {
					"This Joker gains {C:mult}+#1#{} Mult",
					"for every card",
					"{C:attention}discarded{} this round",
					"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
				},
			},
			j_UTDR_alphys = {
				name = "Alphys",
				text = {
					"Gives a random {C:attention}Bonus{}",
					"when Blind is selected",
				},
			},
			j_UTDR_alphys_one = {
				name = "Alphys",
				text = {
					"{C:blue}+#1#{} Hands",
					"{C:inactive}(Effect changes",
					"{C:inactive}at end of round)",
				},
			},
			j_UTDR_alphys_two = {
				name = "Alphys",
				text = {
					"{C:red}+#1#{} Discards",
					"{C:inactive}(Effect changes",
					"{C:inactive}at end of round)",
				},
			},
			j_UTDR_alphys_three = {
				name = "Alphys",
				text = {
					"{C:attention}+#1#{} hand size",
					"{C:inactive}(Effect changes",
					"{C:inactive}at end of round)",
				},
			},
			j_UTDR_alphys_four = {
				name = "Alphys",
				text = {
					"{C:chips}+#1#{} Chips",
					"{C:inactive}(Effect changes",
					"{C:inactive}at end of round)",
				},
			},
			j_UTDR_alphys_five = {
				name = "Alphys",
				text = {
					"{C:mult}+#1#{} Mult",
					"{C:inactive}(Effect changes",
					"{C:inactive}at end of round)"
				},
			},
			j_UTDR_alphys_six = {
				name = "Alphys",
				text = {
					"{X:mult,C:white}X#1#{} Mult",
					"{C:inactive}(Effect changes",
					"{C:inactive}at end of round)",
				},
			},
			j_UTDR_alphys_seven = {
				name = "Alphys",
				text = {
					"{C:attention}Retrigger{} all scoring cards",
					"{C:inactive}(Effect changes at end of round)",
				},
			},
			j_UTDR_alphys_eight = {
				name = "Alphys",
				text = {
					"Disables effect of {C:attention}Boss Blind",
					"{C:inactive}(Effect changes at end of round)",
				},
			},
			j_UTDR_mettaton = {
				name = "Mettaton",
				text = {
					"If {C:attention}first hand{} of round is",
					"a single card of {C:clubs}#2#{} suit,",
					"{C:red}destroy{} it and earn {C:money}$#1#{}",
				},
			},

			j_UTDR_true_lab = {
				name = "True Lab",
				text = {
					"Gains {C:mult}+#1#{} Mult when",
					"a card is {C:attention}copied{}",
					"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
				},
			},
			j_UTDR_burnt_pan = {
				name = "Burnt Pan",
				text = {
					"{C:chips}+#1#{} chips for each",
					"held consumable",
					"{C:tarot}+#2#{} consumable slots",
					"{C:inactive}(Currently {C:chips}+#3#{C:inactive} Chips)",
				},
			},
			j_UTDR_yaoi = {
				name = "Royal Guards",
				text = {
					"Gains {C:chips}+#1#{} Chips",
					"if played hand",
					"contains a {C:attention}#2#{}",
					"{C:inactive}(Currently {C:chips}+#3#{C:inactive} Chips)",
				},
			},
			j_UTDR_stained_apron = {
				name = "Stained Apron",
				text = {
					"Earn {C:money}$#1#{} on {C:attention}every{}",
					"{C:attention}other{} scored card",
				},
			},
			j_UTDR_amalgam = {
				name = "Amalgamates",
				text = {
					"At end of round, randomize",
					"{C:attention}rank{} and {C:attention}suit{} of {C:attention}all",
					"cards held in hand"
				},
			},
			j_UTDR_hot_dog = {
				name = "Hot Dog",
				text = {
					"Sell this card to",
					"create {C:attention}#1#{} random",
					"{C:tarot}#2#{} cards",
					"{C:inactive}(Must have room){}",
				},
			},
			j_UTDR_glamburger = {
				name = "Glamburger",
				text = {
					"{C:green}#6# in #1#{} chance for {C:mult}+#2#{} Mult",
					"{C:green}#6# in #3#{} chance to win {C:money}$#4#{}",
					"{C:green}#6# in #5#{} chance this card is",
					"{C:attention}destroyed{} at end of round",
				},
			},
			j_UTDR_muffet = {
				name = "Muffet",
				text = {
					"{C:attention}+#1#{} hand size if you",
					"have at least {C:money}$#2#{}",
				},
			},
			j_UTDR_mettaton_steak = {
				name = "Steak in the Shape of Mettaton's Face",
				text = {
					"{C:attention}#2#{} held in hand give {C:mult}+#1#{} Mult",
				},
			},
			j_UTDR_hot_cat = {
				name = "Hot Cat",
				text = {
					"Sell this card to",
					"create {C:attention}#1#{} random",
					"{C:planet}#2#{} cards",
					"{C:inactive}(Must have room){}",
				},
			},
			j_UTDR_burgerpants = {
				name = "Burgerpants",
				text = {
					"Earn {C:money}$#1#{} at",
					"end of round",
					"{C:red}-#2#{} hand size",
				},
			},
			j_UTDR_cowboy_hat = {
				name = "Cowboy Hat",
				text = {
					"Played cards with",
					"{C:attention}numerical{} ranks give",
					" {C:mult}+#1#{} or {C:mult}+#2#{} Mult when scored",
				},
			},
			j_UTDR_mettaton_ex = {
				name = "Mettaton EX",
				text = {
					"{X:mult,C:white}X#1#{} Mult for every",
					"{C:money}$#2#{} you have",
					"{C:inactive}(Currently {X:mult,C:white}X#3#{C:inactive} Mult)",
				},
			},
			j_UTDR_empty_gun = {
				name = "Empty Gun",
				text = {
					"If {C:attention}first hand{} of",
					"round is a {C:attention}secret{}",
					"{C:attention}hand{}, retrigger all",
					"played cards",
				},
			},
			j_UTDR_CORE = {
				unlock = {
					"Discard a",
					"{E:1,C:attention}#1#",
				},
				text = {
					"{C:attention}#1#s{} count as",
					"{C:attention}#2#es{}",
				},
				name = "CORE",
			},

			j_UTDR_worn_dagger = {
				unlock = {
					"Have no more than",
					"{E:1,C:money}$50{} at any point ",
					"during a run",
				},
				text = {
					"Scoring {C:hearts}#3#{} give",
					"{C:money}$#1#{} or {C:chips}+#2#{}",
					"Chips when scored",
				},
				name = "Worn Dagger",
			},
			j_UTDR_patience = {
				unlock = {
					"Win a run {E:1,C:attention}without{}",
					"skipping any Blinds",
				},
				text = {
					"Doubles {C:money}interest{} and",
					"{C:money}Blind payout{} if round",
					"was won on {C:attention}final hand{}",
				},
				name = "{element:1}Patience",
			},
			j_UTDR_boss_monster_soul = {
				name = "{element:1}Boss Monster Soul",
				unlock = {
					"Discard a",
					"{E:1,C:attention}#1#{}",
				},
				text = {
					"Gains {C:chips}+#1#{} Chips when a playing",
					"card is either {C:attention}destroyed{}",
					"or {C:attention}added{} to your deck",
					"{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)",
				},
			},
			j_UTDR_bravery = {
				unlock = {
					"Play a hand containing",
					"at least 4 {E:1,C:attention}#1#s{}",
				},
				text = {
					"This Joker gains {X:mult,C:white}X#1#{} Mult",
					"for each shop visited",
					"{C:attention}without buying anything{}",
					"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
				},
				name = "{element:1}Bravery",
			},
			j_UTDR_last_dream = {
				unlock = {
					"Reach Ante",
					"level {E:1,C:attention}10{}",
				},
				text = {
					"{C:chips}+#1#{} Chips",
					"if all played cards",
					"are of {C:hearts}#2#{} suit",
				},
				name = "Last Dream",
			},
			j_UTDR_justice = {
				unlock = {
					"Play a",
					"{E:1,C:attention}secret hand",
				},
				text = {
					"This Joker gains",
					"{C:mult}+#1#{} Mult at",
					"end of round",
					"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
				},
				name = "{element:1}Justice",
			},
			j_UTDR_asgore = {
				unlock = {
					"Have at least",
					"{E:1,C:attention}7{} Jokers",
				},
				text = {
					"{X:mult,C:white}X#1#{} Mult for every",
					"{C:attention}Consumable{} card held",
					"{C:blue}+#2#{} consumable slots",
					"{C:inactive}(Currently {X:mult,C:white}X#3#{C:inactive} Mult)",
				},
				name = "Asgore",
			},
			j_UTDR_asriel = {
				unlock = {
					"Play a 5 card hand",
					"containing only {E:1,C:attention}#4#s{}",
				},
				text = {
					"Each played {C:attention}#1#{} gives",
					"{X:mult,C:white}X#2#{} Mult when scored",
					"{C:inactive}Activates after {C:attention}#3# {C:inactive}[#4#] rounds",
				},
				name = "{E:UTDR_asriel}ASRIEL DREEMURR",
			},
			j_UTDR_asriel_active = {
				text = {
					"Each played {C:attention}#1#{} gives",
					"{X:mult,C:white}X#2#{} Mult when scored",
				},
				name = "{E:UTDR_asriel}ASRIEL DREEMURR",
			},
			j_UTDR_omega_flowey = {
				unlock = {
					"Lose a run on",
					"Ante level {E:1,C:attention}8{}",
				},
				text = {
					"Prevents Death if chips",
					"scored are at least",
					"{C:attention}#1#%{} of required chips,",
					"gains {X:mult,C:white}X#2#{} Mult when",
					"{C:attention}Death is prevented{}",
					"{C:inactive}(Currently {X:mult,C:white}X#3#{C:inactive} Mult)",
				},
				name = "Omega Flowey",
			},
			j_UTDR_integrity = {
				unlock = {
					"Play any hand",
					"type {E:1,C:attention}25{} times",
					"in one run",
				},
				text = {
					"{C:chips}+#1#{} Chips if",
					"all played cards have",
					"the {C:attention}same{} Enhancement",
				},
				name = "{element:1}Integrity",
			},
			j_UTDR_real_knife = {
				unlock = {
					"Thin your full",
					"deck to {E:1,C:attention}30{}",
					"cards or less",
				},
				text = {
					"Gains {X:mult,C:white}X#1#{} Mult when",
					"a {C:attention}playing card{} with",
					"{C:hearts}Heart{} suit is destroyed",
					"{C:inactive}(Currently {X:mult,C:white}X#2#{} Mult)",
				},
				name = "Real Knife",
			},
			j_UTDR_kindness = {
				unlock = {
					"Use no {E:1,C:red}discards{} for",
					"{E:1,C:attention}3{} consecutive rounds",
				},
				text = {
					"{C:dark_edition}#1#{} Cards grant {C:chips}+#2#{} Chips",
					"{C:dark_edition}#3#{} Cards grant {C:mult}+#4#{} Mult",
					"{C:dark_edition}#5#{} Cards grant {X:mult,C:white}X#6#{} Mult",
				},
				name = "{element:1}Kindness",
			},
			j_UTDR_heart_locket = {
				unlock = {
					"Have at least {E:1,C:attention}5{}",
					"{E:1,C:attention}#1#s{} in",
					"your deck",
				},
				text = {
					"{C:steel}#4#s{} give",
					"{C:mult}+#3#{} Mult when scored",
				},
				name = "Heart Locket",
			},
			j_UTDR_perseverance = {
				unlock = {
					"Win a run on",
					"{E:1,C:attention}your final hand{}",
				},
				text = {
					"{X:mult,C:white}X#1#{} Mult if you have",
					"at most {C:attention}#2#{} Enhanced",
					"cards in your #4#",
					"{C:inactive}(Currently {C:attention}#3#{C:inactive})",
				},
				name = "{element:1}Perseverance",
			},
			j_UTDR_chara = {
				unlock = {
					"{E:1,C:ballgame}Five heart nines.{}",
				},
				text = {
					"{X:ballgame,C:white}X#1#{} Mult",
					"{C:ballgame}-#2#{} hand size",
				},
				name = "#3#​",
			},

			j_UTDR_new_home = {
				name = "New Home",
				text = {
					"{C:chips}+#1#{} Chips in {C:attention}final",
					"{C:attention}hand{} of round",
				},
			},
			j_UTDR_barrier = {
				unlock = {
					"In one hand,",
					"earn at least",
					"{E:1,C:attention}1e11{} chips",
				},
				text = {
					"{C:attention}#2# cards{} give",
					"{C:money}$#1#{} when scored",
				},
				name = "The Barrier",
			},
			j_UTDR_the_end = {
				unlock = {
					"Win a run with any",
					"deck on at least",
					"{E:1,V:1}#1#{} difficulty",
				},
				text = {
					"Earn {C:money}$12{} when",
					"{C:attention}Boss Blind{} is defeated",
				},
				name = "The End",
			},
			j_UTDR_surface = {
				unlock = {
					"Have at least {E:1,C:attention}5",
					"{E:1,C:attention}#1#s{} in",
					"your deck",
				},
				text = {
					"Played {C:attention}#2#s{} give",
					"{C:mult}+#1#{} Mult when scored",
				},
				name = "The Surface",
			},
			j_UTDR_dummy = {
				name = "Dummy",
				text = {
					"{C:chips}+#1#{} Chips for",
					"each {C:attention}Joker{}",
					"{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)",
				},
			},
			j_UTDR_toby_temmie = {
				name = "Toby and Temmie",
				text = {
					"Creates a {C:purple}#2#",
					"when {C:attention}Boss Blind is defeated",
				},
			},
			j_UTDR_annoying_dog = {
				name = "Annoying Dog",
				text = {
					"{X:mult,C:white}X#1#{} Mult",
					"{C:red}-#2#{} consumable slots",
					"{C:joker_grey}+1 dogs",
				},
			},
			j_UTDR_mt_ebott = {
				name = "Mt. Ebott",
				text = {
					"{C:attention}+#1#{} hand size,",
					"{C:attention}lose all discards{}",
				},
			},
			j_UTDR_dog_residue = {
				name = "Dog Residue",
				text = {
					"{C:mult}+#1#{} Mult",
				},
			},
			j_UTDR_lesser_dog = {
				unlock = {
					"Scale Jokers {E:1,C:attention}121{} Times {C:inactive}[#1#]",
				},
				text = {
					"Gains {C:mult}+#1#{} Mult when",
					"other Jokers {C:attention}scale{}",
					"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
				},
				name = "Lesser Dog",
			},
			j_UTDR_doghole = {
				name = "Dog Hole",
				text = {
					"Doesn't grant {X:mult,C:white}X100{} Mult,",
					"because it {C:attention}wouldn't be very",
					"{C:attention}interesting{} if it did.",
				},
			},
			j_UTDR_dog_shrine = {
				text = {
					"{C:red}-$#1#{} at the end",
					"of round, {C:attention}and...?{}"
				},
				name = "Dog Shrine",
			},
			j_UTDR_true_reset = {
				unlock = {
					"Beat the {E:1,C:attention}Ante{}",
					"{E:1,C:attention}0{} Boss Blind",
				},
				text = {
					"{C:attention}Sell{} this card to {S:1.1,C:ballgame,E:2}destroy all",
					"{S:1.1,C:ballgame,E:2}Jokers{} and create an equal",
					"number of {C:dark_edition}#1#s{}",
				},
				name = "True Reset",
			},
			j_UTDR_mysterious_artifact = {
				name = "Mysterious Artifact",
				text = {
					"{C:red}???",
				},
			},
			j_UTDR_check_it_out_im_in_the_house_like_carpet = {
				text = {
					"Creates a {C:planet}#3#{} card",
					"after {C:attention}#2#{} {C:inactive}[#1#]{} hands played",
					"{C:inactive}(Must have room){}"
				},
				name = "Roast Chicken",
			},

			j_UTDR_amber_card = {
				name = "Amber Card",
				text = {
					"{C:blue}+#1#{} hands per round",
					"{C:red}-#2#{} hand size",
				},
			},
			j_UTDR_lancer_cookie = {
				name = "Lancer Cookie",
				text = {
					"{C:chips}+#1#{} Chips",
					"Destroyed when {C:attention}Boss",
					"{C:attention}Blind{} is defeated",
				},
			},
			j_UTDR_top_cake = {
				name = "Top Cake",
				text = {
					"Gains {X:mult,C:white}X#1#{} Mult per",
					"hand played, destroys",
					"itself after {C:attention}#2#{} {C:inactive}[#3#]{} hands",
					"{C:inactive}(Currently {X:mult,C:white}X#4#{C:inactive} Mult)",
				},
			},
			j_UTDR_thrash_machine = {
				name = "Thrash Machine",
				text = {
					"{C:chips}+#1#{} Chips when",
					"{C:red}#2#{} discards remaining",
				},
			},
			j_UTDR_k_round = {
				name = "K. Round",
				text = {
					"{C:chips}+#1#{} Chips for each {C:attention}hand{} played",
					"{C:red}#2#{} Chips for each {C:attention}discard{} used",
					"{C:inactive}(Currently {C:attention}+#3#{C:inactive} Chips)",
				},
			},
			j_UTDR_seam = {
				name = "Seam",
				text = {
					"Only {C:attention}Mega{} Booster Packs",
					"show up in shop",
				},
			},
			j_UTDR_lancer = {
				name = "Lancer",
				text = {
					"Played cards with",
					"{C:spades}#2#{} suit give",
					"{C:chips}+#1#{} Chips when scored",
				},
			},
			j_UTDR_king = {
				name = "Chaos King",
				text = {
					"Gains {X:mult,C:white}X#1#{} Mult when a",
					"{C:attention}playing card{} not of",
					"{C:spades}#3#{} suit is destroyed",
					"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
				},
			},
			j_UTDR_clover = {
				name = "Clover",
				text = {
					"Played cards with",
					"{C:clubs}#3#{} suit give",
					"{C:chips}+#1#{} Chips and",
					"{C:mult}+#2#{} Mult{} when scored",
				},
			},
			j_UTDR_jevil = {
				name = "Jevil",
				text = {
					"Retrigger all",
					"played {C:attention}#1#s{}",
				},
			},
			j_UTDR_scarlet_forest = {
				name = "Scarlet Forest",
				text = {
					"Gains {C:mult}+#1#{} Mult if played",
					"hand contains a {C:attention}#2#{}",
					"{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult)",
				},
			},
			j_UTDR_glowshard = {
				name = "Glowshard",
				text = {
					"Gains {C:money}$#1#{} of {C:attention}sell value",
					"when a card is sold",
				},
			},
			j_UTDR_rouxls = {
				name = "Rouxls Kaard",
				text = {
					"Gains {C:chips}+#1#{} Chips",
					"when played hand",
					"is a {C:attention}#2#{}",
					"{s:0.8}hand changes at end of round",
					"{C:inactive}(Currently {C:chips}+#3#{C:inactive} Chips)",
				},
			},
			j_UTDR_iron_shackle = {
				name = "Iron Shackle",
				text = {
					"{C:gold}#1#s{} and {C:steel}#2#s",
					"are considered the",
					"{C:attention}same enhancement",
				},
			},
			j_UTDR_devilsknife = {
				name = "Devilsknife",
				text = {
					"Played {C:attention}#2#s{} give",
					"{X:mult,C:white}X#1#{} Mult when scored",
				},
			},

			j_UTDR_sweet_capn_cakes = {
				name = "Sweet Cap'n Cakes",
				text = {
					"{C:common}#3#{} Jokers each",
					"give {C:chips}+#1#{} Chips and",
					"{C:mult}+#2#{} Mult when sccored",
				},
			},
			j_UTDR_kris_tea = {
				name = "Kris Tea",
				text = {
					"{C:chips}+#1#{} Chips for each played {C:spades}#7#{} card",
					"{X:mult,C:white}X#2#{} Mult for each played {C:hearts}#8#{} card",
					"{C:mult}+#3#{} Mult for each played {C:clubs}#9#{} card",
					"{C:money}$#4#{} for each played {C:diamonds}#10#{} card",
					"Destroyed after {C:attention}#5# {C:inactive}[#6#]{} rounds",
				},
			},
			j_UTDR_cyber_world = {
				name = "Cyber World",
				text = {
					"{C:green}#1# in #2#{} chance to create",
					"a {C:planet}#3#{} card when a",
					"{C:tarot}#4#{} card is used",
				},
			},
			j_UTDR_royal_pin = {
				name = "Royal Pin",
				text = {
					"Gains {C:chips}+#1#{} Chips when a",
					"{C:attention}face{} card is scored",
					"{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)",
				},
			},
			j_UTDR_starwalker = {
				name = "Starwalker",
				text = {
					"These cards are {C:red}Pissing me off.",
					"{C:chips}+#1#{} Chips if all played cards are       {C:diamonds}#2# suit{}",
				},
			},
			j_UTDR_tro_piss_walker = {
				name = "{E:UTDR_tropiss}Tropical Starwalker",
				text = {
					"These cards are {E:UTDR_tropiss}Tropissing me off.",
					"{C:chips}+#1#{} Chips if all played cards are       {E:UTDR_tropiss}#2# suit{}",
				},
			},
			j_UTDR_silver_watch = {
				name = "Silver Watch",
				text = {
					"Played cards give {C:mult}+#1#{}",
					"Mult when scored,",
					"{C:red}only one hand per round",
				},
			},
			j_UTDR_swatch = {
				name = "Swatch",
				text = {
					"This Joker gains {C:mult}+#1#{} Mult when",
					"{C:attention}anything{} is bought in the shop",
					"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
				},
			},
			j_UTDR_queen = {
				name = "Q5U4EX7YY2E9N",
				text = {
					"All Played {C:attention}Face{} Cards Become",
					"{C:steel}Steel Cards{} When Scored"
				},
			},
			j_UTDR_tasque_manager = {
				name = "Tasque Manager",
				text = {
					"{X:mult,C:white}X#1#{} Mult if your {C:attention{full",
					"{C:attention}deck{} is exactly {C:attention}#2#{} cards",
				},
			},
			j_UTDR_twin_ribbon = {
				name = "Twin Ribbon",
				text = {
					"{C:mult}+#1#{} Mult for each",
					"{C:attention}change{} in hand",
					"size from {C:attention}#2#",
					"{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult)",
				},
			},
			j_UTDR_revivemint = {
				name = "Revivemint",
				text = {
					"Creates a {C:tarot}#1#{} card",
					"when {C:attention}Blind{} is selected",
					"{C:green}#2# in #3#{} chance for this",
					"card to destroy itself",
					"when {C:attention}Blind{} is selected",
				},
			},
			j_UTDR_spamton = {
				name = "Spamton G. Spamton",
				text = {
					"Each played {C:attention}#4#{}, {C:attention}#5#{}, or {C:attention}#6#",
					"has a {C:green}#1# in #2#{} chance",
					"to give {C:money}$#3#{} when scored",
				},
			},
			j_UTDR_dealmaker = {
				name = "Dealmaker",
				text = {
					"Each scored card",
					"gives {C:money}$#1#{} when",
					"{C:red}#2#{} discards remaining",
				},
			},
			j_UTDR_spamton_neo = {
				name = "SPAMTON NEO",
				text = {
					"RETRIGGER [EveryHotSingle]",
					"{C:attention}1{}, {C:attention}9{}, OR {C:attention}7!!",
				},
			},
			j_UTDR_pipis = {
				name = "Pipis",
				text = {
					"{C:mult}-#1#{} Mult",
					"{X:mult,C:white}X#2#{} Mult during {C:attention}Boss Blind{}",
					"Destroyed when {C:attention}Boss",
					"{C:attention}Blind{} is defeated",
				},
			},

			j_UTDR_gingerguard = {
				name = "Ginger Guard",
				text = {
					"Played {C:steel}#2#s{} give",
					"{C:chips}+#1#{} Chips when scored",
				},
			},
			j_UTDR_ramb = {
				name = "Ramb",
				text = {
					"Creates a {C:tarot}#1#{} or {C:planet}#2#",
					"card at end of round",
					"{C:inactive}(Must have room)",
				},
			},
			j_UTDR_lanino_elnina = {
				name = "Lanino & Elnina",
				text = {
					"Upgrades a random",
					"{C:attention}Poker Hand{} when",
					"Blind is selected",
				},
			},
			j_UTDR_watercooler = {
				name = "Watercooler",
				text = {
					"Played {C:attention}#3#s{} give",
					"{C:money}$#1#{} when scored",
					"{s:0.8,C:watercooler}#2#        ",
				},
			},
			j_UTDR_tv_world = {
				name = "TV World",
				text = {
					"This Joker gains {C:mult}+#1#{} Mult",
					"per {C:attention}consecutive hand",
					"played with a {V:1}#2#{} card",
					"{s:0.8}suit changes at end of round",
					"{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult)",
				},
			},
			j_UTDR_oddcontroller = {
				name = "Odd Controller",
				text = {
					"{C:green}#1#{} and {C:red}#2#",
					"Jokers in shop are {C:attention}free",
				},
			},
			j_UTDR_shadowguy = {
				name = "Shadowguy",
				text = {
					"{C:attention}Poker Hands{} gain an",
					"additional {C:chips}+#1#{} Chips and",
					"{C:mult}+#2#{} Mult on level up",
				},
			},
			j_UTDR_tenna = {
				name = "Mr. (Ant) Tenna",
				text = {
					"When round begins, play a",
					" {element:1} ",
					"and give {C:white,X:mult}X#1#{} if successful"
				},
			},
			j_UTDR_mike = {
				name = "Mike",
				text = {
					"Earn {C:money}$#1#{} if played",
					"hand contains a",
					"{C:attention}#2#{}",
				},
			},
			j_UTDR_lightners_live = {
				name = "Lightners Live",
				text = {
					"Gains {C:mult}+#1#{} Mult for each",
					"consecutive hand containing",
					"a scoring {C:attention}#3#{} or {C:attention}#4#{}",
					"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)"
				}
			},
			j_UTDR_ERAM = {
				name = "ERAM",
				text = {
					"{C:attention}Discarded{} cards have",
					"a {C:green}#1# in #2#{} chance to",
					"be {C:red}destroyed",
				},
			},
			j_UTDR_HERO_SWORD = {
				name = "HERO_SWORD",
				text = {
					"Creates a {C:tarot}#1#{} card when a",
					"a {C:attention}playing card{} is destroyed",
					"{C:inactive}(Must have room)",
				},
			},
			j_UTDR_knight = {
				name = "The Roaring Knight",
				text = {
					"At end of round, destroy",
					"{C:ballgame}all cards held in hand",
					"and gain {X:mult,C:white}X#1#{} Mult",
					"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
				},
			},
			j_UTDR_blackshard = {
				name = "BlackShard",
				text = {
					"During {C:attention}Boss Blind{}, give",
					"{X:mult,C:white}X#1#{} Mult and played cards",
					"are {C:attention}retriggered{} when scored",
				},
			},
			j_UTDR_shadow_mantle = {
				name = "Shadow Mantle",
				text = {
					"Gain {C:blue}+#1#{} Hands",
					"and {C:red}+#2#{} Discards",
					"during {C:attention}Boss Blind{}",
				},
			},

			j_UTDR_cupwalker = {
				name = "Cuptains",
				text = {
					"Gains {C:chips}+#1#{} Chips",
					"if played hand is",
					"a {C:attention}#2#",
					"{C:inactive}(Currently {C:chips}+#3#{C:inactive} Chips)",
				},
			},
			j_UTDR_bittertear = {
				name = "BitterTear",
				text = {
					"The next {C:attention}#1#{} played",
					"cards give {C:money}$#2#{}",
					"when scored",
				},
			},
			j_UTDR_oldman = {
				name = "Old Man",
				text = {
					"This Joker gains {C:mult}+#1#{} Mult",
					"per {C:attention}consecutive{} hand",
					"without playing any hand",
					"type {C:attention}twice in a row",
					"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
					"{s:0.8,C:joker_grey}I'm old!",
				},
			},
			j_UTDR_missmizzle = {
				name = "Miss Mizzle",
				text = {
					"All Seals are",
					"considered",
					"{C:gold}#1#s{} ",
				},
			},
			j_UTDR_jackenstein = {
				name = "Jackenstein",
				text = {
					"{X:mult,C:white}X#1#{} Mult on {C:attention}first",
					"{C:attention}hand of round",
					"{X:mult,C:white}X#2#{} Mult on all",
					"subsequent hands",
				},
			},
			j_UTDR_axe_of_justice = {
				name = "Justice Axe",
				text = {
					"Played cards give",
					"{X:mult,C:white}X#1#{} Mult when scored",
				},
			},
			j_UTDR_sanctuary = {
				name = "Dark Sanctuary",
				text = {
					"Gives {C:mult}+#1#{} Mult for",
					"each card in your deck",
					"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
				},
			},
			j_UTDR_motherfucking_gerson_boom = {
				name = "Hammer of Justice",
				text = {
					"This Joker gains {X:mult,C:white}X#1#{} Mult per",
					"{C:attention}#3#{} redeemed this run",
					"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
				},
			},
			j_UTDR_second_sanctuary = {
				name = "Second Sanctuary",
				text = {
					"Gains {X:mult,C:white}X#1#{} Mult for each",
					"card {C:attention}drawn{} from your deck",
					"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
				},
			},
			j_UTDR_sound_of_justice = {
				name = "Sound of Justice",
				text = {
					"{C:green}#1# in #2#{} chance to {C:attention}retrigger",
					"each scored card",
					"{C:red}Blind requirements",
					"{C:red}are not displayed",
				},
			},
			j_UTDR_scarlixir = {
				name = "Scarlixir",
				text = {
					"Earn {C:money}$#1#{} at end of",
					"round, decreases",
					"by {C:red}-$#2#{} every round",
				},
			},
			j_UTDR_spawn = {
				name = "Titan Spawn",
				text = {
					"Gains {C:mult}+#1#{} Mult when a",
					"{C:attention}#3#{} is scored",
					"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
				},
			},
			j_UTDR_titan = {
				name = "Titan",
				text = {
					"Retrigger each played",
					"{C:attention}#2# #1#{} times",
				},
			},
			j_UTDR_princess_ribbon = {
				name = "Princess Ribbon",
				text = {
					"Played {C:attention}#2#s{} give",
					"{C:chips}+#1#{} Chips when scored",
				},
			},
			j_UTDR_philosopher = {
				name = "Philosopher",
				text = {
					"{C:planet}#1#{} cards may appear",
					"in any {C:attention}#2#",
				},
			},

			j_UTDR_the_lake = {
				name = "The Lake",
				text = {
					"Increases the rank of {C:attention}played",
					"{C:attention}but unscoring{} cards by {C:attention}#1#{}",
				},
			},
			j_UTDR_xaviers_lake = {
				name = "The Lake",
				text = {
					"Does anyone know how to get to {C:watercooler}The Lake... {C:inactive}The Lake.",
					"Does anyone know how to get to {C:watercooler}The Lake... {C:inactive}The Lake.",
					"Do {C:attention}you{} know how to get to {C:watercooler}The Lake... {C:inactive}The Lake?",
					"Do {C:attention}you{} know how to get to {C:watercooler}The Lake... {C:inactive}The Lake?",
					"Does anyone know how to get to {C:watercooler}The Lake... {C:inactive}The Lake.",
					"Oh No... I'm headed right towards the {C:red}Cyclone...{}"
				},
			},
			j_UTDR_aqua = {
				name = "{C:flower_aqua,element:1}Aqua ",
				text = {
					"Played cards give a",
					"{C:attention}random{} amount of",
					"{C:mult}Mult{} when scored",
				},
			},
			j_UTDR_petal_feather = {
				name = "Petal Feather",
				text = {
					"{C:attention}Adjacent{} hand types are",
					"considered the {C:attention}same",
					"{C:inactive}(ex: {C:attention}#1#{C:inactive} also contains",
					"{C:attention}#2#{C:inactive} and {C:attention}#3#{C:inactive})"
				},
			},
			j_UTDR_petal_feather_1hand = {
				name = "Petal Feather",
				text = {
					"{C:attention}Adjacent{} hand types are",
					"considered the {C:attention}same",
					"{C:inactive}(ex: {C:attention}#1#{C:inactive} also",
					"{C:inactive}contains {C:attention}#2#{C:inactive})"
				},
			},
			j_UTDR_seth = {
				name = "{C:flower_seth,element:1}Seth ",
				text = {
					"{C:green}#1# in #2#{} chance to upgrade your",
					"{C:attention}most played poker hand{}",
					"when a {C:planet}#3#{} card is used",
				},
			},
			j_UTDR_festival = {
				name = "Festival",
				text = {
					"{C:attention}+#1#{} card per",
					"Booster Pack"
				},
			},
			j_UTDR_yellow = {
				name = "{C:flower_yellow,element:1}Yellow ",
				text = {
					"{X:mult,C:white} X#1# {} Mult if scoring hand",
					"contains exactly {C:attention}#2# suits",
					"{C:inactive,s:0.75}(This Joker is {C:red,s:0.75}destroyed {C:inactive,s:0.75}if{}",
					"{C:inactive,s:0.75}it hasn't triggered this Ante)"
				}
			},
			j_UTDR_yellow_gay = {
				name = "{C:flower_yellow,element:1}Yellow ",
				text = {
					"{X:mult,C:white} X#1# {} Mult if scoring hand",
					"contains exactly {C:attention}#2# suits",
				}
			},
			j_UTDR_flower_castle = {
				name = "Flower Castle",
				text = {
					"Gains {C:chips}+#1#{} Chips for each",
					"played card of {C:clubs}#2#{} suit",
					"{C:inactive}(Currently {C:chips}+#3#{C:inactive} Chips)"
				},
			},
			j_UTDR_flowery = {
				name = "Flowery",
				text = {
					"Each played {C:attention}#2#{} gives",
					"{X:mult,C:white}X#1#{} Mult and is",
					" {C:attention}retriggered{} when scored",
				},
			},
			j_UTDR_flowery_scarf = {
				name = "Flowery Scarf",
				text = {
					"Played but {C:attention}unscoring",
					"cards are given a",
					"{C:attention}random Enhancement",
				},
			},
			j_UTDR_blue = {
				name = "{C:flower_blue,element:1}Blue ",
				text = {
					"{C:attention}Prevents Death{} if chips",
					"scored are at least",
					"{C:attention}#1#%{} of required chips,",
					"creates a {C:tarot}Tarot{} card when",
					"Death is prevented",
				},
			},
			j_UTDR_netskie = {
				name = "Netskie",
				text = {
					"{C:attention}Enhanced{} cards give",
					"{C:mult}+#1#{} Mult when scored",
					"{E:1,C:netskie}Kee kee~",
				},
			},
			j_UTDR_netskie_disguise = {
				name = "Netskie",
				text = {
					"{E:1,C:netskie}Kee kee~"
				},
			},
			j_UTDR_netskie_disguise_base = {
				name = "Default",
				text = {
					"{E:1,C:netskie}Kee kee~"
				},
			},
			j_UTDR_netskie_bad_disguise = {
				name = "Netskie",
				text = {
					"{C:attention}I'M{} the Original!",
					"{E:1,C:netskie}Kon, kon, kee kee!",
				},
			},
			j_UTDR_orange = {
				name = "{C:flower_orange,element:1}Orange ",
				text = {
					"{C:mult}+#1#{} Mult after a card is sold",
					"{C:inactive}(Resets at end of round)",
				},
			},
			j_UTDR_pink = {
				name = "{C:flower_pink,element:1}Pink",
				text = {
					"{C:green}#1# in #2#{} chance for",
					"each scoring card of",
					"{V:1}#4#{} suit to create",
					"a {C:dark_edition}#5#{} {V:2}#3#{} card",
					"{C:inactive}(Must have room){}"
				},
			},
			j_UTDR_pink_you = {
				name = "{C:flower_pink,element:1}Pink",
				text = {
					"{C:green}#1# in #2#{} chance for",
					"each scoring card of",
					"{V:1}#4#{} suit to create",
					"a {C:dark_edition}#5#{} {C:attention}consumable",
					"{C:inactive}(Must have room){}"
				},
			},
			j_UTDR_green = {
				name = "{C:flower_green,element:1}Green ",
				text = {
					"Creates a {C:dark_edition}#4#{} {V:2}#3#{}",
					"card every {C:attention}#2#{} {C:inactive}[#1#]{}",
					"Booster Packs opened",
					"{C:inactive}(Must have room){}"
				},
			},
			j_UTDR_susies_idea = {
				name = "{element:1}Susie's Idea",
				text = {
					"When round begins, add a",
					"playing card with a {C:attention}random",
					"{C:attention}edition{} to your hand",
				},
			},

			j_UTDR_thornring = {
				name = "Thorn Ring",
				text = {
					"Played {C:attention}#1#s{}",
					"{S:1.1,C:ballgame,E:2}always{} break, {C:ballgame}and...?{}",
				},
			},
			j_UTDR_carol = {
				name = "Carol",
				text = {
					"Cards are drawn in order",
					"of rank, {C:attention}lowest to highest",
				},
			},
			j_UTDR_find_her_dogg_girl = {
				name = "December",
				text = {
					"{C:common}#1#{} Jokers {C:red}no",
					"{C:red}longer appear{} in shop",
				},
			},
			j_UTDR_lacquer_triangle = {
				name = "Lacquer Triangle",
				text = {
					"{C:ballgame}-#1# Hand{}",
					"{C:gold}Gold{} capsule prizes",
					"begin at {C:points}300 POINTs"
				},
				unlock = {
					"Try our discount code:",
					"{C:ballgame}B  A  L  L",
				},
			},
			j_UTDR_shadow_crystal = {
				name = "Shadow Crystal",
				text = {
					"Removes the {C:attention}negative",
					"{C:attention}effects{} of all",
					"{C:spectral}#1#{} cards",
				},
			},
			j_UTDR_dogcheck = {
				name = "DOGCHECK",
				text = {
					"{C:green}#1# in #2#{} chance to",
					"prevent death and",
					"create a {C:attention}random Tag",
				},
			},
			j_UTDR_shelter_code = {
				name = "Shelter Code",
				text = {
					"{C:uncommon}#1#{} and {C:rare}#2#{} Jokers",
					"appear in shop more often",
				},
			},
			j_UTDR_sjelter = {
				name = "Shelter",
				text = {
					"{C:gaster}. . .{}",
				},
			},
			j_UTDR_sjelter_sjelter = {
				name = "Sjelter",
				text = {
					"{C:gaster}. . .{}",
				},
			},
			j_UTDR_ROOTS = {
				name = "ROOTS",
				text = {
					"Only {C:red}Jokers{} appear in shop",
				},
			},
			j_UTDR_FRIEND = {
				name = "_FRIEND",
				text = {
					"{C:FRIEND}Creates a {C:FRIEND_PINK}#3#{C:FRIEND} card",
					"{C:FRIEND}after {C:FRIEND_YELLOW}#1# {C:FRIEND_PINK}[#2#]{C:FRIEND} cards",
					"{C:FRIEND}are {C:FRIEND_YELLOW}destroyed{}",
					"{C:FRIEND}(Must have room)",
				},
			},
			j_UTDR_VESSEL_FRIEND = {
				name = "_FRIEND",
				text = {
					"{C:FRIEND}Creates a {C:FRIEND_PINK}#3#{C:FRIEND} card",
					"{C:FRIEND}after any card is {C:FRIEND_YELLOW}destroyed",
					"{C:FRIEND}(Must have room)",
				},
			},
			j_UTDR_fun_value = {
				unlock = {
					"{E:1,C:green}#1# in #2#{} chance to unlock",
					"after {E:1,C:attention}winning{} a run",
				},
				text = {
					"Each Joker has a {C:green}#1# in #2#",
					"chance to give {X:mult,C:white}X#3#{} Mult",
				},
				name = "fun value",
			},
			j_UTDR_SURVEY_PROGRAM = {
				unlock = {
					"Win {E:1,C:attention}5{} runs {C:inactive}[#1#]",
				},
				text = {
					"Gains {X:mult,C:white}X#1#{} Mult when",
					"a {C:spectral}#3#{} card is used",
					"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
				},
				name = "SURVEY_PROGRAM",
			},
			j_UTDR_weird_deard_gaster = {
				unlock = {
					"{C:gaster}AT THAT TIME,",
					"{C:gaster}I WILL ASK YOU",
					"{C:gaster}A FEW QUESTIONS.",
				},
				text = {
					""
				},
				name = "{f:UTDR_HIM}GASTER",
			},
			j_UTDR_vessel = {
				unlock = {
					"Sell {E:1,C:attention}30{} Jokers",
				},
				text = {
					"Gains {X:mult,C:white}X#1#{} Mult",
					"for each sold {C:attention}Joker",
					"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
				},
				name = "VESSEL",
			},
			j_UTDR_man = {
				name = "Man",
				text = {
					"Not too important,",
					"{C:attention}not too unimportant.",
					"{C:inactive}(Must have room)",
				},
			},


			j_UTDR_hometown = {
				name = "Hometown",
				text = {
					"Gains {X:mult,C:white}X#1#{} Mult for",
					"{C:attention}each{} scored card",
					"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
				},
			},
			j_UTDR_berdly = {
				name = "Berdly",
				text = {
					"Played {C:attention}#3#s{}",
					"give {C:mult}+#1#{} Mult and",
					"{C:money}$#2#{} when scored",
					"{C:attention}#3#s{} can",
					"{C:red}no longer trigger",
				},
			},
			j_UTDR_newsletter = {
				name = "Newsletter",
				text = {
					"Creates a {C:planet}Planet{} card when",
					"{C:attention}Small Blind{} is defeated",
					"Creates a {C:tarot}Tarot{} card when",
					"{C:attention}Big Blind{} is defeated",
					"Earn {C:money}$#1#{} when {C:attention}Boss Blind{} is defeated",
				},
			},
			j_UTDR_noelle = {
				name = "Noelle",
				text = {
					"{C:attention}#1#s{} give {X:mult,C:white}X#2#{} Mult,",
					"but have a {C:green}#3# in #4#{}",
					"chance to break",
				},
			},
			j_UTDR_suselle = {
				name = "Noelle",
				text = {
					"{C:attention}#1#s{} give {X:mult,C:white}X#2#{} Mult,",
					"and can {C:flower_pink}no longer break"
				},
			},
			j_UTDR_noelle_side_b = {
				name = "Noelle",
				text = {
					"{C:attention}#1#s{} give {X:mult,C:white}X#2#{} Mult,",
					"and {S:1.1,C:ballgame,E:2}always{} break",
				},
			},
			j_UTDR_save = {
				name = "SAVE",
				text = {
					"After {C:attention}#1#{C:inactive} [#2#]{} rounds,",
					"sell this card for {C:attention}-#3#{} Ante",
				},
			},
			j_UTDR_tension_gem = {
				name = "Tension Gem",
				text = {
					"Sell this card to",
					"create {C:attention}#1#{}",
					"{C:tarot}#2#s",
				},
			},
			j_UTDR_tension_slop = {
				name = "Tension Slop",
				text = {
					"Sell this card to",
					"create {C:attention}#1#{}",
					"{C:tarot}#2#s",
				},
			},
			j_UTDR_kris = {
				name = "Kris",
				text = {
					"Copies ability of {C:attention}Joker{}",
					"to the left for",
					"{C:attention}first hand of round",
				},
			},
			j_UTDR_kris_split = {
				name = "{element:1}Kris",
				text = {
					"Copies ability of {C:attention}Joker{}",
					"to the left for",
					"{C:attention}first hand of round",
				},
			},
			j_UTDR_you = {
				unlock = {
					"{s:1.3}?????",
				},
				text = {
					"Copies abilities of {C:attention}Jokers{}",
					"to the left and right",
				},
				name = "You",
			},
			j_UTDR_susie = {
				name = "Susie",
				text = {
					"{X:mult,C:white}X#1#{} Mult during {C:attention}Small Blind{}",
					"{X:mult,C:white}X#2#{} Mult during {C:attention}Big Blind{}",
					"{X:mult,C:white}X#3#{} Mult during {C:attention}Boss Blind{}",
				},
			},
			j_UTDR_lord_of_hammer = {
				text = {
					"{X:mult,C:white} X#1# {} Mult if {C:attention}Joker{} slots are full",
				},
				name = "Lord of the Hammer",
			},
			j_UTDR_ralsei_dummy = {
				name = "Ralsei's Dummy",
				text = {
					"{C:mult}+#1#{} Mult for each",
					"empty {C:attention}Joker{} slot",
					"{s:0.8}#3# included{}",
					"{C:inactive}(Currently {C:mult}+#2#{} Mult)",
				},
			},
			j_UTDR_castle_town = {
				name = "Castle Town",
				text = {
					"{C:mult}+#1#{} Mult for each",
					"card above {C:attention}#2#{}",
					"in your #4#",
					"{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult)",
				},
			},
			j_UTDR_ralsei = {
				name = "Ralsei",
				text = {
					"{C:attention}Retrigger{} each played",
					"{V:1}#1# of #2#{C:attention} #3#{} times ",
					"{s:0.8}rank and suit change at end of round",
				},
			},
			j_UTDR_ralseis = {
				name = "Ralsei",
				text = {
					""
				},
			},
			j_UTDR_dark_fountain = {
				name = "Dark Fountain",
				text = {
					"After {C:attention}#1#{C:inactive} [#2#]{} rounds,",
					"sell this card to",
					"apply {C:dark_edition}#3#{} to the",
					"Joker to the {C:attention}right",
				},
			},
			j_UTDR_moss = {
				name = "Moss",
				text = {
					"{S:1.1,C:dark_edition,E:2}You found it!{}",
				},
			},
			j_UTDR_dev_viomarks = {
				name = "VioMarks",
				text = {
					{
						"{s:1.5,E:UTDR_tropiss}what is up you fREAKS",
					},
					{
						"anyway hi i'm vio i'm the director and ideas guy AND",
						"somehow the artist for all 195 jokers in this mod.",
						"i started this project back in march of 2025",
						"as just 'what if the punch card was a joker' ",
						"and it somehow spiraled into this. i still think",
						"this is one of the best projects i've been",
						"a part of and i'm so thankful for all the people",
						"that both helped actually make this and played/streamed it",
					}
				}
			},
			
			j_UTDR_dev_white_tail_ani = {
				name = "WhitetailAni",
				text = {
					{
						"{s:1.3}Hi! I'm {s:1.3,C:homura}WhitetailAni.",
					},{
						"Until v3, I was the {C:attention}sole dev{} for this mod.",
						"{C:vio_marks}Vio{} did the art, designed the jokers,",
						"but it was my job to implement them. It was pretty fun!",
						"Lots of {C:ballgame}Late Nights{} spent digging through the Balatro source,",
						"asking the {C:discord}Balatro Discord{} for tips on where to find stuff..",
					},{
						"Anyway. In v3 we had {C:blue}too many ideas{} and realized we'd need more help.",
						"I also got a {C:money}job{} in the meantime,",
						"which meant I couldn't spend all day working on it anymore...",
						"It was difficult to adjust to not being the only dev anymore.",
						"{s:0.71}I'm not very good at working with other people.",
						"But I think it turned out pretty well.",
						"After all, you're playing the new update right now!",
					}
				}
			},
			
			j_UTDR_dev_white_tail_ani_first_look = {
				name = "WhitetailAni",
				text = {
					{
						"{s:1.3}Hi! I'm {s:1.3,C:homura}WhitetailAni.",
					},{
						"Until v3, I was the {C:attention}sole dev{} for this mod.",
						"{C:vio_marks}Vio{} did the art, designed the jokers,",
						"but it was my job to implement them. It was pretty fun!",
						"Lots of {C:ballgame}Late Nights{} spent digging through the Balatro source,",
						"asking the {C:discord}Balatro Discord{} for tips on where to find stuff..",
					},{
						"Anyway. In v3 we had {C:blue}too many ideas{} and realized we'd need more help.",
						"I also got a {C:money}job{} in the meantime, which meant I couldn't spend all day working on it anymore...",
						"It was difficult to adjust to not being the only dev anymore.",
						"{s:0.71}I'm not very good at working with other people.",
						"But I think it turned out pretty well.",
						"After all, you're playing the new update right now!",
					},{
						"{s:0.9}If you want to view this message again, hold Alt and hover over me.",
						"{s:0.9}Or hold Ctrl to view something else!", 
					}
				}
			},
			j_UTDR_dev_ani_no_no_no = {
				name = "WhitetailAni",
				text = {
					"By the way, I hope you liked Flowery.",
					"I spent {C:attention}2 weeks{} constantly tweaking his voice clip interactions.",
					"The 'Ralseis' toggle was suggested by someone else...",
					"I don't remember who......"
				}
			},
			j_UTDR_dev_ani_caly = {
				name = "Calypso",
				text = {
					"{C:caly}Is that really what you're hoping for?",
				}
			},
			j_UTDR_dev_ani_oh_no = {
				name = "",
				text = {
					"{C:gaster}Are you who you say you are?",
					"",
					"Are you who you say you are?",
					"",
					"{C:homura}Are you who you say you are?",
				}
			},
			j_UTDR_dev_ani_xavier_magic_button = {
				name = "Xavier: Renegade Angel",
				text = {
					"Okay, so imagine a magic button. I'm imagining the button. If you press the button- What color is it? It's the only button. It doesn't matter what color it is. Nah, I ain't falling for that again. Last time there was a {C:red}red{} button and a {C:blue}blue{} button- That's a different thought experiment. -and I tried to be a nice guy and pick {C:blue}blue{} so I could save everybody, but it turns out y'all a bunch of {C:red}selfish motherfuckers{} and I died. It wasn't buttons. It was pills. Don't care. I'm out for {C:attention}me{} this time. What color is the button? Ugh, fine. It's {C:red}red{}. I press the button. You don't even know what it does yet! And I pull the trolley lever. There's no lever! Bias for Action. Just listen: there's a button that lets you save 10^100 shrimp, but it kills one random person. Would you press it? What flavor are the shrimp? Flavor? Yeah, you know: garlic, Old Bay, Korean BBQ. You're saving the shrimp, not eating them!",
					"Saving them for what? For nothing. They get to live their lives. What? Just doin' shrimp stuff? Yeah. How long do shrimp live? Uh, it depends on the species? {C:attention}1-2 years?{} And then what happens? They {C:ballgame}die{}. That seems like a waste. How is that a waste? They got to live full lives. Weren't you just telling me last week that bees live in perpetual agony and we should {C:ballgame}commit insect omnicide{} to free from the suffering of the flesh? Yeah, but that was last week. This week I read a new Snubstack post with a {C:blue}math equation{} in it and believe something totally different. Uh huh. It's called updating your priors. Okay, well here's my updated prior: I press the button, let the shrimp live for a year, and then I eat them. What? All of them. You can't eat 10^100 shrimp. I freeze the leftovers. You would need a freezer bigger than the universe! Really?",
					"Yes! 10^100 is more than all the atoms in the observable universe! Okay, then I have a freezer bigger than the universe. You can't just- No, wait. Three freezers. One for each flavor. You can't just make up three freezers! Why not? It's a hypothetical! Yeah I hypothetically have {C:attention}three{} big ass freezers. The point- If you get to throw out a big ass number of shrimp, I get to have some big ass freezers. {C:maytag}Maytag{} freezers. The point of the hypothetical- I've always been a {C:maytag{}Maytag{} man. The point of the hypothetical is to {C:attention{}interrogate{} our moral intuitions! Yeah well the only thing I want to interrogate right now is a Red Lobster menu. I don't think you're engaging with this in good faith. Wait, I got a new hypothetical. A counterfactual even. Oh really. You know what I would've done differently if I knew you were gonna hit me with this mouthwatering supper-time supposition? What? I would've had breakfast this morning. Fuck you."
				}
			},
			j_UTDR_dev_ani_sjelter = {
				name = "What?",
				text = {
					"{C:ballgame}Lost{} where the {C:rental}Forrest would grow,",
					"the {C:money}children{} wandered across the {C:kyoko}dield,",
					"into the {C:gaster}drakness{} of the {C:red}Sjelter"
				}
			},
			j_UTDR_dev_ani_kalos = {
				name = "Hex Maniac",
				text = {
					"{C:homura}No, you're not the one.",
				}
			},
			j_UTDR_dev_ani = {
				name = "WhitetailAni",
				text = {
					"{C:cerulean}https://cerulean.fm"
				}
			},
			j_UTDR_dev_ani_theory = {
				name = "How does this connect to Roaring Knight IDF theory",
				text = {
					"The {C:green}seven aces of Mancountry{} Light World {C:FRIEND_YELLOW}pro{C:FRIEND_PINK}tein {C:scarlet_forest_pink}tree{} egg...",
					"He says {C:attention}11 years{} Deltarune {C:gaster}Gaster{} prophecy,",
					"which connects to {C:kris_cape}trauma {C:kris_body}Kris{} and the {C:goner}VESSEL",
					"The {C:goner}VESSEL{} {C:attention}Forgotten Man {C:goner}Goner {C:gaster}Gaster{} copies are monochrome...",
					"Hmm."
				}
			},
			j_UTDR_dev_ani_sweepstakes_2 = {
				name = "Wild Prizes!",
				text = {
					"Worm from the string.",
					"Worm from the string.",
					"Worm from the string.",
					"Worm from the string.",
					"Worm from the string.",
					"Worm from the string.",
					"Worm from the string.",
					"Worm from the string.",
					"Worm from the string.",
					"Worm from the string.",
					"Worm from the string.",
					"Worm from the string.",
					"Worm from the string.",
					"Worm from the string.",
					"Worm from the string.",
					"Worm from the string.",
					"Worm from the string.",
					"Worm from the string.",
					"Worm from the string.",
					"Worm from the string.",
					"Worm from the string.",
					"Worm from the string.",
					"Worm from the string.",
					"Worm from the string.",
					"Worm from the string.",
					"Worm from the string.",
					"Worm from the string.",
					"Worm from the string.",
					"Worm from the string.",
					"Worm from the string.",
					"Worm from the string.",
					"Worm from the string.",
					"Worm from the string.",
					"Worm from the string.",
					"Worm from the string.",
					"Worm from the string.",
				}
			},
			j_UTDR_dev_ani_sweepstakes_5 = {
				name = "Ode to Spamton",
				text = {
					"You may ask, {C:FRIEND_PINK}Who is next?",
					"You may ask, {C:FRIEND_YELLOW}Who will be?",
					"Who will be {C:red}secret boss,",
					"Of {C:attention}Adventure no 3?",
					" ",
					"Me don't know",
					"And me don't cares!",
					"Me only cares about {C:FRIEND_PINK}Spam{C:FRIEND_YELLOW}ton{}",
					"The rest can go up in the {C:flower_aqua}airs!!",
					" ",
					"Please pay {C:money}[4.99]{} to continue the poem"
				}
			},
			j_UTDR_dev_ani_sweepstakes_6 = {
				name = "Kill Your TV",
				text = {
					"I'll {C:red}smash{} my TV with a battering ram",
					"I'll {C:ballgame}kill{} my TV with a battering ram!",
					"I'll {C:blue}brush{} my TV with mayonnaise and slimes",
					"I'll {C:ballgame}crush{} my TV for its horrible crimes!",
					"I {C:red}don't need a TV anymore!",
					"{C:FRIEND_PINK}Spam{C:FRIEND_YELLOW}ton{} is here, and he I adore!"
				}
			},
			j_UTDR_dev_ani_sweepstakes_7 = {
				name = "JUSTIN_FX",
				text = {
					"{C:money}SINGALONG SUBTITLES BY JUSTIN-FX",
					"{C:money}THEY {C:red}DID NOT {C:money}PAY ME 2 DO THIS ONE",
					"{C:money}SO I DIDENT",
				}
			},
			j_UTDR_dev_ani_juice = {
				name = "Juiece",
				text = {
					"If I go make my {C:alphys_juice_1}12% red{}",
					"and {C:alphys_juice_2}3% yellow{} and",
					"{C:alphys_juice_3}8% pink{} and {C:alphys_juice_4}9% blue{} and",
					"and {C:alphys_juice_5}1% green{} and",
					"{C:alphys_juice_6}4% purple{} and {C:alphys_juice_7}10% orange{}",
					"and {C:alphys_juice_8}1% vermillion{} and",
					"{C:gaster}3% dark{} and {C:angel}5% light{}",
					"and {C:alphys_juice_9}7% original{} and",
					"{C:alphys_juice_10}1% sea{} and {C:alphys_juice_11}1% weed{} and",
					"{C:alphys_juice_12}2% free{} and {C:alphys_juice_13}5% Gaster",
					"and {C:alphys_juice_14}6% d13931{} and",
					"{C:alphys_juice_15}4% buble{} and {C:gaster}1225% guitar{}",
					"and {C:alphys_juice_16}5% genocides{} and",
					"{C:alphys_juice_17}1% flower{} and {C:goner}0% vessel{} and"
				}
			},
			j_UTDR_dev_ani_survey = {
				name = "Survey",
				text = {
					"Thanks for your feedback!",
					"Be seeing you soon!"
				}
			},
			
			j_UTDR_dev_j8 = {
				name = "J8-Bit",
				text = {
					"(insert",
					"credits",
					"description",
					"here)"
				}
			},
			j_UTDR_dev_elle = {
				name = "{f:UTDR_slimelets}slimestuff.",
				text = {
					{
						"{f:UTDR_slimelets}Hi! We're a system of {f:UTDR_slimelets,E:UTDR_ellerainbow}#1#{f:UTDR_slimelets} creatures.",
						" {element:1} ",
						"{f:UTDR_slimelets,s:.8,C:inactive}Though it's usually {f:UTDR_slimelets,s:.8,V:1}elle.{f:UTDR_slimelets,s:.8,C:inactive} doing things."
					},
					{
						"{f:UTDR_slimelets}We were brought in because of an old {f:UTDR_slimelets,C:attention}Tenna{f:UTDR_slimelets} microgame",
						"{f:UTDR_slimelets}system we were working on for our {f:UTDR_slimelets,C:red}Balatro{f:UTDR_slimelets} mod.",
						"{f:UTDR_slimelets}The {f:UTDR_slimelets,C:attention}Joker{f:UTDR_slimelets} is shelved now but it got {f:UTDR_slimelets,C:vio_marks}Vio{f:UTDR_slimelets}'s {f:UTDR_slimelets,C:attention}attention{f:UTDR_slimelets}.",
						"{f:UTDR_slimelets,s:.8,C:inactive}Recreating all the  {element:2,f:UTDR_slimelets,s:.8,C:inactive}  by {f:UTDR_slimelets,s:.8,C:blue}hand{f:UTDR_slimelets,s:.8,C:inactive} was too daunting"
					},
					{
						"{f:UTDR_slimelets}We made the {f:UTDR_slimelets,C:attention}Tenna{f:UTDR_slimelets} minigame for this mod too,",
						"{f:UTDR_slimelets}along with most of the work for the new {f:UTDR_slimelets,C:catty,E:1}shops{f:UTDR_slimelets}.",
						"{f:UTDR_slimelets}You can find us on {f:UTDR_slimelets,C:blue}BlueSky{f:UTDR_slimelets} at {f:UTDR_slimelets,V:1}@ellestuff.dev{f:UTDR_slimelets}.",
						"{f:UTDR_slimelets,s:.8,C:inactive}We have a website too! It's the same link, just in your browser."
					}
				}
			},
		},
		Back = {
			b_ghost = {
				text = {
					"{C:spectral}Prophecy{} cards may",
					"appear in the shop, start",
					"with a {C:spectral,T:c_hex}Blackened Knife{} card",
				},
			},
			b_UTDR_forgotten = {
				name = "Forgotten Deck",
				text = {
					"All rerolls cost {C:money}$#1#",
				},
			},
			b_UTDR_dog = {
				name = "Dogdeck",
				text = {
					"Start run with",
					"{C:attention,T:j_UTDR_bandage}#1#{} and {C:attention,T:j_UTDR_stick}#2#{}",
					"Winning Ante is {C:attention}#3#{}",
				},
			},
			b_UTDR_dark = {
				name = "Dark Deck",
				text = {
					"Start run with",
					"{C:tarot,T:v_crystal_ball}#1#{} and",
					"{C:tarot,T:v_omen_globe}#2#{}",
				},
			},
			b_UTDR_soul = {
				name = "Soul Deck",
				text = {
					"Winning Ante is {C:attention}#1#",
				},
			},
			b_UTDR_merciful = {
				name = "Merciful Deck",
				text = {
					"{V:1}#1#{} and {V:2}#2#{}",
					"Jokers cost {C:attention}#5#",
					"{V:3}#3#{} and {V:4}#4#{}",
					"Jokers cost {C:attention}#6#",
				},
			},
		},
		Other = dr and {
			p_spectral_normal_1 = {
				name = "Prophecy Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2# {C:spectral}Prophecy{} cards to",
					"be used immediately",
				},
			},
			p_spectral_jumbo_1 = {
				name = "Jumbo Prophecy Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2# {C:spectral}Prophecy{} cards to",
					"be used immediately",
				},
			},
			p_spectral_mega_1 = {
				name = "Mega Prophecy Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2# {C:spectral}Prophecy{} cards to",
					"be used immediately",
				},
			},
			p_spectral_normal_2 = {
				name = "Prophecy Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2# {C:spectral}Prophecy{} cards to",
					"be used immediately",
				},
			},
		} or nil,
		Tag = {
			tag_ethereal = {
				text = {
				},
			},
			tag_UTDR_annoying = {
				name = "Annoying Tag",
				text = {
					"Gives a free",
					"{C:gaster}Dog{} Joker",
				},
			},
			tag_UTDR_glamorous = {
				name = "Glamorous Tag",
				text = {
					"Gives {C:attention}1{} free",
					"trade with {C:bratty}Bratty",
					"and {C:catty}Catty"
				},
			},
			tag_UTDR_t_rank = {
				name = "T-Rank Tag",
				text = {
					"After defeating",
					"the Boss Blind,",
					"gain {C:points}#1# POINTs"
				},
			},
			tag_UTDR_capsule = {
				name = "Capsule Tag",
				text = {
					"{C:gold}Gold{} chance",
					"is {C:attention}100%{} on",
					"next roll"
				},
			},
		},
		Spectral = dr and { -- Don't do this if Deltarune is disabled
			c_UTDR_jorkington = {
				name = "Jorkington",
				text = {
					"Creates a random",
					"{C:red}Rare{C:attention} Joker{}",
				},
			},
			c_trance = {
				name = "The Cage",
			},
			c_medium = {
				name = "The Prince",
			},
			c_cryptid = {
				name = "Tail of Hell",
			},
			c_soul = {
				name = "DELTARUNE",
			},
			c_familiar = {
				name = "Queen's Chariot",
			},
			c_grim = {
				name = "Flower Man",
			},
			c_hex = {
				name = "Blackened Knife",
			},
			c_incantation = {
				name = "Lord of Screens",
			},
			c_UTDR_ankh_crystal = {
				name = "Pointy-Headed",
				text = {
					"Create a copy of a",
					"random {C:attention}Joker{}",
				},
			},
			c_talisman = {
				name = "Four Tones",
			},
			c_aura = {
				name = "Heaven's Call",
			},
			c_UTDR_immolate_crystal = {
				name = "Final Tragedy",
				text = {
					"Gain {C:money}$#2#",
				},
			},
			c_wraith = {
				name = "Jockington",
			},
			c_UTDR_hex_crystal = {
				name = "Blackened Knife",
				text = {
					"Add {C:dark_edition}Polychrome{} to",
					"a random {C:attention}Joker{}",
				},
			},
			c_sigil = {
				name = "Gallery",
			},
			c_UTDR_familiar_crystal = {
				name = "Queen's Chariot",
				text = {
					"Add {C:attention}#1#{} random {C:attention}Enhanced",
					"{C:attention}face cards{} to your hand",
				},
			},
			c_ouija = {
				name = "Darkened Eyes",
			},
			c_UTDR_jorkington_crystal = {
				name = "Jorkington",
				text = {
					"Creates a random",
					"{C:red}Rare{C:attention} Joker{}",
				},
			},
			c_ectoplasm = {
				name = "Three Heroes",
			},
			c_UTDR_ectoplasm_crystal = {
				name = "Three Heroes",
				text = {
					"Add {C:dark_edition}Negative{} to",
					"a random {C:attention}Joker",
				},
			},
			c_immolate = {
				name = "Final Tragedy",
			},
			c_UTDR_grim_crystal = {
				name = "Flower Man",
				text = {
					"Add {C:attention}#1#{} random {C:attention}Enhanced",
					"{C:attention}Aces{} to your hand",
				},
			},
			c_ankh = {
				name = "Pointy-Headed",
			},
			c_UTDR_incantation_crystal = {
				name = "Lord of Screens",
				text = {
					"Add {C:attention}#1# random",
					"{C:attention}Enhanced numbered",
					"{C:attention}cards{} to your hand",
				},
			},
			c_deja_vu = {
				name = "The Girl",
			},
			c_UTDR_ouija_crystal = {
				name = "Darkened Eyes",
				text = {
					"Converts all cards",
					"in hand to a single",
					"random {C:attention}rank",
				},
			},
			c_UTDR_wraith_crystal = {
				name = "Jockington",
				text = {
					"Creates a random",
					"{C:red}Rare{C:attention} Joker{}",
				},
			},
		} or nil,
	},
	misc = {
		challenge_names = {
			c_UTDR_flowers = "Flower Power",
			c_UTDR_tricky_tony = "Tony's Trick",
			c_UTDR_love = "Level of Violence",
			c_UTDR_find_her_dot_o_g_g = "Find Her",
			c_UTDR_t_v_time = "TV TIME!",
			c_UTDR_shatter_dream = "Shattered Dreams",
			c_UTDR_neutral_on_these_things = "True Pacifist",
			c_UTDR_try_our_discount_code = "C-Rank and B-Rank",
			c_UTDR_balatro_the_musical = "Lights, Camera, Ratings!",
			c_UTDR_sans = "{F:ComicSansUT}sans."
		},
		quips = {
			tennaquiz_UTDR_tvtime = {
				"What time is it right now?"
			},
			tennaquiz_UTDR_ralsei = {
				"The Shop values this {C:attention}Joker{} at {C:money}$6{}.",
				"What's the true value?"
			},
			tennaquiz_UTDR_tennaname = {
				"What's the name of this show's host?"
			},
			tennaquiz_UTDR_lancer = {
				"What's the name of this {C:attention}Joker{}?",
				"Seriously, I don't remember."
			},
			tennaquiz_UTDR_jokers = {
				"Apparently base game",
				"{C:attention}Joker{} art",
				"looks like this.",
				"Except for...?"
			},
			tennaquiz_UTDR_tarot = {
				"Apparently base game",
				"{C:tarot}Tarot{} card art",
				"looks like this.",
				"Except for...?"
			},
			tennaquiz_UTDR_spectral = {
				"Apparently base game",
				"{C:spectral}Spectral{} cardart",
				"looks like this.",
				"Except for...?"
			},
			tennaquiz_UTDR_satellite = {
				"Which one of these stellar",
				"{C:attention}Jokers{} generates money?"
			},
			tennaquiz_UTDR_jimbo = {
				"What's the ability of this unpleasant card?"
			},
			tennaquiz_UTDR_balala = {
				"What's the name of",
				"the game you're playing?"
			},
			tennaquiz_UTDR_dev = {
				"Who was this mod's Director again?"
			},
			tennaquiz_UTDR_jokercount = {
				"How many {C:attention}Jokers{} does this",
				"wonderful mod add?"
			},
			tennaquiz_UTDR_reskins = {
				"This mod retextures all",
				"Vanilla {C:attention}Consumable{} types.",
				"Except for...?"
			}
		},
		poker_hands = {
			["UTDR_him"] = "Him",
		},
		poker_hand_descriptions = {
			["UTDR_him"] = {
				"",
			},
		},
		labels = {
			UTDR_friend = "Rare"
		},
		dictionary = {
			totem_UTDR_punch_card = "Redeemed the Punch Card",
			totem_UTDR_omegaflowey = "HAHAHAHAHAHAHAHAHAHAHA!!",
			totem_UTDR_dogcheck = "Checked!",
			totem_UTDR_blue = "This is a comedy, not a tragedy!",
			totem_UTDR_buttspie = "Spared by Buttspie",
			k_UTDR_upgrade_qu = "Upgrade?",

			k_UTDR_more = "more",
			k_UTDR_less = "less",
			k_UTDR_splat_ex = "Splat!",
			k_UTDR_burned_ex = "Burned!",
			k_UTDR_robot = "Roboticized!",
			k_UTDR_yellow_thanks = "Thanks, y'all!",
			k_upgrade_qm = "Upgrade?",

			k_dog = "Dog",
			k_him = "Him",
			k_swoon = "SWOON",

			utdr_points_suffix = " PTs",

			-- Deltarune Prophecy stuff
			b_spectral_cards = dr and "Prophecy Cards" or nil,
			b_stat_spectrals = dr and "Prophecies" or nil,
			k_plus_spectral = dr and "+1 Prophecy" or nil,
			k_spectral = dr and "Prophecy" or nil,
			k_spectral_pack = dr and "Prophecy Pack" or nil,

			-- Shop stuff
			ph_utdr_capsule = "Gamble points for cards!",
			ph_utdr_cattybratty = "Trade for tags!",
			b_utdr_cattybratty_trade = "Trade",

			-- Shop Dialogue
			utdr_shopcatty_open = "Hey! Check it out!",
			utdr_shopbratty_open = "Yeah! Check it out!",
			utdr_shopcatty_buy = "Bratty! We're gonna be rich!",
			utdr_shopbratty_buy = "Yeah! We're gonna be rich!",
			utdr_shopcatty_sold = "Mee-YOW!",
			utdr_shopbratty_sold = "We're all $$$$old out!",

			-- Config options
			b_UTDR_enable_undertale = "UNDERTALE content",
			b_UTDR_enable_deltarune = "DELTARUNE content",
			b_UTDR_voice_clips = "Voice Clips",
			b_UTDR_ralseis = "Ralseis",
			b_UTDR_restart = "Restart Game",
			b_UTDR_requires_restart = "Requires restart for changes to appear!",
			
			-- shop tab stuff
			s_UTDR_shop = "Shop",
			s_UTDR_cattybratty = "Catty & Bratty",
			s_UTDR_ball = "Ball Machine",

			-- Ball Machine
			UTDR_shopball_chance0 = "%",
			UTDR_shopball_chance1 = " chance of",
			UTDR_shopball_chance2 = "getting GOLD prize",
			UTDR_shopball_trade = "Bet!",
			UTDR_shopball_skip = "Skip",
			UTDR_shopball_take = "Take",
			UTDR_shopball_use = "Use",
			
			
			--lacquer script
			ph_UTDR_improve = "Improve.",
		},
		achievement_descriptions = {
			clairvoyance = dr and "Discover every Prophecy card" or nil
		}
	},
}
