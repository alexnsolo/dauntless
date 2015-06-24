_ = require('lodash')
events = require('pubsub-js')
CombatManager = require('./combat-manager')

module.exports = class EnemyAI

	'ship': null

	constructor: () ->
		events.subscribe 'GAME_TIME', (msg, {game}) =>
			player = game['player_ship']

			# 1. Acquire target
			unless @['ship']['target']?
				@['ship'].setTarget(player)
				return