local TEMPLATES = {
    {
        name        = WeaponNames[Weapons.DAGGER],
        description = "An antique-style cavalry dagger with a hand guard."
    },
    {
        name        = WeaponNames[Weapons.BAT],
        description = "A classic Louisville Slugger-style baseball bat."
    },
    {
        name        = WeaponNames[Weapons.BOTTLE],
        description = "A broken bottle with plenty of sharp edges."
    },
    {
        name        = WeaponNames[Weapons.PISTOL],
        description = "A basic double action semi-automatic pistol."
    },
    {
        name        = WeaponNames[Weapons.SMG],
        description = "Compact, lightweight, small caliber, fully automatic."
    },
    {
        name        = WeaponNames[Weapons.PUMPSHOTGUN],
        description = "A pump action heavy gauge shotgun."
    },
    {
        name        = WeaponNames[Weapons.ASSAULTRIFLE],
        description = "Standard assault rifle used by militaries around the world."
    },
    {
        name        = WeaponNames[Weapons.RPG],
        description = "Shoulder mounted, manually aimed rocket propelled grenade launcher."
    },
    {
        name        = WeaponNames[Weapons.SNIPERRIFLE],
        description = "Magnified zoom, large caliber, bolt-action sniper rifle."
    },
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
