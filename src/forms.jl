# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   This file contains functions related to forms handling.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export create_field, create_form, destroy_field, destroy_form, get_field_data,
       post_form, unpost_form, form_driver, set_field_type, set_form_win

"""
    function create_field(height::Int, width::Int, y::Int, x::Int, buffer::String = "", id::String = "", offscreen::Int = 0, nbuffers::Int = 0; ...)

Create a field with id `id`, height `height` and width `width`, positioned at
`y` and `x` coordinates. The initial buffer string can be set by the variable
`buffer`. The number of off-screen rows is set by `offscreen` and the number of
buffers `nbuffers`.

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
                      buffer::String = "", id::String = "", offscreen::Int = 0,
                      nbuffers::Int = 0;
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

    return TUI_FIELD(id               = id,
                     ptr              = field,
                     height           = height,
                     width            = width,
                     y                = y,
                     x                = x,
                     buffer           = buffer,
                     offscreen        = offscreen,
                     nbuffers         = nbuffers,
                     color_foreground = color_foreground,
                     color_background = color_background,
                     justification    = justification,
                     visible          = visible,
                     active           = active,
                     public           = public,
                     edit             = edit,
                     wrap             = wrap,
                     blank            = blank,
                     autoskip         = autoskip,
                     nullok           = nullok,
                     passok           = passok,
                     static           = static)
end

"""
    function create_form(fields::Vector{TUI_FIELD}; ...)

Create a new form with the fields `fields`.

# Keywords

* `newline_overload`: Enable overloading of `REQ_NEW_LINE`.
                      (**Default** = `false`)
* `backspace_overload`: Enable overloading of `REQ_DEL_PREV`.
                        (**Default** = `false`)

"""
function create_form(fields::Vector{TUI_FIELD};
                     newline_overload::Bool = false,
                     backspace_overload::Bool = false)

    # Assemble the vector with the pointers to the fields.
    ptr_fields = [f.ptr for f in fields]

    # The last element of the `fields` vector must be `null`.
    ptr_fields[end] != C_NULL && push!(ptr_fields, C_NULL)

    # Create the form.
    form = new_form(ptr_fields)

    # Create the attributes based on the user selections.
    attrs  = 0x00

    newline_overload   && (attrs |= formopts[:o_nl_overload])
    backspace_overload && (attrs |= formopts[:o_bs_overload])

    set_form_opts(form, attrs)

    return TUI_FORM(fields = fields, ptr_fields = ptr_fields, ptr = form)
end

"""
    function destroy_field(field::Ptr{Cvoid})

Destroy the field `field`.

"""
function destroy_field(field::TUI_FIELD)
    field.ptr   != C_NULL && free_field(field.ptr)
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
    function get_field_data(field::TUI_FIELD, buffer::Int = 0)

Get the data of the field `field` at buffer `buffer`.

"""
function get_field_data(field::TUI_FIELD, buffer::Int = 0)
    pstr = field_buffer(field.ptr, buffer)
    return unsafe_string(pstr)
end

"""
    function get_field_data(form::TUI_FORM, field_id::String, buffer::Int = 0)

Get the data of the field with ID `field_id` at buffer `buffer` in the form
`form`

"""
function get_field_data(form::TUI_FORM, field_id::String, buffer::Int = 0)
    field_ind = findfirst( x->x.id == field_id, form.fields )

    field_ind == nothing && error("Field $field_id was not found in the form.")

    return get_field_data(form.fields[field_ind])
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

function set_field_type(form::TUI_FORM, field_id::String, T::Type, args...)
    field_ind = findfirst( x->x.id == field_id, form.fields )

    field_ind == nothing && error("Field $field_id was not found in the form.")

    set_field_type(form.fields[field_ind], T, args...)
end

set_field_type(field::TUI_FIELD, ::Type{Val{:alnum}}, min_width::Integer) =
    set_field_type(field.ptr, TYPE_ALNUM(), args[1])

set_field_type(field::TUI_FIELD, ::Type{Val{:alpha}}, min_width::Integer) =
    set_field_type(field.ptr, TYPE_ALPHA(), args[1])

function set_field_type(field::TUI_FIELD, ::Type{Val{:enum}},
                        values::Vector{String}, check_case::Bool = false,
                        check_unique::Bool = false)

    # Create the array with the pointer to the strings.
    pointers = [ Cstring(pointer(v)) for v in values ]

    # The array must be NULL terminated.
    push!(pointers, C_NULL)

    # Store `pointers` to avoid being collect by the GC.
    field.penum = pointers

    # Set the field type.
    set_field_type(field.ptr, TYPE_ENUM(), pointers, check_case, check_unique)
end

set_field_type(field::TUI_FIELD, ::Type{Val{:integer}}, padding::Int,
               vmin::Int, vmax::Int) =
    set_field_type(field.ptr, TYPE_INTEGER(), padding, vmin, vmax)

set_field_type(field::TUI_FIELD, ::Type{Val{:numeric}}, padding::Int,
               vmin::Number, vmax::Number) =
    set_field_type(field.ptr, TYPE_NUMERIC(), padding, Float64(vmin), Float64(vmax))

set_field_type(field::TUI_FIELD, ::Type{Val{:regexp}}, regex::Regex) =
    set_field_type(field.ptr, TYPE_REGEXP(), regex.pattern)

"""
    function set_form_win(form::TUI_FORM, win::Window)

Set the form `form` window to `win`.

"""
function set_form_win(form::TUI_FORM, win::Window)
    if (form.ptr != C_NULL) && (win.ptr != C_NULL)
        form.win = win
        set_form_win(form.ptr, win.ptr)
        set_form_sub(form.ptr, win.ptr)
        push!(win.children, form)

        # Show the form.
        post_form(form)
        request_view_update(win)
        refresh_window(win)
    end

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
        request_view_update(form.win)
        update_cursor(form.win)
        return true
    else
        if k.ktype == :enter
            form.on_return_pressed(form)
            request_view_update(form.win)
            update_cursor(form.win)
            return true
        elseif (k.ktype == :char) || (k.ktype == :utf8)
            form_add_char(form, UInt32(k.value[1]))
            request_view_update(form.win)
            update_cursor(form.win)
            return true
        end
    end

    return false
end

################################################################################
#                                     API
################################################################################

# Focus manager
# ==============================================================================

"""
    function accept_focus(form::TUI_FORM)

Command executed when form `form` must state whether or not it accepts the
focus. If the focus is accepted, then this function returns `true`. Otherwise,
it returns `false`.

"""
function accept_focus(form::TUI_FORM)
    form.has_focus = true
    update_cursor(form.win)
    request_view_update(form.win)
    return true
end

"""
    function process_focus(form::TUI_FORM, k::Keystroke)

Process the actions when the form `form` is in focus and the keystroke `k` was
issued by the user.

"""
function process_focus(form::TUI_FORM, k::Keystroke)
    return form_driver(form, k)
end

"""
    function release_focus(form::TUI_FORM)

Release the focus from the form `form`.

"""
function release_focus(form::TUI_FORM)
    form.has_focus = false
    return nothing
end
