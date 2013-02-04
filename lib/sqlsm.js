var _ = require('lodash');
var config = require('./config');


var sqlsm = {
	init: require('./actions/init.js')(config)
};


module.exports = sqlsm;