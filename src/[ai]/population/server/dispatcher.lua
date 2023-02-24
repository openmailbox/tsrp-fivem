Dispatcher = {}

-- Forward declarations
local assign_units

local CALL_RADIUS = 200.0

local calls   = {}
local next_id = 1

-- Tell the Dispatcher a unit is available.
function Dispatcher.available(unit)
    local closest  = nil
    local distance = CALL_RADIUS

    for _, call in pairs(calls) do
        local dist = Dist2d(GetEntityCoords(unit.entity), call.location)

        if dist < distance then
            closest  = call
            distance = dist
        end
    end

    if closest then
        unit:assign_call(closest)
        table.insert(closest.units, unit)
    end
end


function Dispatcher.cancel(id)
    local call = calls[id]

    if not call then
        return false
    end

    calls[id] = nil

    for _, unit in ipairs(call.units) do
        unit:clear()
    end

    Logging.log(Logging.INFO, "Dispatcher cancelled call " .. id .. ".")

    return true
end

function Dispatcher.find_call(query)
    for _, call in pairs(calls) do
        for key, value in pairs(query) do
            if call[key] == value or call.details[key] == value then
                return call.id
            end
        end
    end

    return nil
end

function Dispatcher.find_call_by_id(id)
    return calls[id]
end

-- Register a new call with the dispatcher
function Dispatcher.new_call(location, details)
    local call = {
        id       = next_id,
        location = location,
        details  = details,
        units    = {},
        suspects = {}
    }

    next_id = next_id + 1

    calls[call.id] = call
    assign_units(call)

    Logging.log(Logging.INFO, "Dispatcher received new call (" .. call.id .. ") at " .. call.location .. ".")
end

function Dispatcher.report(call_id, data)
    local call = calls[call_id]
    if not call then return end

    local suspect = data.target and NetworkGetEntityFromNetworkId(data.target)
    local exists  = false

    for _, s in ipairs(call.suspects) do
        if s.entity == suspect then
            s.last_known = data.location
            s.last_seen  = GetGameTimer()

            exists = true
            break
        end
    end

    if not exists then
        table.insert(call.suspects, {
            entity     = suspect,
            last_known = data.location,
            last_seen  = GetGameTimer()
        })
    end

    for _, cop in ipairs(call.units) do
        cop:process_input(data)
    end
end

-- @local
function assign_units(call)
    local nearby_units = PoliceUnit.available_nearby(call.location, CALL_RADIUS)

    for _, unit in ipairs(nearby_units) do
        unit:assign_call(call)
        table.insert(call.units, unit)
    end
end
