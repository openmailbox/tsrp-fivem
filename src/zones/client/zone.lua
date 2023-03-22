Zone = {}

local current_zone = nil
local is_active    = false
local location     = vector3(0, 0, 0) -- player's cached position
local zones        = {}               -- all zones this player knows about

function Zone.add(data)
    local zone = Zone:new(data)
    table.insert(zones, zone)

    if GetConvarInt("LOG_LEVEL", 4) >= Logging.DEBUG then
        zone:show()
    end
end

function Zone.teardown()
    for _, z in ipairs(zones) do
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
                for i, zone in ipairs(zones) do
                    if zone:contains(new_location.x, new_location.y) then
                        if zone ~= current_zone then
                            TriggerEvent(Events.ON_NEW_PLAYER_ZONE, {
                                zone     = zone,
                                old_zone = current_zone
                            })

                            current_zone = zone
                        end

                        break
                    elseif i == #zones and current_zone then
                        TriggerEvent(Events.ON_NEW_PLAYER_ZONE, {
                            zone     = nil,
                            old_zone = current_zone
                        })

                        current_zone = nil
                    end
                end

                location = new_location
            end

            Citizen.Wait(1000)
        end
    end)
end

function Zone:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Zone:contains(x, y)
    local x_min = self.center.x - (self.width / 2)
    local x_max = self.center.x + (self.width / 2)

    if x < x_min or x > x_max then
        return false
    end

    local y_min = self.center.y - (self.height / 2)
    local y_max = self.center.y + (self.height / 2)

    if y < y_min or y > y_max then
        return false
    end

    return true
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
