Stashes = {}

Stashes.Presets = {
    HANDGUNS = {
        Weapons.PISTOL,
        Weapons.PISTOL_MK2,
        Weapons.COMBATPISTOL,
        Weapons.APPISTOL,
        Weapons.STUNGUN,
        Weapons.PISTOL50,
        Weapons.SNSPISTOL,
        Weapons.SNSPISTOL_MK2,
        Weapons.HEAVYPISTOL,
        Weapons.VINTAGEPISTOL,
        Weapons.FLAREGUN,
        Weapons.MARKSMANPISTOL,
        Weapons.REVOLVER,
        Weapons.REVOLVER_MK2,
        Weapons.DOUBLEACTION,
        Weapons.RAYPISTOL
    },

    SMGS = {
        Weapons.MICROSMG,
        Weapons.SMG,
        Weapons.SMG_MK2,
        Weapons.ASSAULTSMG,
        Weapons.COMBATPDW,
        Weapons.MACHINEPISTOL,
        Weapons.MINISMG,
        Weapons.RAYCARBINE,
    },

    ASSAULT = {
        Weapons.ASSAULTRIFLE,
        Weapons.ASSAULTRIFLE_MK2,
        Weapons.CARBINERIFLE,
        Weapons.CARBINERIFLE_MK2,
        Weapons.ADVANCEDRIFLE,
        Weapons.SPECIALCARBINE,
        Weapons.SPECIALCARBINE_MK2,
        Weapons.BULLPUPRIFLE,
        Weapons.BULLPUPRIFLE_MK2,
        Weapons.COMPACTRIFLE,
    }
}

Stashes.Locations = {
    ["Cultist Camp Crate"] = {
        location = vector3(-1109.4373, 4924.5083, 218.5466),
        model    = GetHashKey('prop_mil_crate_01'),
        contents = {
            { cash   = 1000 },
            { weapon = Stashes.Presets.SMGS },
            { weapon = Stashes.Presets.ASSAULT },
        }
    },

    ["Tennis Courts Box"] = {
        location = vector3(-2925.3704, 54.4143, 11.0380),
        model    = GetHashKey('prop_box_wood01a'),
        contents = {
        }
    },

    ["Grove Street Box"] = {
        location = vector3(96.7561, -1980.3606, 20.5795),
        model    = GetHashKey('prop_box_wood01a'),
        contents = {
            { cash = 500 },
            Stashes.Presets.HANDGUNS,
            Stashes.Presets.SMGS
        }
    },

    ["Forum House Box"] = {
        location = vector3(-9.8260, -1436.5989, 31.1016),
        model    = GetHashKey('v_res_smallplasticbox'),
        contents = {
            cash = 350
        }
    }
}
