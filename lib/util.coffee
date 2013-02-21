module.exports = (config) ->
	fs = require 'fs'

	readOptions: (options) ->
		# TODO

	snapshot: (database, username, password, message) ->
		cd config.get('snapshot_dir') + '/' + database

		# We always need to be on a branch to commit
		exec 'git checkout master', silent: true

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

	# makes sure the settings file and the snapshot directory exists
	init: () ->
		if not fs.existsSync config.get('snapshot_dir')
			fs.mkdirSync config.get('snapshot_dir')

			# TODO get mysql and mysqldump interactively if they can't be found
			config.set('mysqldump', 'mysqldump');
			config.set('mysql', 'mysql');