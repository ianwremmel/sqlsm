var _ = require('lodash');

var config = {
	snapshot_dir: '~/.sqlsm.d',
	config_file: '~/.sqldm.rc',
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
	}
}