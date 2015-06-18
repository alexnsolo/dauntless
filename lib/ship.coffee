events = require('pubsub-js')

module.exports = class Ship
	'name': ''
	'crew_count': 0
	'is_destroyed': false
	'shield_strength': {'current': 0, 'base': 0}
	'hull_integrity': {'current': 0, 'base': 0}
	'capacitor_charge': {'current': 0, 'base': 0}

	constructor: ->

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