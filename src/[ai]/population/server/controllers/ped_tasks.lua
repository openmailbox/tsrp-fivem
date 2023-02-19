local function update(data)
    for _, details in ipairs(data.updates) do
        local entity = NetworkGetEntityFromNetworkId(details.entity)
        local cop    = PoliceUnit.for_entity(entity)

        if cop then
            cop:process_input(details)
        end
    end
end
RegisterNetEvent(Events.UPDATE_POPULATION_TASK, update)
