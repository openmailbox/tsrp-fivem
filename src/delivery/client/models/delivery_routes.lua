DeliveryRoutes = {
    ["Go Postal"] = {
        origin  = vector4(68.7993, 127.2573, 79.2058, 156.0530),
        blip    = { icon = 478, color = 10, label = "Delivery Job" },
        emote   = "box", -- if supported, the emote that will play when player is "delivering"
        vehicle = {
            model  = "boxville2",
            spawns = {
                vector4(58.6648, 120.6847, 79.2320, 156.5412),
                vector4(72.7464, 117.0776, 79.0494, 152.9806),
                vector4(64.4360, 119.5774, 79.1152, 162.3527)
            }
        },
        dropoffs = {
            vector3(3.3956, 36.5355, 70.6304),       -- 0605 Laguna Pl, West Vinewood
            vector3(114.7869, -5.9946, 66.9104),     -- Pop's Pills pharmacy, Alta St, Vinewood
            vector3(172.7878, -26.5904, 67.4455),    -- Vinewood Institute, Hawick
            vector3(252.4337, -47.2144, 69.9410),    -- Ammunation, Hawick
            vector3(335.1068, 119.4046, 103.4074),   -- Fred's Store, Vinewood Blvd, Downtown Vinewood
            vector3(321.5246, 182.3366, 102.6865),   -- Tattoo Shop, Vinewood Blvd, Downtown Vinewood
            vector3(225.4082, 338.3333, 104.7074),   -- Pitcher's, Clinton Ave, Downtown Vinewood
            vector3(374.2959, 330.0128, 102.6663),   -- 24/7, Alta St, Downtown Vinewood
            vector3(-629.6690, 239.4854, 80.9974),   -- Bean Machine, West Vinewood
            vector3(-677.1456, 311.1752, 82.1841),   -- Eclipse Medical Tower, West Vinewood
            vector3(-773.4521, 308.3716, 84.7981),   -- Eclipse Towers, Rockford Hills
            vector3(-818.4861, 177.4731, 71.3225),   -- Michael's House, Rockford Hills
            vector3(-809.2515, -180.7390, 36.6689),  -- Bub Mulet, Rockford Hills
            vector3(-1081.3075, -249.2536, 36.6633), -- Lifeinvader, Movie Star Way, Rockford Hills
            vector3(-1306.0103, -391.3244, 35.7958), -- Ammunation, Morningwood
            vector3(-1483.3597, -375.9045, 39.2634), -- Rob's Liquor, Morningwood
            vector3(-1470.6033, -328.4532, 43.9008), -- Los Cuadros Deli, Morningwood
            vector3(-1547.6235, -218.0296, 53.6652), -- Outdoor Action, South Rockford Dr, Morningwood
            vector3(-143.7235, 231.3874, 94.0501),   -- Hardcore Comic Store, West Vinewood
            vector3(-35.5880, -155.0358, 56.1765),   -- Hair on Hawick
            vector3(-355.6294, -127.7737, 38.5306),  -- LS Customs, Burton
            vector3(-241.4357, -240.8971, 35.6190),  -- Rockford Plaza, Burton
            vector3(-144.7856, -66.1468, 53.7000),   -- Fruit of the Vine Wine Merchant, Hawick Ave, Burton
            vector3(-51.8963, -213.1119, 44.9042),   -- LS Office Supply, Burton
            vector3(314.6724, -226.8774, 53.1262),   -- Pink Cage, Alta
            vector3(526.1160, -151.0222, 56.8634),   -- Fake 24/7, Hawick
        }
    },

    ["Post Op Couriers"] = {
        origin  = vector4(-231.4501, -912.8694, 32.3109, 289.8804),
        blip    = { icon = 501, color = 16, label = "Courier Job" },
        emote   = "backpack",
        vehicle = {
            required = true, -- player must bring their own vehicle
            class    = 13    -- bicycles
        },
        dropoffs = {
            vector3(-267.0710, -959.2544, 30.3231), -- 3 Alta St, Pillbox Hill
            vector3(-194.0519, -831.7274, 29.8941), -- Gruppe Sechs, Pillbox Hill
            vector3(-6.8534, -661.2135, 32.5805),   -- Union Depository Loading Dock, Pillbox Hill
            vector3(111.4326, -749.7087, 44.8547),  -- FIB Lobby, Pillbox Hill
            vector3(6.2310, -709.3139, 45.0730),    -- Union Depository main entrance, Pillbox Hill
            vector3(-70.2461, -798.2324, 43.3273),  -- Maze Bank main entrance, Pillbox Hill
            vector3(309.5430, -590.8304, 42.3840),  -- Pillbox lobby
            vector3(-112.2790, -605.7161, 35.3807), -- Arcadius Business Center main entrance, Pillbox Hill
            vector3(-59.8214, -616.0707, 36.4568),  -- 4 Integrity Way, Pillbox Hill
            vector3(267.6771, -638.9748, 41.1197),  -- Integrity Towers, Pillbox Hill
            vector3(55.1683, -797.8290, 30.6840),   -- G&P Restaurant, Pillbox Hill
            vector3(-240.0576, -776.9979, 33.1917), -- Cafe Redemption, Pillbox Hill
            vector3(167.2720, -566.9451, 42.9729),  -- Penris Building, Pillbox Hill
            vector3(-269.7897, -706.8718, 37.3770), -- Slaughter, Slaughter, & Slaughter office, Pillbox Hill
            vector3(-214.4060, -727.4740, 32.6715), -- Schlongberg Sachs, Pillbox Hill
            vector3(5.4970, -934.8519, 29.0050),    -- Lombank, Pillbox Hill
            vector3(6.0519, -984.2795, 28.4685),    -- Hookah Palace, Vespucci Blvd, Pillbox Hill
            vector3(68.5676, -959.7261, 28.9038),   -- The Emissary, Vespucci Blvd, Pillbox Hill
            vector3(150.4702, -1039.6237, 28.4689), -- Fleeca, Pillbox Hill
            vector3(122.3492, -879.8928, 30.2231),  -- Escapism Travel, Pillbox Hill
            vector3(-295.9993, -829.3188, 31.5158), -- Quikhouse, Peaceful St, Pillbox Hill
        }
    }
}
