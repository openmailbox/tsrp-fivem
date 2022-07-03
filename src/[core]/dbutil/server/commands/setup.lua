Setup = {}

-- Forward declarations
local validate

function Setup.initialize(source, args, raw_command)
    local command = Setup:new({
        source      = source,
        args        = args,
        raw_command = raw_command
    })

    command:execute()
end
RegisterCommand("dbutil setup", Setup.initialize, true)

function Setup:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Setup:execute()
    local succ, msg = validate(self)

    if not succ then
        -- Send msg to enactor
        return
    end
end

-- @local
function validate(command)
    if command.source and command.source > 0 then
        return false, "This command may only be executed from the console."
    end

    return true
end