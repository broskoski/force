express = require 'express'
routes = require './routes'
embedVideo = require 'embed-video'
{ resize, crop } = require '../../components/resizer'

app = module.exports = express()
app.set 'views', __dirname + '/templates'
app.set 'view engine', 'jade'
app.locals.resize = resize
app.locals.crop = crop
app.locals.embedVideo = embedVideo

app.get '/rss/news', routes.news
app.get '/rss/instant-articles', routes.instantArticles
