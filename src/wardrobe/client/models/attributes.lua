AttributeTypes = {
    MODEL        = 1,
    COMPONENT    = 2,
    PROP         = 3,
    FACE_FEATURE = 4,
    EYE_COLOR    = 5,
    HAIR_COLOR   = 6,
    HEAD_BLEND   = 7,
    HEAD_OVERLAY = 8,
    MAKEUP_COLOR = 9,
    TATTOO       = 10,
}

Attributes = {
    ["model"] = { label = "Model", type = AttributeTypes.MODEL },

    ["face"]         = { label = "Face",         type = AttributeTypes.COMPONENT, index = 0  },
    ["mask"]         = { label = "Mask",         type = AttributeTypes.COMPONENT, index = 1  },
    ["hair"]         = { label = "Hair",         type = AttributeTypes.COMPONENT, index = 2  },
    ["torso"]        = { label = "Torso",        type = AttributeTypes.COMPONENT, index = 3  },
    ["legs"]         = { label = "Legs",         type = AttributeTypes.COMPONENT, index = 4  },
    ["bag"]          = { label = "Bag",          type = AttributeTypes.COMPONENT, index = 5  },
    ["shoes"]        = { label = "Shoes",        type = AttributeTypes.COMPONENT, index = 6  },
    ["accessories"]  = { label = "Accessories",  type = AttributeTypes.COMPONENT, index = 7  },
    ["undershirts"]  = { label = "Undershirts",  type = AttributeTypes.COMPONENT, index = 8  },
    ["body_armor"]   = { label = "Body Armor",   type = AttributeTypes.COMPONENT, index = 9  },
    ["decals"]       = { label = "Decals",       type = AttributeTypes.COMPONENT, index = 10 },
    ["tops"]         = { label = "Tops",         type = AttributeTypes.COMPONENT, index = 11 },

    ["hat"]      = { label = "Hat",      type = AttributeTypes.PROP, index = 0 },
    ["glasses"]  = { label = "Glasses",  type = AttributeTypes.PROP, index = 1 },
    ["ears"]     = { label = "Ears",     type = AttributeTypes.PROP, index = 2 },
    ["watch"]    = { label = "Watch",    type = AttributeTypes.PROP, index = 6 },
    ["bracelet"] = { label = "Bracelet", type = AttributeTypes.PROP, index = 7 },
}
