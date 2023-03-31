-- Triggered from client when player hits a weapon pickup.
local function create(data)
    local player_id = source
    exports.inventory:GiveItemToPlayer(player_id, data.weapon)
end
RegisterNetEvent(Events.CREATE_WEAPON_PICKUP, create)
