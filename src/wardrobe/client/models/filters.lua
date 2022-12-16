Filters = {}

-- Limit the range of controls visible in the wardrobe during a session.
Filters = {
    Clothing = {
        block = {
            { type = AttributeTypes.MODEL },
            { type = AttributeTypes.COMPONENT, labels = { "Face", "Mask", "Hair" } },
        }
    },

    Barber = {
        allow = {
            { type = AttributeTypes.COMPONENT, labels = { "Hair" } }
        }
    }
}
