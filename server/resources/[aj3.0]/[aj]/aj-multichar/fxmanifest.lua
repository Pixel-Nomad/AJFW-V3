fx_version 'cerulean'
games { 'gta5' }

author 'a'
version '1.0.2'
server_script '@aj-framework-errors/error_sv.lua'
client_script '@aj-framework-errors/error_cl.lua'
lua54 'yes'

client_script {
    'core.lua',
    'client/main.lua',
}
server_script {
    '@oxmysql/lib/MySQL.lua',
    'core.lua',
    'server/config.lua',
    'server/functions.lua',
    'server/main.lua'
}

ui_page "nui/index.html"
files { 'nui/**/*' }

escrow_ignore {
    'core.lua',
    'server/config.lua',
    'server/functions.lua',
    'client/**',
    'nui/**',
}
dependency '/assetpacks'
escrow_ignore {
    '**/*.html',
    '**/*.js',
    '**/*.css',
}