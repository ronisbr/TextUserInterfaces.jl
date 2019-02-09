# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   This file contains functions related to forms handling.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export create_field, create_form, destroy_field, destroy_form, post_form,
       unpost_form, form_driver

"""
    function create_field(height::Int, width::Int, y::Int, x::Int, buffer::String = "", offscreen::Int = 0, nbuffers::Int = 0; ...)

Create a field with height `height` and width `width`, positioned at `y` and `x`
coordinates. The initial buffer string can be set by the variable `buffer`. The
number of off-screen rows is set by `offscreen` and the number of buffers
`nbuffers`.

# Keywords

* `color_foreground`: Color mask that will be used in the field foreground. See
                      function `ncurses_color`. If negative, then the color will
                      not be changed. (**Default** = -1)
* `color_background`: Color mask that will be used in the field background. See
                      function `ncurses_color`. If negative, then the color will
                      not be changed. (**Default** = -1)
* `justification`: Justification of the form. It can be `:l` for left, `:c` for
                   center, and `:r` for right. For any other symbol, the left
                   justification is used. (**Default** = `:l`)
* `visible`: If `true`, then the control is visible on the screen.
             (**Default** = `true`)
* `active`: If `true`, then the control is active. (**Default** = `true`)
* `public`: If `true`, then the data of the field is displayed during entry. For
            example, set this to `false` for password fields.
            (**Default** = `true`)
* `edit`: If `true`, then the data of the field can be modified.
          (**Default** = `true`)
* `wrap`: If `true`, then the word will be wrapped in multi-line fields.
          (**Default** = `true`)
* `blank`: If `true`, then entering a character at the first field position
           erases the entire fields. (**Default** = `false`)
* `autoskip`: If `true`, then the field will be automatically skipped when
              filled. (**Default** = `false`)
* `nullok`: If `true`, then the validation is **not** applied to blank fields.
            (**Default** = `true`)
* `passok`: If `true`, then the validation will occur on every exit. Otherwise,
            it will only occur when the field is modified.
            (**Default** = `false`)
* `static`: If `true`, then the field is fixed to the initial dimensions.
            Otherwise, it will stretch to fit the entered data.
            (**Default** = `true`)

"""
function create_field(height::Int, width::Int, y::Int, x::Int,
                      buffer::String = "", offscreen::Int = 0, nbuffers::Int = 0;
                      color_foreground::Int = -1,
                      color_background::Int = -1,
                      justification::Symbol = :l,
                      visible::Bool = true,
                      active::Bool = true,
                      public::Bool = true,
                      edit::Bool = true,
                      wrap::Bool = true,
                      blank::Bool = false,
                      autoskip::Bool = false,
                      nullok::Bool = true,
                      passok::Bool = false,
                      static::Bool = true)

    # Create the new field.
    field = new_field(height, width, y, x, offscreen, nbuffers)

    # Create the attributes based on the user selections.
    attrs  = 0x00

    visible  && (attrs |= fieldopts[:o_visible])
    active   && (attrs |= fieldopts[:o_active])
    public   && (attrs |= fieldopts[:o_public])
    edit     && (attrs |= fieldopts[:o_edit])
    wrap     && (attrs |= fieldopts[:o_wrap])
    blank    && (attrs |= fieldopts[:o_blank])
    autoskip && (attrs |= fieldopts[:o_autoskip])
    nullok   && (attrs |= fieldopts[:o_nullok])
    passok   && (attrs |= fieldopts[:o_passok])
    static   && (attrs |= fieldopts[:o_static])

    set_field_opts(field, attrs)

    # Set the justification.
    if justification == :r
        set_field_just(field, fieldjust[:justify_right])
    elseif justification == :c
        set_field_just(field, fieldjust[:justify_center])
    else
        set_field_just(field, fieldjust[:justify_left])
    end

    # Set the colors.
    color_background >= 0 && set_field_back(field, color_background)
    color_foreground >= 0 && set_field_fore(field, color_foreground)

    # Set the buffer.
    length(buffer) > 0 && set_field_buffer(field, 0, buffer)

    return field
end

"""
    function create_form(fields::Vector{Ptr{Cvoid}}; ...)

Create a new form with the fields `fields`.

# Keywords

* `newline_overload`: Enable overloading of `REQ_NEW_LINE`.
                      (**Default** = `false`)
* `backspace_overload`: Enable overloading of `REQ_DEL_PREV`.
                        (**Default** = `false`)

"""
function create_form(fields::Vector{Ptr{Cvoid}};
                     newline_overload::Bool = false,
                     backspace_overload::Bool = false)

    # The last element of the `fields` vector must be `null`.
    fields[end] != C_NULL && push!(fields, C_NULL)

    # Create the form.
    form = new_form(fields)

    # Create the attributes based on the user selections.
    attrs  = 0x00

    newline_overload   && (attrs |= formopts[:o_nl_overload])
    backspace_overload && (attrs |= formopts[:o_bs_overload])

    set_form_opts(form, attrs)

    return TUI_FORM(fields = fields, ptr = form)
end

