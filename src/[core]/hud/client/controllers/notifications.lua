local function create(data)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(data.message)

    if data.sender then
        EndTextCommandThefeedPostMessagetext(data.sender.image, data.sender.image, false, 1, data.sender.name, data.sender.subject)
    end

    EndTextCommandThefeedPostTicker(true, true)
end
RegisterNetEvent(Events.CREATE_HUD_NOTIFICATION, create)