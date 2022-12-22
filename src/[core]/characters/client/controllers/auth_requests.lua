local callback = nil

local function create(_, cb)
    callback = cb
    TriggerServerEvent(Events.CREATE_CHARACTER_AUTH_REQUEST)
end
RegisterNUICallback(Events.CREATE_CHARACTER_AUTH_REQUEST, create)

local function update(data)
    callback(data)
    callback = nil
end
RegisterNetEvent(Events.UPDATE_CHARACTER_AUTH_REQUEST, update)
