local function update(data)
    for _, incident in ipairs(data.enemies) do
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
end
RegisterNetEvent(Events.UPDATE_POPULATION_TASK_SEARCH_HATED, update)
