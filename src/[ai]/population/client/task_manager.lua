TaskManager = {}

TaskManager.Tasks = {}

-- Forward declarations
local flush_buffer,
      start_updates

local active_tasks  = {}
local buffer        = {}
local is_active     = false
local next_flush_at = 0

function TaskManager.add(task_id, entity, args)
    local task = TaskManager.Tasks[task_id]

    task.begin(entity, args)

    table.insert(active_tasks, {
        entity     = entity,
        task       = task,
        args       = args,
        started_at = GetGameTimer()
    })

    if not is_active then
        start_updates()
    end
end

function TaskManager.buffer_update(update)
    table.insert(buffer, update)

    local time = GetGameTimer()

    if time >= next_flush_at then
        flush_buffer()
    else
        Citizen.SetTimeout(next_flush_at - time, function()
            flush_buffer()
        end)
    end
end

function TaskManager.clear(entity)
    for i, task in ipairs(active_tasks) do
        if entity == task.entity then
            table.remove(active_tasks, i)
            break
        end
    end

    ClearPedTasks(entity)
end

-- @local
function start_updates()
    is_active = true

    Citizen.CreateThread(function()
        Logging.log(Logging.DEBUG, "Starting task updates.")

        while is_active do
            for i = #active_tasks, 1, -1 do
                local next     = active_tasks[i]
                local is_valid = DoesEntityExist(next.entity) and not IsPedDeadOrDying(next.entity, 1)
                local result   = is_valid and next.task.update(next.entity, next.args)

                if not result then
                    table.remove(active_tasks, i)
                end
            end

            Citizen.Wait(2000)

            if #active_tasks == 0 then
                is_active = false
            end
        end

        flush_buffer()

        Logging.log(Logging.DEBUG, "Stopping task updates.")
    end)
end

-- @local
function flush_buffer()
    Logging.log(Logging.TRACE, "Passing " .. #buffer .. " task updates to server.")

    next_flush_at = GetGameTimer() + 2000

    TriggerServerEvent(Events.UPDATE_POPULATION_TASK, {
        updates = buffer
    })

    buffer = {}
end
