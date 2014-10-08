request = require 'request'

name = process.argv[2]
version = process.argv[3] or '0'

api = process.env.API

request.post "#{api}/module", {json: { name: name, version: version, files: [] }}, (err, res, info) ->
  console.error err if err
  console.log info
