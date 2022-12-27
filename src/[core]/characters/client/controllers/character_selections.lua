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
