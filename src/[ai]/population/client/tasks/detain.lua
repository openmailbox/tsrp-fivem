Detain = {}

TaskManager.Tasks[Tasks.DETAIN] = Detain

local Animation = { DICTIONARY = "mp_arrest_paired", NAME = "cop_p2_back_left" }

function Detain.begin(entity, args)
    local target = NetToPed(args.target)

    Logging.log(Logging.DEBUG, "Telling ".. entity .. " to detain " .. target .. ".")

    if not HasAnimDictLoaded(Animation.DICTIONARY) then
        RequestAnimDict(Animation.DICTIONARY)

        repeat
            Citizen.Wait(10)
        until HasAnimDictLoaded(Animation.DICTIONARY)
    end

    TaskPlayAnim(entity, Animation.DICTIONARY, Animation.NAME, 3.0, -3.0, -1, 0, 0, 0, 0, 0)
end

function Detain.update(_, _)
end
