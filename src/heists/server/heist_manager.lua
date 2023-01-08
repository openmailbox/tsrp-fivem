HeistManager = {}

local is_active = false

function HeistManager.wait_for_refresh()
    if is_active then return end
    is_active = true

    Citizen.CreateThread(function()
        while is_active do
            local continue = false
            local updates  = {}

            for _, heist in ipairs(Heist.all()) do
                if heist:update() then
                    table.insert(updates, heist)
                end

                if not heist.available then
                    continue = true
                end
            end

            if #updates > 0 then
                TriggerClientEvent(Events.UPDATE_HEISTS, -1, {
                    heists = updates
                })
            end

            if continue then
                Citizen.Wait(60000)
            else
                is_active = false
            end
        end

        TriggerEvent(Events.LOG_MESSAGE, {
            level   = Logging.DEBUG,
            message = "All heists have refreshed."
        })
    end)
end
