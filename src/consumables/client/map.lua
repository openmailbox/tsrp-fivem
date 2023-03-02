Map = {}

-- Forward declarations
local update

local is_active = false

local objects = {} -- Entity->BlipHandle map of map entities we're tracking
local models  = {} -- Hash->Boolean map of models we're tracking for quick lookups

function Map.cleanup()
    for _, id in pairs(objects) do
        exports.map:RemoveBlip(id)
    end

    objects = {}
    models  = {}
end

function Map.remove(entity)
    if not objects[entity] then return end
    exports.map:StopEntityTracking(entity)
end

function Map.reveal_objects()
    if is_active then return end
    is_active = true

    Logging.log(Logging.DEBUG, "Revealing world objects that restore health.")

    for _, model in ipairs(Objects.DUMPSTERS) do
        models[model] = true
    end

    for _, model in ipairs(Objects.SODA_MACHINES) do
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

            Citizen.Wait(3000)
        end

        Map.cleanup()
        Vending.cleanup()

        TriggerEvent(Events.LOG_MESSAGE, {
            level   = Logging.DEBUG,
            message = "Hiding world objects that restore health."
        })
    end)
end

-- @local
function update()
    local pool   = GetGamePool("CObject")
    local handle = nil
    local scale  = vector3(0.8, 0.8, 0.8)
    local count  = 0

    for object, id in pairs(objects) do
        if not DoesEntityExist(object) then
            exports.map:RemoveBlip(id)
            objects[object] = nil
        end
    end

    for _, object in ipairs(pool) do
        if not objects[object] and models[GetEntityModel(object)] and not exports.interactions:IsExcluded(object) then
            handle = exports.map:StartEntityTracking(object, {
                icon    = 153,
                color   = 8,
                scale   = scale,
                display = 2,
                alpha   = 150,
                label   = "Health"
            })

            objects[object] = handle

            count = count + 1

            if count > 10 then
                break
            end
        end
    end
end
