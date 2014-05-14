gulp = require 'gulp'
coffee = require 'gulp-coffee'
transpile = require 'gulp-es6-module-transpiler'
concat = require 'gulp-concat-sourcemap'
usemin = require 'gulp-usemin'
livereload = require 'gulp-livereload'
es = require 'event-stream'
path = require 'path'
_ = require 'underscore'

dest =
  root: 'dist'

src =
  scripts: 'app/**/*.{js,coffee}'

gulp.task 'scripts', ->
  es.merge(gulp.src('app/**/*.coffee').pipe(coffee bare: true),
           gulp.src ['app/**/*.js', '!app/main.js'])
  .pipe(transpile type: 'amd')
  .pipe gulp.dest dest.root

gulp.task 'maps', ->
  gulp.src('vendor/bootstrap/dist/css/bootstrap.css.map')
  .pipe gulp.dest dest.root

gulp.task 'index', ['scripts'], ->
  gulp.src(['app/index.html', 'app/main.js'])
  .pipe gulp.dest dest.root

gulp.task 'vendor', ->
  gulp.src('vendor/requirejs/require.js')
  .pipe gulp.dest dest.root

gulp.task 'default', ['index', 'vendor'], ->
  gulp.watch _.values(src), ['index']
  gulp.watch 'app/index.html', ['index']
  server = livereload()
  # nodemon(script: 'app.js', watch: ['api/', 'config/'], ext: 'js coffee').on 'restart', ->
  #   setTimeout (-> server.changed 'index.html'), 3000
  # gulp.watch('.tmp/public/**/*').on 'change', (file) ->
  #   server.changed file.path

