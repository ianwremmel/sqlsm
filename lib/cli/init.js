var cli = require('cli');
var fs = require('fs');
var config = require('../sqlsm.js').config;

require('shelljs/global');

module.exports = {
	options: {
		database: ['d', 'Database', 'string'],
		username: ['u', 'Database Username', 'string'],
		password: ['p', 'Database Password', 'string'],
		mysql: [false, 'Path to MySQL binary (defaults to `mysql`)', 'string', 'mysql'],
		mysqldump: [false, 'Path to MySQL Dump binary (defaults to `mysqldump`)', 'string', 'mysqldump']
	},
	dispatch: function(options) {
		if (!options.database) {
			// TODO get database interactively
		}

		if (!options.username) {
			// TODO get username interactively
		}

		if (!options.password) {
			// TODO get password interactively
			// TODO ask if password should be saved
		}

		// Initialize the snapshot archive
		var dir = config.get('snapshot_dir') + '/' + options.database;
		// TODO prevent reinitialization of repository
		if (exec('git init ' + dir).code !== 0) {
		  // TODO handle error
		}

		// Create the first snapshot
		cd(dir);
		var cmd = options.mysqldump + ' --user=' + options.username + ' --password=' + options.password + ' ' + options.database;
		// console.log(cmd);
		// process.exit();
		var dump = exec(cmd, {silent: true});
		if (dump.code !== 0) {
			console.error(dump.output);
		}

		fs.writeFile('snapshot.sql', dump.output);

		exec('git add snapshot.sql');
		exec('git commit -m "initial commit"');

		// Set the current database
		config.set({current: options.database});
		exec('git config sqlsm.username ' + options.username);
		exec('git config sqlsm.password ' + options.password);
	}
};