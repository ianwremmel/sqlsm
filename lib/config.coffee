_ = require 'lodash'
fs = require 'fs'

config = {}

# Helper for determining the user's home directory.
getHome = ->
	if process.platform is 'win32'
		varname = 'USERPROFILE'
	else
		varname = 'HOME'

	process.env[varname]

save = ->
	fs.writeFileSync(config_filename, JSON.stringify(config, null, '\t'));

config_filename = getHome() + '/.sqlsm.rc'

if fs.existsSync(config_filename)
	config_raw = fs.readFileSync(config_filename)
	config = JSON.parse(config_raw)
else
	config.snapshot_dir = getHome() + '/.sqlsm.d'
	save()

module.exports =
	get: (key) ->
		config[key]
	set: (key, value) ->
		config[key] = value
		save()
	list: ->
		_.clone(config, true)
