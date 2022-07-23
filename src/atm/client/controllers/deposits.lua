local callback = nil

local function create(data, cb)
    callback = cb
    TriggerServerEvent(Events.CREATE_ATM_DEPOSIT, data)
end
RegisterNUICallback(Events.CREATE_ATM_DEPOSIT, create)

local function update(data)
    callback(data)
    callback = nil
end
RegisterNetEvent(Events.UPDATE_ATM_DEPOSIT, update)
