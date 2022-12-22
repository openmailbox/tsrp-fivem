local function create(_)
    local session = Session:new()
    session:initialize()
end
RegisterNetEvent(Events.CREATE_CHARACTER_SELECT_SESSION, create)
