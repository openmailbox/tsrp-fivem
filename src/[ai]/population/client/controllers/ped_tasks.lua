local function create(data)
    TaskManager.add(data.task_id, NetToPed(data.net_id), data)
end
RegisterNetEvent(Events.CREATE_POPULATION_TASK, create)

local function delete(data)
    TaskManager.clear(NetToPed(data.net_id))
end
RegisterNetEvent(Events.DELETE_POPULATION_TASK, delete)
