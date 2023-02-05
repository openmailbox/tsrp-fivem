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

function PoliceUnit:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function PoliceUnit:cleanup()
    Logging.log(Logging.DEBUG, "Removed police unit for " .. self.entity .. ".")
end

function PoliceUnit:initialize()
    table.insert(all_units, self)

    Logging.log(Logging.DEBUG, "Now tracking " .. #all_units .. " police units.")

    if not is_active then
        start_updates()
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

                if not DoesEntityExist(unit.entity) then
                    unit:cleanup()
                    table.remove(all_units, i)
                end
            end

            if #all_units == 0 then
                is_active = false
            end

            Citizen.Wait(5000)
        end

        Logging.log(Logging.DEBUG, "Stopping police unit updates.")
    end)
end
