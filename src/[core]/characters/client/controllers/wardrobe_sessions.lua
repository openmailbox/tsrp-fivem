local function delete(data)
    local session = SelectSession.get_active()
    if not session then return end

    if data.success then
        local new_char = Character:new({
            snapshot = data.snapshot
        })

        SelectSession.set_new_character(new_char)
        SelectSession.await()

        SendNUIMessage({ type = Events.CREATE_CHARACTER_NAME_PROMPT })
    end

    SetNuiFocus(true, true)
    session:initialize()
end
AddEventHandler(Events.DELETE_WARDROBE_SESSION, delete)
