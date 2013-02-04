var cli = require('cli');
var fs = require('fs');
var config = require('../sqlsm.js').config;
var child_process = require('child_process');

require('shelljs/global');

module.exports = {
	options: {
		name: ['n', 'Snapshot name', 'string']
	},
	dispatch: function(options) {
		cd(config.get('snapshot_dir') + '/' + config.get('database'));

		if (options.name) {
			if (exec('git checkout ' + options.name).code !== 0) {
				console.error('No tag or branch named ' + options.name);
				exit(3);
			}
		}

		var cmd = config.get('mysql') + ' --user=' + config.get('username') + ' --password=' + config.get('password') + ' ' + config.get('database') + ' < snapshot.sql';
		child_process.exec(cmd, function(error, stdout, stderr) {
			if (error !== null) {
				console.error('error');
				exit(4);
			}
		});
	}
};