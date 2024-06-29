author '9dgamer'

description 'Utility to edit the handling of vehicles and record speeds'

version '1.0.0'

fx_version 'cerulean'
game 'gta5'

lua54 'yes'

ui_page 'html/index.html'

files {
	'html/index.css',
	'html/index.html',
	'html/index.js',
}

client_scripts {
	'cl_config.lua',
	'cl_debugger.lua',
}

escrow_ignore{
	'html/index.css',
	'html/index.html',
	'html/index.js',
}

server_script 'sv_debugger.lua'

escrow_ignore {
    '**/*.html',
    '**/*.js',
    '**/*.css',
}