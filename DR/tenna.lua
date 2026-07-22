function create_UIBox_quiz()
  local show_lose_cta = false
  local eased_green = copy_table(G.C.GREEN)
  eased_green[4] = 0
  ease_value(eased_green, 4, 0.5, nil, nil, true)
  local t = create_UIBox_generic_options({ padding = 0, bg_colour = eased_green , colour = G.C.BLACK, outline_colour = G.C.EDITION, no_back = true, no_esc = true, contents = {
    {n=G.UIT.R, config={align = "cm"}, nodes={
      {n=G.UIT.O, config={object = DynaText({string = {localize('ph_you_win')}, colours = {G.C.EDITION},shadow = true, float = true, spacing = 10, rotate = true, scale = 1.5, pop_in = 0.4, maxw = 6.5})}},
    }},
    {n=G.UIT.R, config={align = "cm", padding = 0.15}, nodes={
      {n=G.UIT.C, config={align = "cm"}, nodes={
    {n=G.UIT.R, config={align = "cm", padding = 0.08}, nodes={
      create_UIBox_round_scores_row('hand'),
      create_UIBox_round_scores_row('poker_hand'),
    }},
    {n=G.UIT.R, config={align = "cm", padding = 0.08}, nodes={
      UIBox_button({button = 'exit_overlay_menu', label = {localize('b_endless')}, minw = 6.5, maxw = 5, minh = 1.2, scale = 0.7, shadow = true, colour = G.C.BLUE, focus_args = {nav = 'wide', button = 'x',set_button_pip = true}}),
    }},
  }}
  }}
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
end