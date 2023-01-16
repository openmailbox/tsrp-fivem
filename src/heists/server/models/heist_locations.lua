HeistLocations = {
    {
        name     = "24/7 Innocence Blvd",
        location = vector3(29.339, -1343.141, 28.597),
        radius   = 7.0,
        blip     = { icon = 59, color = 2, label = "Convenience Store" },
        objects  = {
            { model = "prop_till_01", location = vector3(24.946, -1347.288, 29.612) },
            { model = "prop_till_01", location = vector3(24.946, -1344.954, 29.612) },
        },
        spawns = {
            {
                model    = "u_m_y_burgerdrug_01",
                location = vector3(24.38, -1345.7, 29.497),
                heading  = 271.849,
                scenario = "WORLD_HUMAN_STAND_MOBILE",
                voice    = "mp_m_shopkeep_01_latino_mini_01"
            }
        }
    }
}
