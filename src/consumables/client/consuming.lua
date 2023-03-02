Consuming = {}

-- Forward declarations
local cancel_emote,
      format_name,
      play_emote

local CANCEL_TEXT  = "Press ~INPUT_VEH_DUCK~ to cancel."
local CANCEL_LABEL = "ConsumingHelpCancel"
local DURATION     = 5000

function Consuming.begin(item)
    local cancelled   = false
    local progress    = exports.progress:ShowProgressBar(DURATION, "Consuming")
    local finish_at   = GetGameTimer() + DURATION
    local parsed_name = format_name(item.name)

    play_emote(parsed_name)

    while GetGameTimer() < finish_at do
        DisplayHelpTextThisFrame(CANCEL_LABEL, 0)

        if IsControlJustPressed(0, 73) then
            cancelled = true
            break
        end

        Citizen.Wait(0)
    end

    cancel_emote()
    exports.progress:CancelProgressBar(progress)

    if cancelled then return end

    local ped = PlayerPedId()

    SetEntityHealth(ped, math.min(GetEntityMaxHealth(ped), GetEntityHealth(ped) + 20))

    TriggerEvent(Events.ADD_CHAT_MESSAGE, {
        color     = Colors.RED,
        multiline = true,
        args      = { "System", "You restore 20 health by eating one " .. item.name .. "." }
    })

    TriggerServerEvent(Events.CREATE_INVENTORY_ITEM_USE, {
        item = item
    })
end

function Consuming.can_consume(item)
    local parsed_name = format_name(item.name)

    for name, _ in pairs(ConsumableItems) do
        if format_name(name) == parsed_name then
            return true
        end
    end

    return false
end

function Consuming.initialize()
    AddTextEntry(CANCEL_LABEL, CANCEL_TEXT)
end

-- @local
function cancel_emote()
    if exports["rpemotes"] then
        exports["rpemotes"]:EmoteCancel()
    end
end

-- @local
function format_name(s)
    return string.lower(string.gsub(s, '%s', ''))
end

-- @local
function play_emote(name)
    -- Avoid making the emote resource a hard dependency so we can easily swap out for whatever emote provider.
    if exports["rpemotes"] then
        exports["rpemotes"]:EmoteCommandStart(name)
    else
        Logging.log(Logging.WARN, "Unable to play emote for consumables.")
    end
end
