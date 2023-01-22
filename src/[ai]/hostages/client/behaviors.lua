Behaviors = {}

local registrations = {}

function Behaviors.for_name(name)
    return registrations[name]
end

function Behaviors.register(name, options)
    registrations[name] = Behaviors:new(options)
end
exports("AddBehavior", Behaviors.register)

function Behaviors.unregister(name)
    registrations[name] = nil
end
exports("RemoveBehavior", Behaviors.unregister)
