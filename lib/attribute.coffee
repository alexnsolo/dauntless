module.exports = class Attribute

	constructor: (base, rate) ->
		@['current'] = base ? 0
		@['base'] = base ? 0
		@['rate'] = rate ? 0

	reset: ->
		@['current'] = 0

	isAtMax: ->
		return @['current'] is @['base']

	incrementByRate: ->
		@['current'] += @['rate']
		if @['current'] > @['base']
			@['current'] = @['base']