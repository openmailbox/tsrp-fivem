---@diagnostic disable: undefined-global

fx_version "cerulean"
games { "gta5" }
lua54 "yes"

author "open_mailbox <dev@open-mailbox.com>"
description "Handles the queue and overall player account management in a platform-agnostic way."
version "0.1.0"

dependencies {
    "mysql-async",
}

client_scripts {
    "@common/shared/events.lua",
    "client/**/*.lua"
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "@common/shared/events.lua",
    "@common/shared/logging.lua",
    "server/**/*.lua"
}

server_exports {
    "GetPlayerAccount"
}
