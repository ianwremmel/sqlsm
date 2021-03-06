_ = require 'lodash'
config = require './config'


sqlsm =
	config: require('./actions/config')(config)
	init: require('./actions/init')(config)
	list: require('./actions/list')(config)
	restore: require('./actions/restore')(config)
	snapshot: require('./actions/snapshot')(config)

module.exports = sqlsm