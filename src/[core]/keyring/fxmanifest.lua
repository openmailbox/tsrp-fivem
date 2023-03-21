---@diagnostic disable: undefined-global

fx_version "cerulean"
games { "gta5" }
lua54 "yes"

author "open_mailbox <dev@open-mailbox.com>"
description "Generic locking system for vehicles and any other entities."
version "0.0.1"

dependencies {
    "characters"
}

client_scripts {
    "@common/shared/events.lua",
    "@common/shared/logging.lua",
    "client/**/*.lua"
}

server_scripts {
    "@common/shared/events.lua",
    "@common/shared/logging.lua",
    "@common/shared/uuid.lua",
    "server/**/*.lua"
}

server_exports {
    "GiveKey",
    "HasKey",
    "RemoveKey"
}
