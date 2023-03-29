local TEMPLATES = {
    {
        name        = "Handgun Ammo",
        description = "Small caliber ammunition suitable for pistols and revolvers.",
        hash        = 1950175060 -- taken from GetPedAmmoTypeFromWeapon()
    },
    {
        name        = "Shotgun Ammo",
        description = "Cartridge ammunition used in shotguns.",
        hash        = -1878508229
    },
    {
        name        = "Rifle Ammo",
        description = "Large caliber ammunition suitable for rifles.",
        hash        = 218444191
    },
    {
        name        = "SMG Ammo",
        description = "Small and medium caliber ammunition suitable for submachine guns.",
        hash        = 1820140472
    },
    {
        name        = "Machine Gun Ammo",
        description = "Belts of ammunition used in large machine guns.",
        hash        = 1788949567
    },
    {
        name        = "Sniper Ammo",
        description = "Large caliber ammunition used in sniper rifles.",
        hash        = 1285032059
    },
}

local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end

    local tags = { "ammunition" }

    for _, t in ipairs(TEMPLATES) do
        t.tags = tags
        ItemTemplate.register(t.name, t)
    end
end
AddEventHandler(Events.ON_RESOURCE_START, create)
AddEventHandler(Events.ON_CLIENT_RESOURCE_START, create)
