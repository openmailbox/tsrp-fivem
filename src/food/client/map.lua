Map = {}

-- Forward declarations
local cleanup,
      update

local is_active = false

local objects = {} -- Entity->BlipHandle map of map entities we're tracking
local models  = {} -- Hash->Boolean map of models we're tracking for quick lookups

function Map.reveal_objects()
    if is_active then return end
    is_active = true

    TriggerEvent(Events.LOG_MESSAGE, {
        level   = Logging.DEBUG,
        message = "Revealing world objects that restore health."
    })

    local trash_models = Trash.initialize()

    for _, model in ipairs(trash_models) do
        models[model] = true
    end

    Citizen.CreateThread(function()
        local ped = PlayerPedId()
        local max = GetEntityMaxHealth(ped)

        while is_active do
            if ped ~= PlayerPedId() or IsPedDeadOrDying(ped, 1) or GetEntityHealth(ped) >= max then
                is_active = false
            else
                update()
            end

            Citizen.Wait(5000)
        end

        cleanup()
        Trash.cleanup()

        TriggerEvent(Events.LOG_MESSAGE, {
            level   = Logging.DEBUG,
            message = "Hiding world objects that restore health."
        })
    end)
end

-- @local
function cleanup()
    for _, id in pairs(objects) do
        exports.map:RemoveBlip(id)
    end

    objects = {}
    models  = {}
end

-- @local
function update()
    local pool   = GetGamePool("CObject")
    local handle = nil
    local scale  = vector3(0.2, 0.2, 0.2)

    for object, id in pairs(objects) do
        if not DoesEntityExist(object) then
            exports.map:RemoveBlip(id)
            objects[object] = nil
        end
    end

    for _, object in ipairs(pool) do
        if not objects[object] and models[GetEntityModel(object)] then
            handle = exports.map:StartEntityTracking(object, {
                icon  = 153,
                color = 8,
                scale = scale
            })

            objects[object] = handle
        end
    end
end