"""
Dictionary defining values of the field justification.

"""
const fieldjust =
Dict{Symbol,Int}(
    :no_justification => 0,
    :justify_left     => 1,
    :justify_center   => 2,
    :justify_right    => 3,
)
export fieldjust

"""
Dictionary defining values of the field options.

"""
const fieldopts =
Dict{Symbol,Int}(
    :o_visible  => 0x001,   # Field is visible.
    :o_active   => 0x002,   # Field is active in the form.
    :o_public   => 0x004,   # The contents entered into the field is echoed.
    :o_edit     => 0x008,   # Can edit the field.
    :o_wrap     => 0x010,   # The field contents can line wrap.
    :o_blank    => 0x020,   # Blank the field on modification.
    :o_autoskip => 0x040,   # Skip to next field when current is full.
    :o_nullok   => 0x080,   # Field is allowed to contain no data.
    :o_static   => 0x100,   # Field is not dynamic.
    :o_passok   => 0x200,   # An umodified field is OK.
    :o_reformat => 0x400,   # Insert newlines at linebreaks on buffer get.
   )
export fieldopts

const formopts =
Dict{Symbol,Int}(
    :o_nl_overload => 0x001,  # Enable overloading of `REQ_NEW_LINE`.
    :o_bs_overload => 0x002,  # Enable overloading of `REQ_DEL_PREV`.
   )

"""
Dictionary defining values of the form commands.

"""
const formcmd =
Dict{Symbol,Int}(
    :req_next_page    => KEY_MAX + 1,    # Move to next page.
    :req_prev_page    => KEY_MAX + 2,    # Move to previous page.
    :req_first_page   => KEY_MAX + 3,    # Move to first page.
    :req_last_page    => KEY_MAX + 4,    # Move to last page.
    :req_next_field   => KEY_MAX + 5,    # Move to next field.
    :req_prev_field   => KEY_MAX + 6,    # Move to previous field.
    :req_first_field  => KEY_MAX + 7,    # Move to first field.
    :req_last_field   => KEY_MAX + 8,    # Move to last field.
    :req_snext_field  => KEY_MAX + 9,    # Move to sorted next field.
    :req_sprev_field  => KEY_MAX + 10,   # Move to sorted prev field.
    :req_sfirst_fielD => KEY_MAX + 11,   # Move to sorted first field.
    :req_slast_field  => KEY_MAX + 12,   # Move to sorted last field.
    :req_left_field   => KEY_MAX + 13,   # Move to left to field.
    :req_right_field  => KEY_MAX + 14,   # Move to right to field.
    :req_up_field     => KEY_MAX + 15,   # Move to up to field.
    :req_down_field   => KEY_MAX + 16,   # Move to down to field.
    :req_next_char    => KEY_MAX + 17,   # Move to next char in field.
    :req_prev_char    => KEY_MAX + 18,   # Move to prev char in field.
    :req_next_line    => KEY_MAX + 19,   # Move to next line in field.
    :req_prev_line    => KEY_MAX + 20,   # Move to prev line in field.
    :req_next_word    => KEY_MAX + 21,   # Move to next word in field.
    :req_prev_word    => KEY_MAX + 22,   # Move to prev word in field.
    :req_beg_field    => KEY_MAX + 23,   # Move to first char in field.
    :req_end_field    => KEY_MAX + 24,   # Move after last char in fld.
    :req_beg_line     => KEY_MAX + 25,   # Move to beginning of line.
    :req_end_line     => KEY_MAX + 26,   # Move after last char in line.
    :req_left_char    => KEY_MAX + 27,   # Move left in field.
    :req_right_char   => KEY_MAX + 28,   # Move right in field.
    :req_up_char      => KEY_MAX + 29,   # Move up in field.
    :req_down_char    => KEY_MAX + 30,   # Move down in field.
    :req_new_line     => KEY_MAX + 31,   # Insert/overlay new line.
    :req_ins_char     => KEY_MAX + 32,   # Insert blank char at cursor.
    :req_ins_line     => KEY_MAX + 33,   # Insert blank line at cursor.
    :req_del_char     => KEY_MAX + 34,   # Delete char at cursor.
    :req_del_prev     => KEY_MAX + 35,   # Delete char before cursor.
    :req_del_line     => KEY_MAX + 36,   # Delete line at cursor.
    :req_del_word     => KEY_MAX + 37,   # Delete word at cursor.
    :req_clr_eol      => KEY_MAX + 38,   # Clear to end of line.
    :req_clr_eof      => KEY_MAX + 39,   # Clear to end of field.
    :req_clr_field    => KEY_MAX + 40,   # Clear entire field.
    :req_ovl_mode     => KEY_MAX + 41,   # Begin overlay mode.
    :req_ins_mode     => KEY_MAX + 42,   # Begin insert mode.
    :req_scr_fline    => KEY_MAX + 43,   # Scroll field forward a line.
    :req_scr_bline    => KEY_MAX + 44,   # Scroll field backward a line.
    :req_scr_fpage    => KEY_MAX + 45,   # Scroll field forward a page.
    :req_scr_bpage    => KEY_MAX + 46,   # Scroll field backward a page.
    :req_scr_fhpage   => KEY_MAX + 47,   # Scroll field forward	 half page..
    :req_scr_bhpage   => KEY_MAX + 48,   # Scroll field backward half page..
    :req_scr_fchar    => KEY_MAX + 49,   # Horizontal scroll char.
    :req_scr_bchar    => KEY_MAX + 50,   # Horizontal scroll char.
    :req_scr_hfline   => KEY_MAX + 51,   # Horizontal scroll line.
    :req_scr_hbline   => KEY_MAX + 52,   # Horizontal scroll line.
    :req_scr_hfhalf   => KEY_MAX + 53,   # Horizontal scroll half line.
    :req_scr_hbhalf   => KEY_MAX + 54,   # Horizontal scroll half line.
    :req_validation   => KEY_MAX + 55,   # Validate field.
    :req_next_choice  => KEY_MAX + 56,   # Display next field choice.
    :req_prev_choice  => KEY_MAX + 57,   # Display prev field choice.
   )
export formcmd
