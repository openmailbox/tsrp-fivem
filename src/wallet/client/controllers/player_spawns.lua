local function create(_)
    TriggerServerEvent(Events.CREATE_WALLET_RESET)
end
AddEventHandler(Events.ON_PLAYER_SPAWNED, create)

--local function cmd_money(source, args, _)
--    local forward = GetEntityForwardVector(PlayerPedId())
--    local coords  = GetEntityCoords(PlayerPedId()) + (forward * 2)
--    local x, y, z = table.unpack(coords)
--    local target  = GetSafePickupCoords(x, y, z, 0, 0)
--    --local pickup  = CreatePickup(GetHashKey("PICKUP_MONEY_VARIABLE"), target, 8, 0, 0, 0)
--    CreateMoneyPickups(x, y, z, 100, 2, GetHashKey("PICKUP_MONEY_VARIABLE"))
--    print("pickup = " .. tostring(pickup))
--end
--RegisterCommand("money", cmd_money)
--
--AddEventHandler("CEventNetworkPlayerCollectedAmbientPickup", function(entities, event_entity, data)
--    print("entity " .. event_entity .. " collected " .. table.concat(data, ", "))
--end)

--AddEventHandler("entityDamaged", function(victim, culprit, weapon, base)
--    print("entityDamaged base = " .. tostring(base))
--end)
