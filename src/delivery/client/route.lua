Route = {}

-- Forward declarations
local activate_package_search,
      attach_package,
      play_emote,
      get_first_available,
      start_updates

local active_route = nil
local is_polling   = false

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

    start_updates(self)
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

-- @local
function activate_package_search()
    if is_polling then return end
    is_polling = true

    Citizen.CreateThread(function()
        while is_polling do
            if IsControlJustPressed(0, 47) then -- G
                if GetEntitySpeed(PlayerPedId()) == 0.0 then
                    is_polling = false
                    attach_package()
                else
                    Tutorial.show_instructions()
                end
            end

            Citizen.Wait(0)
        end
    end)
end

-- @local
function attach_package()
    TaskLeaveVehicle(PlayerPedId(), GetVehiclePedIsIn(PlayerPedId(), false), 256)

    Citizen.CreateThread(function()
        repeat
            Citizen.Wait(100)
        until not IsPedInAnyVehicle(PlayerPedId(), false)

        play_emote()
    end)
end

-- @local
function play_emote()
    -- Avoid making the emote resource a hard dependency so we can easily swap out for whatever emote provider.
    if exports["rpemotes"] then
        exports["rpemotes"]:EmoteCommandStart("box")
    else
        Logging.log(Logging.WARN, "Unable to attach box via emote.")
    end
end

-- @local
function start_updates(route)
    Citizen.CreateThread(function()
        local last_vehicle = 0

        while Route.get_active() == route do
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

            if vehicle > 0 and last_vehicle == 0 then -- when entering the vehicle
                activate_package_search()
                Tutorial.show_instructions()
            elseif vehicle == 0 and last_vehicle > 0 then -- when leaving the vehicle
                is_polling = false
            end

            if vehicle == 0 then
                Tutorial.enter_vehicle()
            end

            last_vehicle = vehicle

            Citizen.Wait(1000)
        end
    end)
end
