local function create(data, cb)
    local char = SelectSession.get_new_character()

    TriggerServerEvent(Events.CREATE_FINISHED_CHARACTER, {
        snapshot   = char.snapshot,
        first_name = data.first,
        last_name  = data.last
    })

    cb({})
end
RegisterNUICallback(Events.CREATE_FINISHED_CHARACTER, create)

local function update(_)
    SelectSession.set_new_character(nil)
    SelectSession.resolve()
end
RegisterNetEvent(Events.UPDATE_FINISHED_CHARACTER, update)
