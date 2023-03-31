Resupply = {}

local CANCEL_LABEL = "ResupplyHelpCancel"
local CANCEL_TEXT  = "Press ~INPUT_VEH_DUCK~ to cancel."

function Resupply.begin(item, quantity)
    local cancelled   = false
    local duration    = math.min(1000 * quantity, 10000)
    local progress    = exports.progress:ShowProgressBar(duration, "Resupplying")
    local finish_at   = GetGameTimer() + duration

    while GetGameTimer() < finish_at do
        DisplayHelpTextThisFrame(CANCEL_LABEL, 0)

        if IsControlJustPressed(0, 73) then
            cancelled = true
            break
        end

        Citizen.Wait(0)
    end
    exports.progress:CancelProgressBar(progress)

    if cancelled then
        return false
    end

    TriggerEvent(Events.ADD_CHAT_MESSAGE, {
        color     = Colors.RED,
        multiline = true,
        args      = { "System", "You resupply " .. quantity .. " rounds of " .. item.name .. "." }
    })

    TriggerServerEvent(Events.CREATE_AMMO_RESUPPLY, {
        item     = item,
        quantity = quantity
    })

    return true
end

function Resupply.can_use(item)
    return string.match(item.name, "Ammo$") and exports.inventory:IsValidItem(item.name)
end

function Resupply.initialize()
    AddTextEntry(CANCEL_LABEL, CANCEL_TEXT)
end
