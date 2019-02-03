"""
Dictionary defining values of the menu commands.

"""
const menucmd =
Dict{Symbol,Int}(
    :req_left_item     => (KEY_MAX + 1),
    :req_right_item    => (KEY_MAX + 2),
    :req_up_item       => (KEY_MAX + 3),
    :req_down_item     => (KEY_MAX + 4),
    :req_scr_uline     => (KEY_MAX + 5),
    :req_scr_dline     => (KEY_MAX + 6),
    :req_scr_dpage     => (KEY_MAX + 7),
    :req_scr_upage     => (KEY_MAX + 8),
    :req_first_item    => (KEY_MAX + 9),
    :req_last_item     => (KEY_MAX + 10),
    :req_next_item     => (KEY_MAX + 11),
    :req_prev_item     => (KEY_MAX + 12),
    :req_toggle_item   => (KEY_MAX + 13),
    :req_clear_pattern => (KEY_MAX + 14),
    :req_back_pattern  => (KEY_MAX + 15),
    :req_next_match    => (KEY_MAX + 16),
    :req_prev_match    => (KEY_MAX + 17),
    :min_menu_command  => (KEY_MAX + 1),
    :max_menu_command  => (KEY_MAX + 17),
   )
export menucmd

const menuopts =
Dict{Symbol,Int}(
    :o_onevalue   => 0x01,
    :o_showdesc   => 0x02,
    :o_rowmajor   => 0x04,
    :o_ignorecase => 0x08,
    :o_showmatch  => 0x10,
    :o_noncyclic  => 0x20,
)
export menuopts
