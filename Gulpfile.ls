gulp = require 'gulp'
gutil = require 'gulp-util'
source = require 'vinyl-source-stream'
browserify = require 'browserify'
watchify = require 'watchify'

sass = require 'gulp-ruby-sass'

gulp.task 'compass', ->
  gulp
    .src 'assets/styles/bundle.sass'
    .pipe(sass(compass: true))
    .pipe gulp.dest 'public/styles'

get-bundler = (instance) ->
  bundler = instance './components/index.ls'
  bundler.transform 'liveify'
  bundler.transform 'envify'
  bundler.require './components/index.ls', expose: 'app'

build-config =
  debug: process.env.NODE_ENV != "production"

update = (bundler) ->
  gutil.log 'Bundling'
  bundler.bundle build-config
    .on 'error', gutil.log
    .pipe source('app.js')
    .pipe gulp.dest('.')
    .on 'end', -> gutil.log 'Bundle complete'

gulp.task 'browserify', -> browserify |> get-bundler |> update

gulp.task 'watch', ->
  gulp.watch 'assets/styles/**/*.sass', ['compass']
  watch = watchify |> get-bundler
  watch.on 'update' -> update watch
  update watch

gulp.task 'default', ['compass', 'browserify']
