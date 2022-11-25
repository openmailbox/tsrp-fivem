---@diagnostic disable: undefined-global

fx_version "cerulean"
games { "gta5" }
lua54 "yes"

author "open_mailbox <dev@open-mailbox.com>"
description "Game loop for stealing / chopping cars."
version "0.0.1"

dependencies {
    "map",
    "markers"
}

ui_page "web/index.html"

client_scripts {
    "@common/shared/events.lua",
    "shared/**/*.lua",
    "client/**/*.lua"
}

files {
    "web/**/*.html",
    "web/**/*.js",
    "web/**/*.css"
}