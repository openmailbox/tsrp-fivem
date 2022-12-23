local function create(_)
    local session = SelectSession:new()
    session:initialize()
end
RegisterNetEvent(Events.CREATE_CHARACTER_SELECT_SESSION, create)
