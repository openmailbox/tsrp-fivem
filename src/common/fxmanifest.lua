---@diagnostic disable: undefined-global

fx_version "cerulean"
games { "gta5" }
lua54 "yes"

author "open_mailbox <dev@open-mailbox.com>"
description "Provides common global definitions meant to be included in other resources."
version "0.0.2"

shared_scripts {
    "shared/**/*.lua",
}

client_scripts {
    "client/**/*.lua"
}

server_scripts {
    "server/**/*.lua"
}
