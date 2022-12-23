local function index(data)
    local player_id = source

    -- TODO: Load player's characters from database.

    TriggerClientEvent(Events.UPDATE_CHARACTER_ROSTER, player_id, {
        characters = {
            {
                id         = 1,
                first_name = "John",
                last_name  = "Doe",
                snapshot   = {
                    {
                        name  = "model",
                        type  = 1,
                        value = {
                            label = "mp_m_freemode_01",
                            hash  = GetHashKey("mp_m_freemode_01")
                        }
                    }
                }
            }
        }
    })
end
RegisterNetEvent(Events.GET_CHARACTER_ROSTER, index)
