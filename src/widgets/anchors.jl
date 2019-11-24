# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   Functions related to anchors.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export wpc

################################################################################
#                              Public functions
################################################################################

"""
    function wpc(...)

Helper function to create anchors. In this case, the anchor can be passed by
keywords and a tuple containing the object and its anchor.

"""
function wpc(;
    anchor_bottom::Union{Nothing,Tuple{AnchorObject,Symbol,Integer}} = nothing,
    anchor_left::Union{Nothing,Tuple{AnchorObject,Symbol,Integer}}   = nothing,
    anchor_right::Union{Nothing,Tuple{AnchorObject,Symbol,Integer}}  = nothing,
    anchor_top::Union{Nothing,Tuple{AnchorObject,Symbol,Integer}}    = nothing,
    anchor_center::Union{Nothing,Tuple{AnchorObject,Symbol,Integer}} = nothing,
    anchor_middle::Union{Nothing,Tuple{AnchorObject,Symbol,Integer}} = nothing,
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

    return WidgetPositioningConfiguration(
        anchor_bottom = ab,
        anchor_left   = al,
        anchor_right  = ar,
        anchor_top    = at,
        anchor_center = ac,
        anchor_middle = am,
        top           = top,
        left          = left,
        height        = height,
        width         = width)
end

################################################################################
#                              Private functions
################################################################################

"""
    _check_vertical_anchor(anchor::Nothing)
    function _check_vertical_anchor(anchor::Anchor)

Check if the `side` parameter of `anchor` is valid for vertical positioning. If
`anchor` is `nothing`, then `true` is always returned.

"""
_check_vertical_anchor(anchor::Nothing) = true
_check_vertical_anchor(anchor::Anchor)  = anchor.side ∈ [:bottom,:middle,:top]

"""
    function _check_horizontal_anchor(anchor::Anchor)

Check if the `side` parameter of `anchor` is valid for horizontal positioning.
If `anchor` is `nothing`, then `true` is always returned.

"""
_check_horizontal_anchor(anchor::Nothing) = true
_check_horizontal_anchor(anchor::Anchor)  = anchor.side ∈ [:left,:center,:right]

"""
    function _get_anchor(anchor::Anchor)

Return the line or column related to the anchor `anchor`.

"""
function _get_anchor(anchor::Anchor, parent::WidgetParent)
    obj = anchor.obj
    pad = anchor.pad

    if obj == parent
        top  = 0
        left = 0
    else
        top  = obj.common.top
        left = obj.common.left
    end

    if anchor.side == :bottom
        return top + get_height(obj) + pad
    elseif anchor.side == :top
        return top + pad
    elseif anchor.side == :left
        return left + pad
    elseif anchor.side == :right
        return left + get_width(obj) + pad
    elseif anchor.side == :center
        return left + div(get_width(obj), 2) + pad
    elseif anchor.side == :middle
        return top + div(get_height(obj), 2) + pad
    else
        error("Unknown side in anchor.")
    end
end

"""
    function _process_vertical_info!(posconf::WidgetPositioningConfiguration)

Process the vertical positioning information in `posconf` and write the variable
`vertical` of the same structure. The possible vertical positioning information
are:

* `:abottom_atop`: Bottom and top anchors were specified.
* `:abottom_height`: Bottom anchor and height were specified.
* `:atop_height`: Top anchor and height were specified.
* `:amiddle_height`: Middle anchor and height were specified.
* `:top_height`: Top and height were specified.
* `:unknown`: Insufficient information to compute the vertical positioning.

"""
function _process_vertical_info!(posconf::WidgetPositioningConfiguration)

    @unpack anchor_bottom, anchor_top, anchor_middle, top, height = posconf

    # Check the input parameters.
    if !_check_vertical_anchor(anchor_bottom) ||
       !_check_vertical_anchor(anchor_middle) ||
       !_check_vertical_anchor(anchor_top)

        @log critical "_process_vertical_info" """
        Wrong vertical anchor type.

        posconf:
        @log_pad 4
        $(_str(posconf))"""

        error("Wrong vertical anchor type.")
    end

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

    posconf.vertical = vertical

    return nothing
end

"""
    function _process_horizontal_info!(posconf::WidgetPositioningConfiguration)

Process the horizontal positioning information in `posconf` and write the variable
`horizontal` of the same structure. The possible horizontal positioning information
are:

* `:aleft_aright`: Left and right anchors were specified.
* `:aleft_height`: Left anchor and height were specified.
* `:aright_height`: Right anchor and height were specified.
* `:acenter_height`: Center anchor and height were specified.
* `:right_height`: Right and height were specified.
* `:unknown`: Insufficient information to compute the horizontal positioning.

"""
function _process_horizontal_info!(posconf::WidgetPositioningConfiguration)

    @unpack anchor_left, anchor_right, anchor_center, left, width = posconf

    # Check the input parameters.
    if !_check_horizontal_anchor(anchor_left)   ||
       !_check_horizontal_anchor(anchor_center) ||
       !_check_horizontal_anchor(anchor_right)

        @log critical "_process_horizontal_info" """
        Wrong horizontal anchor type.

        posconf:
        @log_pad 4
        $(_str(posconf))"""

        error("Wrong vertical anchor type.")
    end


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

    posconf.horizontal = horizontal

    return nothing
end

"""
    function _str(wpc::WidgetPositioningConfiguration)

Convert the information in `wpc` to a string for debugging purposes.

"""
function _str(wpc::WidgetPositioningConfiguration)
    ab = wpc.anchor_bottom
    al = wpc.anchor_left
    ar = wpc.anchor_right
    at = wpc.anchor_top
    ac = wpc.anchor_center
    am = wpc.anchor_middle

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

    top    = $(wpc.top)
    left   = $(wpc.left)
    height = $(wpc.height)
    width  = $(wpc.width)

    vertical = $(wpc.vertical)
    horizontal = $(wpc.horizontal)
    """
end
