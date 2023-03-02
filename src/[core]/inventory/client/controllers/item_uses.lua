local function create(data, cb)
    if IsPedDeadOrDying(PlayerPedId(), 1) then
        TriggerEvent(Events.CREATE_HUD_HELP_MESSAGE, {
            message = "You cannot use items while incapacitated."
        })
        return
    end

    TriggerEvent(Events.CREATE_INVENTORY_ITEM_USE, data)

    cb({})
end
RegisterNUICallback(Events.CREATE_INVENTORY_ITEM_USE, create)
