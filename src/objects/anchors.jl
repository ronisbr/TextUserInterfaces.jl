# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Functions related to anchors.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export compute_object_positioning

################################################################################
#                              Public functions
################################################################################

"""
    compute_object_positioning(layout::ObjectLayout, parent)

Compute the object position based on the configuration `layout` and on its
parent object `parent`.

# Return

- The object height.
- The object width.
- The top position w.r.t. the `parent` object.
- The left position w.r.t. the `parent` object.
"""
function compute_object_positioning(layout::ObjectLayout, parent)
    # Process the positioning.
    horizontal =_process_horizontal_info(layout)
    vertical   = _process_vertical_info(layout)

    @unpack_ObjectLayout layout

    anchor_bottom = layout.anchor_bottom
    anchor_left   = layout.anchor_left
    anchor_right  = layout.anchor_right
    anchor_top    = layout.anchor_top
    anchor_center = layout.anchor_center
    anchor_middle = layout.anchor_middle

    # Absolute positioning.
    top    = _process_positioning_value(top,    :height, parent)
    left   = _process_positioning_value(left,   :width,  parent)
    height = _process_positioning_value(height, :height, parent)
    width  = _process_positioning_value(width,  :width,  parent)

    # Vertical
    # ==========================================================================

    if vertical == :abottom_atop
        bottom = _get_anchor(anchor_bottom, parent)
        top    = _get_anchor(anchor_top, parent)
        height = bottom - top

    elseif vertical == :abottom_top
        bottom = _get_anchor(anchor_bottom, parent)
        height = bottom - top

    elseif vertical == :abottom_height
        bottom = _get_anchor(anchor_bottom, parent)
        top    = bottom - height

    elseif vertical == :atop_height
        top = _get_anchor(anchor_top, parent)

    elseif vertical == :amiddle_height
        middle = _get_anchor(anchor_middle, parent)
        top    = middle - div(height, 2)

    elseif vertical == :unknown
        @log critical "compute_object_positioning" """
        It was not possible to guess the vertical positioning of the object.

        parent:
        @log_pad 4
        $parent
        @log_pad 0
        layout:
        @log_pad 4
        $(_str(layout))"""

        error("It was not possible to guess the vertical positioning of the object.")
    end

    if top < 0
        @log critical "compute_object_positioning" """
        Wrong vertical size configuration leading to negative top position.

        parent:
        @log_pad 4
        $parent
        @log_pad 0
        layout:
        @log_pad 4
        $(_str(layout))"""

        error("Wrong vertical size configuration leading to negative top position.")
    end

    if height <= 0
        @log critical "compute_object_positioning" """
        Wrong vertical size configuration leading to negative top position.

        parent:
        @log_pad 4
        $parent
        @log_pad 0
        layout:
        @log_pad 4
        $(_str(layout))"""

        error("Wrong vertical size configuration leading to negative top position.")
    end

    # Horizontal
    # ==========================================================================

    if horizontal == :aleft_aright
        left  = _get_anchor(anchor_left, parent)
        right = _get_anchor(anchor_right, parent)
        width = right - left

    elseif horizontal == :aleft_width
        left = _get_anchor(anchor_left, parent)

    elseif horizontal == :aright_width
        right = _get_anchor(anchor_right, parent)
        left  = right - width

    elseif horizontal == :aright_left
        right = _get_anchor(anchor_right, parent)
        width = right - left

    elseif horizontal == :acenter_width
        center = _get_anchor(anchor_center, parent)
        left   = center - div(width,2)

    elseif horizontal == :unknown
        @log critical "compute_object_positioning" """
        It was not possible to guess the horizontal positioning of the object.

        parent:
        @log_pad 4
        $parent
        @log_pad 0
        layout:
        @log_pad 4
        $(_str(layout))"""

        error("It was not possible to guess the horizontal positioning of the object.")
    end

    if left < 0
        @log critical "compute_object_positioning" """
        Wrong vertical size configuration leading to negative left position.

        parent:
        @log_pad 4
        $parent
        @log_pad 0
        layout:
        @log_pad 4
        $(_str(layout))"""

        error("Wrong vertical size configuration leading to negative left position.")
    end

    if width <= 0
        @log critical "compute_object_positioning" """
        Wrong vertical size configuration leading to non-positive width position.

        parent:
        @log_pad 4
        $parent
        @log_pad 0
        layout:
        @log_pad 4
        $(_str(layout))"""

        error("Wrong vertical size configuration leading to non-positive width position.")
    end

    return height, width, top, left
