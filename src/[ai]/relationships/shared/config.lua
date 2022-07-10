Config = {}

-- Always use custom relationship groups for players instead of built-in to avoid unintended behaviors with
-- preexisting base game relationships. Set your players to one of these groups with
-- SetPedRelationshipGroupDefaultHash() and SetPedRelationshipGroupHash() to have NPCs back them up when shot at etc.
Config.CustomRelationshipGroups = {
}

-- These models should always go into these groups when they spawn
Config.ModelGroups = {
    [GetHashKey("csb_ballasog")]        = "AMBIENT_GANG_BALLAS",
    [GetHashKey("g_f_y_ballas_01")]     = "AMBIENT_GANG_BALLAS",
    [GetHashKey("g_m_y_ballasout_01")]  = "AMBIENT_GANG_BALLAS",
    [GetHashKey("ig_ballasog")]         = "AMBIENT_GANG_BALLAS",
    [GetHashKey("g_f_y_families_01")]   = "AMBIENT_GANG_FAMILY",
    [GetHashKey("g_m_y_famca_01")]      = "AMBIENT_GANG_FAMILY",
    [GetHashKey("g_m_y_famdnf_01")]     = "AMBIENT_GANG_FAMILY",
    [GetHashKey("g_m_y_famfor_01")]     = "AMBIENT_GANG_FAMILY",
    [GetHashKey("mp_m_famdd_01")]       = "AMBIENT_GANG_FAMILY",
    [GetHashKey("g_f_y_lost_01")]       = "AMBIENT_GANG_LOST",
    [GetHashKey("g_m_y_lost_01")]       = "AMBIENT_GANG_LOST",
    [GetHashKey("g_m_y_lost_02")]       = "AMBIENT_GANG_LOST",
    [GetHashKey("g_m_y_lost_03")]       = "AMBIENT_GANG_LOST",
    [GetHashKey("g_f_y_vagos_01")]      = "AMBIENT_GANG_MEXICAN",
    [GetHashKey("g_m_y_mexgoon_01")]    = "AMBIENT_GANG_MEXICAN",
    [GetHashKey("g_m_y_mexgoon_02")]    = "AMBIENT_GANG_MEXICAN",
    [GetHashKey("g_m_y_mexgoon_03")]    = "AMBIENT_GANG_MEXICAN",
    [GetHashKey("csb_cop")]             = "COP",
    [GetHashKey("s_f_y_cop_01")]        = "COP",
    [GetHashKey("s_m_m_snowcop_01")]    = "COP",
    [GetHashKey("s_m_y_cop_01")]        = "COP",
    [GetHashKey("s_m_y_hwaycop_01")]    = "COP",
    [GetHashKey("s_f_y_sheriff_01")]    = "COP",
    [GetHashKey("s_m_y_sheriff_01")]    = "COP",
    [GetHashKey("cs_prolsec_02")]       = "COP",
    [GetHashKey("csb_prolsec")]         = "COP",
    [GetHashKey("mp_m_fibsec_01")]      = "COP",
    [GetHashKey("s_m_m_ciasec_01")]     = "COP",
    [GetHashKey("s_m_m_fibsec_01")]     = "COP",
    [GetHashKey("ig_prolsec_02")]       = "COP",
    [GetHashKey("a_f_m_fatcult_01")]    = "AMBIENT_GANG_CULT",
    [GetHashKey("a_m_m_acult_01")]      = "AMBIENT_GANG_CULT",
    [GetHashKey("a_m_o_acult_01")]      = "AMBIENT_GANG_CULT",
    [GetHashKey("a_m_o_acult_02")]      = "AMBIENT_GANG_CULT",
    [GetHashKey("a_m_y_acult_01")]      = "AMBIENT_GANG_CULT",
    [GetHashKey("a_m_y_acult_02")]      = "AMBIENT_GANG_CULT",
}

Config.Relationships = {
    { -- All first responders are companions
        nature = "Companion",
        groups = {
            "COP",
            "FIREMAN",
            "SECURITY_GUARD",
            "MEDIC",
        }
    },
    { -- All player groups need to respect each other to prevent car jacking on entry into the same vehicle
        nature = "Respect",
        groups = {
            "PLAYER",
            "PC_WANTED"
        }
    },
    { -- Regular civilians are disliked by all gangs
        nature = "Dislike",
        groups = { "PLAYER", "AMBIENT_GANG_BALLAS" }
    },
    {
        nature = "Dislike",
        groups = { "PLAYER", "AMBIENT_GANG_LOST" }
    },
    {
        nature = "Dislike",
        groups = { "PLAYER", "AMBIENT_GANG_FAMILY" }
    },
    {
        nature = "Dislike",
        groups = { "PLAYER", "AMBIENT_GANG_MEXICAN" }
    },
    { -- Vagos <-> Lost at war
        nature = "Hate",
        groups = { "AMBIENT_GANG_MEXICAN", "AMBIENT_GANG_LOST" }
    },
    {
        nature = "Hate",
        groups = { "PC_GANG_VAGOS", "AMBIENT_GANG_LOST" }
    },
    {
        nature = "Hate",
        groups = { "PC_GANG_LOST", "AMBIENT_GANG_MEXICAN" }
    },
    { -- Vagos <-> Ballas at war
        nature = "Hate",
        groups = { "AMBIENT_GANG_MEXICAN", "AMBIENT_GANG_BALLAS" }
    },
    {
        nature = "Hate",
        groups = { "PC_GANG_VAGOS", "AMBIENT_GANG_BALLAS" }
    },
    {
        nature = "Hate",
        groups = { "PC_GANG_BALLAS", "AMBIENT_GANG_MEXICAN" }
    },
    { -- GSF <-> Ballas at war
        nature = "Hate",
        groups = { "AMBIENT_GANG_FAMILY", "AMBIENT_GANG_BALLAS" }
    },
    {
        nature = "Hate",
        groups = { "PC_GANG_FAMILY", "AMBIENT_GANG_BALLAS" }
    },
    {
        nature = "Hate",
        groups = { "PC_GANG_BALLAS", "AMBIENT_GANG_FAMILY" }
    },
    { -- Lost <-> Ballas at war
        nature = "Hate",
        groups = { "AMBIENT_GANG_LOST", "AMBIENT_GANG_BALLAS" }
    },
    {
        nature = "Hate",
        groups = { "PC_GANG_LOST", "AMBIENT_GANG_BALLAS" }
    },
    {
        nature = "Hate",
        groups = { "PC_GANG_BALLAS", "AMBIENT_GANG_LOST" }
    },
    { -- Animal behaviors
        nature = "Hate",
        groups = { "COUGAR", "SHARK", "PLAYER" }
    },
}
