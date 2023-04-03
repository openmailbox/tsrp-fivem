PhoneSession = {}

-- Forward declarations
local init_prop,
      play_anim

local PED_RIGHT_HAND = 28422 -- bone index
local PHONE_MODEL    = "prop_amb_phone"

local Animation = { DICTIONARY = "cellphone@", CAR_DICTIONARY = "anim@cellphone@in_car@ps" }

local current_session = nil

function PhoneSession.get_current()
    return current_session
end

function PhoneSession:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function PhoneSession:cleanup()
    current_session = nil

    play_anim("cellphone_text_out")

    Citizen.SetTimeout(500, function()
        ClearPedTasks(PlayerPedId())
        DeleteEntity(self.prop)
        SetNuiFocus(false, false)
    end)
end

function PhoneSession:initialize()
    current_session = self

    play_anim("cellphone_text_in")

    Citizen.SetTimeout(500, function()
        self.prop = init_prop()
    end)

    SendNUIMessage({ type = Events.CREATE_PHONE_SESSION })
    SetNuiFocus(true, true)
end

-- @local
function init_prop()
    local bone = GetPedBoneIndex(PlayerPedId(), PED_RIGHT_HAND)

    if not HasModelLoaded(PHONE_MODEL) then
        RequestModel(PHONE_MODEL)

        repeat
            Citizen.Wait(50)
        until HasModelLoaded(PHONE_MODEL)
    end

    local prop = CreateObject(PHONE_MODEL, 1.0, 1.0, 1.0, true, false, false)

    AttachEntityToEntity(prop, PlayerPedId(), bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)

    return prop
end

-- @local
function play_anim(anim)
    local dictionary = Animation.DICTIONARY

    if IsPedInAnyVehicle(PlayerPedId(), false) then
        dictionary = Animation.CAR_DICTIONARY
    end

    if not HasAnimDictLoaded(dictionary) then
        RequestAnimDict(dictionary)

        repeat
            Citizen.Wait(50)
        until HasAnimDictLoaded(dictionary)
    end

    TaskPlayAnim(PlayerPedId(), dictionary, anim, -3.0, 3.0, -1, 50, 0, false, false, false)
end