end

################################################################################
#                              Private functions
################################################################################

"""
    _check_vertical_anchor(anchor::Nothing)
    _check_vertical_anchor(anchor::Anchor)

Check if the `side` parameter of `anchor` is valid for vertical positioning. If
`anchor` is `_no_anchor`, then `true` is always returned.
"""
function _check_vertical_anchor(anchor::Anchor)
    return (anchor == _no_anchor) || (anchor.side ∈ [:bottom,:middle,:top])
end

"""
    _check_horizontal_anchor(anchor::Anchor)

Check if the `side` parameter of `anchor` is valid for horizontal positioning.
If `anchor` is `_no_anchor`, then `true` is always returned.
"""
function _check_horizontal_anchor(anchor::Anchor)
    return (anchor == _no_anchor) || (anchor.side ∈ [:left,:center,:right])
end

"""
    _get_anchor(anchor::Anchor, parent)

Return the line or column related to the anchor `anchor`. If the object in
`anchor` is the `parent`, then the positioning will be computed relative to the
`parent`.
"""
function _get_anchor(anchor::Anchor, parent)
    obj = anchor.obj
    pad = anchor.pad

    # If `obj` is the parent of the object we want to anchor, then the
    # computation of the position must be performed differently.
    if obj == :parent
        height = get_height_for_child(parent)
        width  = get_width_for_child(parent)
        top    = get_top_for_child(parent)
        left   = get_left_for_child(parent)

    else
        # If the object is not added to a parent, we cannot get its information.
        if !(obj isa Window) && isnothing(obj.parent)
            @log critical "_get_anchor" """
            An anchor is referencing an object which is not added to any parent yet.

            obj:
            @log_pad 4
            $obj"""

            error("An anchor is referencing an object which is not added to any parent yet.")
        end

        top    = get_top(obj)
        left   = get_left(obj)
        height = get_height(obj)
        width  = get_width(obj)
    end

    if anchor.side == :bottom
        return top + height + pad
    elseif anchor.side == :top
        return top + pad
    elseif anchor.side == :left
        return left + pad
    elseif anchor.side == :right
        return left + width + pad
    elseif anchor.side == :center
        return left + div(width, 2) + pad
    elseif anchor.side == :middle
        return top + div(height, 2) + pad
    else
        error("Unknown side in anchor.")
    end
end

"""
    _process_vertical_info(layout::ObjectLayout)

Process the vertical positioning information in `layout` and write the variable
`vertical` of the same structure. The possible vertical positioning information
are:

- `:abottom_atop`: Bottom and top anchors were specified.
- `:abottom_height`: Bottom anchor and height were specified.
- `:atop_height`: Top anchor and height were specified.
- `:amiddle_height`: Middle anchor and height were specified.
- `:top_height`: Top and height were specified.
- `:unknown`: Insufficient information to compute the vertical positioning.
"""
function _process_vertical_info(layout::ObjectLayout)
    @unpack anchor_bottom, anchor_top, anchor_middle, top, height = layout

    # Check the input parameters.
    if !_check_vertical_anchor(anchor_bottom) ||
       !_check_vertical_anchor(anchor_middle) ||
       !_check_vertical_anchor(anchor_top)

        @log critical "_process_vertical_info" """
        Wrong vertical anchor type.

        layout:
        @log_pad 4
        $(_str(layout))"""

        error("Wrong vertical anchor type.")
    end

    if (anchor_bottom != _no_anchor) && (anchor_top != _no_anchor)
        vertical = :abottom_atop
    elseif (anchor_bottom != _no_anchor) && ((top isa String) || (top ≥ 0))
        vertical = :abottom_top
    elseif (anchor_bottom != _no_anchor) && ((height isa String) || (height > 0))
        vertical = :abottom_height
    elseif (anchor_top != _no_anchor) && ((height isa String) || (height > 0))
        vertical = :atop_height
    elseif (anchor_middle != _no_anchor) && ((height isa String) || (height > 0))
        vertical = :amiddle_height
    elseif ((top isa String) || (top ≥ 0)) && ((height isa String) || (height > 0))
        vertical = :top_height
    else
        vertical = :unknown
    end

    return vertical
