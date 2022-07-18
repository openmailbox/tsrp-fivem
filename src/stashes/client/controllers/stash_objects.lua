local function create(data)
    local stash = data.stash

    if not HasModelLoaded(stash.model) then
        RequestModel(stash.model)

        while not HasModelLoaded(stash.model) do
            Citizen.Wait(5)
        end
    end

    TriggerServerEvent(Events.CREATE_STASH_OBJECT, data)
end
RegisterNetEvent(Events.CREATE_STASH_OBJECT, create)

local function update(data)
    local object = NetToObj(data.net_id)
    ActivatePhysics(object)
    SetModelAsNoLongerNeeded(GetEntityModel(object))
end
RegisterNetEvent(Events.UPDATE_STASH_OBJECT, update)
