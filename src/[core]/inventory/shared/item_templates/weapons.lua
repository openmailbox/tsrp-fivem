local TEMPLATES = {
    -- MELEE
    {
        name        = WeaponNames[Weapons.DAGGER],
        description = "An antique-style cavalry dagger with a hand guard."
    },
    {
        name        = WeaponNames[Weapons.BAT],
        description = "A large metal cylinder with obvious applications."
    },
    {
        name        = WeaponNames[Weapons.BOTTLE],
        description = "A broken bottle with plenty of sharp edges."
    },
    {
        name        = WeaponNames[Weapons.CROWBAR],
        description = "A curved piece of heavy metal suitable for breaking stuff."
    },
    {
        name        = WeaponNames[Weapons.FLASHLIGHT],
        description = "A Maglite-style battery powered flashlight with some heft."
    },
    {
        name        = WeaponNames[Weapons.GOLFCLUB],
        description = "A long, metal club that's perfect for whacking tiny balls."
    },
    {
        name        = WeaponNames[Weapons.HAMMER],
        description = "A basic carpenter's hammer with a clawed head for removing nails."
    },
    {
        name        = WeaponNames[Weapons.HATCHET],
        description = "A small, portable axe suitable for chopping things."
    },
    {
        name        = WeaponNames[Weapons.KNUCKLE],
        description = "A heavy piece of molded brass with holes for the user's fingers."
    },
    {
        name        = WeaponNames[Weapons.KNIFE],
        description = "A sharpened hunting knife with a long blade and serrated edge on one side."
    },
    {
        name        = WeaponNames[Weapons.MACHETE],
        description = "A long, sharp steel blade designed to hack through heavy wilderness."
    },
    {
        name        = WeaponNames[Weapons.SWITCHBLADE],
        description = "A small, spring-loaded pocket knife with a short blade that retracts into the handle."
    },
    {
        name        = WeaponNames[Weapons.NIGHTSTICK],
        description = "A standard issue, tonfa-style police baton made out of fiberglass."
    },
    {
        name        = WeaponNames[Weapons.WRENCH],
        description = "A large, metal wrench."
    },
    {
        name        = WeaponNames[Weapons.BATTLEAXE],
        description = "A wicked looking axe designed for close combat."
    },
    {
        name        = WeaponNames[Weapons.POOLCUE],
        description = "The unscrewed lower half of a pool cue."
    },
    {
        name        = WeaponNames[Weapons.STONE_HATCHET],
        description = "A primitive tomahawk axe handmade out of basic materials."
    },
    -- HANDGUNS
    {
        name        = WeaponNames[Weapons.PISTOL],
        description = "A basic double action semi-automatic pistol."
    },
    {
        name        = WeaponNames[Weapons.PISTOL_MK2],
        description = "A heavier version of the standard double action semi-automatic pistol."
    },
    {
        name        = WeaponNames[Weapons.COMBATPISTOL],
        description = "A slightly heavier double action semi-automatic pistol commonly used by law enforcement and militaries."
    },
    {
        name        = WeaponNames[Weapons.APPISTOL],
        description = "A high-penetration, fully-automatic pistol that makes up for poor accuracy with number of bullets."
    },
    {
        name        = WeaponNames[Weapons.STUNGUN],
        description = "A less lethal handgun option that fires a high-voltage projectile designed to temporarily stun targets."
    },
    {
        name        = WeaponNames[Weapons.PISTOL50],
        description = "A high-impact large caliber pistol that delivers immense power but with extremely strong recoil."
    },
    {
        name        = WeaponNames[Weapons.SNSPISTOL],
        description = "A small handgun with a short barrel designed to fit in a pocket or handbag."
    },
    {
        name        = WeaponNames[Weapons.SNSPISTOL_MK2],
        description = "A flashier version of the snub-nosed pistol designed to fit in pockets and handbags."
    },
    {
        name        = WeaponNames[Weapons.HEAVYPISTOL],
        description = "A heavyweight champion of magazine fed, semi-automatic handguns that delivers accuracy along with a serious forearm workout."
    },
    {
        name        = WeaponNames[Weapons.VINTAGEPISTOL],
        description = "An otherwise fairly standard pistol with intricate barrel engravings that would make it a nice decoration piece."
    },
    {
        name        = WeaponNames[Weapons.FLAREGUN],
        description = "A single-shot pistol that fires highly flammable flares designed to signal distress or drunken excitement."
    },
    {
        name        = WeaponNames[Weapons.MARKSMANPISTOL],
        description = "A single-shot handgun with unmatched accuracy that takes forever to reload."
    },
    {
        name        = WeaponNames[Weapons.REVOLVER],
        description = "A very heavy cylinder-fed handgun with enough stopping power to drop a crazed rhino."
    },
    {
        name        = WeaponNames[Weapons.REVOLVER_MK2],
        description = "An even heavier version of the cylinder-fed base variant, this is the closest you'll get to shooting someone with a freight train."
    },
    {
        name        = WeaponNames[Weapons.DOUBLEACTION],
        description = "A cylinder-fed six shooter similar to those used in western films."
    },
    {
        name        = WeaponNames[Weapons.RAYPISTOL],
        description = "???"
    },
    -- SMGs
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
