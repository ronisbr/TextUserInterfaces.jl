# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   Functions related to anchors.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export object_positioning_conf, compute_object_positioning

################################################################################
#                              Public functions
################################################################################

"""
    compute_object_positioning(opc::ObjectPositioningConfiguration, parent)

Compute the object position based on the configuration `opc` and on its
parent object `parent`.

# Return

* The object height.
* The object width.
* The top position w.r.t. the `parent` object.
* The left position w.r.t. the `parent` object.

"""
function compute_object_positioning(opc::ObjectPositioningConfiguration, parent)

    # Process the positioning.
    _process_vertical_info!(opc)
    _process_horizontal_info!(opc)

    @unpack_ObjectPositioningConfiguration opc

    # Vertical
    # ==========================================================================

    if vertical == :abottom_atop
        bottom = _get_anchor(anchor_bottom, parent)
        top    = _get_anchor(anchor_top, parent)
        height = bottom - top

    elseif vertical == :abottom_height
        bottom = _get_anchor(anchor_bottom, parent)
        top    = bottom - height

    elseif vertical == :atop_height
        top = _get_anchor(anchor_top, parent)

    elseif vertical == :amiddle_height
        middle = _get_anchor(anchor_middle, parent)
        top    = middle - div(height,2)

    elseif vertical == :unknown
        @log critical "compute_object_positioning" """
        It was not possible to guess the vertical positioning of the object.

        parent:
        @log_pad 4
        $parent
        @log_pad 0
        opc:
        @log_pad 4
        $(_str(opc))"""

        error("It was not possible to guess the vertical positioning of the object.")
    end

    if top < 0
        @log critical "compute_object_positioning" """
        Wrong vertical size configuration leading to negative top position.

        parent:
        @log_pad 4
        $parent
        @log_pad 0
        opc:
        @log_pad 4
        $(_str(opc))"""

        error("Wrong vertical size configuration leading to negative top position.")
    end

    if height <= 0
        @log critical "compute_object_positioning" """
        Wrong vertical size configuration leading to negative top position.

        parent:
        @log_pad 4
        $parent
        @log_pad 0
        opc:
        @log_pad 4
        $(_str(opc))"""

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
        opc:
        @log_pad 4
        $(_str(opc))"""

        error("It was not possible to guess the horizontal positioning of the object.")
    end

    if left < 0
        @log critical "compute_object_positioning" """
        Wrong vertical size configuration leading to negative left position.

        parent:
        @log_pad 4
        $parent
        @log_pad 0
        opc:
        @log_pad 4
        $(_str(opc))"""

        error("Wrong vertical size configuration leading to negative left position.")
    end

    if width <= 0
        @log critical "compute_object_positioning" """
        Wrong vertical size configuration leading to non-positive width position.

        parent:
        @log_pad 4
        $parent
        @log_pad 0
        opc:
        @log_pad 4
        $(_str(opc))"""

        error("Wrong vertical size configuration leading to non-positive width position.")
    end

    return height, width, top, left
end

"""
    object_positioning_conf(...)

Helper function to create the object positioning configuration. In this case,
the anchor can be passed by keywords and a tuple containing the object and its
anchor.

"""
function object_positioning_conf(;
    anchor_bottom::AnchorTuple = nothing,
    anchor_left::AnchorTuple   = nothing,
    anchor_right::AnchorTuple  = nothing,
    anchor_top::AnchorTuple    = nothing,
    anchor_center::AnchorTuple = nothing,
    anchor_middle::AnchorTuple = nothing,
    top::Int    = -1,
    left::Int   = -1,
    height::Int = -1,
    width::Int  = -1)

    ab = anchor_bottom != nothing ? Anchor(anchor_bottom...) : nothing
    al = anchor_left   != nothing ? Anchor(anchor_left...)   : nothing
    ar = anchor_right  != nothing ? Anchor(anchor_right...)  : nothing
    at = anchor_top    != nothing ? Anchor(anchor_top...)    : nothing
    ac = anchor_center != nothing ? Anchor(anchor_center...) : nothing
    am = anchor_middle != nothing ? Anchor(anchor_middle...) : nothing

    opc = ObjectPositioningConfiguration(anchor_bottom = ab,
                                         anchor_left   = al,
                                         anchor_right  = ar,
                                         anchor_top    = at,
                                         anchor_center = ac,
                                         anchor_middle = am,
                                         top           = top,
                                         left          = left,
                                         height        = height,
                                         width         = width)

    # Process the vertical and horizontal positioning.
    _process_vertical_info!(opc)
    _process_horizontal_info!(opc)

    return opc
end

################################################################################
#                              Private functions
################################################################################

"""
    _check_vertical_anchor(anchor::Nothing)
    _check_vertical_anchor(anchor::Anchor)

Check if the `side` parameter of `anchor` is valid for vertical positioning. If
`anchor` is `nothing`, then `true` is always returned.

"""
_check_vertical_anchor(anchor::Nothing) = true
_check_vertical_anchor(anchor::Anchor)  = anchor.side ∈ [:bottom,:middle,:top]

"""
    _check_horizontal_anchor(anchor::Anchor)

Check if the `side` parameter of `anchor` is valid for horizontal positioning.
If `anchor` is `nothing`, then `true` is always returned.

