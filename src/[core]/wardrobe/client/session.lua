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

    self.active = false
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

    local serializer = WebSerializer:new({ ped = PlayerPedId() })
    SendNUIMessage({
        type  = Events.CREATE_WARDROBE_SESSION,
        state = serializer:serialize(self.filters or {})
    })

    start_session(self)

    local x, y, z = table.unpack(self.camera:get_location())
    TaskTurnPedToFaceCoord(PlayerPedId(), x, y, z, 2000)

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
        local session     = sesh
        local ped         = PlayerPedId()
        local last_armor  = GetPedArmour(ped)
        local last_health = GetEntityHealth(ped)
        local last_xyz    = GetEntityCoords(ped)
        local last_model  = GetEntityModel(ped)
        local next_check  = GetGameTimer() + 1000
        local scaleform   = CreateInstructionalDisplay("Turn Left", 34,
                                                       "Turn Right", 35,
                                                       "Pan Up", 32,
                                                       "Pan Down", 33,
                                                       "Zoom In", 38,
                                                       "Zoom Out", 44)

        local new_armor, new_health, new_model, new_xyz

        while session.active do
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)

            session.camera:update()

            if GetGameTimer() > next_check then
                -- If we use a cached PlayerPedId() here, changing the player model could cause one of these function
                -- calls to return an unexpected value which might kill the session prematurely.
                new_armor  = GetPedArmour(PlayerPedId())
                new_health = GetEntityHealth(PlayerPedId())
                new_model  = GetEntityModel(PlayerPedId())
                new_xyz    = GetEntityCoords(PlayerPedId())
                next_check = GetGameTimer() + 1000

                if new_model ~= last_model then
                    local serializer = WebSerializer:new({ ped = PlayerPedId() })
                    SendNUIMessage({
                        type  = Events.CREATE_WARDROBE_SESSION,
                        state = serializer:serialize(sesh.filters or {})
                    })
                end

                if Vdist(last_xyz, new_xyz) > 1.0 or
                    -- Switching the model can cause new/old health/armor to briefly become out of sync.
                    ((new_armor < last_armor or new_health < last_health) and new_model == last_model) then

                    SendNUIMessage({ type = Events.DELETE_WARDROBE_SESSION })

                    if active_session then
                        active_session:finish()
                    end
                end
            end

            Citizen.Wait(0)
        end
    end)
end
