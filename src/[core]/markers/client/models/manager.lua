Manager = {}

-- Forward declarations
local start_checking, start_drawing

local active_marker = nil
local in_range      = {}
local is_checking   = false
local is_drawing    = false
local markers       = {}
local player_xyz    = vector3(0, 0, 0)

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
