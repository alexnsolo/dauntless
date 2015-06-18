_ = require('lodash')
events = require('pubsub-js')
Ship = require('./ship.coffee')

module.exports = class Game

	playerShip: null
	reports_log: []
	console_log: []

	constructor: ->
		@playerShip = new Ship()
		@playerShip['name'] = "Dauntless"
		@playerShip['crew_count'] = _.random(50, 120)
		@playerShip['shield_strength']['base'] = @playerShip['shield_strength']['current'] = _.random(500, 700)
		@playerShip['hull_integrity']['base'] = @playerShip['hull_integrity']['current'] = _.random(1000, 1500)
		@playerShip['capacitor_charge']['base'] = @playerShip['capacitor_charge']['current'] = _.random(20000, 25000)

		@logToReports("The #{@['playerShip']['name']} is operational.")
		@logToConsole("SYSTEM awaiting commands.")

		events.subscribe('SHIP_DESTROYED', (msg, ship) =>
			if ship is @playerShip
				@logToReports("The #{@['playerShip']['name']} has been destroyed.")
		)

	logToConsole: (message) ->
		@console_log.push(message)

	logToReports: (message) ->
		@reports_log.push(message)

	processCommand: (command) ->
		return if _.isEmpty(command)

		@logToConsole("-> #{command}")

		switch command
			when 'quit'
				@logToConsole('Suspending SYSTEM...')
				@saveAndQuit()

		if @playerShip['is_destroyed']
			@logToConsole('ERROR.')
			return

		switch command
			when '!takedamage'
				@playerShip.takeDamage(5000)
			else
				@logToConsole('Unrecognized command!')

	saveAndQuit: ->
		# TODO: save
		setTimeout( ->
			process.exit(0)
		, 500)