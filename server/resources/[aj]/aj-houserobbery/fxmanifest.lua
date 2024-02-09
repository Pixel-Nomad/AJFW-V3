fx_version 'cerulean'
game 'gta5'

description 'AJ-HouseRobbery'
version '1.2.0'

shared_scripts {
    'config.lua',
    '@aj-base/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua'
}

client_script 'client/main.lua'
server_script 'server/main.lua'

dependencies {
    'aj-lockpick',
    'aj-skillbar'
}

lua54 'yes'
