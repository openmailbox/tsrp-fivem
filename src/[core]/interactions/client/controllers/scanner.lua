local is_active = false

local function create()
    is_active = not is_active
    EntityRadar.set_debug(is_active)

    TriggerEvent(Events.CREATE_HUD_NOTIFICATION, {
        message = "Scanner is " .. (is_active and "~g~active" or "~r~disabled") .. "~s~."
    })
end
RegisterNetEvent(Events.CREATE_SCANNER_TOGGLE, create)
