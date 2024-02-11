fx_version 'cerulean'
game 'gta5'

description 'AJ-Weapons'
version '1.2.1'
server_script '@aj-framework-errors/error_sv.lua'
client_script '@aj-framework-errors/error_cl.lua'
shared_scripts {
    '@aj-base/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua',
    'config.lua',
}

server_script 'server/main.lua'
client_script 'client/main.lua'

files {
    'weaponsnspistol.meta'
}

data_file 'WEAPONINFO_FILE_PATCH' 'weaponsnspistol.meta'

lua54 'yes'
