## Description #############################################################################
#
# Functions related to anchors.
#
############################################################################################

export process_object_layout

############################################################################################
#                                     Public Functions                                     #
############################################################################################

"""
    process_object_layout(layout::ObjectLayout, parent) -> Int, Int, Int, Int

Process the object `layout` considering its `parent`.

# Returns

- `Int`: The object height.
- `Int`: The object width.
- `Int`: The top position with respect to the parent object.
- `Int`: The left position with respect to the parent object.
"""
function process_object_layout(
    layout::ObjectLayout,
    parent::Object;
    horizontal_hints::Dict{Symbol, Any} = Dict{Symbol, Any}(),
    vertical_hints::Dict{Symbol, Any} = Dict{Symbol, Any}()
)
    @nospecialize parent

    # Process the horizontal and vertical layout information.
    horizontal = _process_horizontal_info(layout)
    vertical   = _process_vertical_info(layout)

    # If we have undefined information, try using the hints.
    if horizontal == :unknown
        # Previously, we used the helper from Parameters.jl:
        #
        #    layout = ObjectLayout(layout; horizontal_hints...)
        #
        # However, it was leading to a huge number of runtime dispatches. Hence, we selected
        # this verbose way to improve the performance.
        layout = ObjectLayout(
            layout.bottom_anchor,
            get(horizontal_hints, :left_anchor, layout.left_anchor)::Anchor,
            get(horizontal_hints, :right_anchor, layout.right_anchor)::Anchor,
            layout.top_anchor,
            get(horizontal_hints, :center_anchor, layout.center_anchor)::Anchor,
            layout.middle_anchor,
            layout.top,
            get(horizontal_hints, :left, layout.left)::Union{Int, String},
            layout.height,
            get(horizontal_hints, :width, layout.width)::Union{Int, String}
        )

        horizontal = _process_horizontal_info(layout)
    end

    if vertical == :unknown
        # Previously, we used the helper from Parameters.jl:
        #
        #    layout = ObjectLayout(layout; vertical_hints...)
        #
        # However, it was leading to a huge number of runtime dispatches. Hence, we selected
        # this verbose way to improve the performance.
        layout = ObjectLayout(
            get(vertical_hints, :bottom_anchor, layout.bottom_anchor)::Anchor,
            layout.left_anchor,
            layout.right_anchor,
            get(vertical_hints, :top_anchor, layout.top_anchor)::Anchor,
            layout.center_anchor,
            get(vertical_hints, :middle_anchor, layout.middle_anchor)::Anchor,
            get(vertical_hints, :top, layout.top)::Union{Int, String},
            layout.left,
            get(vertical_hints, :height, layout.height)::Union{Int, String},
            layout.width
        )

        vertical = _process_vertical_info(layout)
    end

    bottom_anchor = layout.bottom_anchor
    left_anchor   = layout.left_anchor
    right_anchor  = layout.right_anchor
    top_anchor    = layout.top_anchor
    center_anchor = layout.center_anchor
    middle_anchor = layout.middle_anchor

    layout_height = layout.height
    layout_left   = layout.left
    layout_top    = layout.top
    layout_width  = layout.width

    # Absolute positioning.
    top    = _process_layout_property(layout_top,    :height, parent)
    left   = _process_layout_property(layout_left,   :width,  parent)
    height = _process_layout_property(layout_height, :height, parent)
    width  = _process_layout_property(layout_width,  :width,  parent)

    # == Vertical ==========================================================================

    if vertical == :abottom_atop
        bottom = _get_anchor(bottom_anchor, parent)
        top    = _get_anchor(top_anchor, parent)
        height = bottom - top

    elseif vertical == :abottom_top
        bottom = _get_anchor(bottom_anchor, parent)
        height = bottom - top

    elseif vertical == :abottom_height
        bottom = _get_anchor(bottom_anchor, parent)
        top    = bottom - height

    elseif vertical == :atop_height
        top = _get_anchor(top_anchor, parent)

    elseif vertical == :amiddle_height
        middle = _get_anchor(middle_anchor, parent)
        top    = middle - div(height, 2)

    elseif vertical == :unknown
        @log CRITICAL "process_object_layout" """
        It was not possible to guess the vertical layout of the object.

        parent:
        @log_pad 4
        $(string(obj_desc(parent)))
        @log_pad 0
        layout:
        @log_pad 4
        $(_str(layout))"""

        error("It was not possible to guess the vertical layout of the object.")
    end

    if top < 0
        @log CRITICAL "process_object_layout" """
        Wrong vertical size configuration leading to negative top position.

        parent:
        @log_pad 4
        $(string(obj_desc(parent)))
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
        $(string(obj_desc(parent)))
        @log_pad 0
        layout:
        @log_pad 4
        $(_str(layout))"""

        error("Wrong vertical size configuration leading to negative top position.")
    end

    # == Horizontal ========================================================================

    if horizontal == :aleft_aright
        left  = _get_anchor(left_anchor, parent)
        right = _get_anchor(right_anchor, parent)
        width = right - left

    elseif horizontal == :aleft_width
        left = _get_anchor(left_anchor, parent)

    elseif horizontal == :aright_width
        right = _get_anchor(right_anchor, parent)
        left  = right - width

    elseif horizontal == :aright_left
        right = _get_anchor(right_anchor, parent)
        width = right - left

    elseif horizontal == :acenter_width
        center = _get_anchor(center_anchor, parent)
        left   = center - div(width,2)

    elseif horizontal == :unknown
        @log CRITICAL "process_object_layout" """
        It was not possible to guess the horizontal layout of the object.

        parent:
        @log_pad 4
        $(string(parent))
        @log_pad 0
        layout:
        @log_pad 4
        $(_str(layout))"""

        error("It was not possible to guess the horizontal layout of the object.")
    end

    if left < 0
        @log CRITICAL "process_object_layout" """
        Wrong vertical size configuration leading to negative left position.

        parent:
        @log_pad 4
        $(string(parent))
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
        $(string(parent))
        @log_pad 0
        layout:
        @log_pad 4
        $(_str(layout))"""

        error("Wrong vertical size configuration leading to non-positive width position.")
    end

    return height, width, top, left
