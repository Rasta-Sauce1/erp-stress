---= erp-framework =---
fx_version 'bodacious'
game 'gta5'

author 'Rasta'
description 'Add stress for shooting, and driving'
version '1.0.1'

shared_script 'config.lua'

client_script 'client/main.lua'

server_script 'server/main.lua'

dependencies {
    'es_extended',
    'esx_status'
}

