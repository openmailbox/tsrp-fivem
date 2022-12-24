---@diagnostic disable: undefined-global

fx_version "cerulean"
games { "gta5" }
lua54 "yes"

author "open_mailbox <dev@open-mailbox.com>"
description "Provides user interface for character customization."
version "0.0.1"

dependencies {
    "map",
    "markers"
}

client_scripts {
    "@common/shared/events.lua",
    "@common/shared/logging.lua",
    "@common/shared/ped_models.lua",
    "client/**/*.lua"
}

server_scripts {
    "@common/shared/events.lua",
    "@common/shared/logging.lua",
    "server/**/*.lua",
}

ui_page "web/dist/index.html"

files {
    "web/dist/**/*.html",
    "web/dist/**/*.js",
    "web/dist/**/*.css",
}

exports {
    "RecordSnapshot",
    "RestoreSnapshot"
}
