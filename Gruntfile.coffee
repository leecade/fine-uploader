# Gruntfile
#   for
# fineuploader

# the 'wrapper' function
module.exports = (grunt) ->

    # Utilities
    # ==========
    _ = (grunt.utils || grunt.util)._
    fs = require 'fs'
    path = require 'path'
    request = require 'request'

    # Package
    # ==========
    pkg = require './package.json'

    # Modules
    # ==========
    # Core modules
    core = [
        './client/js/util.js',
        './client/js/version.js',
        './client/js/features.js',
        './client/js/promise.js',
        './client/js/button.js',
        './client/js/paste.js',
        './client/js/upload-data.js',
        './client/js/uploader.basic.js',
        './client/js/dnd.js',
        './client/js/uploader.js',
        './client/js/ajax.requester.js',
        './client/js/deletefile.ajax.requester.js',
        './client/js/window.receive.message.js',
        './client/js/handler.base.js',
        './client/js/handler.form.js',
        './client/js/handler.xhr.js',
        './client/js/ui.handler.events.js',
        './client/js/ui.handler.click.drc.js',
        './client/js/ui.handler.edit.filename.js',
        './client/js/ui.handler.click.filename.js',
        './client/js/ui.handler.focusin.filenameinput.js',
        './client/js/ui.handler.focus.filenameinput.js'
    ]

    # jQuery plugin modules
    jquery = core.concat './client/js/jquery-plugin.js',
                         './client/js/jquery-dnd.js'


    extra = [
        './client/js/iframe.xss.response.js'
        './client/loading.gif',
        './client/processing.gif',
        './client/edit.gif',
        './README.md',
        './LICENSE'
    ]

    versioned = [
        'package.json',
        'fineuploader.jquery.json',
        'client/js/version.js',
        'bower.json',
        'README.md'
    ]

    browsers = require './test/browsers.json'

    # Configuration
    # ==========
    grunt.initConfig

        # Package
        # --------
        pkg: pkg
        extra: extra

        # Modules
        # ----------
        # works
        bower:
            install:
                options:
                    targetDir: './test/_vendor'
                    install: true
                    cleanTargetDir: true
                    cleanBowerDir: true
                    layout: 'byComponent'

        # Clean
        # --------
        clean:
            build:
                files:
                    src: './_build'
            dist:
                files:
                    src: './_dist'
            test:
                files:
                    src: ['./test/_temp*', 'test/coverage']
            vendor:
                files:
                    src: './test/_vendor'

        # Banner
        # ----------
        usebanner:
            header:
                src: ['./_build/*.{js,css}']
                options:
                    position: 'top'
                    banner: '''
                            /*!
                             * <%= pkg.title %>
                             *
                             * Copyright 2013, <%= pkg.author %> info@fineuploader.com
                             *
                             * Version: <%= pkg.version %>
                             *
                             * Homepage: http://fineuploader.com
                             *
                             * Repository: <%= pkg.repository.url %>
                             *
                             * Licensed under GNU GPL v3, see LICENSE
                             */ \n\n'''
            footer:
                src: ['./_build/*.{js,css}']
                options:
                    position: 'bottom'
                    banner: '/*! <%= grunt.template.today("yyyy-mm-dd") %> */\n'

        # Complexity
        # ----------
        complexity:
                src:
                    files:
                        src: ['./client/js/*.js']
                    options:
                        errorsOnly: false # show only maintainability errors
                        cyclomatic: 5
                        halstead: 8
                        maintainability: 100
                        #jsLintXML: 'report.xml' # create XML JSLint-like report

        # Concatenate
        # --------
        concat:
            core:
                options:
                    separator: ';'
                src: core
                dest: './_build/<%= pkg.name %>.js'
            jquery:
                options:
                    separator: ';'
                src: jquery
                dest: './_build/jquery.<%= pkg.name %>.js'
            css:
                src: ['./client/*.css']
                dest: './_build/<%= pkg.name %>.css'


        # Uglify
        # --------
        uglify:
            options:
                mangle: true
                compress: true
                report: 'min'
                preserveComments: 'some'
            core:
                src: ['<%= concat.core.dest %>']
                dest: './_build/<%= pkg.name %>.min.js'
            jquery:
                src: ['<%= concat.jquery.dest %>']
                dest: './_build/jquery.<%= pkg.name %>.min.js'

        # Copy
        # ----------
        copy:
            dist:
                files: [
                    {
                        expand: true
                        cwd: './_build/'
                        src: ['*.js', '!*.min.js', '!jquery*', '!*iframe*']
                        dest: './_dist/<%= pkg.name %>-<%= pkg.version %>/'
                        ext: '-<%= pkg.version %>.js'
                    }
                    {
                        expand: true
                        cwd: './_build/'
                        src: ['*.min.js', '!jquery*']
                        dest: './_dist/<%= pkg.name %>-<%= pkg.version %>/'
                        ext: '-<%= pkg.version %>.min.js'
                    }
                    {
                        expand: true
                        cwd: './_build/'
                        src: ['jquery*js', '!*.min.js']
                        dest: './_dist/jquery.<%= pkg.name %>-<%= pkg.version %>/'
                        ext: '.<%= pkg.name %>-<%= pkg.version %>.js'
                    },
                    {
                        expand: true
                        cwd: './_build/'
                        src: ['jquery*min.js']
                        dest: './_dist/jquery.<%= pkg.name %>-<%= pkg.version %>/'
                        ext: '.<%= pkg.name %>-<%= pkg.version %>.min.js'
                    }
                    {
                        expand: true
                        cwd: './client/js/'
                        src: ['iframe.xss.response.js']
                        dest: './_dist/<%= pkg.name %>-<%= pkg.version %>/'
                        ext: '.xss.response-<%= pkg.version %>.js'
                    }
                    {
                        expand: true
                        cwd: './client/js/'
                        src: ['iframe.xss.response.js']
                        dest: './_dist/jquery.<%= pkg.name %>-<%= pkg.version %>/'
                        ext: '.xss.response-<%= pkg.version %>.js'
                    }
                    {
                        expand: true
                        cwd: './client/'
                        src: ['*.gif']
                        dest: './_dist/<%= pkg.name %>-<%= pkg.version %>/'
                    }
                    {
                        expand: true
                        cwd: './client/'
                        src: ['*.gif']
                        dest: './_dist/jquery.<%= pkg.name %>-<%= pkg.version %>/'
                    }
                    {
                        expand: true
                        cwd: './'
                        src: ['LICENSE']
                        dest: './_dist/<%= pkg.name %>-<%= pkg.version %>/'
                    }
                    {
                        expand: true
                        cwd: './'
                        src: ['LICENSE']
                        dest: './_dist/jquery.<%= pkg.name %>-<%= pkg.version %>/'
                    }
                    {
                        expand: true
                        cwd: './_build'
                        src: ['*.min.css']
                        dest: './_dist/<%= pkg.name %>-<%= pkg.version %>'
                        ext: '-<%= pkg.version %>.min.css'
                    }
                    {
                        expand: true
                        cwd: './_build'
                        src: ['*.css', '!*.min.css']
                        dest: './_dist/<%= pkg.name %>-<%= pkg.version %>'
                        ext: '-<%= pkg.version %>.css'
                    }
                    {
                        expand: true
                        cwd: './_build'
                        src: ['*.min.css']
                        dest: './_dist/jquery.<%= pkg.name %>-<%= pkg.version %>'
                        ext: '-<%= pkg.version %>.min.css'
                    }
                    {
                        expand: true
                        cwd: './_build'
                        src: ['*.css', '!*.min.css']
                        dest: './_dist/jquery.<%= pkg.name %>-<%= pkg.version %>'
                        ext: '-<%= pkg.version %>.css'
                    }
                ]
            build:
                files: [
                    {
                        expand: true
                        cwd: './client/js/'
                        src: ['iframe.xss.response.js']
                        dest: './_build/'
                    },
                    {
                        expand: true
                        cwd: './client/'
                        src: ['*.gif']
                        dest: './_build/'
                    }
                ]
            test:
                expand: true
                flatten: true
                src: ['./_build/*']
                dest: './test/_temp'


        # Compress
        # ----------
        compress:
            core:
                options:
                    archive: './_dist/<%= pkg.name %>-<%= pkg.version %>.zip'
                files: [
                    {
                        expand: true
                        cwd: '_dist/'
                        src: './<%= pkg.name %>-<%= pkg.version %>/*'
                    }
                ]
            jquery:
                options:
                    archive: './_dist/jquery.<%= pkg.name %>-<%= pkg.version %>.zip'
                files: [
                    {
                        expand: true
                        cwd: '_dist/'
                        src: './jquery.<%= pkg.name %>-<%= pkg.version %>/*'
                    }
                ]

        # cssmin
        # ---------
        cssmin:
            options:
                banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
                report: 'min'
            files:
                src: '<%= concat.css.dest %>'
                dest: './_build/<%= pkg.name %>.min.css'

        # Lint
        # --------
        jshint:
            source: ['./client/js/*.js']
            tests: ['./test/unit/*.js']
            options:
                validthis: true
                laxcomma: true
                laxbreak: true
                browser: true
                eqnull: true
                debug: true
                devel: true
                boss: true
                expr: true
                asi: true

        # Run linter on coffeescript files
        # ----------
        coffeelint:
            options:
                indentation:
                    level: 'ignore'
                no_trailing_whitespace:
                    level: 'ignore'
                max_line_length:
                    level: 'ignore'
            grunt: './Gruntfile.coffee'


        # Server to run tests against and host static files
        # ----------
        connect:
            root_server:
                options:
                    base: "."
                    hostname: "0.0.0.0"
                    port: 9000
                    keepalive: true
            test_server:
                options:
                    base: "test"
                    hostname: "0.0.0.0"
                    port: 9001

        # Watching for changes
        # ----------
        watch:
            options:
                interrupt: true
                debounceDelay: 250
            js:
                files: ['./client/js/*.js']
                tasks: [
                    'build'
                    'test-unit'
                ]
            test:
                files: ['./test/unit/*.js']
                tasks: [
                    'jshint:tests'
                    'test-unit'
                ]
            grunt:
                files: ['./Gruntfile.coffee']
                tasks: ['coffeelint:grunt']

        # Increment version with semver
        # ----------
        version:
            options:
                pkg: pkg,
                prefix: '[^\\-][Vv]ersion[\'"]?\\s*[:=]\\s*[\'"]?'
            major:
                options:
                    release: 'major'
                src: versioned
            minor:
                options:
                    release: 'minor'
                src: versioned
            hotfix:
                options:
                    release: 'patch'
                src: versioned
            build:
                options:
                    release: 'build'
                src: versioned

        # Mocha Tests
        # ----------
        mocha:
            unit:
                options:
                    urls: ['http://localhost:9001/index.html']
                    log: true
                    mocha:
                        ignoreLeaks: false
                    reporter: 'Spec'
                    run: true

        # Saucelabs + Mocha Tests
        # ---------
        'mocha-sauce':
            options:
                username: process.env.SAUCE_USERNAME || process.env.USER || ''
                accessKey: process.env.SAUCE_ACCESS_KEY || ''
                tunneled: true
                timeout: 3000
                identifier: process.env.TRAVIS_JOB_ID || Math.floor((new Date).getTime() / 1000 - 1230768000).toString()
                tags: [ process.env.SAUCE_USERNAME+"@"+process.env.TRAVIS_BRANCH || process.env.SAUCE_USERNAME+"@local"]
                build: process.env.TRAVIS_BUILD_ID || Math.floor((new Date).getTime() / 1000 - 1230768000).toString()
                concurrency: 3
            unit:
                #urls: ['http://localhost:9001/index.html']
                options:
                    browsers: browsers.unit
                    url: 'http://localhost:9001/index.html'
                    name: 'Unit Tests'
            integration:
                src: ['./test/integration/**/*-test.coffee']
                options:
                    browsers: browsers.integration
                    name: 'Integration Tests'


    # Dependencies
    # ==========
    for name of pkg.devDependencies when name.substring(0, 6) is 'grunt-'
        grunt.loadNpmTasks name
    grunt.loadTasks './lib/tasks'


    # Tasks
    # ==========

    # Lint
    # ----------
    grunt.registerTask 'lint', 'Lint, in order, the Gruntfile, sources, and tests.', [
        'coffeelint:grunt',
        'jshint:source',
        'jshint:tess'
    ]

    # Minify
    # ----------
    grunt.registerTask 'minify', 'Minify the source javascript and css', [
        'uglify'
        'cssmin'
    ]

    # Docs
    # ----------
    grunt.registerTask 'docs', 'IN THE WORKS: Generate documentation', []


    # Watcher
    # ----------
    grunt.registerTask 'test-watch', 'Run headless unit-tests and re-run on file changes', [
        'rebuild'
        'copy:test'
        'watch'
    ]
    # Coverage
    # ----------
    grunt.registerTask 'coverage', 'IN THE WORKS: Generate a code coverage report', []

    # Integration Testing
    # ----------
    grunt.registerTask 'test-integration', 'IN THE WORKS: Run integration tests', [
        'copy:test'
        'connect:test_server'
        'mocha:integration'
    ]

    grunt.registerTask 'test-integration-sauce', 'IN THE WORKS: Run integration tests', [
        'copy:test',
        'connect:test_server'
        'mocha-sauce:integration'
    ]

    # Travis
    # ---------
    grunt.registerTask 'check_for_pull_request_from_master', 'Fails if we are testing a pull request against master', ->
        if (process.env.TRAVIS_BRANCH == 'master' and process.env.TRAVIS_PULL_REQUEST != 'false')
            grunt.fail.fatal '''Woah there, buddy! Pull requests should be
            branched from develop!\n
            Details on contributing pull requests found here: \n
            https://github.com/Widen/fine-uploader/blob/master/CONTRIBUTING.md\n
            '''

    # Travis' own test
    # ----------
    grunt.registerTask 'travis', [
        'check_for_pull_request_from_master'
        'travis-sauce'
    ]

    grunt.registerTask 'travis-sauce', 'Run tests on Saucelabs', [
        'copy:test'
        'connect:test_server'
        'mocha-sauce:unit'
        'mocha-sauce:integration'
    ]

    # Test
    # ----------
    grunt.registerTask 'test-unit', 'Run headless unit tests', [
        'rebuild'
        'copy:test'
        'connect:test_server'
        'mocha:unit'
    ]

    # Test on Saucelabs
    # ----------
    grunt.registerTask 'test-unit-sauce', 'Run tests on Saucelabs', [
        'rebuild'
        'copy:test'
        'connect:test_server'
        'mocha-sauce:unit'
    ]

    # Local tests (indefinite)
    # ----------
    grunt.registerTask 'test-unit-local', 'Run a local server indefinitely for testing', [
        'rebuild'
        'copy:test'
        'connect:root_server'
    ]


    # Build
    # ----------
    grunt.registerTask 'build', 'build from latest source', [
        'concat'
        'minify'
        'usebanner'
    ]

    # Prepare
    # ----------
    grunt.registerTask 'prepare', 'Prepare the environment for FineUploader development', [
        'clean'
        'bower'
    ]

    # Rebuild
    # ----------
    grunt.registerTask 'rebuild', "Rebuild the environment and source", [
        'prepare',
        'build'
    ]

    # Dist
    # ---------
    grunt.registerTask 'dist', 'build a zipped distribution-worthy version', [
        'build'
        'copy:dist'
        'compress'
    ]

    # Default
    # ----------
    grunt.registerTask 'default', 'Default task: clean, bower, lint, build, & test', [
        'clean'
        #'lint'
        'build'
        'test'
    ]
