Acting = {}

Hostage.States[HostageStates.ACTING] = Acting

function Acting:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Acting:enter()
    self.hostage.behavior.on_enter(self.hostage.entity)
end

function Acting:exit()
    self.hostage.behavior.on_exit(self.hostage.entity)
end

function Acting:update()
    local result = self.hostage.behavior.on_update(self.hostage.entity)

    if not result then
        self.hostage:move_to(HostageStates.FLEEING)
    end
end
