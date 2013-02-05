_ = require 'lodash'
cli = require 'cli'

require 'shelljs/global'

actions = [
	'init'
	'list'
	'use'
	'info'
	'snapshot'
	'restore'
]

module.exports =
	dispatch: ->
		# Make sure we have git
		if not which('git')
			console.log 'You must install git to use sqlsm'
			process.exit 1

		action = process.argv[2]

		if _.contains(actions, action)
			action = require('./actions/' + action)
			options = cli.parse(action.options, actions)
			action.dispatch(options)

			cli.parse({}, actions)