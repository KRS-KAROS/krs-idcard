fx_version 'cerulean'
game 'gta5'
lua54 'yes'


shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
}

client_script {
	'client.lua',
	'config.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua',
	'config.lua'
}


ui_page 'html/index.html'

files {
	'html/index.html',
	'html/assets/css/*.css',
	'html/assets/js/*.js',
	'html/assets/fonts/roboto/*.woff',
	'html/assets/fonts/roboto/*.woff2',
	'html/assets/fonts/justsignature/JustSignature.woff',
	'html/assets/images/*.png'
}
