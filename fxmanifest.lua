fx_version 'adamant'
game 'gta5'

author 'Crystal2K'
description 'interaction NUI by Crystal2K'
version "1.0.0"

client_scripts {'client/*.lua'}
shared_scripts {'config.lua', 'utility.lua'}
server_scripts {'server/*.lua'}

ui_page('ui/main.html')

files {
    'ui/main.html',
    'ui/css/main.css',
    'ui/js/main.js',
}
