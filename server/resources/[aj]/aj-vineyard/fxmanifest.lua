fx_version 'cerulean'
game 'gta5'

description 'AJ-Vineyard'
version '1.2.0'
server_script '@aj-framework-errors/error_sv.lua'
client_script '@aj-framework-errors/error_cl.lua'
shared_scripts {
    '@aj-base/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua',
    'config.lua'
}

server_script 'server.lua'

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    'client.lua'
}

dependencies {
    'aj-base',
    'PolyZone'
}

lua54 'yes'
escrow_ignore {
    '**/*.yml',
    '**/*.md',
}