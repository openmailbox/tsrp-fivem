local function cmd_phone(_, _, _)
    if not PhoneSession.get_current() then
        TriggerEvent(Events.CREATE_PHONE_SESSION)
    end
end
RegisterCommand("phone", cmd_phone, false)
RegisterKeyMapping("phone", "Phone (toggle)", "keyboard", "f2")
