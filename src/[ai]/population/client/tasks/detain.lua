Detain = {}

TaskManager.Tasks[Tasks.DETAIN] = Detain

local Animation = { DICTIONARY = "mp_arrest_paired", NAME = "cop_p2_back_left" }

function Detain.begin(entity, args)
    local target = NetToPed(args.target)
    local time   = GetGameTimer()

    Logging.log(Logging.DEBUG, "Tasking ".. entity .. " to detain " .. target .. ".")

    if not HasAnimDictLoaded(Animation.DICTIONARY) then
        RequestAnimDict(Animation.DICTIONARY)

        repeat
            Citizen.Wait(10)
        until HasAnimDictLoaded(Animation.DICTIONARY)
    end

    ClearPedTasksImmediately(entity)
    Citizen.Wait(math.max(10, GetGameTimer() - time + tonumber(args.ping))) -- hacky anim sync
    TaskPlayAnim(entity, Animation.DICTIONARY, Animation.NAME, 3.0, -3.0, -1, 0, 0, 0, 0, 0)
end

function Detain.update(entity, _)
    if IsEntityPlayingAnim(entity, Animation.DICTIONARY, Animation.NAME, 3) then
        return true
    end

    return false
end
