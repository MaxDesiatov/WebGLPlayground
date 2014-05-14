gulp = require 'gulp'
coffee = require 'gulp-coffee'
transpile = require 'gulp-es6-module-transpiler'
bowerFiles = require 'gulp-bower-files'
livereload = require 'gulp-livereload'
es = require 'event-stream'
inject = require 'gulp-inject'
path = require 'path'
_ = require 'underscore'
express = require 'express'
server = express()

server.use express.static './dist'

dest =
  root: 'dist'
dest.vendor = "#{dest.root}/vendor"
dest.shaders = "#{dest.root}/shaders"

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
  gulp.src('app/index.html')
  .pipe(inject bowerFiles())
  .pipe gulp.dest dest.root

gulp.task 'require', ->
  gulp.src(['vendor/requirejs/require.js', 'app/main.js', 'app/*.glsl'])
  .pipe gulp.dest dest.root

gulp.task 'vendor', ->
  bowerFiles().pipe gulp.dest dest.vendor

gulp.task 'default', ['index', 'require', 'vendor'], ->
  gulp.watch _.values(src), ['index']
  gulp.watch 'app/index.html', ['index']
  server.listen 8000
  # server = livereload()
  # nodemon(script: 'app.js', watch: ['api/', 'config/'], ext: 'js coffee').on 'restart', ->
  #   setTimeout (-> server.changed 'index.html'), 3000
  # gulp.watch('.tmp/public/**/*').on 'change', (file) ->
  #   server.changed file.path

