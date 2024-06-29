-- FXVersion Version
fx_version 'adamant'
games { 'gta5' }
server_script '@aj-framework-errors/error_sv.lua'
client_script '@aj-framework-errors/error_cl.lua'
-- Client Scripts
client_script 'client/main.lua'

-- Server Scripts
server_script 'server/main.lua'

-- NUI Default Page
ui_page "client/html/index.html"

-- Files needed for NUI
-- DON'T FORGET TO ADD THE SOUND FILES TO THIS!
files {
    'client/html/index.html',
    -- Begin Sound Files Here...
    -- client/html/sounds/ ... .ogg
    'client/html/sounds/*.ogg'
}
lua54 'yes'
