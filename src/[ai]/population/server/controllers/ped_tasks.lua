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
        cop:move_to(PoliceStates.DETAINING)
    end
end

local function update(data)
    for _, details in ipairs(data.updates) do
        if details.task_id == Tasks.SEARCH_FOR_HATED_IN_AREA then
            found_hated_target(details)
        elseif details.task_id == Tasks.AIM_AT_ENTITY then
            closest_cop_to_suspect(details)
        end
    end
end
RegisterNetEvent(Events.UPDATE_POPULATION_TASK, update)