"""
    function destroy_field(field::Ptr{Cvoid})

Destroy the field `field`.

"""
function destroy_field(field::Ptr{Cvoid})
    field != C_NULL && free_field(field)
    return nothing
end

"""
    function destroy_form(form::TUI_FORM)

Destroy the form `form`.

"""
function destroy_form(form::TUI_FORM)
    form.ptr != C_NULL && free_form(form.ptr)
    for field in form.fields
        destroy_field(field)
    end
    return nothing
end

"""
    function post_form(form::TUI_FORM)

Post the for `form`.

"""
function post_form(form::TUI_FORM)
    form.ptr != C_NULL && post_form(form.ptr)
    return nothing
end

"""
    function unpost_form(form::TUI_FORM)

Unpost the form `form`.

"""
function unpost_form(form::TUI_FORM)
    form.ptr != C_NULL && unpost_form(form.ptr)
    return nothing
end

"""
    function set_form_win(form::TUI_FORM, win::TUI_WINDOW)

Set the form `form` window to `win`.

"""
function set_form_win(form::TUI_FORM, win::TUI_WINDOW)
    (form.ptr != C_NULL) && (win.ptr != C_NULL) && set_form_win(form.ptr, win.ptr)
    return nothing
end

"""
    function set_form_sub(form::TUI_FORM, win::TUI_WINDOW)

Set the form `form` sub-window to `sub`.

"""
function set_form_sub(form::TUI_FORM, win::TUI_WINDOW)
    (form.ptr != C_NULL) && (win.ptr != C_NULL) && set_form_sub(form.ptr, win.ptr)
    return nothing
end

# Commands to the forms
# ==============================================================================

for (f,c,d) in
    [
     (:form_next_field, :req_next_field, "Move to the next field of the form `form`."),
     (:form_prev_field, :req_prev_field, "Move to the previous field of the form `form`."),
     (:form_next_char,  :req_next_char,  "Move to the next character of the active field in the form `form`."),
     (:form_prev_char,  :req_prev_char,  "Move to the previous character of the active field in the form `form`."),
     (:form_beg_field,  :req_beg_field,  "Move to the beginning of the active field in the form `form`."),
     (:form_end_field,  :req_end_field,  "Move to the end of the active field in the form `form`."),
     (:form_left_char,  :req_left_char,  "Move to the left character of the active field in the form `form`."),
     (:form_right_char, :req_right_char, "Move to the right character of the active field in the form `form`."),
     (:form_up_char,    :req_up_char,    "Move to the up character of the active field in the form `form`."),
     (:form_down_char,  :req_down_char,  "Move to the down character of the active field in the form `form`."),
     (:form_del_char,   :req_del_char,   "Delete the character at the cursor of the active field in the form `form`."),
     (:form_del_prev,   :req_del_prev,   "Delete the previous character from the cursor of the active field in the form `form`."),
    ]

    fq = Meta.quot(f)
    cq = Meta.quot(c)

    @eval begin
        function $f(form::TUI_FORM)
            form.ptr != C_NULL && form_driver(form.ptr, formcmd[$cq])
            return nothing
        end
        export $f

        @doc """
            function $($fq)(form::TUI_FORM)

        $($d)

        """ $f
    end
end

"""
    function form_add_char(form::TUI_FORM, ch::Int)

Add the character `ch` to the active field of the form `form`.

"""
function form_add_char(form::TUI_FORM, ch::UInt32)
    form.ptr != C_NULL && form_driver(form.ptr, ch)
    return nothing
end
export form_add_char

# Form driver helper
# ==============================================================================

# Default commands.
const _default_forms_cmds = Dict{Union{String,Tuple{Symbol,Bool,Bool,Bool}},Function}(
    (:down,     false,false,false) => form_down_char,
    (:left,     false,false,false) => form_left_char,
    (:right,    false,false,false) => form_right_char,
    (:up,       false,false,false) => form_up_char,
    (:home,     false,false,false) => form_beg_field,
    (:end,      false,false,false) => form_end_field,
    (:delete,   false,false,false) => form_del_char,
    (:tab,      false,false,false) => form_next_field,
    (:tab,      false,false, true) => form_prev_field,
    (:backspace,false,false,false) => form_del_prev,
)

function form_driver(form::TUI_FORM, k::Keystroke;
                     user_cmds::Dict{Union{String,Tuple{Symbol,Bool,Bool,Bool}},Function} =
                     Dict{Union{String,Tuple{Symbol,Bool,Bool,Bool}},Function}())

    # Merge the commands to the default.
    cmds = merge(_default_forms_cmds, user_cmds)

    # Check if we must execute a command.
    form_func = nothing

    if haskey( cmds, (k.ktype,k.alt,k.ctrl,k.shift) )
        form_func = cmds[(k.ktype,k.alt,k.ctrl,k.shift)]
    elseif haskey(cmds, k.value)
        form_func = cmds[k.value]
    end

    if form_func != nothing
        form_func(form)
        return true
    else
        if k.ktype == :char || k.ktype == :utf8
            form_add_char(form, UInt32(k.value[1]))
            return true
        end
    end

    return false
end
