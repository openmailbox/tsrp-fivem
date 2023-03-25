Keyring = {}

-- Forward declarations
local get_entity_lock_id,
      sync_player_keys

local keyrings = {} -- in-memory CharacterID->Keyring map
local updates  = {}

function Keyring.cleanup(player_id)
    local character = exports.characters:GetPlayerCharacter(player_id)
    local keyring   = keyrings[character.id]

    -- TODO: Better cleanup over time so we don't hold memory for irrelevant locks.
    if #keyring == 0 then
        keyrings[character.id] = {}
    end
end

function Keyring.give(entity, player)
    local etype = GetEntityType(entity)

    if etype == 0 then
        return nil
    end

    local character = exports.characters:GetPlayerCharacter(player)
    local name      = character.first_name .. " " .. character.last_name

    if not character then
        return nil
    end

    local lock_id = get_entity_lock_id(entity)
    local keyring = keyrings[character.id]
    local net_id  = NetworkGetNetworkIdFromEntity(entity)

    if not keyring then
        keyring = {}
        keyrings[character.id] = keyring
    end

    table.insert(keyring, {
        lock_id = lock_id,
        net_id  = net_id
    })

    sync_player_keys(player)

    Logging.log(Logging.TRACE, "Gave key for " .. net_id .. " to " .. GetPlayerName(player) .. " (" .. player .. ") as " .. name .. ".")

    return lock_id
end
exports("GiveKey", Keyring.give)

function Keyring.check(entity, player)
    local lock_id = get_entity_lock_id(entity)

    if not lock_id then
        return false
    end

    local character = exports.characters:GetPlayerCharacter(player)

    for _, key in ipairs(keyrings[character.id] or {}) do
        if key.lock_id == lock_id then
            return true
        end
    end

    return false
end
exports("HasKey", Keyring.check)

function Keyring.initialize(player_id)
    local character = exports.characters:GetPlayerCharacter(player_id)
    local keyring   = keyrings[character.id]

    if keyring and #keyring > 0 then
        sync_player_keys(player_id)
    else
        keyrings[character.id] = {}
    end
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

    local estate = Entity(entity).state
    local id     = estate.keyring_lock_id

    if not id then
        id = GenerateUUID()

        estate.keyring_lock_id     = id
        estate.keyring_lock_status = false -- unlocked by default
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
        local character = exports.characters:GetPlayerCharacter(player_id)

        updates[player_id] = nil

        TriggerClientEvent(Events.UPDATE_PLAYER_KEYRING, player_id, {
            keys = keyrings[character.id]
        })
    end)
end
