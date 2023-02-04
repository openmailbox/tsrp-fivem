local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end

    LifeCycle.initialize()

    if not IsPlayerDead(PlayerId()) and not IsPedDeadOrDying(PlayerPedId(), 1) then
        local life = LifeCycle:new()
        life:begin()
    end
end
AddEventHandler(Events.ON_CLIENT_RESOURCE_START, create)

local function delete(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end

    if LifeCycle.get_current() then
        LifeCycle.get_current():finish()
    end
end
AddEventHandler(Events.ON_CLIENT_RESOURCE_STOP, delete)
AddEventHandler(Events.ON_RESOURCE_STOP, delete)
