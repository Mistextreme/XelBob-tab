fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Xelyos | Bobs&Co'
version '2.0.4'
description 'Game tablet'

ui_page 'nui/index.html'

shared_scripts{
    'config.lua',
    'locales.lua',
    'locales/*.lua'
}

client_scripts {
    'client.lua',
    'nui/assets/config.js',
    'nui/assets/index.js'
}

server_scripts {
    'server.lua'
}

files {
    'nui/index.html',
    'nui/assets/config.js',
    'nui/assets/index.js',
    'nui/assets/style.css',
    'nui/assets/color.css',
    'nui/img/*'
}

escrow_ignore {
    'config.lua',
    'locales/*.lua',
    'nui/assets/config.js',
    'nui/assets/color.css',
    'nui/img/*',
    'nui/index.html'
}

-- FIX #6: Removed duplicate 'dependency /assetpacks' entry
dependency '/assetpacks'
