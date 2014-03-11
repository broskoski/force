Q = require 'q'
_ = require 'underscore'
OrderedSets = require '../../collections/ordered_sets.coffee'
Genes = require '../../collections/genes.coffee'
{ ARTSY_URL } = require('sharify').data

@index = (req, res) ->
  [featuredGenes, popularCategories] = requests = [
    new OrderedSets(key: 'browse:featured-genes'),
    new OrderedSets(key: 'browse:popular-categories')
  ]
  Q.allSettled(_.map(requests, (xs) -> xs.fetchAll(cache: true))).then ->
    res.render 'index',
      featuredGenes: featuredGenes
      popularCategories: popularCategories

@categories = (req, res) ->
  geneCategories = new OrderedSets(key: 'browse:gene-categories')
  geneCategories.fetchAll
    cache: true
    success: ->
      new Genes().fetchUntilEnd
        data: { size: 100, published: true, sort: "name" }
        url: "#{ARTSY_URL}/api/v1/genes"
        cache: true
        success: (genes) ->
          aToZGroup = genes.groupByAlphaWithColumns 3
          res.render 'categories',
            geneCategories: geneCategories
            aToZGroup: aToZGroup