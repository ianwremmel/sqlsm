module.exports = (config) ->
	cli = require 'cli'
	fs = require 'fs'
	util = require('../util')(config)

	require 'shelljs/global'

	options:
		name: ['n', 'Snapshot name', 'string']
		database: ['d', 'Database', 'string']
	dispatch: (options) ->
		if options.database?
			cd config.get('snapshot_dir') + '/' + options.database

			username = exec('git config sqlsm.username', silent: true).output.trim()

			password = exec('git config sqlsm.password', silent: true)
			if (password.code is 0)
				password = password.output.trim()
			else
				# TODO get password interactively
				console.log 'interactive password collection not yet implemented'
				process.exit 3

			util.snapshot(options.database, username, password, new Date().toISOString())

			if options.name?
				exec 'git tag ' + options.name

		else
			console.error 'Please specify a database with `sqlsm use`'

