local TEMPLATES = {
    -- MELEE
    {
        hash        = Weapons.DAGGER,
        description = "An antique-style cavalry dagger with a hand guard.",
    },
    {
        hash        = Weapons.BAT,
        description = "A large metal cylinder with obvious applications.",
    },
    {
        hash        = Weapons.BOTTLE,
        description = "A broken bottle with plenty of sharp edges.",
    },
    {
        hash        = Weapons.CROWBAR,
        description = "A curved piece of heavy metal suitable for breaking stuff.",
    },
    {
        hash        = Weapons.FLASHLIGHT,
        description = "A Maglite-style battery powered flashlight with some heft.",
    },
    {
        hash        = Weapons.GOLFCLUB,
        description = "A long, metal club that's perfect for whacking tiny balls.",
    },
    {
        hash        = Weapons.HAMMER,
        description = "A basic carpenter's hammer with a clawed head for removing nails.",
    },
    {
        hash        = Weapons.HATCHET,
        description = "A small, portable axe suitable for chopping things.",
    },
    {
        hash        = Weapons.KNUCKLE,
        description = "A heavy piece of molded brass with holes for the user's fingers.",
    },
    {
        hash        = Weapons.KNIFE,
        description = "A sharpened hunting knife with a long blade and serrated edge on one side.",
    },
    {
        hash        = Weapons.MACHETE,
        description = "A long, sharp steel blade designed to hack through heavy wilderness.",
    },
    {
        hash        = Weapons.SWITCHBLADE,
        description = "A small, spring-loaded pocket knife with a short blade that retracts into the handle.",
    },
    {
        hash        = Weapons.NIGHTSTICK,
        description = "A standard issue, tonfa-style police baton made out of fiberglass.",
    },
    {
        hash        = Weapons.WRENCH,
        description = "A large, metal wrench.",
    },
    {
        hash        = Weapons.BATTLEAXE,
        description = "A wicked looking axe designed for close combat.",
    },
    {
        hash        = Weapons.POOLCUE,
        description = "The unscrewed lower half of a pool cue.",
    },
    {
        hash        = Weapons.STONE_HATCHET,
        description = "A primitive tomahawk axe handmade out of basic materials.",
    },
    -- HANDGUNS
    {
        hash        = Weapons.PISTOL,
        description = "A basic double action semi-automatic pistol.",
    },
    {
        hash        = Weapons.PISTOL_MK2,
        description = "A heavier version of the standard double action semi-automatic pistol.",
    },
    {
        hash        = Weapons.COMBATPISTOL,
        description = "A slightly heavier double action semi-automatic pistol commonly used by law enforcement and militaries.",
    },
    {
        hash        = Weapons.APPISTOL,
        description = "A high-penetration, fully-automatic pistol that makes up for poor accuracy with number of bullets.",
    },
    {
        hash        = Weapons.STUNGUN,
        description = "A less lethal handgun option that fires a high-voltage projectile designed to temporarily stun targets.",
    },
    {
        hash        = Weapons.PISTOL50,
        description = "A high-impact large caliber pistol that delivers immense power but with extremely strong recoil.",
    },
    {
        hash        = Weapons.SNSPISTOL,
        description = "A small handgun with a short barrel designed to fit in a pocket or handbag.",
    },
    {
        hash        = Weapons.SNSPISTOL_MK2,
        description = "A flashier version of the snub-nosed pistol designed to fit in pockets and handbags.",
    },
    {
        hash        = Weapons.HEAVYPISTOL,
        description = "A heavyweight champion of magazine fed, semi-automatic handguns that delivers accuracy along with a serious forearm workout.",
    },
    {
        hash        = Weapons.VINTAGEPISTOL,
        description = "An otherwise fairly standard pistol with intricate barrel engravings that would make it a nice decoration piece.",
    },
    {
        hash        = Weapons.FLAREGUN,
        description = "A single-shot pistol that fires highly flammable flares designed to signal distress or drunken excitement.",
    },
    {
        hash        = Weapons.MARKSMANPISTOL,
        description = "A single-shot handgun with unmatched accuracy that takes forever to reload.",
    },
    {
        hash        = Weapons.REVOLVER,
        description = "A very heavy cylinder-fed handgun with enough stopping power to drop a crazed rhino.",
    },
    {
        hash        = Weapons.REVOLVER_MK2,
        description = "An even heavier version of the cylinder-fed base variant, this is the closest you'll get to shooting someone with a freight train.",
    },
    {
        hash        = Weapons.DOUBLEACTION,
        description = "A cylinder-fed six shooter similar to those used in western films.",
    },
    {
        hash        = Weapons.RAYPISTOL,
        description = "???",
    },
    -- SMGs
    {
        hash        = Weapons.SMG,
        description = "Compact, lightweight, small caliber, fully automatic.",
    },
    {
        hash        = Weapons.PUMPSHOTGUN,
        description = "A pump action heavy gauge shotgun.",
    },
    {
        hash        = Weapons.ASSAULTRIFLE,
        description = "Standard assault rifle used by militaries around the world.",
    },
    {
        hash        = Weapons.RPG,
        description = "Shoulder mounted, manually aimed rocket propelled grenade launcher.",
    },
    {
        hash        = Weapons.SNIPERRIFLE,
        description = "Magnified zoom, large caliber, bolt-action sniper rifle.",
    },
}

local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end

    local tags = { "equipment" }

    for _, t in ipairs(TEMPLATES) do
        t.name = WeaponNames[t.hash]
        t.tags = tags

        exports.inventory:RegisterItem(t.name, t)
    end
end
AddEventHandler(Events.ON_RESOURCE_START, create)
AddEventHandler(Events.ON_CLIENT_RESOURCE_START, create)
