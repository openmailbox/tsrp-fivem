-- Player initialized opening a stash
local function create(data)
    local player_id  = source
    local entity     = NetworkGetEntityFromNetworkId(data.net_id)
    local stash_name = Entity(entity).state.stash_name
    local stash      = stash_name and Stash.find_by_name(stash_name)

    if stash and not stash:can_open(player_id) then
        TriggerClientEvent(Events.UPDATE_STASH_OPENING, player_id, {
            success   = false,
            opened_at = data.opened_at
        })
    else
        TriggerClientEvent(Events.UPDATE_STASH_OPENING, player_id, {
            success    = true,
            stash_name = stash_name,
            contents   = (stash and stash.contents) or Stash.generate_contents(),
            opened_at  = data.opened_at,
            latency    = GetPlayerPing(player_id)
        })
    end
end
RegisterNetEvent(Events.CREATE_STASH_OPENING, create)

-- Process a successful stash opening and dole out rewards
local function update(data)
    print(source .. " opened a stash containing $" .. data.contents.cash .. ".")
end
RegisterNetEvent(Events.UPDATE_STASH_OPENING, update)
