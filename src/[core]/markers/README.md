# Markers

Utilities for dealing with native markers.

```lua
-- Add a new marker. Default values shown.
local handle = exports.markers:AddMarker({
    icon           = 1,
    coords         = vector3(0, 0, 0),
    direction      = vector3(0, 0, 0),
    rotation       = vector3(0, 0, 0),
    scale          = vector3(1.0, 1.0, 1.0),
    bob            = false, -- bob up and down
    face_camera    = false, -- always face the camera
    rotate         = false, -- rotate continuously
    text           = nil,
    on_enter       = nil,   -- function
    on_exit        = nil,   -- function
    on_interact    = nil,   -- function
    draw_range     = 7.0,
    interact_range = 2.0
    data           = {},    -- any arbitrary data to be associated with the marker
    red            = 255,
    green          = 255,
    blue           = 255,
    alpha          = 255
})

exports.markers:RemoveMarker(handle)
```
See the [FiveM Reference](https://docs.fivem.net/docs/game-references/markers/) for possible `icon` values.

The marker system keeps track of all added markers internally, and is smart enough to only turn them on and off when the player is nearby (configurable with the range options). It should be able to handle a very large number of markers without dropping noticeable client performance.