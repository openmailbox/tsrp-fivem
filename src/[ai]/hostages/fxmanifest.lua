---@diagnostic disable: undefined-global

fx_version "cerulean"
games { "gta5" }
lua54 "yes"

author "open_mailbox <dev@open-mailbox.com>"
description "Provides ability to take NPCs hostage and order them to do various things."
version "0.0.1"

dependencies {
    "interactions",
    "progress"
}

client_scripts {
    "@common/shared/events.lua",
    "@common/shared/logging.lua",
    "shared/**/*.lua",
    "client/**/*.lua"
}

server_scripts {
    "@common/shared/events.lua",
    "@common/shared/logging.lua",
    "shared/**/*.lua",
    "server/**/*.lua"
}

exports {
    "AddBehavior",
    "RemoveBehavior"
}