end

############################################################################################
#                                    Private Functions                                     #
############################################################################################

# Check if the `side` parameter of `anchor` is valid for vertical layout information. If
# `anchor` is `_NO_ANCHOR`, then `true` is always returned.
function _check_vertical_anchor(anchor::Anchor)
    return (anchor == _NO_ANCHOR) || (anchor.side ∈ (:bottom, :middle, :top))
end

# Check if the `side` parameter of `anchor` is valid for horizontal layout information. If
# `anchor` is `_NO_ANCHOR`, then `true` is always returned.
function _check_horizontal_anchor(anchor::Anchor)
    return (anchor == _NO_ANCHOR) || (anchor.side ∈ (:left, :center, :right))
end

# Return the line or column related to the anchor `anchor`. If the object in `anchor` is the
# `parent`, then the layout will be computed relative to the `parent`.
function _get_anchor(anchor::Anchor, parent::Object)
    @nospecialize parent

    obj = anchor.obj
    pad = anchor.pad

    # If `obj` is the parent of the object we want to anchor, the layout computation must be
    # performed differently.
    if !(obj isa Symbol)
        height = get_height(obj)::Int
        left   = get_left(obj)::Int
        top    = get_top(obj)::Int
        width  = get_width(obj)::Int
    elseif obj == :parent
        height = get_inner_height(parent)::Int
        width  = get_inner_width(parent)::Int
        top    = get_inner_top(parent)::Int
        left   = get_inner_left(parent)::Int
    else
        error("Symbol $obj is not a valid source for anchors.")
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

# Process the vertical layout information in `layout`, and return how the vertical layout
# can be obtained:
#
# - `:abottom_atop`: Bottom and top anchors were specified.
# - `:abottom_top`: Bottom anchor and top position were specified.
# - `:abottom_height`: Bottom anchor and height were specified.
# - `:atop_height`: Top anchor and height were specified.
# - `:amiddle_height`: Middle anchor and height were specified.
# - `:top_height`: Top and height were specified.
# - `:unknown`: Insufficient information to compute the vertical positioning.
function _process_vertical_info(layout::ObjectLayout)
    @unpack bottom_anchor, top_anchor, middle_anchor, top, height = layout

    # Check the input parameters.
    if !_check_vertical_anchor(bottom_anchor) ||
       !_check_vertical_anchor(middle_anchor) ||
       !_check_vertical_anchor(top_anchor)

        @log CRITICAL "_process_vertical_info" """
        Wrong vertical anchor type.

        layout:
        @log_pad 4
        $(_str(layout))"""

        error("Wrong vertical anchor type.")
    end

    if (bottom_anchor != _NO_ANCHOR) && (top_anchor != _NO_ANCHOR)
        vertical = :abottom_atop
    elseif (bottom_anchor != _NO_ANCHOR) && ((top isa String) || (top >= 0))
        vertical = :abottom_top
    elseif (bottom_anchor != _NO_ANCHOR) && ((height isa String) || (height > 0))
        vertical = :abottom_height
    elseif (top_anchor != _NO_ANCHOR) && ((height isa String) || (height > 0))
        vertical = :atop_height
    elseif (middle_anchor != _NO_ANCHOR) && ((height isa String) || (height > 0))
        vertical = :amiddle_height
    elseif ((top isa String) || (top >= 0)) && ((height isa String) || (height > 0))
        vertical = :top_height
    else
        vertical = :unknown
    end

    return vertical
