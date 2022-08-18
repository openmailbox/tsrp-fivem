---@diagnostic disable: undefined-global

fx_version "cerulean"
games { "gta5" }
lua54 "yes"

author "open_mailbox <dev@open-mailbox.com>"
description "Provides user interface for character customization."
version "0.0.1"

dependencies {
    --"mysql-async",
    "webpack",
     "yarn"
}

client_scripts {
    "@common/shared/events.lua",
    "client/**/*.lua"
}

ui_page "web/dist/index.html"

files {
    "web/dist/**/*.html",
    "web/dist/**/*.js",
}

webpack_config "webpack.config.js"

exports {
}

server_exports {
}