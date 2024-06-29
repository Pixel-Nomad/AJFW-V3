fx_version 'cerulean'
game 'gta5'

description 'AJ-HotdogJob'
version '1.2.2'
server_script '@aj-framework-errors/error_sv.lua'
client_script '@aj-framework-errors/error_cl.lua'
ui_page 'html/ui.html'

shared_scripts {
    '@aj-base/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua',
    'config.lua'
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    'client/main.lua'
}

server_script 'server/main.lua'

files {
    'html/ui.html',
    'html/ui.css',
    'html/ui.js',
    'html/icon.png',
}

lua54 'yes'
escrow_ignore {
    '**/*.html',
    '**/*.js',
    '**/*.css',
    '**/*.png',
    '**/*.yml',
    '**/*.md',
}