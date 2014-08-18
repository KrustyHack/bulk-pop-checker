express = require "express"
path = require "path"
favicon = require "static-favicon"
logger = require "morgan"
cookieParser = require "cookie-parser"
bodyParser = require "body-parser"
async = require "async"
app = express()

# view engine setup
app.set "views", path.join __dirname, "views"
app.set "view engine", "jade"
app.use favicon()
app.use logger "dev"
app.use bodyParser.json()
app.use bodyParser.urlencoded()
app.use cookieParser()
app.use require("less-middleware")(path.join(__dirname, "public"))
app.use express.static(path.join(__dirname, "public"))

app.get "/", (req, res) ->
  res.render "index",
    title: "Express"

app.post "/check", (req, res) ->
  Checker = new(require "./libs/checker")
  emails = req.body.emails.split "\n"

  async.map(emails, (email, callback) ->
    pemail = email.split ":"
    host = pemail[0]
    port = pemail[1]
    username = pemail[2]
    password = pemail[3]

    Checker.check host, port, username, password, (result) ->
      callback null, result
  , (err, results) ->
    if err
      res.send "error"
    else
      res.send results
  )

app.use (req, res, next) ->
  err = new Error "Not Found"
  err.status = 404
  next err
  return

app.use (err, req, res, next) ->
  res.status err.status or 500
  res.render "error",
    message: err.message
    error: {}

  return

app.set "port", process.env.PORT || 3000

server = app.listen app.get('port'), () ->
  console.log 'Express server listening on port ' + server.address().port