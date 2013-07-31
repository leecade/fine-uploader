###
    utils

    utilities for integration tests
###

fs = require 'fs'
request = require 'request'

###
    Download something from the 'net
###
module.exports.download = (uri, filename) ->
    request(uri).pipe(fs.createWriteStream(filename))
    return filename