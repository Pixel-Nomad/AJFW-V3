fx_version 'cerulean'
game 'gta5'

description 'AJ-VehicleFailure'
version '1.2.2'

shared_scripts {
    '@aj-base/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua',
    'config.lua'
}

client_script 'client.lua'
server_script 'server.lua'

lua54 'yes'
