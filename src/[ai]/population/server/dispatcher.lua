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

    for _, call in ipairs(calls) do
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
    for i, call in ipairs(calls) do
        if call.id == id then
            for _, unit in ipairs(call.units) do
                unit:clear()
            end

            table.remove(calls, i)
            Logging.log(Logging.INFO, "Dispatcher cancelled call " .. id .. ".")

            return true
        end
    end

    return false
end

function Dispatcher.find_call(query)
    for _, call in ipairs(calls) do
        for key, value in pairs(query) do
            if call[key] == value or call.details[key] == value then
                return call.id
            end
        end
    end

    return nil
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

    table.insert(calls, call)
    assign_units(call)

    Logging.log(Logging.INFO, "Dispatcher received new call (" .. call.id .. ") at " .. call.location .. ".")
end

function Dispatcher.report_suspect(call_id, entity)
    local call = nil

    for _, c in ipairs(calls) do
        if c.id == call_id then
            call = c
            break
        end
    end

    if not call then return end

    for _, s in ipairs(call.suspects) do
        if s == entity then
            return
        end
    end

    table.insert(call.suspects, entity)
end

-- @local
function assign_units(call)
    local nearby_units = PoliceUnit.available_nearby(call.location, CALL_RADIUS)

    for _, unit in ipairs(nearby_units) do
        unit:assign_call(call)
        table.insert(call.units, unit)
    end
end
