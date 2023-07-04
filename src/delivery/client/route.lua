Route = {}

-- Forward declarations
local activate_deliveries,
      get_first_available,
      pick_random,
      start_updates

local active_route = nil
local is_active    = false

function Route.get_active()
    return active_route
end

function Route.setup(depot)
    if active_route then
        active_route:cleanup()
        active_route = nil
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

-- Called after a successful package dropoff
function Route:checkpoint()
    local completed = true

    for _, dropoff in ipairs(self.dropoffs) do
        if not dropoff.completed then
            completed = false
            break
        end
    end

    if not completed then return end

    Route.teardown()

    self.depot:initialize()

    TriggerServerEvent(Events.CREATE_DELIVERY_PACKAGE_DROPOFF, {
        finished_route = true
    })

    TriggerEvent(Events.CREATE_HUD_NOTIFICATION, {
        message = "You receive a bonus for completing the delivery route."
    })
end

function Route:cleanup()
    if self.vehicle then
        TriggerServerEvent(Events.DELETE_DELIVERY_VEHICLE, {
            net_id = VehToNet(self.vehicle)
        })
    end

    for _, dropoff in ipairs(self.dropoffs) do
        dropoff:cleanup()
    end

    self.dropoffs = {}
end

function Route:initialize()
    local progress = exports.progress:ShowProgressBar(3000, "Finding Route")

    if not self.depot.vehicle.required then
        TriggerServerEvent(Events.CREATE_DELIVERY_VEHICLE, {
            model    = self.depot.vehicle.model,
            location = get_first_available(self.depot.vehicle.spawns),
            name     = self.depot.name
        })
    else
        self.vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    end

    start_updates(self)

    -- Construct the delivery route
    Citizen.CreateThread(function()
        local indices = pick_random(7, #self.depot.dropoffs)

        self.dropoffs = {}

        for _, i in ipairs(indices) do
            local coords = self.depot.dropoffs[i]

            local dropoff = Dropoff:new({
                route     = self,
                coords    = coords,
                completed = false
            })

            dropoff:initialize()

            table.insert(self.dropoffs, dropoff)
        end

        exports.progress:CancelProgressBar(progress)
    end)
end

-- @local
function activate_deliveries(route)
    if is_active then return end
    is_active = true

    Citizen.CreateThread(function()
        while is_active do
            if IsControlJustPressed(0, 47) then -- G
                if IsVehicleStopped(GetVehiclePedIsIn(PlayerPedId(), false)) then
                    is_active = false
                    Dropoff.activate(route)
                else
                    Tutorial.show_instructions()
                end
            end

            Citizen.Wait(0)
        end
    end)
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

-- Return a list of n random unique integers from 1 to m.
-- @local
function pick_random(n, m)
    local remaining = {}
    local results   = {}

    for i = 1, m do
        table.insert(remaining, i)
    end

    if n >= m then
        return remaining
    end

    while #results < n do
        local next = remaining[math.random(#remaining)]

        table.insert(results, next)

        for i, num in ipairs(remaining) do
            if num == next then
                table.remove(remaining, i)
                break
            end
        end
    end

    return results
end

-- @local
function start_updates(route)
    Citizen.CreateThread(function()
        local last_vehicle = 0

        while Route.get_active() == route do
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

            if vehicle > 0 and last_vehicle == 0 then -- when entering a vehicle
                if Dropoff.is_active() then
                    Dropoff.deactivate()
                end

                if vehicle == route.vehicle then
                    activate_deliveries(route)
                    Tutorial.show_instructions()
                end
            elseif vehicle == 0 then
                if is_active then
                    is_active = false
                end

                if Dropoff.is_active() then
                    Tutorial.drop_package()
                else
                    Tutorial.enter_vehicle()
                end
            end

            last_vehicle = vehicle

            Citizen.Wait(1000)
        end
    end)
end
