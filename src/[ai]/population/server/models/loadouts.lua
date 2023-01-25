Loadouts = {
    Banger = {
        combat_attribs  = { 0, 1, 2, 3, 46, 52 },
        combat_movement = 3,
        accuracy        = 50,
        weapons         = { "WEAPON_PISTOL" }
    },

    Officer = {
        armor           = 75,
        driver_ability  = 1.0,
        combat_ability  = 2,
        combat_attribs  = { 0, 1, 2, 3, 46, 52 },
        combat_movement = 2,
        accuracy        = 66,
        weapons         = { "WEAPON_COMBATPISTOL", "WEAPON_NIGHTSTICK", "WEAPON_STUNGUN" }
    },

    Swat = {
        armor           = 100,
        driver_ability  = 1.0,
        combat_ability  = 2,
        combat_attribs  = { 0, 1, 2, 3, 46, 52 },
        combat_movement = 2,
        accuracy        = 80,
        weapons         = { "WEAPON_CARBINERIFLE" }
    }
}

local MODEL_LOADOUTS = {
    [GetHashKey("csb_cop")]             = Loadouts.Officer,
    [GetHashKey("s_f_y_cop_01")]        = Loadouts.Officer,
    [GetHashKey("s_m_m_snowcop_01")]    = Loadouts.Officer,
    [GetHashKey("s_m_y_cop_01")]        = Loadouts.Officer,
    [GetHashKey("s_m_y_hwaycop_01")]    = Loadouts.Officer,
    [GetHashKey("s_f_y_sheriff_01")]    = Loadouts.Officer,
    [GetHashKey("s_m_y_sheriff_01")]    = Loadouts.Officer,
    [GetHashKey("cs_prolsec_02")]       = Loadouts.Officer,
    [GetHashKey("csb_prolsec")]         = Loadouts.Officer,
    [GetHashKey("mp_m_fibsec_01")]      = Loadouts.Officer,
    [GetHashKey("s_m_m_ciasec_01")]     = Loadouts.Officer,
    [GetHashKey("s_m_m_fibsec_01")]     = Loadouts.Officer,
    [GetHashKey("ig_prolsec_02")]       = Loadouts.Officer,
    [GetHashKey("u_m_m_prolsec_01")]    = Loadouts.Officer,
    [GetHashKey("mp_m_securoguard_01")] = Loadouts.Officer,
    [GetHashKey("s_m_m_security_01")]   = Loadouts.Officer,
    [GetHashKey("s_m_y_swat_01")]       = Loadouts.Swat,
    [GetHashKey("csb_ballasog")]        = Loadouts.Banger,
    [GetHashKey("g_f_y_ballas_01")]     = Loadouts.Banger,
    [GetHashKey("g_m_y_ballasout_01")]  = Loadouts.Banger,
    [GetHashKey("g_m_y_ballaeast_01")]  = Loadouts.Banger,
    [GetHashKey("g_m_y_ballaorig_01")]  = Loadouts.Banger,
    [GetHashKey("ig_ballasog")]         = Loadouts.Banger,
    [GetHashKey("g_f_y_families_01")]   = Loadouts.Banger,
    [GetHashKey("g_m_y_famca_01")]      = Loadouts.Banger,
    [GetHashKey("g_m_y_famdnf_01")]     = Loadouts.Banger,
    [GetHashKey("g_m_y_famfor_01")]     = Loadouts.Banger,
    [GetHashKey("mp_m_famdd_01")]       = Loadouts.Banger,
    [GetHashKey("g_f_y_lost_01")]       = Loadouts.Banger,
    [GetHashKey("g_m_y_lost_01")]       = Loadouts.Banger,
    [GetHashKey("g_m_y_lost_02")]       = Loadouts.Banger,
    [GetHashKey("g_m_y_lost_03")]       = Loadouts.Banger,
    [GetHashKey("g_f_y_vagos_01")]      = Loadouts.Banger,
    [GetHashKey("g_m_y_mexgang_01")]    = Loadouts.Banger,
    [GetHashKey("g_m_y_mexgoon_01")]    = Loadouts.Banger,
    [GetHashKey("g_m_y_mexgoon_02")]    = Loadouts.Banger,
    [GetHashKey("g_m_y_mexgoon_03")]    = Loadouts.Banger,
    [GetHashKey("a_f_m_fatcult_01")]    = Loadouts.Banger,
    [GetHashKey("a_m_m_acult_01")]      = Loadouts.Banger,
    [GetHashKey("a_m_o_acult_01")]      = Loadouts.Banger,
    [GetHashKey("a_m_o_acult_02")]      = Loadouts.Banger,
    [GetHashKey("a_m_y_acult_01")]      = Loadouts.Banger,
    [GetHashKey("a_m_y_acult_02")]      = Loadouts.Banger,
    [GetHashKey("g_m_y_korean_01")]     = Loadouts.Banger,
    [GetHashKey("g_m_y_korean_02")]     = Loadouts.Banger,
    [GetHashKey("g_m_y_korlieut_01")]   = Loadouts.Banger,
    [GetHashKey("g_m_y_salvaboss_01")]  = Loadouts.Banger,
    [GetHashKey("g_m_y_salvagoon_01")]  = Loadouts.Banger,
    [GetHashKey("g_m_y_salvagoon_02")]  = Loadouts.Banger,
    [GetHashKey("g_m_y_salvagoon_03")]  = Loadouts.Banger
}

function Loadouts.for_model(hash)
    return MODEL_LOADOUTS[hash]
end
