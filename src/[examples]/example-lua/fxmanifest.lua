fx_version "cerulean"
games { "gta5" }
lua54 "yes"

author "open_mailbox <dev@open-mailbox.com>"
description "This resource does nothing. It's just a template for getting started."
version "0.0.1"

dependencies {
    --"mysql-async",
}

client_scripts {
    "shared/**/*.lua",
    "client/**/*.lua"
}

server_scripts {
    --"@mysql-async/lib/MySQL.lua",
    "shared/**/*.lua",
    "server/**/*.lua"
}

--ui_page "web/index.html"
--
--files {
--    "web/**/*.html",
--    "web/**/*.js",
--    "web/**/*.css",
--}

-- files {
--}

--exports {
--}

--server_exports {
--}

-- server_only 'yes'
