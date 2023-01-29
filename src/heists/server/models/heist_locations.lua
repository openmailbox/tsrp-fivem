HeistLocations = {
    {
        name     = "24/7 Innocence Blvd",
        location = vector3(29.339, -1343.141, 28.597),
        radius   = 7.0,
        blip     = { icon = 59, color = 2, label = "Convenience Store" },
        spawns   = {
            {
                model      = "u_m_y_burgerdrug_01",
                location   = vector3(24.38, -1345.7, 29.497),
                heading    = 271.849,
                init_state = {
                    hostage_behavior = "store_clerk",
                    scenario         = "WORLD_HUMAN_STAND_MOBILE",
                }
            }
        }
    }
}
