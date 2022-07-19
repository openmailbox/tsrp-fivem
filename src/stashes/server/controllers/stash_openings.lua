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
            contents   = stash and stash.contents,
            opened_at  = data.opened_at
        })
    end
end
RegisterNetEvent(Events.CREATE_STASH_OPENING, create)

-- Process a successful stash opening and dole out rewards
local function update(data)
    -- add money to wallet etc.
end
RegisterNetEvent(Events.UPDATE_STASH_OPENING, update)
