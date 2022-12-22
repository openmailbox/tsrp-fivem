local function delete(_)
    local session = SelectSession.get_active()
    if not session then return end
    session:initialize()
end
AddEventHandler(Events.DELETE_WARDROBE_SESSION, delete)
