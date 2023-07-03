Route = {}

local active_route = nil

function Route.setup(depot)
    local route = Route:new(depot)
    route:initialize()

    active_route = route
end

function Route.teardown()
    if not active_route then return end

    active_route:cleanup()

    active_route = nil
end

function Route:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Route:cleanup()
    -- destroy truck
    -- clear dropoff markers
end

function Route:initialize()
    -- spawn truck
    -- mark dropoffs
    -- show instructions
end
