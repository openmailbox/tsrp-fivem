local rotating = false

local function create(data, cb)
    if rotating then return end
    rotating = true

    Citizen.CreateThread(function()
        local ped = PlayerPedId()
        local rot

        while rotating do
            rot = GetEntityRotation(ped, 2)
            SetEntityRotation(ped, rot.x, rot.y, rot.z + data.direction, 2, true)

            Citizen.Wait(0)
        end
    end)

    cb({})
end
RegisterNUICallback(Events.CREATE_WARDROBE_ROTATION, create)

local function delete(_, cb)
    rotating = false
    cb({})
end
RegisterNUICallback(Events.DELETE_WARDROBE_ROTATION, delete)
