---@diagnostic disable: undefined-global

fx_version "cerulean"
games { "gta5" }
lua54 "yes"

author "open_mailbox <dev@open-mailbox.com>"
description "Provides the UI for the vehicle model browser."
version "0.0.1"

client_scripts {
    "@common/shared/events.lua",
    "@common/shared/logging.lua",
    "@common/client/scaleform.lua",
    "client/**/*.lua"
}

server_scripts {
    "@common/shared/events.lua",
    "@common/shared/logging.lua",
    "server/**/*.lua"
}

ui_page "web/dist/index.html"

files {
    "web/dist/**/*.html",
    "web/dist/**/*.js",
    "web/dist/**/*.css"
}

exports {
    "StartSession"
}
