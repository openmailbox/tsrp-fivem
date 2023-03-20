local function create(_)
    MainMenu.start()
end
AddEventHandler(Events.CREATE_WELCOME_SESSION, create)

local function delete(data, cb)
    cb({})

    MainMenu.stop()

    if data and data.quit then
        RestartGame()
        return
    end

    TriggerEvent(Events.CREATE_CHARACTER_SELECT_SESSION)
end
RegisterNUICallback(Events.DELETE_WELCOME_SESSION, delete)

local function update(data, cb)
    cb({})

    if data.settings then
        ActivateFrontendMenu(GetHashKey("FE_MENU_VERSION_MP_PAUSE"), 0, -1)
        SetNuiFocus(false, false)

        Citizen.CreateThread(function()
            Citizen.Wait(1500)

            while IsPauseMenuActive() do
                Citizen.Wait(200)
            end

            SetNuiFocus(true, true)

            SendNUIMessage({
                type = Events.CREATE_WELCOME_SESSION
            })
        end)

        return
    end

    exports.utility:ShowConfirmation({
        title    = "Support",
        message  = [[<p class="text-large">Join the Discord at <span class="text-bold text-warning">
                     discord.gg/3ZbD9MP</span> to open a support ticket.</p>]],
        callback = function()
            SetNuiFocus(true, true)
        end
    })
end
RegisterNUICallback(Events.UPDATE_WELCOME_SESSION, update)
