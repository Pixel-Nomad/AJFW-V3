fx_version 'cerulean'
game 'gta5'

description 'https://github.com/Project-Sloth/aj-hacks'

credits 'https://github.com/sharkiller/nopixel_minigame'
server_script '@aj-framework-errors/error_sv.lua'
client_script '@aj-framework-errors/error_cl.lua'

client_scripts {
  'client/*.lua',
}

ui_page {
  'html/index.html'
}

files {
    'html/js/*.js',
    'html/index.html',
    'html/style.css',
}