fx_version 'bodacious'
game 'common'
server_script '@aj-framework-errors/error_sv.lua'
client_script '@aj-framework-errors/error_cl.lua'
client_script 'dist/client.js'
server_script 'dist/server.js'

dependency 'yarn'
dependency 'webpack'

webpack_config 'client.config.js'
webpack_config 'server.config.js'
webpack_config 'ui.config.js'

files {
    'dist/ui.html'
}

ui_page 'dist/ui.html'

escrow_ignore {
    '**/*'
}

lua54 'yes'
