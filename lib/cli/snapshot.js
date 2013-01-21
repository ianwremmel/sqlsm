var cli = require('cli');
var fs = require('fs');
var config = require('../sqlsm.js').config;

require('shelljs/global');

module.exports = {
	options: {
		name: ['n', 'Snapshot name', 'string']
	},
	dispatch: function(options) {
		if (config.database) {
			cd(config.get('snapshot_dir') + '/' + config.get('database'));

			var cmd = config.get('mysqldump') + ' --user=' + config.get('username') + ' --password=' + config.get('password') + ' --skip-dump-date ' + config.database;
			var dump = exec(cmd, {silent: true});
			if (dump.code !== 0) {
				console.error(dump.output());
				prcess.exet(1);
			}

			fs.writeFile('snapshot.sql', dump.output);

			exec('git add snapshot.sql');
			exec('git commit -m "initial commit"');

			if (options.name) {
				exec('git tag ' + options.name);
			}
		}
		else {
			console.log('Please specify a database with sqlsm use');
		}
	}
};

