local TEMPLATES = {
    {
        name        = WeaponNames[Weapons.PISTOL],
        description = "Your basic pea shooter."
    },
    {
        name        = WeaponNames[Weapons.PUMPSHOTGUN],
        description = "A shotgun."
    }
}

local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end

    local tags = { "equipment" }

    for _, t in ipairs(TEMPLATES) do
        t.tags = tags
        ItemTemplate.register(t.name, t)
    end
end
AddEventHandler(Events.ON_RESOURCE_START, create)
AddEventHandler(Events.ON_CLIENT_RESOURCE_START, create)
