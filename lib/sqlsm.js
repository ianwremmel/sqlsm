var _ = require('lodash');

var getHome = function() {
	return process.env[(process.platform == 'win32') ? 'USERPROFILE' : 'HOME'];
};

var config = {
	snapshot_dir: getHome() + '/.sqlsm.d',
	config_file: getHome() + '/.sqldm.rc',
	current: 'test'
};

module.exports = {
	config: {
		get: function(key) {
			return config[key];
		},
		set: function(conf) {
			_(conf).each(function(value, key) {
				config[key] = value;
			});
		}
	},
	home: getHome
};