local rotating = false

local function create(data, cb)
    if not IsPedInAnyVehicle(PlayerPedId(), false) then return end

    if rotating then return end
    rotating = true

    Citizen.CreateThread(function()
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        local rot

        while rotating do
            rot = GetEntityRotation(vehicle, 2)
            SetEntityRotation(vehicle, rot.x, rot.y, rot.z + data.direction, 2, true)

            Citizen.Wait(0)
        end
    end)

    cb({})
end
RegisterNUICallback(Events.CREATE_SHOWROOM_ROTATION, create)

local function delete(_, cb)
    rotating = false
    cb({})
end
RegisterNUICallback(Events.DELETE_SHOWROOM_ROTATION, delete)
