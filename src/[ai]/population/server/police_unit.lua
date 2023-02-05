PoliceUnit = {}

-- Forward declarations
local start_updates

local all_units = {}
local is_active = false

function PoliceUnit.for_entity(entity)
    for _, unit in ipairs(all_units) do
        if unit.entity == entity then
            return unit
        end
    end

    return nil
end

function PoliceUnit.available_nearby(coords, range)
    local results = {}

    for _, unit in ipairs(all_units) do
        if not unit.assigned_call and Dist2d(GetEntityCoords(unit.entity), coords) < range then
            table.insert(results, unit)
        end
    end

    return results
end

function PoliceUnit:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function PoliceUnit:assign_call(call)
    self.assigned_call = call
    SetPedConfigFlag(self.entity, 17, true)
    Logging.log(Logging.INFO, "Police unit " .. self.entity .. " assigned call " .. call.id .. " at " .. call.location .. ".")
end

function PoliceUnit:clear()
    local id = self.assigned_call.id
    self.assigned_call = nil

    SetPedConfigFlag(self.entity, 17, false)
    ClearPedTasks(self.entity)

    Logging.log(Logging.INFO, "Police unit " .. self.entity .. " cleared call " .. id .. ".")
end

function PoliceUnit:cleanup()
    Logging.log(Logging.DEBUG, "Removed police unit for " .. self.entity .. ".")
end

function PoliceUnit:initialize()
    table.insert(all_units, self)

    Logging.log(Logging.DEBUG, "Now tracking " .. #all_units .. " police units.")

    Dispatcher.available(self)

    if not is_active then
        start_updates()
    end
end

function PoliceUnit:update()
    if not self.assigned_call then
        Dispatcher.available(self)
        return
    end

    if Dist2d(GetEntityCoords(self.entity), self.assigned_call.location) > 20.0 then
        return
    end

    if GetPedScriptTaskCommand(self.entity) == -2128726980 then
        local owner = NetworkGetEntityOwner(self.entity)

        TriggerClientEvent(Events.CREATE_POPULATION_PED_TASK, owner, {
            net_id   = NetworkGetNetworkIdFromEntity(self.entity),
            location = self.assigned_call.location
        })
    end
end

-- @local
function start_updates()
    is_active = true

    Logging.log(Logging.DEBUG, "Starting police unit updates.")

    Citizen.CreateThread(function()
        while is_active do
            for i = #all_units, 1, -1 do
                local unit = all_units[i]

                if DoesEntityExist(unit.entity) then
                    unit:update()
                else
                    unit:cleanup()
                    table.remove(all_units, i)
                end
            end

            if #all_units == 0 then
                is_active = false
            end

            Citizen.Wait(3000)
        end

        Logging.log(Logging.DEBUG, "Stopping police unit updates.")
    end)
end
