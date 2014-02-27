module.exports = (grunt) ->
  grunt.initConfig
    compass:
      dev:
        options:
          sassDir: "assets/styles"
          specify: "assets/styles/bundle.sass"
          cssDir: "public/styles"

    browserify:
      dev:
        files:
          'app.js': ['components/index.js']
        options:
          debug: true
          transform: ['liveify']
          alias: ['components/index.ls:app']

    copy:
      dist:
        files: []

    watch:
      styles:
        files: "assets/styles/**/*.sass"
        tasks: [ "compass:dev" ]
      components:
        files: "components/*.ls"
        tasks: [ "browserify:dev" ]

  # Tasks
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-copy"
  grunt.loadNpmTasks "grunt-contrib-compass"
  grunt.loadNpmTasks "grunt-browserify"
  grunt.loadNpmTasks "grunt-contrib-uglify"

  # Default task.
  grunt.registerTask "default", [ "copy", "compass:dev", "browserify:dev" ]
  grunt.registerTask "travis", [ "default" ]
  grunt.registerTask "heroku", [ "default" ]
