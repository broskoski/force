_         = require 'underscore'
sd        = require('sharify').data
Backbone  = require 'backbone'
Artworks  = require '../collections/artworks.coffee'
{ Image, Markdown } = require 'artsy-backbone-mixins'
Artist    = require '../models/artist.coffee'

module.exports = class Gene extends Backbone.Model

  _.extend @prototype, Image(sd.SECURE_IMAGES_URL)
  _.extend @prototype, Markdown

  urlRoot: "#{sd.ARTSY_URL}/api/v1/gene"

  clientUrl: -> "/gene/#{@get('id')}"

  href: -> "/gene/#{@get('id')}"

  displayName: -> @get('name')

  alphaSortKey: -> @get('id')

  initialize: ->
    @relatedArtists       = new Backbone.Collection [], model: Artist
    @relatedArtists.url   = "#{sd.ARTSY_URL}/api/v1/gene/#{@id}/artists"
    @trendingArtists      = new Backbone.Collection [], model: Artist
    @trendingArtists.url  = "#{sd.ARTSY_URL}/api/v1/artists/trending?gene=#{@id}"

  fetchArtists: (type, options={}) ->
    @["#{type}Artists"].fetch(options)

  fetchArtworks: (options) ->
    artworks = new Artworks
    artworks.url = "#{@url()}/artworks"
    artworks.fetch options

  isSubjectMatter: ->
    "Subject Matter" in _.pluck @get('type').properties, 'value'

  fetchFilterSuggest: (params, options) ->
    new Backbone.Model().fetch _.extend
      data: params
      url: "#{sd.ARTSY_URL}/api/v1/search/filtered/gene/#{@get 'id'}/suggest"
    , options
