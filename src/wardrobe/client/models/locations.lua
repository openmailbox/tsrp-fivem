-- Places to put an invisible marker (Store) that opens a wardrobe session in various contexts i.e. clothing stores.
Locations = {
    ["Clothing Store"] = {
        blip      = { icon = 73, color = 17 },
        locations = {
            {
                name     = "Binco Sinner Street",
                location = vector3(427.276, -805.774, 28.591),
                radius   = 7.5
            },
            {
                name     = "Sub Urban Route 68",
                location = vector3(617.554, 2764.363, 41.188),
                radius   = 15.5
            },
            {
                name     = "Binco Paleto",
                location = vector3(6.095, 6511.412, 30.978),
                radius   = 7.5
            }
        }
    },

    Barber = {
        blip      = { icon = 71, color = 4 },
        locations = {
            {
                name     = "Herr Kutz South Los Santos",
                location = vector3(137.407, -1707.874, 28.392),
                radius   = 3.5
            },
            {
                name     = "Herr Kutz Paleto",
                location = vector3(-278.533, 6228.525, 30.796),
                radius     = 4.5
            }
        }
    }
}
