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

refresh = []

# 30 FPS
setInterval( ->
	refresh.forEach (callback) -> callback.apply()
	screen.render()
, 33)

screen.key ['C-c'], (ch, key) -> process.exit(0)

# ==================================================================
# = Setup Game
# ==================================================================

Game = require('./lib/game.coffee')

game = new Game()


# == Ship Info ====================================
ship_info = grid.set(0, 16, 4, 8, contrib.table, { 
	label: 'Ship Info'
	columnSpacing: 1
	columnWidth: [15, 18]
})

refresh.push ->
	ship_info.setData(
		headers: ['Attribute', 'Value']
		data: [
			['',''] #wtf
			['Name', game['playerShip']['name']]
			['Crew Count', game['playerShip']['crew_count']]
			['Shield', game['playerShip'].describeShieldStrength()]
			['Hull', game['playerShip'].describeHullIntegrity()]
			['Capacitor', game['playerShip'].describeCapacitorCharge()]
		]
	)


# == Reports Log ==================================
reports_log = grid.set(0, 0, 16, 16, blessed.log, {
	label: 'Reports'
	padding: {left: 1}
})

refresh.push ->
	reports_log.setContent(game['reports_log'].join('\n'))


# == Console Log===================================
console_log = grid.set(16, 0, 6, 16, blessed.log, {
	label: 'Console'
	padding: {left: 1}
})

refresh.push ->
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
