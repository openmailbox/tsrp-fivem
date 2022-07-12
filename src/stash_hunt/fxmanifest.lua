---@diagnostic disable: undefined-global

fx_version "cerulean"
games { "gta5" }
lua54 "yes"

author "open_mailbox <dev@open-mailbox.com>"
description "An opt-in recurring PvPvE event where players compete to find stashes of loot."
version "0.0.1"

dependencies {
    --"mysql-async",
    "interactions"
}

client_scripts {
    "@common/shared/events.lua",
    "shared/**/*.lua",
    "client/**/*.lua"
}

server_scripts {
    --"@mysql-async/lib/MySQL.lua",
    "@common/shared/events.lua",
    "shared/**/*.lua",
    "server/**/*.lua"
}

--ui_page "web/index.html"
--
--files {
--    "web/**/*.html",
--    "web/**/*.js",
--    "web/**/*.css",
--}

-- files {
--}

--exports {
--}

--server_exports {
--}

-- Cannot require this resource as a dependency for any other resource that has a client-side component.
-- server_only 'yes'
