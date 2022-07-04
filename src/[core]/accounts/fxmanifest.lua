---@diagnostic disable: undefined-global

fx_version "cerulean"
games { "gta5" }
lua54 "yes"

author "open_mailbox <dev@open-mailbox.com>"
description "Handles player account management in a platform-agnostic way."
version "0.0.1"

dependencies {
    "mysql-async",
}

client_scripts {
    "shared/**/*.lua",
    "client/**/*.lua"
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "shared/**/*.lua",
    "server/**/*.lua"
}

server_exports {
    "GetPlayerAccount"
}
