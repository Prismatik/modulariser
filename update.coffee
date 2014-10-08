id = process.argv[2]
version = process.argv[3]
force = process.argv[4]

request = require 'request'
mungeSemver = require 'munge-semver'
semver = require 'semver'

filer = require './lib/filer'
manifesto = require './lib/manifesto'

api = process.env.API

throw new Error 'no api endpoint specified' if !api

request.get "#{api}/module/#{id}", (err, res, info) ->
  throw err if err
  info = JSON.parse info
  if semver.gt mungeSemver(info.version), mungeSemver(version)
    console.warn 'It looks like you are trying to push an older version than the current head'
    throw new Error 'Refusing to push old version' unless force
    
  filer api, (err) ->
    throw err if err
    manifesto version, info.name, id, (err, manifest) ->
      throw err if err
      request.post "#{api}/module/#{id}", {json: manifest}, (err, res, info) ->
        throw err if err
        console.log "Successfully set module #{id} to version #{version}"
