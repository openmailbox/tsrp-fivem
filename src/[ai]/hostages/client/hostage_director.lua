-- Keeps track of all the hostages this client controls.
HostageDirector = {}

-- Forward declarations
local start_updates

local hostages  = {}
local is_active = false

function HostageDirector.add_hostage(data)
    local hostage = Hostage:new(data)

    hostage:initialize()
    table.insert(hostages, hostage)

    if not is_active then
        start_updates()
    end
end

-- @local
function start_updates()
    is_active = true

    Citizen.CreateThread(function()
        TriggerEvent(Events.LOG_MESSAGE, {
            level   = Logging.DEBUG,
            message = "Starting hostage updates."
        })

        while is_active do
            local next_hostage

            for i = #hostages, 1, -1 do
                next_hostage = hostages[i]

                if DoesEntityExist(next_hostage.ped) then
                    next_hostage:update()
                else
                    table.remove(hostages, i)
                end
            end

            if #hostages == 0 then
                is_active = false
            end

            Citizen.Wait(3000)
        end

        TriggerEvent(Events.LOG_MESSAGE, {
            level   = Logging.DEBUG,
            message = "Stopping hostage updates."
        })
    end)
end
