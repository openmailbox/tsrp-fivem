---@diagnostic disable: undefined-global

fx_version "cerulean"
games { "gta5" }
lua54 "yes"

author "open_mailbox <dev@open-mailbox.com>"
description "Provides core database utils and API for other resources."
version "0.0.1"

dependencies {
    "mysql-async",
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "server/**/*.lua"
}

-- Cannot require this as a dependency for any resource that has a client-side component.
server_only 'yes'
