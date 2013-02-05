module.exports = (config) ->
	options:
		database: ['d', 'Database', 'string']
	dispatch: (options) ->
		if options.database?
			config.set
				current: options.database
		else
			console.log config.get('current')