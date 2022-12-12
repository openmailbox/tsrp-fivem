# Map

Provides centralized behaviors related to the map and player locations.

## Map Blips
### Basic Usage
```lua
local coords = vector3(0, 0, 0)

local options = {
    icon    = 1,
    color   = 2,
    display = 3,
    alpha   = 255
}

-- Add to map
local handle = exports.map:AddBlip(coords, options)

-- Remove from map
local success = exports.map:RemoveBlip(handle)
```
See the [FiveM reference](https://docs.fivem.net/docs/game-references/blips/) for what icons and colors are available for blips.

### Tracking an Entity
Add a blip that will appear and follow a particular entity near the player. The blip will disappear once the entity goes out of scope.

```lua
-- Add a blip tracking the player's own position.
local handle = exports.map:StartTrackingEntity(PlayerPedId(), options)

-- Remove the blip
local success = exports.map:StopTrackingEntity(PlayerPedId())

-- You can also remove it using the blip handle for i.e. when the entity already went out of scope.
local success = exports.map:RemoveBlip(handle)
```

## World Map
We keep the player's knowledge of various things across the world in memory using a [spatial partition](http://gameprogrammingpatterns.com/spatial-partition.html). The interface exists both client-side (for keeping track of markers, blips, etc.) and also server-side (for efficient storing of tracked NPCs and so on). We do this to provide a scalable and efficient way of managing a large number of arbitrary data objects in the game world (i.e. markers, blips, object locations, and so on).
```lua
local origin = vector3(0, 0, 0)
local label  = "example_storage"
local data   = { foo = 42, bar = "apples" }

-- Store arbitrary data associated with a position and label.
local handle = exports.map:StartTracking(origin, label, data)

-- Later, retrieve all of the data near a position with the given label
local nearby = exports.map:FindObjects(origin, label)

-- Remove something you previously tracked
local success = exports.map:StopTracking(origin, label, handle)
```
Each partition is 100x100 game units in size. When using `FindObjects` (or any of the map exports), the `vector3` coordinates provided are mapped to the proper 100x100 cell. This means you don't need to remember exactly where something is stored in terms of coordinates. You just need to be close enough. Results from `FindObjects` are returned for the current map cell _and_ all immediately surrounding cells in case something is near a border.