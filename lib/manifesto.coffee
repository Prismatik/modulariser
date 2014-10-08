crypto = require 'crypto'
recursive = require 'recursive-readdir'
async = require 'async'
fs = require 'fs'
path = require 'path'

calcHashes = (cb) ->
  recursive '.', (err, files) ->
    files = files.filter (file) -> file.charAt(0) isnt '.'
    jobs = files.map hashFactory
    async.parallelLimit jobs, 5, (err, files) ->
      cb(err, files)

hashFactory = (file) ->
  return (cb) ->
    calcHash file, cb

calcHash  = (file, cb) ->
  fs.readFile file, (err, buf) ->
    return cb err if err
    shasum = crypto.createHash("sha256")

    shasum.update buf

    cb null,
      localName: path.basename file
      localPath: path.dirname file
      sha: shasum.digest("hex")

module.exports = (version, name, id, cb) ->
  calcHashes (err, files) ->
    cb null,
      name: name
      version: version
      files: files
