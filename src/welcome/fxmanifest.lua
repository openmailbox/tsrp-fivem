---@diagnostic disable: undefined-global

fx_version "cerulean"
games { "gta5" }
lua54 "yes"

author "open_mailbox <dev@open-mailbox.com>"
description "Displays a simple welcome message."
version "0.0.1"

client_scripts {
    "@common/shared/events.lua",
    "client/**/*.lua"
}

ui_page "web/index.html"

files {
    "web/**/*.html",
    "web/**/*.js",
    "web/**/*.css",
}
