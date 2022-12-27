local function create(_)
    local player_id = source
    local label     = GetCurrentResourceName() .. "-" .. player_id

    exports.instances:SetPlayerInstance(player_id, label)
end
RegisterNetEvent(Events.CREATE_CHARACTER_SELECT_SESSION, create)

local function delete(_)
    local player_id = source
    exports.instances:SetPlayerInstance(player_id, nil)
end
RegisterNetEvent(Events.DELETE_CHARACTER_SELECT_SESSION, delete)
