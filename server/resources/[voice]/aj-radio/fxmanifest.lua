fx_version 'cerulean'
game 'gta5'

description 'AJ-Radio'
version '1.2.2'
server_script '@aj-framework-errors/error_sv.lua'
client_script '@aj-framework-errors/error_cl.lua'
shared_script {
  '@aj-base/shared/locale.lua',
  'locales/en.lua',
  'locales/*.lua',
  'config.lua'
}

client_scripts {
  'client.lua',
}

server_script 'server.lua'

ui_page('html/ui.html')

files {
  'html/ui.html',
  'html/js/script.js',
  'html/css/style.css',
  'html/img/radio.png'
}

dependency 'pma-voice'

lua54 'yes'
