local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end

    for name, details in pairs(ConsumableItems) do
        exports.inventory:RegisterItem(name, details)
    end
end
AddEventHandler(Events.ON_RESOURCE_START, create)
