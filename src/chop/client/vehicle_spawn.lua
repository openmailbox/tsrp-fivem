VehicleSpawn = {}

-- Forward declarations
local add_generator,
      start_updates

local MAX_GENERATORS = 3
local RADIUS         = 300.0

local generators = {}
local is_active  = false
local origin     = vector3(0, 0, 0)

function VehicleSpawn.activate(options)
    origin = options.spawn

    if is_active then return end
    start_updates(options.model)
end

function VehicleSpawn.cleanup()
    is_active = false

    for _, gen in ipairs(generators) do
        SetScriptVehicleGenerator(gen, false)
        DeleteScriptVehicleGenerator(gen)
    end

    generators = {}
end

-- @local
function add_generator(model)
    local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
    local has_node, node, nodeh = GetClosestVehicleNodeWithHeading(x, y, z, 1, 3.0, 0)

    if not has_node then
        Logging.log(Logging.DEBUG, "Unable to find vehicle node near " .. vector3(x, y, z) .. ".")
        return
    end

    local has_road, road = GetPointOnRoadSide(node.x, node.y, node.z)

    if not has_road then
        Logging.log(Logging.DEBUG, "Unable to find vehicle roadside for node at " .. node .. ".")
        return
    end

    if not HasModelLoaded(model) then
        RequestModel(model)
    end

    local generator = CreateScriptVehicleGenerator(road.x, road.y, road.z, nodeh, 5.0, 3.0, model, -1, -1, -1, -1, true, false, false, false, true, -1)
    SetScriptVehicleGenerator(generator, true)
    SetAllVehicleGeneratorsActive(true)

    table.insert(generators, {
        id       = generator,
        location = road
    })

    Logging.log(Logging.TRACE, "Created vehicle script generator " .. generator .. " at " .. road .. " for model " .. model .. ".")
end

-- @local
function start_updates(model_hash)
    is_active = true

    Citizen.CreateThread(function()
        local ploc

        while is_active do
            ploc = GetEntityCoords(PlayerPedId())

            for i = #generators, 1, -1 do
                local gen = generators[i]

                if Vdist(gen.location, ploc) > RADIUS then
                    table.remove(generators, i)

                    SetScriptVehicleGenerator(gen, false)
                    DeleteScriptVehicleGenerator(gen)

                    Logging.log(Logging.TRACE, "Removed vehicle script generator " .. i .. ".")
                end
            end

            if Vdist(origin, ploc) < RADIUS and #generators < MAX_GENERATORS then
                add_generator(model_hash)
            end

            Citizen.Wait(5000)
        end
    end)
end
