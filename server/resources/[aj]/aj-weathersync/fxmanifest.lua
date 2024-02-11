fx_version 'cerulean'
game 'gta5'

description 'vSyncRevamped'
version '2.1.0'
server_script '@aj-framework-errors/error_sv.lua'
client_script '@aj-framework-errors/error_cl.lua'
shared_scripts {
    'config.lua',
    '@aj-base/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua'
}

server_script 'server/server.lua'
client_script 'client/client.lua'

lua54 'yes'
