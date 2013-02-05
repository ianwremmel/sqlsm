exports = (config) ->

	fs = require 'fs'
	require 'shelljs/global'

	readOptions = (options) ->
		# TODO

	snapshot = (database, username, password, message) ->
		cd config.get('snapshot_dir') + '/' + database

		cmd = config.get('mysqldump') +
			' --user=' + username +
			' --password=' + password +
			'--skip-dump-date ' +
			database

		dump = exec(cmd, {silent: true})
		if dump.code isnt 0
			console.error dump.output
			process.exit 1

		fs.writeFileSync('snapshot.sql', dump.output)

		exec 'git add snapshot.sql'
		# TODO checked exit code
		exec 'git commit -m "' + message + '"'
		# TODO checked exit code

	init = () ->
		if not fs.existsSync config.get('snapshot_dir')
			fs.mkdirSync config.get('snapshot_dir')

			#TODO get mysql and mysqldump interactively
			config.set('mysqldump', 'mysqldump');
			config.set('mysql', 'mysql');

	options:
		database: ['d', 'Database', 'string']
		username: ['u', 'Database Username', 'string']
		password: ['p', 'Database Password', 'string']
		mysql: [false, 'Path to MySQL binary (defaults to `mysql`)', 'string', 'mysql']
		mysqldump: [false, 'Path to MySQL Dump binary (defaults to `mysqldump`)', 'string', 'mysqldump']
	dispatch: (options) ->
		dir = config.get('snapshot_dir') + '/' + options.database
		if fs.existsSync(dir)
			console.error('Attempted to reinitialize an existing snapshot chain.');
			process.exit(2);

		# Initialize the repository
		exec 'git init ' + config.get('snapshot_dir') + '/' + options.database

		snapshot(options.database, options.username, options.password, 'Initial commit')

		# Store options
		cd config.get('snapshot_dir') + '/' + options.database
		exec 'git config sqlsm.username ' + options.username
		exec 'git config sqlsm.password ' + options.password

		# Set the current database
		config.set('current', options.database);