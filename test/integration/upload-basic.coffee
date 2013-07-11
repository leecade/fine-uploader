###
    upload-basic.coffee
###

assert = require 'assert'
fs = require 'fs'

module.exports.url = "http://localhost:9001/integration/fixtures/upload-basic.html"

module.exports.test = upload_basic = (browser, cb) ->

    browser.uploadFile '/Users/mfeltner/tux.jpg', (err, filepath) ->
        if (err)
            return cb err
        browser.elementByClassName 'qq-upload-button', (err, element) ->
            if (err)
                return cb err
            element.elementByTagName 'input', (err, el) ->
                if (err)
                    return cb err
                el.sendKeys filepath, (err) ->
                    if (err)
                        return cb err
                    cb()
