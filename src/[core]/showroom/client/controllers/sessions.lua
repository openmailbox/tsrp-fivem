local function create(data)
    if not data.categories then
        local categories = {}
        local results    = {}

        for _, name in ipairs(GetAllVehicleModels()) do
            local cat_name = VehicleClasses[GetVehicleClassFromName(GetHashKey(name))] or "Other"
            local category = categories[cat_name]

            if not category then
                category = {
                    name   = cat_name,
                    models = {}
                }

                categories[cat_name] = category
            end

            table.insert(category.models, {
                name  = name,
                label = GetDisplayNameFromVehicleModel(GetHashKey(name)),
                price = -1
            })
        end

        for _, v in pairs(categories) do
            table.insert(results, v)
        end

        table.sort(results, function(a, b)
            return a.name < b.name
        end)

        data.categories = results
    end

    local session = Session:new(data)
    session:initialize()
end
RegisterNetEvent(Events.CREATE_SHOWROOM_SESSION, create)

local function delete(_, cb)
    local session = Session.get_active()
    local preview = VehiclePreview.get_active()

    if preview then
        preview:cleanup()
    end

    if session then
        session:finish()
    end

    cb({})
end
RegisterNUICallback(Events.DELETE_SHOWROOM_SESSION, delete)
