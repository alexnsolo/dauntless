# *&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&
# DAUNTLESS
# Copyright Alex Solo 2015
# *&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&

# ==================================================================
# = Setup Screen
# ==================================================================

require('coffee-script')
_ = require('lodash')
blessed = require('blessed')
contrib = require('blessed-contrib')

screen = blessed.screen()
grid = new contrib.grid({rows: 24, cols: 24, screen: screen})

updates = []

# 30 FPS
setInterval( ->
	updates.forEach (callback) -> callback.apply()
	screen.render()
, 33)

screen.key ['C-c'], (ch, key) -> process.exit(0)

# ==================================================================
# = Setup Game
# ==================================================================

Game = require('./lib/game')

game = new Game()

# == Header =========================================
time = grid.set(0, 0, 2, 8, blessed.text, {
	label: 'Time'
	padding: {left: 1}
})

location = grid.set(0, 8, 2, 8, blessed.text, {
	label: 'Location'
	padding: {left: 1}
})

updates.push ->
	time.content = game.describeTime()
	location.content = game.describeLocation()

# == Ship Info ====================================
ship_info = grid.set(0, 16, 8, 8, contrib.table, { 
	label: 'Ship Info'
	columnSpacing: 1
	columnWidth: [15, 18]
})

updates.push ->
	ship_info.setData(
		headers: ['Attribute', 'Value']
		data: [
			['',''] #wtf
			['Name', game['player_ship']['name']]
			['Crew Count', game['player_ship']['crew_count']]
			['Shield', game['player_ship'].describeShieldStrength()]
			['Hull', game['player_ship'].describeHullIntegrity()]
			['Capacitor', game['player_ship'].describeCapacitorCharge()]
		]
	)


# == Sensors ====================================
sensors = grid.set(8, 16, 16, 8, contrib.table, { 
	label: 'Sensors'
	columnSpacing: 1
	columnWidth: [13, 30]
})

updates.push ->
	data = []
	data.push(['','']) #wtf
	game['location']['ships'].forEach (ship) ->
		data.push([ship['signature'], ship['name']])

	sensors.setData(
		headers: ['Signature', 'Name']
		data: data
	)

# == Reports Log ==================================
reports_log = grid.set(2, 0, 14, 16, blessed.log, {
	label: 'Reports'
	padding: {left: 1}
})

updates.push ->
	reports_log.setContent(game['reports_log'].join('\n'))


# == Console Log===================================
console_log = grid.set(16, 0, 6, 16, blessed.log, {
	label: 'Console'
	padding: {left: 1}
})

updates.push ->
	console_log.setContent(game['console_log'].join('\n'))


# == Command Input ================================
command_input = grid.set(22, 0, 2, 16, blessed.textbox, {
	label: 'Command'
	padding: {left: 1}
	content: 'test'
})

command_input.on('submit', ->
	game.processCommand(command_input.getValue())
	command_input.clearValue()
	command_input.readInput()
)

command_input.on('cancel', ->
	command_input.clearValue()
	command_input.readInput()
)

command_input.readInput()