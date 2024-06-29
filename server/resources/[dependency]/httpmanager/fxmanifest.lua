
fx_version "cerulean"
game "common"

name "httpmanager"
author "kibukj"
description "HTTP handler library for FiveM and RedM"
repository "https://github.com/kibook/httpmanager"
server_script '@aj-framework-errors/error_sv.lua'
client_script '@aj-framework-errors/error_cl.lua'
server_scripts {
	"url.lua",
	"mime.lua",
	"base64.lua",
	"hash.lua",
	"realms.lua",
	"httphandler.lua",
	"main.lua"
}


lua54 'yes'
