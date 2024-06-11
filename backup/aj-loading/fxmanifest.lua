fx_version 'cerulean'
game 'gta5'

description 'aj-loading'
version '1.2.0'
server_script '@aj-framework-errors/error_sv.lua'
client_script '@aj-framework-errors/error_cl.lua'

files {
  'assets/**',
  'html/*'
}

loadscreen {
  'html/index.html'
}

loadscreen_cursor 'yes'
loadscreen_manual_shutdown 'yes'

lua54 'yes'
