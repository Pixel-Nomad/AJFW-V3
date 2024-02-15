fx_version 'cerulean'
games { 'gta5' }

version '1.0.3'

shared_scripts {
     '@aj-base/shared/locale.lua',
     'locale/en.lua',
     'config.lua',
     'shared/shared.lua'
}

client_scripts {
     -- '@PolyZone/client.lua',
     -- '@PolyZone/BoxZone.lua',
     'client/client_main.lua',
     'client/menu/menu.lua',
}

server_script {
     '@oxmysql/lib/MySQL.lua',
     'server/server_main.lua',
}

-- dependency 'oxmysql'

lua54 'yes'
