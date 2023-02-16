local Animation = { DICTIONARY = "ped", UP = "handsup_base", DOWN = "handsup_exit" }

local function cmd_toggle_hands(_, _, _)
    if IsPedCuffed(PlayerPedId()) then
        TriggerEvent(Events.CREATE_HUD_NOTIFICATION, {
            message = "You can't move your hands while cuffed."
        })
        return
    end

    if IsEntityPlayingAnim(PlayerPedId(), Animation.DICTIONARY, Animation.UP) then
        TaskPlayAnim(PlayerPedId(), Animation.DICTIONARY, Animation.DOWN, 3.0, -3.0, -1, 50, 1.0, false, false, false)
        Citizen.Wait(250)
        ClearPedTasks(PlayerPedId())
    else
        TaskPlayAnim(PlayerPedId(), Animation.DICTIONARY, Animation.UP, 3.0, -3.0, -1, 50, 1.0, false, false, false)
    end
end
RegisterCommand("handsup", cmd_toggle_hands, false)
RegisterKeyMapping("handsup", "Hands Up (toggle)", "keyboard", "X")