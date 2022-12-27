local function create(data)
    local first       = tostring(data.first)
    local last        = tostring(data.last)
    local player_id   = source
    local valid_first = true
    local valid_last  = true

    if not data.first or string.len(first) < 3 then
        valid_first = false
    end

    if not data.last or string.len(last) < 3 then
        valid_last = false
    end

    -- TODO: Implement blacklisted words based on server.cfg convar

    TriggerClientEvent(Events.UPDATE_CHARACTER_NAME_VALIDATION, player_id, {
        first   = valid_first,
        last    = valid_last,
        success = valid_first and valid_last
    })
end
RegisterNetEvent(Events.CREATE_CHARACTER_NAME_VALIDATION, create)
