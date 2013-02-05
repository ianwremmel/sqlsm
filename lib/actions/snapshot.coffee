module.exports = (config) ->
	cli = require 'cli'
	fs = require 'fs'
	util = require('../util')(config)

	require 'shelljs/global'

	options:
		name: ['n', 'Snapshot name', 'string']
	dispatch: (options) ->
		if config.current?
			cd config.get('snapshot_dir') + '/' + config.get('database')

			username = exec('git config sqlsm.username').output

			password = exec('git config sqlsm.username')
			if (password.code is 0)
				password = password.output
			else
				# TODO get password interactively
				console.log 'interactive password collection not yet implemented'
				process.exit 3

			util.snapshot(config.current, username, password, Date.toIsoString())

			if options.name?
				exec 'git tag ' + options.name

		else
			console.error 'Please specify a database with `sqlsm use`'

