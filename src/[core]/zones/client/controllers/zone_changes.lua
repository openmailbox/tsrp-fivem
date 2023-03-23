local function on_change(data)
    local message

    if data.zone and data.zone.restricted then
        message = "You entered a ~r~restricted area~s~."
        SetPedRelationshipGroupHash(PlayerPedId(), GetHashKey("PC_TRESPASSING"))
    elseif (not data.zone or data.zone.restricted) and data.old_zone.restricted then
        message = "You left a ~r~restricted area~s~."
        SetPedRelationshipGroupHash(PlayerPedId(), GetHashKey("PLAYER"))
    end

    if not message then return end

    TriggerEvent(Events.CREATE_HUD_NOTIFICATION, {
        message = message
    })
end
AddEventHandler(Events.ON_NEW_PLAYER_ZONE, on_change)
