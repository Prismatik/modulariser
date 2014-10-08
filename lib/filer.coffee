ProgressBar = require 'progress'
recursive = require 'recursive-readdir'
async = require 'async'
fs = require 'fs'
request = require 'request'

bar = null
api = null

uploadFactory = (file) ->
  return (cb) ->
    return cb null if file.charAt(0) is '.'
    input = fs.createReadStream "./#{file}"
    output = request.post "#{api}/file"
    form = output.form()
    form.append 'file', input, { filename: 'file' }
    input.on 'error', (err) ->
      return cb null if err.message is 'EISDIR, read'
      throw err
    output.on 'error', (err) ->
      throw err
    output.on 'end', ->
      bar.tick()
      cb null
    #input.pipe output

module.exports = (passedApi, cb) ->
  api = passedApi
  recursive '.', (err, files) ->
    throw err if err

    bar = new ProgressBar "ETA :eta :bar", {total: files.length}

    jobs = []
    jobs.push(uploadFactory(file)) for file in files

    async.parallelLimit jobs, 5, (err) ->
      cb(err)
