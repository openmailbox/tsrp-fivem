---@diagnostic disable: undefined-global

fx_version "cerulean"
games { "gta5" }
lua54 "yes"

author "open_mailbox <dev@open-mailbox.com>"
description "This resource does nothing. It's just a template for getting started."
version "0.0.1"

dependencies {
    -- If you need the database
    --"mysql-async",

    -- if you're using a Vue front-end
    "webpack",
     "yarn"
}

client_scripts {
    "@common/shared/events.lua",
    "shared/**/*.lua",
    "client/**/*.lua"
}

server_scripts {
    --"@mysql-async/lib/MySQL.lua",
    "@common/shared/events.lua",
    "shared/**/*.lua",
    "server/**/*.lua"
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

--  If you uncomment, you cannot require this resource as a dependency for any other
-- resource that has a client-side component.
-- server_only 'yes'