end

# Process the horizontal layout information in `layout`, and return how the horizontal
# layout can be obtained:
#
# - `:aleft_aright`: Left and right anchors were specified.
# - `:aleft_width`: Left anchor and width were specified.
# - `:aleft_height`: Left anchor and height were specified.
# - `:aright_height`: Right anchor and height were specified.
# - `:acenter_height`: Center anchor and height were specified.
# - `:left_height`: Left and height were specified.
# - `:unknown`: Insufficient information to compute the horizontal positioning.
function _process_horizontal_info(layout::ObjectLayout)
    @unpack left_anchor, right_anchor, center_anchor, left, width = layout

    # Check the input parameters.
    if !_check_horizontal_anchor(left_anchor)   ||
       !_check_horizontal_anchor(center_anchor) ||
       !_check_horizontal_anchor(right_anchor)

        @log CRITICAL "_PROCESS_HORIZONTAL_INFO" """
        Wrong horizontal anchor type.

        layout:
        @log_pad 4
        $(_str(layout))"""

        error("Wrong vertical anchor type.")
    end

    if (left_anchor != _NO_ANCHOR) && (right_anchor != _NO_ANCHOR)
        horizontal = :aleft_aright
    elseif (left_anchor != _NO_ANCHOR) && ((width isa String) || (width > 0))
        horizontal = :aleft_width
    elseif (right_anchor != _NO_ANCHOR) && ((width isa String) || (width > 0))
        horizontal = :aright_width
    elseif (right_anchor != _NO_ANCHOR) && ((left isa String) || (left ≥ 0))
        horizontal = :aright_left
    elseif (center_anchor != _NO_ANCHOR) && ((width isa String) || (width > 0))
        horizontal = :acenter_width
    elseif ((left isa String) || (left >= 0)) && ((width isa String) || (width > 0))
        horizontal = :left_width
    else
        horizontal = :unknown
    end

    return horizontal
end

# Process the layout value `v` related to the dimension `dim` of the parent widget `parent`.
# `dim` can be `:height` or `:width`.
#
# If `v` is an `Int`, then it return  `v`.
function _process_layout_property(v::String, dim::Symbol, parent::Object)
    @nospecialize parent

    # Check if the format is correct.
    ids = findfirst(r"^[0-9]+%", v)

    if isnothing(ids)
        @log CRITICAL "_process_layout_property" "Invalid value \"$v\" for positioning information."
        error("Invalid value \"$v\" for positioning information.")
    end

    perc = parse(Int, v[ids][1:end - 1])
    size = getproperty(parent, dim)::Int

    return floor(Int, size * perc / 100)
end

function _process_layout_property(v::Int, ::Symbol, parent::Object)
    @nospecialize parent
    return v
end

# Convert the information in `layout` to a string for debugging purposes.
function _str(layout::ObjectLayout)
    ab = layout.bottom_anchor
    al = layout.left_anchor
    ar = layout.right_anchor
    at = layout.top_anchor
    ac = layout.center_anchor
    am = layout.middle_anchor

    ab_str = ab == _NO_ANCHOR ? "No anchor" : "($(typeof(ab.obj)), $(ab.side), $(ab.pad))"
    al_str = al == _NO_ANCHOR ? "No anchor" : "($(typeof(al.obj)), $(al.side), $(al.pad))"
    ar_str = ar == _NO_ANCHOR ? "No anchor" : "($(typeof(ar.obj)), $(ar.side), $(ar.pad))"
    at_str = at == _NO_ANCHOR ? "No anchor" : "($(typeof(at.obj)), $(at.side), $(at.pad))"
    ac_str = ac == _NO_ANCHOR ? "No anchor" : "($(typeof(ac.obj)), $(ac.side), $(ac.pad))"
    am_str = am == _NO_ANCHOR ? "No anchor" : "($(typeof(am.obj)), $(am.side), $(am.pad))"

    return str = """
    bottom_anchor = $am_str
    left_anchor   = $ac_str
    right_anchor  = $at_str
    top_anchor    = $ar_str
    center_anchor = $al_str
    middle_anchor = $ab_str

    top    = $(layout.top)
    left   = $(layout.left)
    height = $(layout.height)
    width  = $(layout.width)
    """
end
