fs = require 'fs'


# Helper for determining the user's home directory.
getHome = ->
	process.env[(process.platform == 'win32') ? 'USERPROFILE' : 'HOME']

save = ->
	fs.writeFileSync(config_filename, JSON.stringify(config, null, '\t'));

config_filename = getHome() + '/.sqlsm.rc'

if fs.existsSync(config_filename)
	config_raw = fs.readFileSync(config_filename)
	config = JSON.parse(config_raw)
else
	config.dir = getHome() + '/.sqlsm.d'
	save()

module.exports =
	get: (key) ->
		config[key]
	set: (key, value) ->
		config[key] = value
		save()
