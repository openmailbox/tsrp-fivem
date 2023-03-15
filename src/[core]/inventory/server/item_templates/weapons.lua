local TEMPLATES = {
    {
        name        = "Pistol",
        description = "Your basic pea shooter."
    }
}

local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end

    for _, t in ipairs(TEMPLATES) do
        ItemTemplate.register(t.name, t)
    end
end
AddEventHandler(Events.ON_RESOURCE_START, create)
