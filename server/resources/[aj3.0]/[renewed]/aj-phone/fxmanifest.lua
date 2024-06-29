fx_version 'cerulean'
game 'gta5'

version '2.0.0'

dependencies {
    'ox_lib',
}

ui_page 'html/index.html'

shared_scripts {
    'config.lua',
    'shared/shared.lua',
    '@aj-garages/config.lua',
    '@ox_lib/init.lua'
}

client_scripts {
    'client/*.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
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
