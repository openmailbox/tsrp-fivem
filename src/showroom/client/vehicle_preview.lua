VehiclePreview = {}

local active_preview = nil

function VehiclePreview.get_active()
    return active_preview
end

function VehiclePreview:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function VehiclePreview:cleanup()
    if DoesEntityExist(self.vehicle) then
        DeleteEntity(self.vehicle)
    end
end

function VehiclePreview:initialize()
    local x, y, z, h = table.unpack(self.location)
    local hash       = GetHashKey(self.model)
    local timeout    = GetGameTimer() + 3000

    Logging.log(Logging.DEBUG, "Creating vehicle preview for " .. self.model .. " at " .. self.location .. ".")

    if not HasModelLoaded(hash) then
        RequestModel(hash)

        repeat
            Citizen.Wait(50)
        until HasModelLoaded(hash) or GetGameTimer() > timeout
    end

    ClearArea(x, y, z, 5.0, true, false, false, false, false)
    local vehicle = CreateVehicle(hash, x, y, z, h, false, true)

    repeat
        Citizen.Wait(100)
    until DoesEntityExist(vehicle) or GetGameTimer() > timeout

    if not DoesEntityExist(vehicle) then
        Logging.log(Logging.WARN, "Unable to create vehicle preview for " .. self.model .. ".")
        return
    end

    SetVehicleEngineOn(vehicle, false, true, true)
    SetVehHasRadioOverride(vehicle, false)
    SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
    SetModelAsNoLongerNeeded(hash)

    repeat
        Citizen.Wait(250)
    until IsPedInVehicle(PlayerPedId(), vehicle, false)

    ClampGameplayCamPitch(-5.0, -5.0)
    ClampGameplayCamYaw(-90.0, -90.0)

    self.vehicle = vehicle
    active_preview = self
end
