var config = require('../sqlsm.js').config;

module.exports = {
	options: {
		database: ['d', 'Database', 'string']
	},
	dispatch: function(options) {
		if (options.database) {
			config.set({current: options.database});
		}
		else {
			console.log(config.get('current'));
		}
	}
};