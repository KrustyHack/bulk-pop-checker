POP3Client = require "poplib1"

class Checker
    constructor: () ->

    check: (host, port, username, password, callback) ->
        client = new POP3Client(port, host,
          tlserrs: false
          enabletls: true
          debug: false
        )
        client.on "error", (err) ->
          if err.errno is 111
            callback "Unable to connect to server #{err}"
          else
            callback "Server error occurred #{err}"

        client.on "connect", ->
          client.login username, password

        client.on "login", (status, rawdata) ->
          if status
            callback "LOGIN/PASS success - #{username} #{host}:#{port}"
          else
            callback "LOGIN/PASS failed - #{username} #{host}:#{port}"
module.exports = Checker