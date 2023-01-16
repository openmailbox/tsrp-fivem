local lock          = false
local uuid_template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
local seed          = nil

-- Generates pseudo-conformant UUIDs. They are not _real_ UUIDs. Good enough for in-memory uniqueness
-- for our purposes.
function GenerateUUID()
    if not seed then
        if os then
            seed = os.time()
        else
            seed = GetGameTimer()
        end

        math.randomseed(seed)
    end

    while lock do
        Citizen.Wait(1)
    end

    lock = true

    local result = string.gsub(uuid_template, '[xy]', function (c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)

    lock = false

    return result
end
