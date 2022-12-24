local function create(_, cb)
    local char = SelectSession.get_new_character()
    TriggerServerEvent(Events.CREATE_FINISHED_CHARACTER, char)
    cb({})
end
RegisterNUICallback(Events.CREATE_FINISHED_CHARACTER, create)

local function update(_)
    SelectSession.set_new_character(nil)
    SelectSession.resolve()
end
RegisterNetEvent(Events.UPDATE_FINISHED_CHARACTER, update)
