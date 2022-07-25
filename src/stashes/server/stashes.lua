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
    },

    MELEE = {
        Weapons.DAGGER,
        Weapons.BAT,
        Weapons.BOTTLE,
        Weapons.CROWBAR,
        Weapons.FLASHLIGHT,
        Weapons.GOLFCLUB,
        Weapons.HAMMER,
        Weapons.HATCHET,
        Weapons.KNUCKLE,
        Weapons.KNIFE,
        Weapons.MACHETE,
        Weapons.SWITCHBLADE,
        Weapons.NIGHTSTICK,
        Weapons.WRENCH,
        Weapons.BATTLEAXE,
        Weapons.POOLCUE,
        Weapons.STONE_HATCHET,
    },

    SHOTGUNS = {
        Weapons.PUMPSHOTGUN,
        Weapons.PUMPSHOTGUN_MK2,
        Weapons.SAWNOFFSHOTGUN,
        Weapons.ASSAULTSHOTGUN,
        Weapons.BULLPUPSHOTGUN,
        Weapons.MUSKET,
        Weapons.HEAVYSHOTGUN,
        Weapons.DBSHOTGUN,
        Weapons.AUTOSHOTGUN,
    },
}

Stashes.Locations = {
    ["Cultist Camp Crate"] = {
        location = vector3(-1109.4373, 4924.5083, 218.5466),
        model    = GetHashKey('prop_mil_crate_01'),
        contents = {
            { cash = 1000 },
            Stashes.Presets.SMGS,
            Stashes.Presets.ASSAULT,
        }
    },

    ["Tennis Courts Box"] = {
        location = vector3(-2925.3704, 54.4143, 11.0380),
        model    = GetHashKey('prop_box_wood01a'),
        contents = {
            { cash = 150 },
            { armor = 25 },
            Stashes.Presets.MELEE
        }
    },

    ["Grove Street Box"] = {
        location = vector3(96.7561, -1980.3606, 20.5795),
        model    = GetHashKey('prop_box_wood01a'),
        contents = {
            { cash = 500 },
            { armor = 50 },
            Stashes.Presets.SMGS
        }
    },

    ["Forum House Box"] = {
        location = vector3(-9.8260, -1436.5989, 31.1016),
        model    = GetHashKey('v_res_smallplasticbox'),
        contents = {
            { cash = 350 },
            Stashes.Presets.MELEE,
            Stashes.Presets.HANDGUNS,
        }
    },

    ["Lost MC Lot"] = {
        location = vector3(995.5547, -105.1902, 74.1177),
        model    = GetHashKey('prop_box_wood01a'),
        contents = {
            { cash = 500 },
            { armor = 50 },
            Stashes.Presets.SHOTGUNS,
        }
    },

    ["Little Seoul Construction Site"] = {
        location = vector3(-455.2286, -1057.3560, 52.4761),
        model    = GetHashKey('prop_box_wood01a'),
        contents = {
            { cash = 250 },
            Stashes.Presets.MELEE,
            Stashes.Presets.HANDGUNS,
        }
    },

    ["Pillbox Hill Construction Site"] = {
        location = vector3(-152.0905, -951.0371, 39.2545),
        model    = GetHashKey('prop_box_wood01a'),
        contents = {
            { cash = 350 },
            Stashes.Presets.MELEE,
            Stashes.Presets.SMGS,
        }
    },

    ["Vinewood Downtown Roof"] = {
        location = vector3(232.3869, 149.9208, 137.5441),
        model    = GetHashKey('prop_box_wood01a'),
        contents = {
            { cash = 750 },
            Stashes.Presets.SHOTGUNS,
            Stashes.Presets.HANDGUNS,
        }
    },

    ["Refinery Interior"] = {
        location = vector3(1108.2949, -2014.0934, 35.4680),
        model    = GetHashKey('prop_box_wood01a'),
        contents = {
            { cash = 350 },
            Stashes.Presets.MELEE,
            { armor = 50 }
        }
    },

    ["Rancho Yard"] = {
        location = vector3(465.0516, -1761.4033, 28.7764),
        model    = GetHashKey('prop_box_wood01a'),
        contents = {
            { armor = 25 },
            Stashes.Presets.MELEE,
            Stashes.Presets.HANDGUNS,
        }
    },

    ["Barrio"] = {
        location = vector3(361.6703, -2044.7842, 22.2792),
        model    = GetHashKey('prop_box_wood01a'),
        contents = {
            { cash = 500 },
            Stashes.Presets.ASSAULT,
            Stashes.Presets.HANDGUNS,
        }
    },

    ["Michael's House"] = {
        location = vector3(-815.8901, 179.7109, 76.7408),
        model    = GetHashKey('v_res_smallplasticbox'),
        contents = {
            { cash = 200 },
            Stashes.Presets.MELEE,
            Stashes.Presets.SHOTGUNS,
        }
    },

    ["Raton Canyon"] = {
        location = vector3(-526.0565, 4196.2119, 193.1649),
        model    = GetHashKey('prop_box_wood01a'),
        contents = {
            { cash = 300 },
            { armor = 50 },
            Stashes.Presets.HANDGUNS,
        }
    },

    ["Chiliad Homeless Camp"] = {
        location = vector3(1442.8668, 6334.0396, 23.8301),
        model    = GetHashKey('prop_box_wood01a'),
        contents = {
            { cash = 150 },
            Stashes.Presets.MELEE,
            Stashes.Presets.HANDGUNS,
        }
    },

    ["Tongva Hills Mansion"] = {
        location = vector3(-2639.8589, 1865.9467, 160.1346),
        model    = GetHashKey('v_res_smallplasticbox'),
        contents = {
            { cash = 150 },
            Stashes.Presets.SMGS,
            Stashes.Presets.SHOTGUNS,
        }
    },

    ["Observatory"] = {
        location = vector3(-415.7365, 1080.7606, 327.6819),
        model    = GetHashKey('v_res_smallplasticbox'),
        contents = {
            { cash = 300 },
            Stashes.Presets.SMGS,
            Stashes.Presets.HANDGUNS,
        }
    },

    ["Northern Island"] = {
        location = vector3(18.5089, 7626.9697, 13.0016),
        model    = GetHashKey('prop_box_wood01a'),
        contents = {
            { cash = 1000 },
            Stashes.Presets.ASSAULT,
            Stashes.Presets.SMGS,
        }
    },

    ["El Burro Oil Depot"] = {
        location = vector3(1734.2998, -1669.6414, 112.5771),
        model    = GetHashKey('prop_box_wood01a'),
        contents = {
            { cash = 250 },
            Stashes.Presets.MELEE,
            Stashes.Presets.HANDGUNS,
        }
    },

    ["Zancudo Small Hangar"] = {
        location = vector3(-2116.4426, 3230.4285, 32.8103),
        model    = GetHashKey('prop_box_wood01a'),
        contents = {
            { cash = 1500 },
            Stashes.Presets.ASSAULT,
            Stashes.Presets.SMGS,
        }
    },

    ["Zancudo Big Hangar"] = {
        location = vector3(-1828.3821, 3014.9189, 32.8103),
        model    = GetHashKey('prop_box_wood01a'),
        contents = {
            { cash = 1000 },
            Stashes.Presets.ASSAULT,
            { armor = 100 }
        }
    }
}
