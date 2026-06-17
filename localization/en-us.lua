return {
    descriptions = {
        Back = {
            b_UTDR_dog = {
                name = "Dogdeck",
                text = {
                    "Start run with",
                    "{C:attention,T:j_UTDR_bandage}#1#{} and {C:attention,T:j_UTDR_stick}#2#{}",
                    "Winning Ante is {C:attention}#3#{}"
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
            b_UTDR_soul = {
                name = "Soul Deck",
                text = {
                    "Winning Ante is {C:attention}#1#"
                },
            },
            b_UTDR_dark = {
                name = "Dark Deck",
                text = {
                    "Start run with",
                    "{C:tarot,T:v_crystal_ball}#1#{} and",
                    "{C:tarot,T:v_omen_globe}#2#{}"
                },
            },
            b_UTDR_forgotten = {
                name = "Forgotten Deck",
                text = {
                    "All rerolls cost {C:money}$#1#"
                },
            }
        },
        Joker = {
            j_UTDR_bandage = {
                name = "Bandage",
                text = {
                    "{C:chips}+#1#{} Chips",
                    "and {C:mult}+#2#{} Mult"
                }
            },
            j_UTDR_stick = {
                name = "Stick",
                text = {
                    "{X:mult,C:white}X#1#{} Mult"
                }
            }
        }
    },
    misc = {
        dictionary = {
            k_UTDR_more = "more",
            k_UTDR_less = "less"
        }
    }
}
