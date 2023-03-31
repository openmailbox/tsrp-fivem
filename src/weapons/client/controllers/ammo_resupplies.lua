-- Triggered from server after player uses an ammo item successfully.
local function update(data)
    AddAmmoToPedByType(PlayerPedId(), data.hash, data.quantity)
end
RegisterNetEvent(Events.UPDATE_AMMO_RESUPPLY, update)
