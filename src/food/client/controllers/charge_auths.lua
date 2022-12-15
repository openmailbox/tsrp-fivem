local function update(data)
    if data.success then
        Vending.authorize(data.amount)
    else
        Vending.authorize(false)
        TriggerEvent(Events.CREATE_HUD_NOTIFICATION, {
            message = "You don't have enough money."
        })
    end
end
RegisterNetEvent(Events.UPDATE_FOOD_CHARGE_AUTH, update)
