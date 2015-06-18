_ = require('lodash')
events = require('pubsub-js')
Ship = require('./ship')
Location = require('./location')

module.exports = class Game

	state: null
	time: 0
	location: null
	time_in_warp: 0
	player_ship: null
	reports_log: []
	console_log: []

	constructor: ->
		@location = Location.generate()

		@player_ship = Ship.generatePlayer()
		@logToReports("The #{@['player_ship']['name']} is operational.")
		@logToConsole("SYSTEM awaiting commands.")

		events.subscribe('SHIP_DESTROYED', (msg, ship) =>
			if ship is @player_ship
				@logToReports("The #{@['player_ship']['name']} has been destroyed.")
		)

	logToConsole: (message) ->
		@console_log.push(message)

	logToReports: (message) ->
		@reports_log.push(message)

	pushTime: (amount=1) ->
		@time += amount

		if @location['type'] is Location.TYPE['Warp']
			@time_in_warp += amount
			if @time_in_warp > 5
				@time_in_warp = 0
				@location = Location.generate()
				@logToReports("Exited warpspace. Arrived at #{@describeLocation()}.")

	describeTime: ->
		return "#{@time} longs After Empire"

	describeLocation: ->
		if @location['type'] is Location.TYPE['Warp']
			return "#{@location.name}"
		else
			return "#{@location.name} - #{@location.type}"

	processCommand: (command) ->
		if _.isEmpty(_.trim(command))
			@pushTime()
			return

		@logToConsole("-> #{command}")

		switch command
			when 'quit'
				@logToConsole('Suspending SYSTEM...')
				@saveAndQuit()
				return

		if @player_ship['is_destroyed']
			@logToConsole('ERROR.')
			return

		switch command
			when '!takedamage'
				@player_ship.takeDamage(5000)
			when 'warp'
				if @location['type'] is Location.TYPE['Warp']
					@logToConsole('ERROR: Cannot activate warpdrive in warpspace.')
					return
				@logToConsole('Activating warpdrive.')
				@logToReports('Entering warpspace...')
				@location = Location.warp
			else
				@logToConsole('Unrecognized command!')

	saveAndQuit: ->
		# TODO: save
		setTimeout( ->
			process.exit(0)
		, 500)