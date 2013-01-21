var cli = require('cli');
var fs = require('fs');
var config = require('../sqlsm.js').config;

require('shelljs/global');

var options = {
	database: ['d', 'Database', 'string'],
	username: ['u', 'Database Username', 'string'],
	password: ['p', 'Database Password', 'string'],
	mysql: [false, 'Path to MySQL binary (defaults to `mysql`)', 'string', 'mysql'],
	mysqldump: [false, 'Path to MySQL Dump binary (defaults to `mysqldump`)', 'string', 'mysqldump']
};

module.exports = {
	dispatch: function() {
		var o = cli.parse(options);

		if (!o.databse) {
			// TODO get database interactively
		}

		if (!o.username) {
			// TODO get username interactively
		}

		if (!o.password) {
			// TODO get password interactively
			// TODO ask if password should be saved
		}

		// Initialize the snapshot archive
		var dir = config.get('snapshot_dir') + '/' + o.database;
		// TODO prevent reinitialization of repository
		if (exec('git init ' + dir).code !== 0) {
		  // TODO handle error
		}

		// Create the first snapshot
		cd(dir);
		var cmd = o.mysqldump + ' --user=' + o.username + ' --password=' + o.password + ' ' + o.database;
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
		config.set({current: o.database});
		exec('git config sqlsm.username ' + o.username);
		exec('git config sqlsm.password ' + o.password);
	}
};