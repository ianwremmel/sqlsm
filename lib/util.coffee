module.exports = (config) ->
	readOptions: (options) ->
		# TODO

	snapshot: (database, username, password, message) ->
		cd config.get('snapshot_dir') + '/' + database

		cmd = config.get('mysqldump') +
			' --user=' + username +
			' --password=' + password +
			' --skip-dump-date ' +
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

	init: () ->
		if not fs.existsSync config.get('snapshot_dir')
			fs.mkdirSync config.get('snapshot_dir')

			# TODO get mysql and mysqldump interactively if they can't be found
			config.set('mysqldump', 'mysqldump');
			config.set('mysql', 'mysql');