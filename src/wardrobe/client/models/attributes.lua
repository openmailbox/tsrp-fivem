AttributeTypes = {
    COMPONENT    = 1,
    FACE_FEATURE = 2,
    EYE_COLOR    = 3,
    HAIR_COLOR   = 4,
    HEAD_BLEND   = 5,
    HEAD_OVERLAY = 6,
    MAKEUP_COLOR = 7,
    PROP         = 8,
    TATTOO       = 9,
    MODEL        = 10
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
}
