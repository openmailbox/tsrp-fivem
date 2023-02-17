local function found_hated_target(incident)
    local aggressor = NetworkGetEntityFromNetworkId(incident.aggressor)
    local target    = NetworkGetEntityFromNetworkId(incident.target)

    if aggressor == 0 or target == 0 then
        return
    end

    local cop = PoliceUnit.for_entity(aggressor)

    if cop then
        cop:confront(target)
    end
end

local function closest_cop_to_suspect(incident)
    local aggressor = NetworkGetEntityFromNetworkId(incident.enactor)
    local target    = NetworkGetEntityFromNetworkId(incident.target)

    if aggressor == 0 or target == 0 then
        return
    end

    local cop = PoliceUnit.for_entity(aggressor)

    if cop then
        cop.current_target_offset = incident.location
        cop:move_to(PoliceStates.DETAINING)
    end
end

local function observe_threat(incident)
    local threat   = NetworkGetEntityFromNetworkId(incident.threat)
    local observer = NetworkGetEntityFromNetworkId(incident.observer)

    if threat == 0 or observer == 0 then
        return
    end

    local cop = PoliceUnit.for_entity(observer)

    if cop and cop.current_target == threat then
        cop:move_to(PoliceStates.FIGHTING)
    end
end

local function update(data)
    -- TODO: Better routing pattern of some sort
    for _, details in ipairs(data.updates) do
        if details.task_id == Tasks.SEARCH_FOR_HATED_IN_AREA then
            found_hated_target(details)
        elseif details.task_id == Tasks.AIM_AT_ENTITY then
            closest_cop_to_suspect(details)
        elseif details.task_id == Tasks.OBSERVE_THREAT then
            observe_threat(details)
        end
    end
end
RegisterNetEvent(Events.UPDATE_POPULATION_TASK, update)
