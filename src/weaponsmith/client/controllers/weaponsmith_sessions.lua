local function create()
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        return false
    end

    local succ, weapon = GetCurrentPedWeapon(PlayerPedId(), 1)

    if not succ or weapon == Weapons.UNARMED then
        return false
    end

    local ploc   = GetEntityCoords(PlayerPedId())
    local spot   = ploc + GetEntityForwardVector(PlayerPedId()) * 1.5
    local object = CreateWeaponObject(weapon, 0, spot.x, spot.y, spot.z, true, 1.0, 0, 0, 0)
    local cloc   = spot + GetEntityForwardVector(object)
    local camera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", cloc.x, cloc.y, cloc.z, 0, 0, 0, 60.0, false, 0)

    SetCamUseShallowDofMode(camera, true)
    SetCamNearDof(camera, 0.3)
    SetCamFarDof(camera, 1.0)
    SetCamDofStrength(camera, 1.0)
    PointCamAtEntity(camera, object, 0, 0, 0, 1)
    SetCamActive(camera, true)
    RenderScriptCams(true, true, 1000, true, true)

    Citizen.CreateThread(function()
        while true do
            DisableControlAction(0, 177, true)
            SetUseHiDof()

            if IsDisabledControlJustPressed(0, 177) then
                break
            end

            Citizen.Wait(0)
        end

        SetCamActive(camera, false)
        RenderScriptCams(false, true, 1000, true, true)
        DeleteObject(object)
    end)
end
RegisterNetEvent(Events.CREATE_WEAPONSMITH_SESSION, create)
