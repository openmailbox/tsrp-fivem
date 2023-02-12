local function create(data)
    TaskManager.add(data.task_id, NetToPed(data.net_id), data)
end
RegisterNetEvent(Events.CREATE_POPULATION_TASK, create)
