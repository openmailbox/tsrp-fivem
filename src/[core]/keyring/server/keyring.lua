Keyring = {}

-- Forward declarations
local get_entity_lock_id,
      sync_player_keys


local keyrings = {} -- in-memory keyrings for connected players
local updates  = {}

function Keyring.cleanup(player_id)
    keyrings[player_id] = nil
end

function Keyring.give(entity, player)
    local etype = GetEntityType(entity)

    if etype == 0 then
        return nil
    end

    local character = exports.characters:GetPlayerCharacter(player)

    if not character then
        return nil
    end

    local lock_id = get_entity_lock_id(entity)
    local keyring = keyrings[player]

    table.insert(keyring, {
        lock_id = lock_id,
        net_id  = NetworkGetNetworkIdFromEntity(entity)
    })

    sync_player_keys(player)

    return lock_id
end
exports("GiveKey", Keyring.give)

function Keyring.check(entity, player)
    local lock_id = get_entity_lock_id(entity)

    if not lock_id then
        return false
    end

    for _, key in ipairs(keyrings[player] or {}) do
        if key.lock_id == lock_id then
            return true
        end
    end

    return false
end
exports("HasKey", Keyring.check)

function Keyring.initialize(player_id)
    keyrings[player_id] = {}
end

function Keyring.remove(player, lock_id)
    for i, key in ipairs(keyrings[player] or {}) do
        if key.lock_id == lock_id then
            table.remove(keyrings[player], i)
            return true
        end
    end

    return false
end
exports("RemoveKey", Keyring.remove)

-- @local
function get_entity_lock_id(entity)
    if not DoesEntityExist(entity) then
        return nil
    end

    local vstate = Entity(entity).state
    local id     = vstate.keyring_lock_id

    if not id then
        id = GenerateUUID()
        vstate.keyring_lock_id = id
    end

    return id
end

-- @local
function sync_player_keys(player_id)
    if updates[player_id] then
        return
    end

    updates[player_id] = true

    Citizen.SetTimeout(1000, function()
        updates[player_id] = nil

        TriggerClientEvent(Events.UPDATE_PLAYER_KEYRING, player_id, {
            keys = keyrings[player_id] or {}
        })
    end)
end