fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
game "gta5"
lua54 'yes'

author "Byte Labs"
version '1.1.6'
description 'Lua Boilerplate'


client_script 'client/init.lua'
server_script 'server/init.lua'
shared_script '@ox_lib/init.lua'


files {
    'data/**',
    'client/**/*',
}


dependencies {
    'ox_lib',
}
