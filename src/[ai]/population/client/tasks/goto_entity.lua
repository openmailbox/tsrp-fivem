GotoEntity = {}

TaskManager.Tasks[Tasks.GOTO_ENTITY] = GotoEntity

function GotoEntity.begin(entity, args)
    local target = NetToPed(args.target)

    Logging.log(Logging.TRACE, "Tasking ".. entity .. " to go to entity " .. target .. ".")

    TaskGoToEntity(entity, target, -1, 1.0, 1.0, 0, 0)

    Citizen.CreateThread(function()
        while GetIsTaskActive(entity, 35) do
            if Vdist(GetEntityCoords(entity), GetEntityCoords(target)) < 1.1 then
                TaskStandStill(entity, -1)
                break
            end

            Citizen.Wait(500)
        end
    end)
end

function GotoEntity.update(entity, _)
    return GetIsTaskActive(entity, 35) -- CTaskComplexControlMovement
end
