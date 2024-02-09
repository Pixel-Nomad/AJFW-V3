fx_version 'cerulean'
game 'gta5'
description 'AJ-VehicleKeys'
version '1.3.0'
ui_page 'NUI/index.html'

files {
    'NUI/index.html',
    'NUI/style.css',
    'NUI/script.js',
    'NUI/images/*',
}

shared_scripts {
    '@aj-base/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua',
    'config.lua',
}

client_script 'client/main.lua'
server_script 'server/main.lua'

lua54 'yes'