end

"""
    _process_horizontal_info(layout::ObjectLayout)

Process the horizontal positioning information in `layout` and write the variable
`horizontal` of the same structure. The possible horizontal positioning
information are:

- `:aleft_aright`: Left and right anchors were specified.
- `:aleft_height`: Left anchor and height were specified.
- `:aright_height`: Right anchor and height were specified.
- `:acenter_height`: Center anchor and height were specified.
- `:right_height`: Right and height were specified.
- `:unknown`: Insufficient information to compute the horizontal positioning.
"""
function _process_horizontal_info(layout::ObjectLayout)
    @unpack anchor_left, anchor_right, anchor_center, left, width = layout

    # Check the input parameters.
    if !_check_horizontal_anchor(anchor_left)   ||
       !_check_horizontal_anchor(anchor_center) ||
       !_check_horizontal_anchor(anchor_right)

        @log critical "_process_horizontal_info" """
        Wrong horizontal anchor type.

        layout:
        @log_pad 4
        $(_str(layout))"""

        error("Wrong vertical anchor type.")
    end

    if (anchor_left != _no_anchor) && (anchor_right != _no_anchor)
        horizontal = :aleft_aright
    elseif (anchor_left != _no_anchor) && ((width isa String) || (width > 0))
        horizontal = :aleft_width
    elseif (anchor_right != _no_anchor) && ((width isa String) || (width > 0))
        horizontal = :aright_width
    elseif (anchor_right != _no_anchor) && ((left isa String) || (left ≥ 0))
        horizontal = :aright_left
    elseif (anchor_center != _no_anchor) && ((width isa String) || (width > 0))
        horizontal = :acenter_width
    elseif ((left isa String) || (left ≥ 0)) && ((width isa String) || (width > 0))
        horizontal = :left_width
    else
        horizontal = :unknown
    end

    return horizontal
end

"""
    _process_positioning_value(v, dim::Symbol, parent::WidgetParent)

Process the positioning value `v` related to the dimension `dim` of the parent
widget `parent`. `dim` can be `:height` or `:width`.

If `v` is an `Int`, then it return  `v`.
"""
function _process_positioning_value(v::String, dim::Symbol, parent::WidgetParent)
    # Check if the format is correct.
    ids = findfirst(r"^[0-9]+%", v)

    if isnothing(ids)
        @log critical "_process_positioning_value" "Invalid value \"$v\" for positioning information."
        error("Invalid value \"$v\" for positioning information.")
    end

    perc = parse(Int, v[ids][1:end-1])

    return floor(Int, getfield(parent, dim)*perc/100)
end

_process_positioning_value(v::Int, ::Symbol, ::WidgetParent) = v

"""
    _str(wpc::ObjectLayout)

Convert the information in `wpc` to a string for debugging purposes.
"""
function _str(layout::ObjectLayout)
    ab = layout.anchor_bottom
    al = layout.anchor_left
    ar = layout.anchor_right
    at = layout.anchor_top
    ac = layout.anchor_center
    am = layout.anchor_middle

    ab_str = ab == _no_anchor ? "No anchor" : "($(typeof(ab.obj)), $(ab.side), $(ab.pad))"
    al_str = al == _no_anchor ? "No anchor" : "($(typeof(al.obj)), $(al.side), $(al.pad))"
    ar_str = ar == _no_anchor ? "No anchor" : "($(typeof(ar.obj)), $(ar.side), $(ar.pad))"
    at_str = at == _no_anchor ? "No anchor" : "($(typeof(at.obj)), $(at.side), $(at.pad))"
    ac_str = ac == _no_anchor ? "No anchor" : "($(typeof(ac.obj)), $(ac.side), $(ac.pad))"
    am_str = am == _no_anchor ? "No anchor" : "($(typeof(am.obj)), $(am.side), $(am.pad))"

    return str = """
    anchor_bottom = $am_str
    anchor_left   = $ac_str
    anchor_right  = $at_str
    anchor_top    = $ar_str
    anchor_center = $al_str
    anchor_middle = $ab_str

    top    = $(layout.top)
    left   = $(layout.left)
    height = $(layout.height)
    width  = $(layout.width)
    """
end
