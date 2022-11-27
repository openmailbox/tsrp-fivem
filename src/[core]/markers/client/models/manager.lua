Manager = {}

-- Forward declarations
local start_checking, start_drawing

local active_marker = nil               -- this player's closest active marker right now
local all_markers   = {}                -- WorldID->vector3 hashmap of all markers in the world
local in_range      = {}                -- markers close enough to draw right now
local is_checking   = false             -- if we are within one map cell of any known markers
local is_drawing    = false             -- if we are drawing any markers currently
local markers       = {}                -- markers within our current + surrounding map cells
local player_xyz    = vector3(0, 0, 0)  -- player's current position

-- @treturn string a UUID to identify the marker for other operations i.e. RemoveMarker
function Manager.add_marker(options)
    -- Square ranges for use w/ Vdist2
    options.draw_range     = options.draw_range and (options.draw_range ^ 2)
    options.interact_range = options.interact_range and (options.interact_range ^ 2)

    local marker = Marker:new({
        world_id       = nil, -- this gets populated by exports.map:StartTracking()
        icon           = options.icon or 1,
        coords         = options.coords,
        direction      = options.direction or Marker.VECTOR3_ZERO,
        rotation       = options.rotation or Marker.DEFAULT_ROTATION,
        scale          = options.scale or Marker.DEFAULT_SCALE,
        bob            = options.bob or false,
        face_camera    = options.face_camera or false,
        rotate         = options.rotate or false,
        text           = options.text,
        on_enter       = options.on_enter,
        on_exit        = options.on_exit,
        on_interact    = options.on_interact,
        draw_range     = options.draw_range or Marker.DEFAULT_DRAW_RANGE,
        interact_range = options.interact_range or Marker.DEFAULT_INTERACT_RANGE,
        data           = options.data or {},
        color          = {
            r = options.red or Marker.DEFAULT_COLOR.r,
            g = options.green or Marker.DEFAULT_COLOR.g,
            b = options.blue or Marker.DEFAULT_COLOR.b,
            a = options.alpha or Marker.DEFAULT_COLOR.a
        }
    })

    local world_id = exports.map:StartTracking(marker.coords, GetCurrentResourceName(), marker)
    all_markers[world_id] = marker.coords

    TriggerEvent(Events.LOG_MESSAGE, {
        level   = Logging.DEBUG,
        message = "Added marker from " .. GetInvokingResource() .. " w/ icon " .. marker.icon .. " at " .. marker.coords .."."
    })

    return world_id
end
exports("AddMarker", Manager.add_marker)

function Manager.remove_marker(id)
    print("remove " .. id)
    if not id then return end

    local coords  = all_markers[id]
    local success = exports.map:StopTracking(coords, GetCurrentResourceName(), id)

    if not success then
        return success
    end

    all_markers[id] = nil

    TriggerEvent(Events.LOG_MESSAGE, {
        level   = Logging.DEBUG,
        message = "Removed marker at " .. coords .."."
    })
end
exports("RemoveMarker", Manager.remove_marker)

function Manager.cleanup()
    for _, marker in ipairs(markers) do
        marker:deactivate()
        Marker.remove(marker.coords)
    end
end

function Manager.update(coords)
    for _, marker in ipairs(markers) do
        marker:deactivate()
    end

    markers = {}
    coords  = coords or GetEntityCoords(PlayerPedId())

    local nearby = exports.map:FindObjects(coords, GetCurrentResourceName())
    if #nearby == 0 then
        is_checking = false
        return
    end

    for _, d in ipairs(nearby) do
        local marker = Marker:new(d)
        table.insert(markers, marker)
    end

    if not is_checking then
        start_checking()
    end
end

-- @local
function start_checking()
    is_checking = true

    Citizen.CreateThread(function()
        while is_checking do
            in_range   = {}
            player_xyz = GetEntityCoords(PlayerPedId())

            for _, marker in ipairs(markers) do
                if Vdist2(player_xyz, marker.coords) <= marker.draw_range then
                    table.insert(in_range, marker)
                end
            end

            if is_drawing and #in_range == 0 then
                is_drawing = false
            elseif not is_drawing and #in_range > 0 then
                start_drawing()
            end

            Citizen.Wait(3000)
        end

        is_drawing  = false
        is_checking = false
    end)
end

-- @local
function start_drawing()
    is_drawing    = true
    active_marker = nil

    TriggerEvent(Events.LOG_MESSAGE, {
        level   = Logging.DEBUG,
        message = "Showing " .. #in_range .. " markers."
    })

    Citizen.CreateThread(function()
        while is_drawing do
            for _, marker in ipairs(in_range) do
                marker:render()
            end

            Citizen.Wait(0)
        end
    end)

    Citizen.CreateThread(function()
        local closest, closest_distance, distance

        local last_xyz = vector3(0, 0, 0)

        while is_drawing do
            closest    = nil
            player_xyz = GetEntityCoords(PlayerPedId())

            if Vdist2(last_xyz, player_xyz) > 0.1 then
                last_xyz = player_xyz

                for _, marker in ipairs(in_range) do
                    distance = Vdist2(marker.coords, player_xyz)

                    if distance <= marker.interact_range and (not closest or distance < closest_distance) then
                        closest = marker
                        closest_distance = distance
                    end
                end

                if active_marker ~= closest then
                    if active_marker then
                        active_marker:deactivate()
                    end

                    active_marker = closest

                    if active_marker then
                        active_marker:activate()
                    end
                end
            end

            Citizen.Wait(1000)
        end
    end)
end
