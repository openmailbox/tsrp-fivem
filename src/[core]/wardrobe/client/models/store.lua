 Store = {}

 -- Forward declarations
 local enter_store,
       use_store

 local BLIP_SCALE = vector3(0.8, 0.8, 0.8)
 local HELP_KEY   = "WardrobeStoreHelp"

 local stores = {}

 local active_store = nil
 local show_prompt  = false

 function Store.add(details)
    local store = Store:new(details)
    store:show()
    table.insert(stores, store)
 end

 function Store.enter(store)
    enter_store(store)
 end

 function Store.exit()
    active_store = nil
    show_prompt  = false
 end

 function Store.find_by_name(name)
    for _, store in ipairs(stores) do
        if store.name == name then
            return store
        end
    end

    return nil
 end

 function Store.get_active()
    return active_store
 end

 function Store.setup()
    AddTextEntry(HELP_KEY, "Press ~INPUT_REPLAY_START_STOP_RECORDING~ to customize your appearance.")
 end

 function Store.teardown()
    for _, store in ipairs(stores) do
        store:hide()
    end
 end

 function Store:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
 end

 function Store:hide()
    exports.map:RemoveBlip(self.blip_id)
    exports.zones:RemoveZone(self.name)
 end

 function Store:show()
    self.blip_id = exports.map:AddBlip(self.location, {
        icon    = self.blip.icon,
        color   = self.blip.color,
        display = 2,
        scale   = BLIP_SCALE,
        label   = self.category
    })

    exports.zones:AddZone({
        name   = self.name,
        center = self.location,
        width  = self.radius * 2,
        height = self.radius * 2
    })
 end

-- @local
function enter_store(store)
    active_store = store
    show_prompt  = true

    Citizen.CreateThread(function()
        while show_prompt do
            DisplayHelpTextThisFrame(HELP_KEY, 0)

            if IsControlJustPressed(0, 288) then -- F1
                use_store(active_store)
            end

            Citizen.Wait(0)
        end
    end)
end

-- @local
function use_store(store)
    show_prompt = false

    local filter = nil

    if store.category == "Clothing Store" then
        filter = "clothing"
    elseif store.category == "Barber" then
        filter = "barber"
    end

    TriggerEvent(Events.CREATE_WARDROBE_SESSION, {
        filter = filter
    })
end
