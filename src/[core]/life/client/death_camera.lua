-- Originally taken from https://github.com/Kiminaze/DeathCam/blob/master/client.lua
local cam = nil

local isDead = false
local angleY = 0.0
local angleZ = 0.0
local radius = 3.5


function StartDeathCam()
    ClearFocus()

    local playerPed = PlayerPedId()

    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", GetEntityCoords(playerPed), 0, 0, 0, GetGameplayCamFov())

    SetCamActive(cam, true)
    RenderScriptCams(true, true, 1000, true, false)
    isDead = true
    Citizen.CreateThread(function()
        while isDead do
            Citizen.Wait(1)

            if cam then
                ProcessCamControls()
            end
        end
    end)
end

function EndDeathCam()
    ClearFocus()

    RenderScriptCams(false, false, 0, true, false)
    DestroyCam(cam, false)
    isDead = false
    cam = nil
end

function ProcessCamControls()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    DisableFirstPersonCamThisFrame()

    local newPos = ProcessNewPosition()

    SetFocusArea(newPos.x, newPos.y, newPos.z, 0.0, 0.0, 0.0)

    SetCamCoord(cam, newPos.x, newPos.y, newPos.z)

    PointCamAtCoord(cam, playerCoords.x, playerCoords.y, playerCoords.z + 0.5)
end

function ProcessNewPosition()
    local mouseX = 0.0
    local mouseY = 0.0

    if (IsInputDisabled(0)) then
        mouseX = GetDisabledControlNormal(1, 1) * 8.0
        mouseY = GetDisabledControlNormal(1, 2) * 8.0

    else
        mouseX = GetDisabledControlNormal(1, 1) * 1.5
        mouseY = GetDisabledControlNormal(1, 2) * 1.5
    end

    angleZ = angleZ - mouseX
    angleY = angleY + mouseY
    if (angleY > 89.0) then angleY = 89.0 elseif (angleY < -89.0) then angleY = -89.0 end

    local pCoords = GetEntityCoords(PlayerPedId())

    local behindCam = {
        x = pCoords.x + ((Cos(angleZ) * Cos(angleY)) + (Cos(angleY) * Cos(angleZ))) / 2 * (radius + 0.5),
        y = pCoords.y + ((Sin(angleZ) * Cos(angleY)) + (Cos(angleY) * Sin(angleZ))) / 2 * (radius + 0.5),
        z = pCoords.z + ((Sin(angleY))) * (radius + 0.5)
    }
    local rayHandle = StartShapeTestRay(pCoords.x, pCoords.y, pCoords.z + 0.5, behindCam.x, behindCam.y, behindCam.z, -1, PlayerPedId(), 0)
    local a, hitBool, hitCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

    local maxRadius = radius
    if (hitBool and Vdist(pCoords.x, pCoords.y, pCoords.z + 0.5, hitCoords) < radius + 0.5) then
        maxRadius = Vdist(pCoords.x, pCoords.y, pCoords.z + 0.5, hitCoords)
    end

    local offset = {
        x = ((Cos(angleZ) * Cos(angleY)) + (Cos(angleY) * Cos(angleZ))) / 2 * maxRadius,
        y = ((Sin(angleZ) * Cos(angleY)) + (Cos(angleY) * Sin(angleZ))) / 2 * maxRadius,
        z = ((Sin(angleY))) * maxRadius
    }

    local pos = {
        x = pCoords.x + offset.x,
        y = pCoords.y + offset.y,
        z = pCoords.z + offset.z
    }

    return pos
end
