_ = require 'lodash'
cli = require 'cli'
sqlsm = require './sqlsm'
require 'shelljs/global'

module.exports =
	dispatch: ->
		# Make sure we have git
		if not which('git')
			console.log 'You must install git to use sqlsm'
			process.exit 1

		action = process.argv[2]

		if action of sqlsm
			options = cli.parse(sqlsm[action].options, _.keys(sqlsm))
			sqlsm[action].dispatch(options)
		else
			cli.parse({}, _.keys(sqlsm))