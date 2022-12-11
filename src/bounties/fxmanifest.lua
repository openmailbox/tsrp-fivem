---@diagnostic disable: undefined-global

fx_version "cerulean"
games { "gta5" }
lua54 "yes"

author "open_mailbox <dev@open-mailbox.com>"
description "Provides a game loop and various activities related to bounty hunting."
version "0.0.1"

dependencies {
    "map",
    "markers",
    "progress"
}

ui_page "web/index.html"

client_scripts {
    "@common/shared/events.lua",
    "shared/**/*.lua",
    "client/**/*.lua"
}

server_scripts {
    "@common/shared/events.lua",
    "shared/**/*.lua",
    "server/**/*.lua"
}

files {
    "web/**/*.html",
    "web/**/*.js",
    "web/**/*.css"
}