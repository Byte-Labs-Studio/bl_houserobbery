fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
game "gta5"
lua54 'yes'

author "Byte Labs"
version '1.0.0'
description 'Lua Boilerplate'


client_scripts {
    '@bl_bridge/imports/client.lua',
    'client/init.lua'
}
server_scripts {
    '@bl_bridge/imports/server.lua',
    'server/init.lua'
}
shared_script '@ox_lib/init.lua'


files {
    'data/**',
    'client/**/*',
}


dependencies {
    'ox_lib',
}
