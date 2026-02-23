fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Xelyos | Bobs&Co'
version '2.0.4'
description 'Game tablet'

ui_page 'nui/index.html'

shared_scripts {
    'config.lua',
    'locales.lua',
    'locales/*.lua'
}

client_scripts {
    -- FIX (pass 2): Removed 'nui/assets/config.js' and 'nui/assets/index.js'.
    -- FiveM client_scripts only executes Lua. Having .js files here causes a
    -- script load error on resource start. These files are already correctly
    -- served to the NUI browser via files{} and loaded by nui/index.html.
    'client.lua'
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

dependency '/assetpacks'