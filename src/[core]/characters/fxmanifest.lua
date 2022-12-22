---@diagnostic disable: undefined-global

fx_version "cerulean"
games { "gta5" }
lua54 "yes"

author "open_mailbox <dev@open-mailbox.com>"
description "Handles character creation, selection, and management."
version "0.0.1"

client_scripts {
    "@common/shared/events.lua",
    "client/**/*.lua"
}

server_scripts {
    "@common/shared/events.lua",
    "server/**/*.lua"
}

ui_page "web/dist/index.html"

files {
    "web/**/*.html",
    "web/**/*.js",
    "web/**/*.css",
}
