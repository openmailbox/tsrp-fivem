local function create(_)
    if IsPlayerDead(PlayerId()) or IsPedDeadOrDying(PlayerPedId(), 1) then
        TriggerEvent(Events.CREATE_HUD_NOTIFICATION, {
            message = "You can't do that right now."
        })
        return
    end

    if PhoneSession.get_current() then return end

    local session = PhoneSession:new()
    session:initialize()
end
AddEventHandler(Events.CREATE_PHONE_SESSION, create)

local function delete(_)
    local session = PhoneSession.get_current()

    if session then
        session:cleanup()
    end
end
RegisterNUICallback(Events.DELETE_PHONE_SESSION, delete)
