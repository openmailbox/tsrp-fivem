Zone = {}

local current_zone = nil
local is_active    = false
local location     = vector3(0, 0, 0) -- player's cached position
local zones        = {}               -- all zones this player knows about

function Zone.all()
    return zones
end

function Zone.teardown()
    for _, z in pairs(zones) do
        z:hide()
    end

    zones = {}
end

function Zone.setup()
    is_active = true

    Citizen.CreateThread(function()
        local new_location

        while is_active do
            new_location = GetEntityCoords(PlayerPedId())

            if Vdist(new_location, location) > 1.0 then
                local new_zone = nil

                for _, zone in pairs(zones) do
                    if zone:contains(new_location.x, new_location.y) then
                        new_zone = zone
                        break
                    end
                end

                if new_zone ~= current_zone then
                    TriggerEvent(Events.ON_NEW_PLAYER_ZONE, {
                        zone     = new_zone,
                        old_zone = current_zone
                    })

                    current_zone = new_zone
                end

                location = new_location
            end

            Citizen.Wait(1000)
        end
    end)
end

function Zone.update(data)
    local zone = Zone:new(data)

    zones[data.name] = zone

    Logging.log(Logging.TRACE, "Updated zone definition for '" .. zone.name .. "'.")
end

function Zone:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Zone:contains(x, y)
    return DoesZoneContain(self, vector2(x, y)) -- shared/support
end

function Zone:hide()
    RemoveBlip(self.blip)
end

function Zone:show()
    local x, y, z = table.unpack(self.center)
    self.blip = AddBlipForArea(x, y, z, self.width, self.height)
    SetBlipAsShortRange(self.blip, true)
    SetBlipDisplay(self.blip, 3)
    SetBlipRotation(self.blip, 0)
    SetBlipColour(self.blip, 1)
    SetBlipAlpha(self.blip, 128)
end
