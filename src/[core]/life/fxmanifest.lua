---@diagnostic disable: undefined-global

fx_version "cerulean"
games { "gta5" }
lua54 "yes"

author "open_mailbox <dev@open-mailbox.com>"
description "Life, death, and respawn things."
version "0.0.1"

client_scripts {
    "@common/shared/events.lua",
    "@common/shared/logging.lua",
    "client/**/*.lua"
}

server_scripts {
    "@common/shared/events.lua",
    "@common/shared/colors.lua",
    "server/**/*.lua"
}

ui_page "web/index.html"

files {
    "web/**/*.html",
    "web/**/*.css",
    "web/**/*.js",
}
