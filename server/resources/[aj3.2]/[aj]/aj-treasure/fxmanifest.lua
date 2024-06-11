fx_version 'cerulean'
game {'gta5'}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    'client/*'
}
server_script 'server.lua'

shared_script 'config.lua'

file 'gen_w_am_metaldetector.ytyp'

lua54 'yes'