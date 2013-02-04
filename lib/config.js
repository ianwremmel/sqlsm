var fs = require('fs');

/**
 * Helper for determining the user's home directory.
 */
var getHome = function() {
	return process.env[(process.platform == 'win32') ? 'USERPROFILE' : 'HOME'];
};

var save = function() {
	fs.writeFileSync(config_filename, JSON.stringify(config, null, '\t'));
};

var config = {};

var config_filename = getHome() + '/.sqlsm.rc';

if (fs.existsSync(config_filename)) {
	config_raw = fs.readFileSync(config_filename);
	config = JSON.parse(config_raw);
}
else {
	config.dir = getHome() + '/.sqlsm.d';
	save();
}

module.exports = {
	get: function(key) {
		return config[key];
	},

	set: function(key, value) {
		config[key] = value;
		save();
	}
};