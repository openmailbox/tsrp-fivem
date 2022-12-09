local blips = {}

local function create(data)
    if data.model == "off" then
        for _, blip in ipairs(blips) do
            BlipManager.remove_blip(blip)
        end
        return
    end

    local all_models = GetAllVehicleModels()
    local found      = false

    for _, name in ipairs(all_models) do
        if name == data.model then
            found = true
            break
        end
    end

    if not found then
        TriggerEvent(Events.ADD_CHAT_MESSAGE, {
            color     = Colors.RED,
            multiline = true,
            args      = { GetCurrentResourceName(), "Invalid vehicle model: '" .. data.model .. "'." }
        })
        return
    end

    local succ, spawn, locations = Snapshot.get_vehicle_spawn(GetHashKey(data.model))

    if succ then
        for _, coords in ipairs(locations or {}) do
            local b = BlipManager.add_blip(coords, {
                color = 1,
                label = data.model .. " Spawn"
            })

            table.insert(blips, b)
        end

        local origin = BlipManager.add_blip(spawn, {
            color = 1,
            label = data.model .. " Origin"
        })

        table.insert(blips, origin)

        TriggerEvent(Events.ADD_CHAT_MESSAGE, {
            color     = Colors.RED,
            multiline = true,
            args      = { GetCurrentResourceName(), "Showing spawn position for '" .. data.model .. "'." }
        })
    else
        TriggerEvent(Events.ADD_CHAT_MESSAGE, {
            color     = Colors.RED,
            multiline = true,
            args      = { GetCurrentResourceName(),
                "Insufficient data to generate '" .. data.model .. "' spawn point." }
        })
    end
end
RegisterNetEvent(Events.CREATE_MAP_VSPAWN_RESULT, create)
