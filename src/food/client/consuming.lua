Consuming = {}

local CANCEL_TEXT  = "Press ~INPUT_VEH_DUCK~ to cancel."
local CANCEL_LABEL = "ConsumingHelpCancel"
local DURATION     = 5000

function Consuming.begin(item)
    local cancelled = false
    local progress  = exports.progress:ShowProgressBar(DURATION, "Consuming")
    local finish_at = GetGameTimer() + DURATION

    exports["rpemotes"]:EmoteCommandStart(string.lower(item.name))

    while GetGameTimer() < finish_at do
        DisplayHelpTextThisFrame(CANCEL_LABEL, 0)

        if IsControlJustPressed(0, 73) then
            cancelled = true
            break
        end

        Citizen.Wait(0)
    end

    exports["rpemotes"]:EmoteCancel()
    exports.progress:CancelProgressBar(progress)

    if cancelled then return end

    local ped = PlayerPedId()

    SetEntityHealth(ped, math.min(GetEntityMaxHealth(ped), GetEntityHealth(ped) + 25))

    TriggerEvent(Events.ADD_CHAT_MESSAGE, {
        color     = Colors.RED,
        multiline = true,
        args      = { "System", "You gained 25 health from eating." }
    })
end

function Consuming.can_consume(item)
    for name, _ in pairs(ConsumableItems) do
        if string.lower(name) == string.lower(item.name) then
            return true
        end
    end

    return false
end

function Consuming.initialize()
    AddTextEntry(CANCEL_LABEL, CANCEL_TEXT)
end
