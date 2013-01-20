require('shelljs/global');

// var cli = require('cli');

// var options = {
// 	database: ['d', 'Database', 'string'],
// 	username: ['u', 'Database Username', 'string'],
// 	password: ['p', 'Database Password', 'string'],
// 	mysql: [false, 'Path to MySQL binary (defaults to `mysql`)', 'string', 'mysql'],
// 	mysqldump: [false, 'Path to MySQL Dump binary (defaults to `mysqldump`)', 'string', 'mysqldump']
// };

// var commands = {
// 	init: 'Begin tracking a database',
// 	list: 'List all the known snapshots',
// 	restore: 'Restore a snapshot',
// 	snapshot: 'Take a snapshot',
// 	use: 'Specify the current database'
// };

module.exports = {
	// Main entry point
	dispatch: function() {
		// Make sure we have git

		if (!which('git')) {
			console.log('You must install git to use sqlsm');
			exit(1);
		}


		var action = require('./cli/' + process.argv[2]);
		action.dispatch();
	}
};