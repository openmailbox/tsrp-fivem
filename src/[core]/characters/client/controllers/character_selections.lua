-- Triggered by player clicking on the front-end to select a character.
local function create(_, cb)
    local character = Roster.get_current_selection()

    if character then
        cb({
            id      = character.id,
            name    = character.first_name .. " " .. character.last_name,
            success = true
        })
    else
        cb({ success = false })
    end
end
RegisterNUICallback(Events.CREATE_CHARACTER_SELECTION, create)

-- Player confirmed character selection and should now enter the game.
local function update(data, cb)
    local char = Roster.find_character(data.id)

    if not char then
        TriggerEvent(Events.LOG_MESSAGE, {
            level   = Logging.WARN,
            message = "Unable to select character " .. data.id .. "."
        })

        return
    end

    SendNUIMessage({ type = Events.DELETE_CHARACTER_SELECT_SESSION })
    DoScreenFadeOut(1500)

    repeat
        Citizen.Wait(100)
    until IsScreenFadedOut()

    exports.wardrobe:RestoreSnapshot(PlayerPedId(), char.snapshot)
    SelectSession.get_active():finish()
    TriggerEvent(Events.CREATE_RESPAWN)

    cb({})
end
RegisterNUICallback(Events.UPDATE_CHARACTER_SELECTION, update)
