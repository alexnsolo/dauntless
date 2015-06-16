module.exports = class Ship
	'name': ''
	'crew_count': 0
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