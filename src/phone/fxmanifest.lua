---@diagnostic disable: undefined-global

fx_version "cerulean"
games { "gta5" }
lua54 "yes"

author "open_mailbox <dev@open-mailbox.com>"
description "Phone stuff."
version "0.0.1"

client_scripts {
    "@common/shared/events.lua",
    "client/**/*.lua"
}

ui_page "web/dist/index.html"

files {
    "web/dist/**/*.html",
    "web/dist/**/*.js",
    "web/dist/**/*.css"
}
