fx_version 'bodacious'
game 'gta5'

description 'Safecracker Minigame'
version '1.0.0'
server_script '@aj-framework-errors/error_sv.lua'
client_script '@aj-framework-errors/error_cl.lua'
client_scripts {
  'config.lua',
  'client.lua'
}

files { 
  'LockPart1.png',
  'LockPart2.png',
}

lua54 'yes'