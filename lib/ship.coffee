_ = require('lodash')
events = require('pubsub-js')

module.exports = class Ship
	'name': ''
	'signature': ''
	'crew_count:': 0
	'is_destroyed': false
	'shield_strength': {'current': 0, 'base': 0}
	'hull_integrity': {'current': 0, 'base': 0}
	'capacitor_charge': {'current': 0, 'base': 0}
	'target': null

	@generatePlayer: ->
		player_ship = new Ship()
		player_ship['name'] = "Dauntless"
		player_ship['signature'] = 'DT-1000'
		player_ship['crew_count'] = _.random(50, 120)
		player_ship['shield_strength']['base'] = player_ship['shield_strength']['current'] = _.random(50, 70) * 10
		player_ship['hull_integrity']['base'] = player_ship['hull_integrity']['current'] = _.random(10, 15) * 100
		player_ship['capacitor_charge']['base'] = player_ship['capacitor_charge']['current'] = _.random(20, 25) * 100
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
		
		return enemy_ship

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
		events.publish('SHIP_DESTROYED', @)