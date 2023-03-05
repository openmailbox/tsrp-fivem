---@diagnostic disable: undefined-global

fx_version "cerulean"
games { "gta5" }
lua54 "yes"

author "open_mailbox <dev@open-mailbox.com>"
description "Handles character creation, selection, and management."
version "0.1.0"

dependencies {
    "accounts",
    "markers",
    "mysql-async",
    "wardrobe"
}

client_scripts {
    "@common/shared/events.lua",
    "@common/shared/logging.lua",
    "client/**/*.lua"
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "@common/shared/events.lua",
    "@common/shared/logging.lua",
    "server/**/*.lua"
}

ui_page "web/index.html"

files {
    "web/**/*.html",
    "web/**/*.js",
    "web/**/*.css",
}

server_exports {
    "GetPlayerCharacter"
}
