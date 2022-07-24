local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end

    for _, scenario in ipairs(SCENARIOS) do
        SetScenarioTypeEnabled(scenario, true)
    end
end
AddEventHandler(Events.ON_CLIENT_RESOURCE_START, create)
