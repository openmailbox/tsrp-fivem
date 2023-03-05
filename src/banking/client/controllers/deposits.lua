local callback = nil

local function create(data, cb)
    callback = cb
    TriggerServerEvent(Events.CREATE_ATM_DEPOSIT, data)
end
RegisterNUICallback(Events.CREATE_ATM_DEPOSIT, create)

local function update(data)
    callback(data)
    callback = nil

    if not data.success then return end

    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName("You deposited ~g~$" .. data.amount .. "~s~.")
    EndTextCommandThefeedPostTicker(false, true)

    StatSetInt(GetHashKey("BANK_BALANCE"), data.new_balance, true)
end
RegisterNetEvent(Events.UPDATE_ATM_DEPOSIT, update)
