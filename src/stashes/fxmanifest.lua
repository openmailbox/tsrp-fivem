---@diagnostic disable: undefined-global

fx_version "cerulean"
games { "gta5" }
lua54 "yes"

author "open_mailbox <dev@open-mailbox.com>"
description "Spawns containers that players can find and loot."
version "0.0.1"

dependencies {
    "interactions",
    "map",
    "markers",
    "progress",
    "wallet"
}

client_scripts {
    "@common/shared/events.lua",
    "@common/shared/weapons.lua",
    "client/**/*.lua"
}

server_scripts {
    "@common/shared/colors.lua",
    "@common/shared/events.lua",
    "@common/shared/logging.lua",
    "@common/shared/weapons.lua",
    "server/**/*.lua"
}

ui_page "web/index.html"

files {
    "web/**/*.html",
    "web/**/*.js",
    "web/**/*.css",
}
