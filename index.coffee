blessed = require('blessed')
contrib = require('blessed-contrib')
_ = require('lodash')

screen = blessed.screen()
grid = new contrib.grid({rows: 12, cols: 12, screen: screen})

map = grid.set(0, 0, 4, 4, contrib.map, {label: 'World Map'})
box = grid.set(4, 4, 4, 4, blessed.box, {content: 'My Box',  style: {
    fg: 'white'
    border: {
      fg: '#f0f0f0'
    }
  }})

box.on('click', (data) ->
  box.setContent('test')
)

gauge = grid.set(8, 8, 1, 4, contrib.gauge, {label: 'Progress'})
gauge.setPercent(25)

bar = grid.set(4, 0, 4, 4, contrib.bar, {label: 'Power Distribution (%)'
       , barWidth: 4
       , barSpacing: 6
       , xOffset: 0
       , maxHeight: 100
       , height: "40%"})

setInterval( ->
	gauge.setPercent(_.random(80, 100))
	bar.setData(
       { titles: ['ENG', 'SHD']
       , data: [5, 10]})
, 200)

setInterval( ->
	screen.render()
, 16)

screen.key ['escape', 'C-c'], (ch, key) -> process.exit(0)

screen.render()