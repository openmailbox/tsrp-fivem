Session = {}

-- Forward delcarations
local start_session

local DICTIONARY = "clothingshirt"
local ANIMATION  = "try_shirt_positive_a"

local active_session = nil

function Session.get_active()
    return active_session
end

function Session:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Session:finish()
    active_session = nil

    local _, forward = self.camera:get_matrix()
    local target     = self.camera:get_location() + (5 * forward)

    self.camera:cleanup()

    TaskTurnPedToFaceCoord(PlayerPedId(), target.x, target.y, target.z, 1000)
    SetNuiFocus(false, false)

    if not self.hide_radar then
        DisplayRadar(true)
    end

    Citizen.Wait(1000)
    ClearPedTasks(PlayerPedId())
end

function Session:initialize()
    if active_session then return end
    active_session = self

    self.camera     = Camera:new()
    self.hide_radar = IsRadarHidden()
    self.active     = true

    self.camera:initialize()

    DisplayRadar(false)
    SetNuiFocus(true, true)
    TriggerEvent(Events.CLEAR_CHAT)
    SendNUIMessage({ type = Events.CREATE_WARDROBE_SESSION })

    start_session(self)

    local x, y, z = table.unpack(self.camera:get_location())
    TaskTurnPedToFaceCoord(PlayerPedId(), x, y, z, -1)

    if not HasAnimDictLoaded(DICTIONARY) then
        RequestAnimDict(DICTIONARY)

        while not HasAnimDictLoaded(DICTIONARY) do
            Citizen.Wait(10)
        end
    end

    TaskPlayAnim(PlayerPedId(), DICTIONARY, ANIMATION, -3.0, 3.0, -1, 48, false, false, false)
end

-- @local
function start_session(sesh)
    Citizen.CreateThread(function()
        local session         = sesh
        local ped             = PlayerPedId()
        local starting_armor  = GetPedArmour(ped)
        local starting_health = GetEntityHealth(ped)
        local starting_xyz    = GetEntityCoords(ped)
        local next_check      = GetGameTimer() + 1000

        local new_armor, new_health, new_xyz

        while session.active do
            session.camera:update()

            if GetGameTimer() > next_check then
                new_armor  = GetPedArmour(ped)
                new_health = GetEntityHealth(ped)
                new_xyz    = GetEntityCoords(ped)
                next_check = GetGameTimer() + 1000

                if Vdist(starting_xyz, new_xyz) > 1.0 or
                    new_armor < starting_armor or
                    new_health < starting_health then

                    if active_session then
                        active_session:finish()
                    end
                end
            end

            Citizen.Wait(0)
        end
    end)
end
