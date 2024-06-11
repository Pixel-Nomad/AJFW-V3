----------------------------------
--<!>-- aj | DEVELOPMENT --<!>--
----------------------------------

fx_version 'cerulean'

game 'gta5'


lua54 'yes'

ui_page 'html/index.html'

files {
    'html/**/*',
}
client_scripts {
    'client/config.lua',
    'client/main.lua',
    'client/**/*',
}
server_scripts {
    'server/*'
}
escrow_ignore {
    'client/**/*',
    'server/*'
}