-- Player initialized opening a stash
local function create(data)
    local player_id  = source
    local entity     = NetworkGetEntityFromNetworkId(data.net_id)
    local stash_name = Entity(entity).state.stash_name
    local stash      = stash_name and Stash.find_by_name(stash_name)

    if stash and not stash:can_open(player_id) then
        TriggerClientEvent(Events.CREATE_STASH_OPENING, player_id, {
            success   = false,
            opened_at = data.opened_at
        })
    else
        TriggerClientEvent(Events.CREATE_STASH_OPENING, player_id, {
            success    = true,
            stash_name = stash_name,
            contents   = Stash.generate_contents(stash),
            opened_at  = data.opened_at,
            latency    = GetPlayerPing(player_id)
        })
    end
end
RegisterNetEvent(Events.CREATE_STASH_OPENING, create)

-- Process a successful stash opening and dole out rewards
local function update(data)
    local player_id = source
    local ped       = GetPlayerPed(player_id)
    local contents  = {}

    for _, item in ipairs(data.rewards) do
        if item.cash then
            exports.wallet:AdjustCash(player_id, item.cash)
            table.insert(contents, "$" .. item.cash)
        end

        if item.weapon then
            local success = exports.inventory:GiveItemToPlayer(player_id, WeaponNames[item.weapon])

            if not success then
                Logging.log(Logging.WARN, "Failed to give weapon " .. item.weapon .. " from stash " .. data.stash .. " to " .. GetPlayerName(player_id) .. " (" .. player_id .. ").")
            end

            table.insert(contents, item.label)
        end

        if item.armor then
            SetPedArmour(ped, GetPedArmour(ped) + item.armor)
            table.insert(contents, "+" .. item.armor .. " armor")
        end
    end

    TriggerClientEvent(Events.CREATE_CASH_PICKUP, player_id, {
        amount   = math.random(50, 200),
        location = GetEntityCoords(GetPlayerPed(player_id))
    })

    Logging.log(Logging.INFO, "Player " .. player_id .. " (" .. GetPlayerName(player_id) .. ") opened a stash containing " .. table.concat(contents, ", ") .. ".")
end
RegisterNetEvent(Events.UPDATE_STASH_OPENING, update)
