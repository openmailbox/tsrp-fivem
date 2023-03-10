Session = {}

-- Forward declarations
local get_equipment,
      start_session

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

    self.active = false
    self.camera:cleanup()

    if not IsPedInAnyVehicle(PlayerPedId(), false) then
        local _, forward = self.camera:get_matrix()
        local target     = self.camera:get_location() + (5 * forward)

        TaskTurnPedToFaceCoord(PlayerPedId(), target.x, target.y, target.z, 1000)
    end

    SetNuiFocus(false, false)

    if not self.hide_radar then
        DisplayRadar(true)
    end
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

    SendNUIMessage({
        type      = Events.CREATE_INVENTORY_SESSION,
        inventory = self.inventory,
        equipment = get_equipment()
    })

    start_session(self)

    if not IsPedInAnyVehicle(PlayerPedId(), false) then
        local x, y, z = table.unpack(self.camera:get_location())
        TaskTurnPedToFaceCoord(PlayerPedId(), x, y, z, 2000)
    end
end

-- @local
function get_equipment()
    local equipment = {}

    for name, weapons in pairs(WeaponSlots) do
        for _, weap in ipairs(weapons) do
            if HasPedGotWeapon(PlayerPedId(), weap, false) then
                equipment[name] = {
                    name  = WeaponLabels[weap], -- defined in @common/shared/weapons
                    label = WeaponNames[weap]
                }
            end
        end
    end

    return equipment
end

-- @local
function start_session(sesh)
    Citizen.CreateThread(function()
        local session    = sesh
        local next_check = GetGameTimer() + 1000

        while session.active do
            session.camera:update()

            if GetGameTimer() > next_check then
                next_check = GetGameTimer() + 1000

                if IsPedDeadOrDying(PlayerPedId(), 1) then
                    SendNUIMessage({ type = Events.DELETE_INVENTORY_SESSION })

                    if active_session then
                        active_session:finish()
                    end
                end
            end

            Citizen.Wait(0)
        end
    end)
end