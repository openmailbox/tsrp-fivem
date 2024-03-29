local function on_event(name, args)
    if name ~= Events.CLIENT_ENTITY_DAMAGE then return end

    local victim  = args[1]
    local is_dead = args[6] == 1

    if is_dead and math.random() > 0.33 then
        TriggerEvent(Events.CREATE_CASH_PICKUP, {
            location = GetEntityCoords(victim),
            amount   = math.random(5, 100)
        })
    end
end
AddEventHandler(Events.ON_GAME_EVENT, on_event)

local next_at = 0

local function on_aim(targets, enactor, _)
    if enactor ~= PlayerPedId() then return end

    local target = targets[1]
    local time   = GetGameTimer()

    -- 28 == PED_TYPE_ANIMAL
    if time < next_at or GetPedType(target) == 28 then
        return
    end

    next_at = time + 2000

    local net_id = PedToNet(enactor)
    local is_cop = GetPedType(target) == 6 or GetPedType(target) == 27
    local crime  = is_cop and 27 or 1

    local type

    for _, witness in ipairs(GetGamePool("CPed")) do
        type = GetPedType(witness)

        if not IsPedAPlayer(witness) and (type < 7 or type > 19) and type ~= 28 and HasEntityClearLosToEntity(witness, enactor) then
            ReportCrime(PlayerId(), crime, 0)

            TaskManager.buffer_update({
                task_id = Tasks.OBSERVE_THREAT,
                entity  = PedToNet(witness),
                threat  = net_id,
            })
        end
    end
end
AddEventHandler(Events.CLIENT_GUN_AIMED_AT, on_aim)
