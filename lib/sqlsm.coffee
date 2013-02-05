_ = require 'lodash'
config = require './config'


sqlsm =
	init: require('./actions/init')(config)


module.exports = sqlsm