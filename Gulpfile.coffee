gulp = require('gulp')
plugins = require('gulp-load-plugins')()

compile_options =
	join: true
	bare: true
#END compile_options

gulp.task 'default', ->

gulp.task 'build', ->
	gulp.src(['src/**.coffee'])
	    .pipe(plugins.plumber())
		.pipe(plugins.coffee(compile_options))
		.pipe(gulp.dest('dist/'))
