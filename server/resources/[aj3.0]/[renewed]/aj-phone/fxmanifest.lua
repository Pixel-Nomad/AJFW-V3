fx_version 'cerulean'
game 'gta5'

version 'Release'

ui_page 'html/index.html'

shared_scripts {
    '@aj-garages/config.lua',
}

client_scripts {
    'config.lua',
    'client/*.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'config.lua',
    'server/*.lua',
}

files {
    'html/*.html',
    'html/js/*.js',
    'html/img/*.png',
    'html/css/*.css',
    'html/img/backgrounds/*.png',
    'html/img/apps/*.png',
}

lua54 'yes'

dependency 'aj-target'
