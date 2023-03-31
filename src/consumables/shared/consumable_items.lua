ConsumableItems = {
    ["Burger"] = {
        description = "Use to restore a small amount of health."
    },
    ["Donut"] = {
        description = "Use to restore a small amount of health."
    },
    ["Taco"] = {
        description = "Use to restore a small amount of health."
    },
    ["Hot Dog"] = {
        description = "Use to restore a small amount of health."
    }
}

local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end

    local tags = { "singleuse" }

    for name, details in pairs(ConsumableItems) do
        details.tags = tags
        exports.inventory:RegisterItem(name, details)
    end
end
AddEventHandler(Events.ON_RESOURCE_START, create)
AddEventHandler(Events.ON_CLIENT_RESOURCE_START, create)
