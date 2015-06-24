_ = require('lodash')
Ship = require('./ship')

module.exports = class Location

	@TYPE: {'Space', 'Warp', 'Asteroid Field', 'Planet', 'Moon', 'Sun', 'Nebula'}

	'name': ''
	'type': null
	'ships': []

	@warp:
		'name': 'Warpspace'
		'type': Location.TYPE['Warp']
		'ships': []

	@generate: ->
		name = ''
		name += _.sample(['A', 'B', 'C', 'D'])
		name += _.sample(['E', 'F', 'G', 'H'])
		name += _.sample(['Z', 'X', 'Y', 'R'])
		name += '-'
		name += _.sample(['1', '3', '6', '9'])
		name += _.sample(['2', '8', '7', '5'])

		ships = []
		enemy =  Ship.generateEnemy()
		ships.push(enemy)

		location = new Location()
		location['name'] = name
		location['type'] = _.sample(['Asteroid Field', 'Planet', 'Moon', 'Sun', 'Nebula'])
		location['ships'] = ships
		return location