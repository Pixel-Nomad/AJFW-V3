fx_version 'cerulean'
game 'gta5'
lua54 'yes'
description 'AJ-AdminMenu'
version '1.2.0'

ui_page 'html/index.html'
server_script '@aj-framework-errors/error_sv.lua'
client_script '@aj-framework-errors/error_cl.lua'
shared_scripts {
    '@aj-base/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua'
}

client_scripts {
    '@menuv/menuv.lua',
    'client/noclip.lua',
    'client/entity_view.lua',
    'client/blipsnames.lua',
    'client/client.lua',
    'client/events.lua',
    'entityhashes/entity.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua'
}

files {
    'html/index.html',
    'html/index.js',
    'html/app.js',
}

escrow_ignore {
    '**/*.html',
    '**/*.js',
    '**/*.css',
    '**/*.yml',
    '**/*.md',
}

dependency 'menuv'
