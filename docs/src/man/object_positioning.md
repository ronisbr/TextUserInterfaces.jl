Object positioning
==================

The *positioning* of an object in **TextUserInterfaces.jl** means its position
and size in the screen. This information is stored in an instance of the
structure [`ObjectPositioningConfiguration`](@ref). It can be created by the
function `newopc`:

```julia
newopc(;kwargs...)
```

Create an instance of the structure `ObjectPositioningConfiguration`. The
following keywords are available to specify the positioning:

* `anchor_bottom`: Bottom anchor specification. (**Default** = `_no_anchor`)
* `anchor_left`: Left anchor specification. (**Default** = `_no_anchor`)
* `anchor_right`: Right anchor specification. (**Default** = `_no_anchor`)
* `anchor_top`: Top anchor specification. (**Default** = `_no_anchor`)
* `anchor_center`: Center anchor specification. (**Default** = `_no_anchor`)
* `anchor_middle`: Middle anchor specification. (**Default** = `_no_anchor`)
* `top`: Absolute position of the object top side. (**Default** = -1)
* `left`: Absolute position of the object left side. (**Default** = -1)
* `height`: Height of the object. (**Default** = -1)
* `width`: Width of the object. (**Default** = -1)

!!! info

    If the absolute positioning arguments (`top`, `left`, `height`, and `width`)
    are negative, then it means that there is no information about them. Hence,
    the relative arguments (anchors) must provide the missing information.

Notice that the position of the object can be defined by relative terms or
absolute terms. They can be mixed, but the user must be sure that the system can
infer the position and size of the object given the provided set of parameters.

## Anchors

Every object has three horizontal anchors and three vertical anchors:

```
Horizontal anchors
===============================================================================

+-----------------------------------------------------------------------------+
|                                                                             |
| <- Left anchor                 Center anchor                Right anchor -> |
|                                                                             |
+-----------------------------------------------------------------------------+

Vertical anchors
===============================================================================

+--------------------------------- Top anchor --------------------------------+
|                                                                             |
|                                Middle anchor                                |
|                                                                             |
+------------------------------- Bottom anchor -------------------------------+
```

The positioning information of an object can be informed by attaching those
anchors to the anchors of another object. This is accomplished by creating an
instance of the structure [`Anchor`](@ref):

```julia
struct Anchor
    obj::Object
    side::Symbol
    pad::Int
end
```

to the desired anchor, where `obj` defines the object we want anchor, `side`
defines which side will be anchored, and `pad` defines a space.

!!! info

    `side` is one of the following symbols: `:left`, `:right`, `:top`,
    `:bottom`, `:center`, or `:middle`.

Thus, suppose that we want that the object `B` is positioned on the left of
object `A` with the same height and width 9:

```
                   <-- 9 -->
+-----------------++-------+
|                 ||       |
|                 ||       |
|                 ||       |
|        A        ||   B   |
|                 ||       |
|                 ||       |
|                 ||       |
+-----------------++-------+
```

Thus, we should create the following [`ObjectPositioningConfiguration`](@ref)
for `B`:

```julia
newopc(anchor_top    = Anchor(A, :top, 0),
       anchor_left   = Anchor(A, :right, 0),
       anchor_bottom = Anchor(A, :bottom, 0),
       width         = 9)
```

Notice that we attached the anchors top, left, and bottom of `B` to the anchors
top, right, and bottom, respectively, of `A`. With only this information, the
width would be undefined. Thus, we provided this information with the absolute
parameter `width`.

!!! warning

    Vertical anchors can only be attached to another vertical anchor, and
    horizontal anchors can only be attached to another horizontal anchor. The
    system checks if the anchor specification is correct and throws an error if
    not.
