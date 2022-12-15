-- Blocking
function LoadAnimDictionary(name)
    if not HasAnimDictLoaded(name) then
        RequestAnimDict(name)

        repeat
            Citizen.Wait(50)
        until HasAnimDictLoaded(name)
    end
end

-- Blocks the thread it's called in.
function TurnToward(coords)
    local ped = PlayerPedId()

    TaskTurnPedToFaceCoord(ped, coords, -1)

    local v, w, angle, degrees
    repeat
        v       = GetEntityForwardVector(ped)
        w       = norm(coords - GetEntityCoords(ped))
        angle   = math.atan2((w.y * v.x) - (w.x * v.y), (w.x * v.x) + (w.y * v.y))
        degrees = angle * 180 / math.pi

        Citizen.Wait(100)
    until degrees > -20 and degrees < 20
end
