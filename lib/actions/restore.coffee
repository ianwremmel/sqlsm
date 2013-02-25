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

			# Delete the database
			cmd = config.get('mysqladmin') +
				' --user=' + username +
				' --password=' + password +
				' drop ' + options.database + ' -f'
			if exec(cmd, {silent: true}).code is not 0
				console.error 'Could not drop database'
				process.exit 3

			# Create the database
			cmd = config.get('mysqladmin') +
				' --user=' + username +
				' --password=' + password +
				' create ' + options.database
			if exec(cmd, {silent: true}).code is not 0
				console.error 'Could not create database'
				process.exit 4

			# Checkout latest (or specified) commit
			cd config.get('snapshot_dir') + '/' + options.database
			if options.name?
				exec 'git checkout ' + options.name, silent: true
			else
				exec 'git checkout master', silent: true

			# Restore the database
			cmd = config.get('mysql') +
				' --user=' + username +
				' --password=' + password +
				' ' + options.database +
				' < snapshot.sql'
			if exec(cmd).code is not 0
				console.error 'Could not restore database'
				process.exit 5

		else
			console.error 'Please specify a database'
