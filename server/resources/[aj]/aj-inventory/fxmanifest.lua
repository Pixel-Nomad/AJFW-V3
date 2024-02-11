fx_version 'cerulean'
game 'gta5'

description 'aj-Inventory'
version '1.2.0'
server_script '@aj-framework-errors/error_sv.lua'
client_script '@aj-framework-errors/error_cl.lua'
shared_scripts {
    '@aj-base/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua',
    'config.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
}
client_script 'client/main.lua'

ui_page {
    'html/ui.html'
}

files {
    'html/ui.html',
    'html/css/main.css',
    'html/js/app.js',
    -- 'html/images/*.png',
    -- 'html/images/*.jpg',
    -- 'html/ammo_images/*.png',
    -- 'html/attachment_images/*.png',
    'html/*.ttf'
}
dependecy 'aj-weapons'

lua54 'yes'