"""
_check_horizontal_anchor(anchor::Nothing) = true
_check_horizontal_anchor(anchor::Anchor)  = anchor.side ∈ [:left,:center,:right]

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
    if obj == parent
        height = get_height_for_child(obj)
        width  = get_width_for_child(obj)
        top    = get_top_for_child(obj)
        left   = get_left_for_child(obj)
    else
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
    _process_vertical_info!(opc::ObjectPositioningConfiguration)

Process the vertical positioning information in `opc` and write the variable
`vertical` of the same structure. The possible vertical positioning information
are:

* `:abottom_atop`: Bottom and top anchors were specified.
* `:abottom_height`: Bottom anchor and height were specified.
* `:atop_height`: Top anchor and height were specified.
* `:amiddle_height`: Middle anchor and height were specified.
* `:top_height`: Top and height were specified.
* `:unknown`: Insufficient information to compute the vertical positioning.

"""
function _process_vertical_info!(opc::ObjectPositioningConfiguration)

    @unpack anchor_bottom, anchor_top, anchor_middle, top, height = opc

    # Check the input parameters.
    if !_check_vertical_anchor(anchor_bottom) ||
       !_check_vertical_anchor(anchor_middle) ||
       !_check_vertical_anchor(anchor_top)

        @log critical "_process_vertical_info" """
        Wrong vertical anchor type.

        opc:
        @log_pad 4
        $(_str(opc))"""

        error("Wrong vertical anchor type.")
    end

    # TODO: What about defining `top` and `anchor_bottom`?
    if (anchor_bottom != nothing) && (anchor_top != nothing)
        vertical = :abottom_atop
    elseif (anchor_bottom != nothing) && (height > 0)
        vertical = :abottom_height
    elseif (anchor_top != nothing) && (height > 0)
        vertical = :atop_height
    elseif (anchor_middle != nothing) && (height > 0)
        vertical = :amiddle_height
    elseif (top >= 0) && (height > 0)
        vertical = :top_height
    else
        vertical = :unknown
    end

    opc.vertical = vertical

    return nothing
end

"""
    _process_horizontal_info!(opc::ObjectPositioningConfiguration)

Process the horizontal positioning information in `opc` and write the variable
`horizontal` of the same structure. The possible horizontal positioning information
are:

* `:aleft_aright`: Left and right anchors were specified.
* `:aleft_height`: Left anchor and height were specified.
* `:aright_height`: Right anchor and height were specified.
* `:acenter_height`: Center anchor and height were specified.
* `:right_height`: Right and height were specified.
* `:unknown`: Insufficient information to compute the horizontal positioning.

"""
function _process_horizontal_info!(opc::ObjectPositioningConfiguration)

    @unpack anchor_left, anchor_right, anchor_center, left, width = opc

    # Check the input parameters.
    if !_check_horizontal_anchor(anchor_left)   ||
       !_check_horizontal_anchor(anchor_center) ||
       !_check_horizontal_anchor(anchor_right)

        @log critical "_process_horizontal_info" """
        Wrong horizontal anchor type.

        opc:
        @log_pad 4
        $(_str(opc))"""

        error("Wrong vertical anchor type.")
    end

    # TODO: What about defining `left` and `anchor_right`?
    if (anchor_left != nothing) && (anchor_right != nothing)
        horizontal = :aleft_aright
    elseif (anchor_left != nothing) && (width > 0)
        horizontal = :aleft_width
    elseif (anchor_right != nothing) && (width > 0)
        horizontal = :aright_width
    elseif (anchor_center != nothing) && (width > 0)
        horizontal = :acenter_width
    elseif (left >= 0) && (width > 0)
        horizontal = :left_width
    else
        horizontal = :unknown
    end

    opc.horizontal = horizontal

    return nothing
end

"""
    _str(wpc::ObjectPositioningConfiguration)

Convert the information in `wpc` to a string for debugging purposes.

"""
function _str(opc::ObjectPositioningConfiguration)
    ab = opc.anchor_bottom
    al = opc.anchor_left
    ar = opc.anchor_right
    at = opc.anchor_top
    ac = opc.anchor_center
    am = opc.anchor_middle

    ab_str = ab == nothing ? "nothing" : "($(typeof(ab.obj)), $(ab.side), $(ab.pad))"
    al_str = al == nothing ? "nothing" : "($(typeof(al.obj)), $(al.side), $(al.pad))"
    ar_str = ar == nothing ? "nothing" : "($(typeof(ar.obj)), $(ar.side), $(ar.pad))"
    at_str = at == nothing ? "nothing" : "($(typeof(at.obj)), $(at.side), $(at.pad))"
    ac_str = ac == nothing ? "nothing" : "($(typeof(ac.obj)), $(ac.side), $(ac.pad))"
    am_str = am == nothing ? "nothing" : "($(typeof(am.obj)), $(am.side), $(am.pad))"

    return str = """
    anchor_bottom = $am_str
    anchor_left   = $ac_str
    anchor_right  = $at_str
    anchor_top    = $ar_str
    anchor_center = $al_str
    anchor_middle = $ab_str

    top    = $(opc.top)
    left   = $(opc.left)
    height = $(opc.height)
    width  = $(opc.width)

    vertical = $(opc.vertical)
    horizontal = $(opc.horizontal)
    """
end
