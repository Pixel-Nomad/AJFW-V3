local InventoryNew = true

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

local InventoryScript = InventoryNew and 'server/inventory-v3.1.lua' or 'server/inventory-v2.6.lua'
local InventoryUI = InventoryNew and 'html/js/app-v2.js' or 'html/js/app.js'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    InventoryScript,
}
client_script 'client/main.lua'

ui_page {
    'html/ui.html'
}

files {
    'html/ui.html',
    'html/css/main.css',
    InventoryUI,
    -- 'html/images/*.png',
    -- 'html/images/*.jpg',
    -- 'html/ammo_images/*.png',
    -- 'html/attachment_images/*.png',
    'html/*.ttf'
}
dependecy 'aj-weapons'

lua54 'yes'
