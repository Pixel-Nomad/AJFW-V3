games {'gta5'}

fx_version 'cerulean'

description 'Define zones of different shapes and test whether a point is inside or outside of the zone'
version '2.6.0'
server_script '@aj-framework-errors/error_sv.lua'
client_script '@aj-framework-errors/error_cl.lua'
client_scripts {
  'client.lua',
  'BoxZone.lua',
  'EntityZone.lua',
  'CircleZone.lua',
  'ComboZone.lua',
  'creation/client/*.lua'
}

server_scripts {
  'creation/server/*.lua',
  'server.lua'
}
