# undertale-balatro
An Undertale/Deltarune mod for Balatro

## Found a bug? Please submit it under the Issues tab! There are 2 templates provided for you, please use them!!

Please be aware that the Undertale/Deltarune mod's compatibility with other mods is not guaranteed. If you experience a crash with other mods active, Please Please Please ~~only microwave his insides


## Mod developer info

Adds a few contexts, if you also make mods.
1. context.voucher_redeem - triggers when a voucher is redeemed. Passes the voucher in question as context.other_voucher
2. context.debuffed_individual - triggers when a scoring-but-debuffed card is debuffed instead of scored. Specifically, it triggers when the blind says "Debuffed" on the card.
3. context.copied_card - triggers when the `copy_card` function is called. Also works with SMODS.copy_card, since that's just a wrapper around `copy_card`.
