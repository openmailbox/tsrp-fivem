local Animation = { DICTIONARY = "ped", UP = "handsup_base", DOWN = "handsup_exit" }

local hands_raised = false

local function cmd_toggle_hands(_, _, _)
    hands_raised = not hands_raised

    if hands_raised then
        TaskPlayAnim(PlayerPedId(), Animation.DICTIONARY, Animation.UP, 3.0, -3.0, -1, 50, 1.0, false, false, false)
    else
        TaskPlayAnim(PlayerPedId(), Animation.DICTIONARY, Animation.DOWN, 3.0, -3.0, -1, 50, 1.0, false, false, false)
        Citizen.Wait(250)
        ClearPedTasks(PlayerPedId())
    end
end
RegisterCommand("handsup", cmd_toggle_hands, false)
RegisterKeyMapping("handsup", "Hands Up (toggle)", "keyboard", "X")