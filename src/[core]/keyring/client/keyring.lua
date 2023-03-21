Keyring = {}

-- Forward declarations
local init_key,
      remove_key,
      start_loop

local is_active = false
local keys      = {} -- LockID->Key map of player's current keyring

function Keyring.update(data)
    local new_keys = {}

    for _, k in ipairs(data) do
        new_keys[k.lock_id] = k
    end

    for lock_id, key in pairs(keys) do
        if new_keys[lock_id] and DoesEntityExist(new_keys[lock_id]) then
            new_keys[lock_id].entity = key.entity
        else
            remove_key(key)
        end
    end

    keys = new_keys

    Logging.log(Logging.TRACE, "Updated player keyring: " .. json.encode(keys) .. ".")

    if is_active then return end
    start_loop()
end

-- @local
function init_key(key)
    key.entity = NetworkGetEntityFromNetworkId(key.net_id)

    exports.interactions:RegisterInteraction({
            entity = key.entity,
            name   = "Toggle Locks",
            prompt = "toggle locks"
        },
        function(entity)
            print("attempt lock change for " .. entity)
        end
    )
end

-- @local
function remove_key(key)
    exports.interactions:UnregisterInteraction(nil, "Toggle Locks", key.entity)
    key.entity = nil
end

-- @local
function start_loop()
    is_active = true

    Citizen.CreateThread(function()
        local exists

        while is_active do
            if not IsPedDeadOrDying(PlayerPedId(), 1) and not IsPedInAnyVehicle(PlayerPedId(), false) then
                for _, key in pairs(keys) do
                    exists = NetworkDoesEntityExistWithNetworkId(key.net_id)

                    if not key.entity and exists then
                        init_key(key)
                    elseif key.entity and not exists then
                        remove_key(key)
                    end
                end
            end

            Citizen.Wait(2000)
        end
    end)
end
