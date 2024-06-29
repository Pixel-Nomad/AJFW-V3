fx_version 'cerulean'
game 'gta5'

description 'AJ-FitBit'
version '1.2.0'
server_script '@aj-framework-errors/error_sv.lua'
client_script '@aj-framework-errors/error_cl.lua'
ui_page 'html/index.html'

shared_scripts {
    '@aj-base/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua'
}

server_script 'server/main.lua'
client_script 'client/main.lua'

files {
    'html/*'
}

lua54'yes'
escrow_ignore {
    '**/*.html',
    '**/*.js',
    '**/*.css',
    '**/*.png',
    '**/*.yml',
    '**/*.md',
}