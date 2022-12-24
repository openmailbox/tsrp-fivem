local callback = nil

local function create(data, cb)
    callback = cb
    TriggerServerEvent(Events.CREATE_CHARACTER_NAME_VALIDATION, data)
end
RegisterNUICallback(Events.CREATE_CHARACTER_NAME_VALIDATION, create)

local function update(data)
    callback(data)
    callback = nil
end
RegisterNetEvent(Events.UPDATE_CHARACTER_NAME_VALIDATION, update)
