fx_version 'cerulean'
game 'gta5'

description 'AJ-RecycleJob'
version '2.2.0'
server_script '@aj-framework-errors/error_sv.lua'
client_script '@aj-framework-errors/error_cl.lua'
shared_scripts {
  '@aj-base/shared/locale.lua',
  'locales/en.lua',
  'locales/*.lua',
  'config.lua'
}

client_script {
  'client/main.lua',
  '@PolyZone/client.lua',
  '@PolyZone/BoxZone.lua',
  '@PolyZone/CircleZone.lua'
}

server_script 'server/main.lua'

lua54 'yes'
