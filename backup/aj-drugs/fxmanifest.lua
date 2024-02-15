fx_version 'cerulean'
game 'gta5'

description 'AJ-Drugs'
version '1.3'
server_script '@aj-framework-errors/error_sv.lua'
client_script '@aj-framework-errors/error_cl.lua'
shared_scripts{
    'config.lua',
    '@aj-base/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua'
}

client_scripts{
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/ComboZone.lua',
    'client/deliveries.lua',
    'client/cornerselling.lua'
}

server_scripts{
    '@oxmysql/lib/MySQL.lua',
    'server/deliveries.lua',
    'server/cornerselling.lua'
}

lua54 'yes'
