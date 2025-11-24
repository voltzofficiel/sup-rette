fx_version 'cerulean'

lua54 'yes'

game 'gta5'

name 'sup-rette'
description 'Supérette moderne avec interface NUI et intégration ox_target pour ESX'
author 'AutoGPT'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/assets/*.svg',
    'html/assets/*.png'
}
