_ = require 'lodash'
config = require './config'


sqlsm =
	config: require('./actions/config')(config)
	init: require('./actions/init')(config)
	list: require('./actions/list')(config)
	snapshot: require('./actions/snapshot')(config)
	use: require('./actions/use')(config)

module.exports = sqlsm