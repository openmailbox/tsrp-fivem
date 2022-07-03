Migrate = {}

local MIGRATIONS_TABLE_NAME = "migrations"

local pending_migrations = {}

-- Maybe not the best place for this global function to live.
-- TODO: Refactor this so it's event-driven. Don't load migrations into memory until the command runs.
function AddMigration(name, func)
    pending_migrations[name] = func
end

function Migrate:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Migrate:execute()
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

    Citizen.Trace("Checking for pending migrations...\n")

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

    Citizen.Trace("Finished applying migrations.\n")
end
