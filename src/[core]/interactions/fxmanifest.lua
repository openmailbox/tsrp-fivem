---@diagnostic disable: undefined-global

fx_version "cerulean"
games { "gta5" }
lua54 "yes"

author "open_mailbox <dev@open-mailbox.com>"
description "Provides automatic crosshair and prompt to interact with raycast targets."
version "0.0.1"

client_scripts {
    "@common/shared/events.lua",
    "@common/shared/logging.lua",
    "client/**/*.lua"
}

server_scripts {
    "@common/shared/events.lua",
    "@common/shared/logging.lua",
    "server/**/*.lua"
}

files {
    "web/**/*.html",
    "web/**/*.js",
    "web/**/*.css",
    "web/**/*.png",
}

ui_page "web/index.html"

exports {
    "AddExclusion",
    "IsExcluded",
    "RegisterInteraction",
    "RemoveExclusion",
    "SetTargetDetails",
    "UnregisterInteraction"
}
