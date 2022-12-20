 Store = {}

 -- Forward declarations
 local enter_store,
       exit_store,
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

 function Store.cleanup()
    for _, store in ipairs(stores) do
        store:hide()
    end
 end

 function Store.enter(store)
    enter_store(store)
 end

 function Store.get_active()
    return active_store
 end

 function Store.initialize()
    AddTextEntry(HELP_KEY, "Press ~INPUT_CONTEXT~ to customize your appearance.")
 end

 function Store:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
 end

 function Store:hide()
    exports.map:RemoveBlip(self.blip_id)
    exports.markers:RemoveMarker(self.marker_id)
 end

 function Store:show()
    self.blip_id = exports.map:AddBlip(self.location, {
        icon    = self.blip.icon,
        color   = self.blip.color,
        display = 2,
        scale   = BLIP_SCALE,
        label   = self.category
    })

    self.marker_id = exports.markers:AddMarker({
        coords         = self.location,
        alpha          = 0,
        draw_range     = self.radius,
        interact_range = self.radius - 0.5,
        on_enter       = function() enter_store(self) end,
        on_exit        = function() exit_store() end,
        on_interact    = function() use_store() end
    })
 end

-- @local
function enter_store(store)
    active_store = store
    show_prompt  = true

    Citizen.CreateThread(function()
        while show_prompt do
            DisplayHelpTextThisFrame(HELP_KEY, 0)
            Citizen.Wait(0)
        end
    end)
end

-- @local
function exit_store()
    active_store = nil
    show_prompt  = false
end

-- @local
function use_store()
    show_prompt = false

    TriggerEvent(Events.CREATE_WARDROBE_SESSION, {
        filter = "clothing"
    })
end
