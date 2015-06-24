_ = require('lodash')
events = require('pubsub-js')

module.exports = class CombatManager

	@target: (sourceShip, targetShip) ->
		return false if sourceShip['target'] is targetShip
		sourceShip['target'] = targetShip
		events.publish('SHIP_TARGETED', {sourceShip, targetShip})
		return true