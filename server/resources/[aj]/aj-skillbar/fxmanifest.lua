fx_version 'cerulean'
game 'gta5'

description 'AJ-Skillbar'
version '1.2.0'
server_script '@aj-framework-errors/error_sv.lua'
client_script '@aj-framework-errors/error_cl.lua'
ui_page 'html/index.html'

client_script 'client/main.lua'

files {
    'html/index.html',
    'html/script.js',
    'html/style.css',
}

dependency 'aj-base'

lua54 'yes'
escrow_ignore {
    '**/*.html',
    '**/*.js',
    '**/*.css',
    '**/*.yml',
    '**/*.md',
}