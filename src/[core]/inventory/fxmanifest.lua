---@diagnostic disable: undefined-global

fx_version "cerulean"
games { "gta5" }
lua54 "yes"

author "open_mailbox <dev@open-mailbox.com>"
description "UI for accessing item storage."
version "0.0.1"

client_scripts {
    "@common/shared/events.lua",
    "@common/shared/logging.lua",
    "@common/shared/uuid.lua",
    "@common/shared/weapons.lua",
    "shared/**/*.lua",
    "client/**/*.lua"
}

server_scripts {
    "@common/shared/colors.lua",
    "@common/shared/events.lua",
    "@common/shared/logging.lua",
    "@common/shared/uuid.lua",
    "@common/shared/weapons.lua",
    "shared/**/*.lua",
    "server/**/*.lua"
}

ui_page "web/dist/index.html"

files {
    "web/dist/**/*.html",
    "web/dist/**/*.js",
    "web/dist/**/*.css"
}

exports {
    "IsValidItem",
    "RegisterItem"
}

server_exports {
    "GiveItemToPlayer",
    "IsValidItem",
    "RegisterItem",
    "RemoveItemFromPlayer"
}
