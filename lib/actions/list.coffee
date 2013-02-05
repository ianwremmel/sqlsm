module.exports = (config) ->
	require 'shelljs/global'

	dispatch: ->
		console.log file for file in ls config.get('snapshot_dir')