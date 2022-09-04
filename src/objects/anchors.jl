# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Functions related to anchors.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export process_object_layout

################################################################################
#                              Public functions
################################################################################

"""
    process_object_layout(layout::ObjectLayout, parent)

Process the object `layout` considering its `parent`.

# Return

- The object height.
- The object width.
- The top position with respect to the parent object.
- The left position with respect to the parent object.
"""
function process_object_layout(layout::ObjectLayout, parent::Object; hints = (;))
    # Process the horizontal and vertical layout information.
    horizontal = _process_horizontal_info(layout)
    vertical   = _process_vertical_info(layout)

    # If we have undefined information, try using the hints.
    if (horizontal == :undefined) || (vertical == :undefined)
        layout = ObjectLayout(layout; hints)

        horizontal = _process_horizontal_info(layout)
        vertical   = _process_vertical_info(layout)
    end

    anchor_bottom = layout.anchor_bottom
    anchor_left   = layout.anchor_left
    anchor_right  = layout.anchor_right
    anchor_top    = layout.anchor_top
    anchor_center = layout.anchor_center
    anchor_middle = layout.anchor_middle

    height = layout.height
    left   = layout.left
    top    = layout.top
    width  = layout.width

    # Absolute positioning.
    top    = _process_layout_property(top,    :height, parent)
    left   = _process_layout_property(left,   :width,  parent)
    height = _process_layout_property(height, :height, parent)
    width  = _process_layout_property(width,  :width,  parent)

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
        @log CRITICAL "process_object_layout" """
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
        @log CRITICAL "process_object_layout" """
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
        @log CRITICAL "process_object_layout" """
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
        @log CRITICAL "process_object_layout" """
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
        @log CRITICAL "process_object_layout" """
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
        @log CRITICAL "process_object_layout" """
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

# Check if the `side` parameter of `anchor` is valid for vertical layout
# information. If `anchor` is `_NO_ANCHOR`, then `true` is always returned.
function _check_vertical_anchor(anchor::Anchor)
    return (anchor == _NO_ANCHOR) || (anchor.side ∈ [:bottom, :middle, :top])
end

# Check if the `side` parameter of `anchor` is valid for horizontal layout
# information. If `anchor` is `_NO_ANCHOR`, then `true` is always returned.
function _check_horizontal_anchor(anchor::Anchor)
    return (anchor == _NO_ANCHOR) || (anchor.side ∈ [:left, :center, :right])
end

# Return the line or column related to the anchor `anchor`. If the object in
# `anchor` is the `parent`, then the layout will be computed relative to the
# `parent`.
function _get_anchor(anchor::Anchor, parent)
    obj = anchor.obj
    pad = anchor.pad

    # If `obj` is the parent of the object we want to anchor, then the layout
    # computation must be performed differently.
    if obj == :parent
        height = get_inner_height(parent)
        width  = get_inner_width(parent)
        top    = get_inner_top(parent)
        left   = get_inner_left(parent)
    else
        height = get_height(obj)
        left   = get_left(obj)
        top    = get_top(obj)
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

# Process the vertical layout information in `layout`, and return how the
# vertical layout can be obtained:
#
# - `:abottom_atop`: Bottom and top anchors were specified.
# - `:abottom_top`: Bottom anchor and top position were specified.
# - `:abottom_height`: Bottom anchor and height were specified.
# - `:atop_height`: Top anchor and height were specified.
# - `:amiddle_height`: Middle anchor and height were specified.
# - `:top_height`: Top and height were specified.
# - `:unknown`: Insufficient information to compute the vertical positioning.
function _process_vertical_info(layout::ObjectLayout)
    @unpack anchor_bottom, anchor_top, anchor_middle, top, height = layout

    # Check the input parameters.
    if !_check_vertical_anchor(anchor_bottom) ||
       !_check_vertical_anchor(anchor_middle) ||
       !_check_vertical_anchor(anchor_top)

        @log CRITICAL "_process_vertical_info" """
        Wrong vertical anchor type.

        layout:
        @log_pad 4
        $(_str(layout))"""

        error("Wrong vertical anchor type.")
    end

    if (anchor_bottom != _NO_ANCHOR) && (anchor_top != _NO_ANCHOR)
        vertical = :abottom_atop
    elseif (anchor_bottom != _NO_ANCHOR) && ((top isa String) || (top >= 0))
        vertical = :abottom_top
    elseif (anchor_bottom != _NO_ANCHOR) && ((height isa String) || (height > 0))
        vertical = :abottom_height
    elseif (anchor_top != _NO_ANCHOR) && ((height isa String) || (height > 0))
        vertical = :atop_height
    elseif (anchor_middle != _NO_ANCHOR) && ((height isa String) || (height > 0))
        vertical = :amiddle_height
    elseif ((top isa String) || (top >= 0)) && ((height isa String) || (height > 0))
        vertical = :top_height
    else
        vertical = :unknown
    end

    return vertical
