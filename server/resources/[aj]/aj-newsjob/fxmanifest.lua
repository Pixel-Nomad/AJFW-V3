fx_version 'cerulean'
game 'gta5'

description 'AJ-NewsJob'
version '1.3.0'
server_script '@aj-framework-errors/error_sv.lua'
client_script '@aj-framework-errors/error_cl.lua'
shared_scripts {
    'config.lua',
    '@aj-base/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua',
}

client_scripts {
    'client/main.lua',
    'client/camera.lua',
}

server_script 'server/main.lua'

lua54 'yes'
