Route = {}

-- Forward declarations
local get_first_available

local active_route = nil

function Route.get_active()
    return active_route
end

function Route.setup(depot)
    if active_route then
        active_route:cleanup()
    end

    local route = Route:new({ depot = depot })
    route:initialize()

    active_route = route
end

function Route.teardown()
    if not active_route then return end

    active_route:cleanup()

    active_route = nil
end

function Route:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Route:cleanup()
    if self.vehicle then
        TriggerServerEvent(Events.DELETE_DELIVERY_VEHICLE, {
            net_id = VehToNet(self.vehicle)
        })
    end

    for _, dropoff in ipairs(self.dropoffs) do
        exports.map:RemoveBlip(dropoff.blip_id)
    end

    self.dropoffs = {}
end

function Route:initialize()
    local model    = self.depot.vehicle.model
    local location = get_first_available(self.depot.vehicle.spawns)

    TriggerServerEvent(Events.CREATE_DELIVERY_VEHICLE, {
        model    = model,
        location = location,
        name     = self.depot.name
    })

    self.dropoffs = {}

    for _, coords in ipairs(self.depot.dropoffs) do
        local blip_id = exports.map:AddBlip(coords, {
            icon    = 478,
            display = 2,
            color   = 10,
            label   = "Package Dropoff",
        })

        table.insert(self.dropoffs, {
            coords  = coords,
            blip_id = blip_id
        })
    end

    Tutorial.initialize(self)
end

-- @local
function get_first_available(points)
    local pool = GetGamePool("CVehicle")

    local closest

    for _, p in ipairs(points) do
        closest = nil

        for _, vehicle in ipairs(pool) do
            if Vdist(vector3(p.x, p.y, p.z), GetEntityCoords(vehicle)) < 1.0 then
                closest = vehicle
                break
            end
        end

        if not closest then
            return p
        end
    end

    return nil
end
