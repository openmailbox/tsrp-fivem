SearchHated = {}

-- Forward declarations
local find_first_visible_enemy,
      get_rand_point_in_circle,
      start_updates

local active    = {}
local is_active = false

function SearchHated.add(entity, target)
    active[entity] = GetGameTimer()

    local location = get_rand_point_in_circle(target, 10.0)
    local x, y, z  = table.unpack(location)

    Logging.log(Logging.TRACE, "Telling ".. entity .. " to search for hated entities near " .. location)

    TaskGoToCoordAndAimAtHatedEntitiesNearCoord(entity, x, y, z, x, y, z, 2.0, false, 3.0, 0.0, true, 16, 1, -957453492)

    if not is_active then
        start_updates()
    end
end

-- @local
function start_updates()
    is_active = true

    Citizen.CreateThread(function()
        Logging.log(Logging.DEBUG, "Starting updates for hated target search.")

        while is_active do
            local count = 0
            local time  = GetGameTimer()

            for entity, t in pairs(active) do
                if DoesEntityExist(entity) and not IsPedDeadOrDying(entity) and time < (t + 5000) then
                    count = count + 1
                else
                    active[entity] = nil
                end
            end

            if count == 0 then
                break
            end

            local enemies = {}
            local locals  = GetGamePool("CPed")

            for entity, is_valid in pairs(active) do
                local enemy = is_valid and find_first_visible_enemy(entity, locals)

                if enemy then
                    table.insert(enemies, {
                        aggressor = PedToNet(entity),
                        target    = PedToNet(enemy)
                    })
                end
            end

            if #enemies > 0 then
                TriggerServerEvent(Events.UPDATE_POPULATION_TASK_SEARCH_HATED, {
                    enemies = enemies
                })
            end

            Logging.log(Logging.TRACE, "Updated search for hated task status on " .. count .. " entities.")
            Citizen.Wait(3000)
        end

        is_active = false
        Logging.log(Logging.DEBUG, "Stopped updates for hated target search.")
    end)
end

-- @local
function get_rand_point_in_circle(origin, r)
    local angle  = math.random() * math.pi * 2
    local radius = math.sqrt(math.random()) * r
    local x      = origin.x + radius * math.cos(angle)
    local y      = origin.y + radius * math.sin(angle)

    return vector3(x, y, origin.z)
end

-- @local
function find_first_visible_enemy(entity, pool)
    for _, ped in ipairs(pool) do
        if GetRelationshipBetweenPeds(entity, ped) >= 4 and HasEntityClearLosToEntity(entity, ped) then
            return ped
        end
    end

    return nil
end
