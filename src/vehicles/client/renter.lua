Renter = {}

-- Forward declarations
local get_first_open,
      init_vehicle_rent,
      show_offer,
      show_prompt

local ICON       = 810 -- radar_vehicle_for_sale
local PROMPT_KEY = "RentalVehiclePrompt"

local is_prompting = false
local renters      = {}

function Renter.all()
    return renters
end

function Renter.setup()
    AddTextEntry(PROMPT_KEY, "Press ~INPUT_CONTEXT~ to rent a vehicle.")

    for name, details in pairs(RentLocations) do
        for _, cat in ipairs(details.categories) do
            for _, model in ipairs(cat.models) do
                model.label = GetDisplayNameFromVehicleModel(GetHashKey(model.name))
            end
        end

        local renter = Renter:new({
            name     = name,
            location = details.location
        })

        renter:initialize()
    end
end

function Renter.teardown()
    for _, renter in ipairs(Renter.all()) do
        renter:cleanup()
    end
end

function Renter:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Renter:initialize()
    self.blip = exports.map:AddBlip(self.location, {
        label   = "Vehicle Rental",
        icon    = ICON,
        color   = 11, -- forest green
        display = 2,
        scale   = vector3(0.7, 0.7, 0.7)
    })

    self.renter = exports.markers:AddMarker({
        coords         = self.location,
        icon           = 36,
        interact_range = 1.0,
        draw_range     = 15.0,
        scale          = vector3(0.2, 0.2, 0.2),
        face_camera    = true,
        red            = 141,
        green          = 206,
        blue           = 167,
        on_interact    = function() show_offer(self) end,
        on_enter       = show_prompt,
        on_exit        = function()
            is_prompting = false
        end
    })

    table.insert(renters, self)
end

function Renter:cleanup()
    exports.map:RemoveBlip(self.blip)
    exports.markers:RemoveMarker(self.renter)
end

-- @local
function get_first_open(points)
    local pool = GetGamePool("CVehicle")

    local closest

    for _, p in ipairs(points) do
        closest = nil

        for _, vehicle in ipairs(pool) do
            if Vdist(vector3(p.x, p.y, p.z), GetEntityCoords(vehicle)) < 3.0 then
                closest = vehicle
                break
            end
        end

        if not closest then
            return p
        end
    end

    return nil
end

-- @local
function show_offer(session)
    if IsPedDeadOrDying(PlayerPedId(), 1) then return end

    if GetPlayerWantedLevel(PlayerId()) > 0 then
        TriggerEvent(Events.CREATE_HUD_NOTIFICATION, {
            message = "Unable to rent a vehicle while wanted by police."
        })
        return
    end

    local config = RentLocations[session.name]
    session:cleanup()

    exports.showroom:StartSession({
        action     = "Rent Vehicle",
        categories = config.categories,
        callback   = function(results)
            if not results then
                session:initialize()
                return
            end

            if results.action ~= "Rent Vehicle" then
                Logging.log(Logging.WARN, "Unexpected showroom return result: " .. json.encode(results) .. ".")
                return
            end

            init_vehicle_rent(session.name, results)

            Citizen.Wait(5000)

            session:initialize()
        end
    })
end

-- @local
function init_vehicle_rent(loc_name, options)
    local config = RentLocations[loc_name]
    local spawn  = get_first_open(config.spawns)

    if not spawn then
        TriggerEvent(Events.CREATE_HUD_NOTIFICATION, {
            message = "Unexpected error. Please try again or contact support.",
            flash   = true
        })

        Logging.log(Logging.WARN, "Unable to find spawn location for rental vehicle at " .. loc_name .. ".")

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

    TriggerServerEvent(Events.CREATE_RENTAL_VEHICLE, {
        model    = options.name,
        price    = options.price,
        name     = loc_name,
        location = spawn
    })
end

-- @local
function show_prompt()
    if is_prompting then return end
    is_prompting = true

    Citizen.CreateThread(function()
        while is_prompting do
            DisplayHelpTextThisFrame(PROMPT_KEY, 0)
            Citizen.Wait(0)
        end
    end)
end
