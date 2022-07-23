local function on_change(data)
    local message

    if data.zone then
        message = "You entered a ~r~restricted area~s~."
        SetPedRelationshipGroupHash(PlayerPedId(), GetHashKey("PC_TRESPASSING"))
    else
        message = "You left a ~r~restricted area~s~."
        SetPedRelationshipGroupHash(PlayerPedId(), GetHashKey("PLAYER"))
    end

    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandThefeedPostTicker(false, true)
end
AddEventHandler(Events.ON_NEW_PLAYER_ZONE, on_change)
