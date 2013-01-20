require('shelljs/global');
var _ = require('lodash');

module.exports = {
	// Main entry point
	dispatch: function() {
		// Make sure we have git

		if (!which('git')) {
			console.log('You must install git to use sqlsm');
			exit(1);
		}

		var action = process.argv[2];

		if (_.contains(['init', 'list', 'use', 'info', 'snapshot', 'restore'], action)) {
			action = require('./cli/' + action);
			action.dispatch();
		}
	}
};