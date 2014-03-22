gulp = require 'gulp'
source = require 'vinyl-source-stream'
browserify = require 'browserify'
watchify = require 'watchify'

compass = require 'gulp-compass'

gulp.task 'compass', ->
  gulp.src('./assets/*.sass').pipe do
    compass do
      bundleExec: true,
      sassDir: 'assets/styles'
      css: 'public/styles/'
      images: 'images'

browserify-config = (instance) ->
  bundler = instance './components/index.ls'
  bundler.transform 'liveify'
  bundler.transform 'envify'
  bundler.require './components/index.ls', expose: 'app'

build-config =
  debug: process.env.NODE_ENV != "production"

gulp.task 'browserify', ->
  bundler = browserify-config browserify
  bundler.bundle build-config
    .pipe source('app.js')
    .pipe gulp.dest('.')

gulp.task 'watch', ->
  bundler = browserify-config watchify
  bundler.on 'update', ->
    bundler.bundle build-config
      .pipe source('app.js')
      .pipe gulp.dest('.')

gulp.task 'default', ['compass', 'browserify']
