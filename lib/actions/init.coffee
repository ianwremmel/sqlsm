module.exports = (config) ->
	fs = require 'fs'
	util = require('../util')(config)
	require 'shelljs/global'

	options:
		database: ['d', 'Database', 'string']
		username: ['u', 'Database Username', 'string']
		password: ['p', 'Database Password', 'string']
	dispatch: (options) ->
		util.init()

		if not options.database?
			console.error('Please specify a database')
			process.exit(1)

		if not options.username?
			console.error('Please specify a username')
			process.exit(1)

		if not options.password?
			console.error('Please specify a password')
			process.exit(1)

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