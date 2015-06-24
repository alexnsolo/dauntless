_ = require('lodash')
events = require('pubsub-js')
EnemyAI = require('./enemy-ai')
Attribute = require('./attribute')
Utils = require('./utils')

module.exports = class Ship
	'name': ''
	'signature': ''
	'is_destroyed': false

	'target': null
	'target_acquired': false

	'crew_count:': null
	'shield_strength': null
	'hull_integrity': null
	'capacitor_charge': null
	'sensor_calibration': null

	@generatePlayer: ->
		player_ship = new Ship()
		player_ship['name'] = "Dauntless"
		player_ship['signature'] = 'DT-1000'
		player_ship['crew_count'] = _.random(50, 120)
		player_ship['shield_strength']['base'] = player_ship['shield_strength']['current'] = _.random(50, 70) * 10
		player_ship['hull_integrity']['base'] = player_ship['hull_integrity']['current'] = _.random(10, 15) * 100
		player_ship['capacitor_charge']['base'] = player_ship['capacitor_charge']['current'] = _.random(20, 25) * 100
		player_ship['sensor_calibration']['base'] = _.random(5, 7) * 10
		player_ship['sensor_calibration']['rate'] = _.random(9, 15)
		
		return player_ship

	@generateEnemy: ->
		name = ''
		name += _.sample(['Corellian', 'Federation', 'Asgarrd', 'Gordon'])
		name += ' '
		name += _.sample(['Frigate', 'Cruiser', 'Barge'])

		signature = ''
		signature += _.sample(['H', 'I', 'J', 'K'])
		signature += _.sample(['A', 'B', 'C', 'D'])
		signature += '-'
		signature += _.random(1000, 9999)

		enemy_ship = new Ship()
		enemy_ship['name'] = name
		enemy_ship['signature'] = signature
		enemy_ship['crew_count'] = _.random(15, 30)
		enemy_ship['shield_strength']['base'] = enemy_ship['shield_strength']['current'] = _.random(20, 30) * 10
		enemy_ship['hull_integrity']['base'] = enemy_ship['hull_integrity']['current'] = _.random(5, 9) * 100
		enemy_ship['capacitor_charge']['base'] = enemy_ship['capacitor_charge']['current'] = _.random(10, 13) * 100
		enemy_ship['sensor_calibration']['base'] = _.random(5, 7) * 10
		enemy_ship['sensor_calibration']['rate'] = _.random(9, 15)

		enemy_ai = new EnemyAI()
		enemy_ai['ship'] = enemy_ship

		return enemy_ship

	constructor: ->
		@['shield_strength'] = new Attribute()
		@['hull_integrity'] = new Attribute()
		@['capacitor_charge'] = new Attribute()
		@['sensor_calibration'] = new Attribute()

		events.subscribe 'GAME_TIME', (msg, {game}) =>
			# Targeting and sensor calibration
			if @['target']?
				if @['target_acquired'] is false
					@['sensor_calibration'].incrementByRate()
					if @['sensor_calibration'].isAtMax()
						@['target_acquired'] = true
						source = @
						target = @['target']
						events.publish('TARGET_SUCCESS', {source, target})
			else
				game.logToConsole("#{@name} reset sensors")
				@['sensor_calibration']['current'] = 0

	describeShieldStrength: ->
		current = @['shield_strength']['current']
		base = @['shield_strength']['base']
		return "#{current} / #{base} DP"

	describeHullIntegrity: ->
		current = @['hull_integrity']['current']
		base = @['hull_integrity']['base']
		return "#{current} / #{base} AC"

	describeCapacitorCharge: ->
		current = @['capacitor_charge']['current']
		base = @['capacitor_charge']['base']
		return "#{current} / #{base} VL"

	describeSensorCalibration: ->
		current = @['sensor_calibration']['current']
		base = @['sensor_calibration']['base']
		return "#{current} / #{base} OMS"

	setTarget: (enemy) ->
		return {outcome: 'failure', message: 'Already targeting ship.'} if @['target'] is enemy
		
		@['target'] = enemy
		@['target_acquired'] = false
		@['sensor_calibration']['current'] = 0

		return {outcome: 'success'}

	takeDamage: (amount) ->
		return if @['is_destroyed']
		
		if @['shield_strength']['current'] > 0
			if @['shield_strength']['current'] >= amount
				@['shield_strength']['current'] -= amount
				amount = 0
			else
				amount -= @['shield_strength']['current']
				@['shield_strength']['current'] = 0

		return if amount <= 0

		if @['hull_integrity']['current'] >= amount
			@['hull_integrity']['current'] -= amount
		else
			@['hull_integrity']['current'] = 0
			@destroy()


	destroy: ->
		@['is_destroyed'] = true
		events.publish('SHIP_DESTROYED', {ship: @})