var config = require('../sqlsm.js').config;

require('shelljs/global');

module.exports = {
	dispatch: function() {
		ls(config.get('snapshot_dir')).forEach(function(file){
			console.log(file);
		});
	}
}