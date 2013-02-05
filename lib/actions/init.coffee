module.exports = (config) ->
	fs = require 'fs'
	util = require '../util'
	require 'shelljs/global'

	options:
		database: ['d', 'Database', 'string']
		username: ['u', 'Database Username', 'string']
		password: ['p', 'Database Password', 'string']
	dispatch: (options) ->
		util.init()

		dir = config.get('snapshot_dir') + '/' + options.database
		if fs.existsSync(dir)
			console.error('Attempted to reinitialize an existing snapshot chain.');
			process.exit(2);

		# Initialize the repository
		exec 'git init ' + config.get('snapshot_dir') + '/' + options.database

		util.snapshot(options.database, options.username, options.password, 'Initial commit')

		# Store options
		cd config.get('snapshot_dir') + '/' + options.database
		exec 'git config sqlsm.username ' + options.username
		exec 'git config sqlsm.password ' + options.password

		# Set the current database
		config.set('current', options.database);