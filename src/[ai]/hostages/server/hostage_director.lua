HostageDirector = {}

-- Forward declarations
local start_updates

local hostages  = {}
local is_active = false

function HostageDirector.add_hostage(data)
    for _, h in ipairs(hostages) do
        if h.entity == data.entity then return end
    end

    local hostage = Hostage:new(data)

    hostage:initialize()
    table.insert(hostages, hostage)

    if is_active then return end
    start_updates()
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

                if DoesEntityExist(next_hostage.entity) then
                    next_hostage:update()
                else
                    table.remove(hostages, i)
                    next_hostage:cleanup()
                end
            end

            if #hostages == 0 then
                is_active = false
                break
            else
                Citizen.Wait(5000)
            end
        end

        TriggerEvent(Events.LOG_MESSAGE, {
            level   = Logging.DEBUG,
            message = "Stopping hostage updates."
        })
    end)
end
