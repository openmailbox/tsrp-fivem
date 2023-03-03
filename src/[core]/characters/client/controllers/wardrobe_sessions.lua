local function delete(data)
    local session = SelectSession.get_active()

    if session and data.success then
        local new_char = Character:new({
            snapshot = data.snapshot
        })

        SelectSession.set_new_character(new_char)
        SelectSession.await()

        SendNUIMessage({ type = Events.CREATE_CHARACTER_NAME_PROMPT })
        SetNuiFocus(true, true)

        session:initialize()
    elseif not session and data.success then
        TriggerServerEvent(Events.UPDATE_CHARACTER_GAME_SESSION, {
            snapshot = data.snapshot
        })
    end
end
AddEventHandler(Events.DELETE_WARDROBE_SESSION, delete)
