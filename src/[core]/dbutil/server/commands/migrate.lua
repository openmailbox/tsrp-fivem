Migrate = {}

local COLOR_RED             = { 255, 0, 0 }
local MIGRATIONS_TABLE_NAME = "migrations"

-- Forward declarations
local fail,
      run_migrations,
      validate

local pending_migrations = {}

-- Maybe not the best place for this global function to live.
-- TODO: Refactor this so it's event-driven. Don't load migrations into memory until the command runs.
function AddMigration(name, func)
    pending_migrations[name] = func
end

function Migrate.initialize(source, args, raw_command)
    local command = Migrate:new({
        source      = source,
        args        = args,
        raw_command = raw_command
    })

    command:execute()
end
RegisterCommand("dbutil setup", Migrate.initialize, true)

function Migrate:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Migrate:execute()
    local succ, msg = validate(self)

    if not succ then
        fail(self.source, msg)
        return
    end

    run_migrations()
end

-- @local
function fail(source, message)
    Citizen.Trace(message .. "\n")

    if source and source > 0 then
        TriggerClientEvent(Events.ADD_CHAT_MESSAGE, source, {
            color     = COLOR_RED,
            multiline = true,
            args      = { GetCurrentResourceName(), message }
        })
    end
end

-- @local
function run_migrations()
    local sorted_keys = {}

    for name, _ in pairs(pending_migrations) do
        table.insert(sorted_keys, name)
    end

    table.sort(sorted_keys)

    local tables   = MySQL.Sync.fetchAll("SHOW TABLES LIKE '" .. MIGRATIONS_TABLE_NAME .. "';")
    local existing = {}

    if #tables > 0 then
        existing = MySQL.Sync.fetchAll("SELECT * FROM migrations")
    end

    for _, key in pairs(sorted_keys) do
        local exists = false

        for _, row in ipairs(existing) do
            if row.name == key then
                exists = true
                break
            end
        end

        if not exists then
            Citizen.Trace("Applying new migration: " .. key .. "\n")

            pending_migrations[key]()

            MySQL.Sync.execute("INSERT INTO migrations (name) VALUES (@name)", { ["@name"] = key })
        end
    end
end

-- @local
function validate(command)
    if command.source and command.source > 0 then
        return false, "This command may only be executed from the console."
    end

    return true
end