end

# Process the horizontal layout information in `layout`, and return how the
# horizontal layout can be obtained:
#
# - `:aleft_aright`: Left and right anchors were specified.
# - `:aleft_width`: Left anchor and width were specified.
# - `:aleft_height`: Left anchor and height were specified.
# - `:aright_height`: Right anchor and height were specified.
# - `:acenter_height`: Center anchor and height were specified.
# - `:left_height`: Left and height were specified.
# - `:unknown`: Insufficient information to compute the horizontal positioning.
function _process_horizontal_info(layout::ObjectLayout)
    @unpack anchor_left, anchor_right, anchor_center, left, width = layout

    # Check the input parameters.
    if !_check_horizontal_anchor(anchor_left)   ||
       !_check_horizontal_anchor(anchor_center) ||
       !_check_horizontal_anchor(anchor_right)

        @log CRITICAL "_PROCESS_HORIZONTAL_INFO" """
        Wrong horizontal anchor type.

        layout:
        @log_pad 4
        $(_str(layout))"""

        error("Wrong vertical anchor type.")
    end

    if (anchor_left != _NO_ANCHOR) && (anchor_right != _NO_ANCHOR)
        horizontal = :aleft_aright
    elseif (anchor_left != _NO_ANCHOR) && ((width isa String) || (width > 0))
        horizontal = :aleft_width
    elseif (anchor_right != _NO_ANCHOR) && ((width isa String) || (width > 0))
        horizontal = :aright_width
    elseif (anchor_right != _NO_ANCHOR) && ((left isa String) || (left ≥ 0))
        horizontal = :aright_left
    elseif (anchor_center != _NO_ANCHOR) && ((width isa String) || (width > 0))
        horizontal = :acenter_width
    elseif ((left isa String) || (left >= 0)) && ((width isa String) || (width > 0))
        horizontal = :left_width
    else
        horizontal = :unknown
    end

    return horizontal
end

# Process the layout value `v` related to the dimension `dim` of the parent
# widget `parent`. `dim` can be `:height` or `:width`.
#
# If `v` is an `Int`, then it return  `v`.
function _process_layout_property(v::String, dim::Symbol, parent::Object)
    # Check if the format is correct.
    ids = findfirst(r"^[0-9]+%", v)

    if isnothing(ids)
        @log CRITICAL "_process_layout_property" "Invalid value \"$v\" for positioning information."
        error("Invalid value \"$v\" for positioning information.")
    end

    perc = parse(Int, v[ids][1:end - 1])

    return floor(Int, getfield(parent, dim) * perc / 100)
end

_process_layout_property(v::Int, ::Symbol, ::Object) = v

# Convert the information in `layout` to a string for debugging purposes.
function _str(layout::ObjectLayout)
    ab = layout.anchor_bottom
    al = layout.anchor_left
    ar = layout.anchor_right
    at = layout.anchor_top
    ac = layout.anchor_center
    am = layout.anchor_middle

    ab_str = ab == _NO_ANCHOR ? "No anchor" : "($(typeof(ab.obj)), $(ab.side), $(ab.pad))"
    al_str = al == _NO_ANCHOR ? "No anchor" : "($(typeof(al.obj)), $(al.side), $(al.pad))"
    ar_str = ar == _NO_ANCHOR ? "No anchor" : "($(typeof(ar.obj)), $(ar.side), $(ar.pad))"
    at_str = at == _NO_ANCHOR ? "No anchor" : "($(typeof(at.obj)), $(at.side), $(at.pad))"
    ac_str = ac == _NO_ANCHOR ? "No anchor" : "($(typeof(ac.obj)), $(ac.side), $(ac.pad))"
    am_str = am == _NO_ANCHOR ? "No anchor" : "($(typeof(am.obj)), $(am.side), $(am.pad))"

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
