var _ = require('lodash');
var cli = require('cli');

require('shelljs/global');


var actions = [
	'init',
	'list',
	'use',
	'info',
	'snapshot',
	'restore'
];

module.exports = {
	// Main entry point
	dispatch: function() {
		// Make sure we have git

		if (!which('git')) {
			console.log('You must install git to use sqlsm');
			exit(1);
		}

		var action = process.argv[2];

		if (_.contains(actions, action)) {
			action = require('./cli/' + action);
			var options = cli.parse(action.options, actions);
			action.dispatch(options);
		}
		else {
			cli.parse({}, actions);
		}
	}
};