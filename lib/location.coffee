_ = require('lodash')

module.exports = class Location

	@TYPE: {'Space', 'Warp', 'Asteroid Field', 'Planet', 'Moon', 'Sun', 'Nebula'}

	name: ''
	type: null

	@warp:
		name: 'Warpspace'
		type: Location.TYPE['Warp']

	@generate: ->
		name = ''
		name += _.sample(['A', 'B', 'C', 'D'])
		name += _.sample(['E', 'F', 'G', 'H'])
		name += _.sample(['Z', 'X', 'Y', 'R'])
		name += '-'
		name += _.sample(['1', '3', '6', '9'])
		name += _.sample(['2', '8', '7', '5'])

		location = new Location()
		location['name'] = name
		location['type'] = _.sample(_.reject(_.keys(Location.TYPE), 'Warp', 'Space'))
		return location