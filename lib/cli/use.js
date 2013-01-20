var cli = require('cli');
var config = require('../sqlsm.js').config;

var options = {
	database: ['d', 'Database', 'string']
};

module.exports = {
	dispatch: function() {
		var o = cli.parse(options);
		if (o.database) {
			config.set({current: o.database});
		}
		else {
			console.log(config.get('current'));
		}
	}
};