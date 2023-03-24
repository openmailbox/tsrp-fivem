Dealer = {}

-- Forwad declarations
local init_vehicle_buy,
      pick_inventory,
      use_dealer

local BLIP_SCALE = vector3(0.7, 0.7, 0.7)
local HELP_KEY   = "ShowroomDealerHelp"

local active_dealer = nil
local dealers       = {} -- Name->Dealer map of all active dealers
local show_prompt   = false

function Dealer.find_by_name(name)
    return dealers[name]
end

function Dealer.setup()
    AddTextEntry(HELP_KEY, "Press ~INPUT_REPLAY_START_STOP_RECORDING~ to shop for vehicles.")

    for name, details in pairs(Dealers) do
        local new_dealer = Dealer:new(details)
        new_dealer.name = name

        dealers[name] = new_dealer

        new_dealer:show()
    end
end

function Dealer.teardown()
    for _, dealer in pairs(dealers) do
        dealer:hide()
    end

    dealers = {}
end

function Dealer:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Dealer:enter()
    active_dealer = self

    if show_prompt then return end
    show_prompt = true

    Citizen.CreateThread(function()
        while show_prompt do
            DisplayHelpTextThisFrame(HELP_KEY, 0)

            if IsControlJustPressed(0, 288) then -- F1
                use_dealer(active_dealer)
            end

            Citizen.Wait(0)
        end
    end)
end

function Dealer:exit()
    active_dealer = nil
    show_prompt = false
end

function Dealer:hide()
    exports.map:RemoveBlip(self.blip_id)
    exports.zones:RemoveZone(self.name)
end

function Dealer:show()
    self.blip_id = exports.map:AddBlip(self.location, {
        icon    = self.blip.icon,
        color   = self.blip.color,
        display = 2,
        scale   = BLIP_SCALE,
        label   = "Vehicle Dealer"
    })

    exports.zones:AddZone({
        name   = self.name,
        center = self.location,
        width  = self.width,
        height = self.height
    })
end

-- @local
function init_vehicle_buy(dealer, options)
    local spawn = GetFirstAvailable(dealer.spawns)

    if not spawn then
        TriggerEvent(Events.CREATE_HUD_NOTIFICATION, {
            message = "Unexpected error. Please try again or contact support.",
            flash   = true
        })

        Logging.log(Logging.WARN, "Unable to find spawn location for vehicle '" .. options.name .. "' at " .. dealer.name .. ".")

        return
    end

    local hash    = GetHashKey(options.name)
    local timeout = GetGameTimer() + 3000

    if not HasModelLoaded(hash) then
        RequestModel(hash)

        repeat
            Citizen.Wait(100)
        until HasModelLoaded(hash) or GetGameTimer() > timeout
    end

    if GetGameTimer() > timeout then
        Logging.log(Logging.WARN, "Unable to load vehicle model for " .. options.name .. ".")
        return
    end

    TriggerServerEvent(Events.CREATE_VEHICLE_PURCHASE, {
        model    = options.name,
        price    = options.price,
        location = spawn,
        dealer   = dealer.name
    })
end

-- @local
function pick_inventory()
    local categories   = {}
    local results      = {}
    local sorted_names = {}
    local count        = 0
    local day_of_week  = math.floor((GetCloudTimeAsInt() / 86400) + 4) % 7

    for name, _ in pairs(VehiclePrices) do
        table.insert(sorted_names, name)
    end

    table.sort(sorted_names)

    for _, name in ipairs(sorted_names) do
        if count == day_of_week then
            local cat_name = VehicleClasses[GetVehicleClassFromName(GetHashKey(name))] or "Other"
            local category = categories[cat_name]

            if not category then
                category = {
                    name   = cat_name,
                    models = {}
                }

                categories[cat_name] = category
            end

            table.insert(category.models, {
                name  = name,
                label = GetDisplayNameFromVehicleModel(GetHashKey(name)),
                price = VehiclePrices[name]
            })
        end

        if count >= 6 then
            count = 0
        else
            count = count + 1
        end
    end

    for _, v in pairs(categories) do
        table.insert(results, v)
    end

    table.sort(results, function(a, b)
        return a.name < b.name
    end)

    return results
end

-- @local
function use_dealer(dealer)
    if IsPedDeadOrDying(PlayerPedId(), 1) then return end

    if GetPlayerWantedLevel(PlayerId()) > 0 then
        TriggerEvent(Events.CREATE_HUD_NOTIFICATION, { message = "Can't do that while wanted by police." })
        return
    end

    show_prompt = false

    exports.showroom:StartSession({
        action     = "Buy Vehicle",
        categories = pick_inventory(),
        callback   = function(results)
            if not results then return end

            if results.action ~= "Buy Vehicle" then
                Logging.log(Logging.WARN, "Unexpected showroom return result: " .. json.encode(results) .. ".")
                return
            end

            init_vehicle_buy(dealer, results)
        end
    })
end