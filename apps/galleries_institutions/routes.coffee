Backbone = require 'backbone'
_ = require 'underscore'
Q = require 'bluebird-q'
qs = require 'qs'
metaphysics = require '../../lib/metaphysics'
{ API_URL } = require('sharify').data
{ FeaturedCities } = require 'places'
Partners = require '../../collections/partners'
Profiles = require '../../collections/profiles'
ViewHelpers = require './components/partner_cell/view_helpers'
query = require './queries/partner_categories_query'
partnerTypes = require './queries/partner_types'
mergeBuckets = require './components/partner_cell_carousel/merge_buckets'
fetchPrimaryCarousel = require './components/primary_carousel/fetch'
facetDefaults = require './components/filter_facet/facet_defaults.coffee'

mapType =
  galleries: 'gallery'
  institutions: 'institution'

mapTypeClasses =
  galleries: ['PartnerGallery']
  institutions: ['PartnerInstitution', 'PartnerInstitutionalSeller']

@index = (req, res, next) ->
  type = mapType[req.params.type]
  searchParams = _.pick(req.query, 'location', 'category')
  params = _.extend type: type, searchParams

  Q.all([
    fetchPrimaryCarousel(params)
    metaphysics(
      query: query
      variables: _.extend category_type: type.toUpperCase(), type: partnerTypes[type]
    ).then (data) ->
      _.compact _.map data.partner_categories, (category) ->
        return null if category.primary.length + category.secondary.length < 3
        _.extend _.omit(category, 'primary', 'secondary'),
          partners: mergeBuckets(category.primary, category.secondary),
          facet: 'category'

  ]).spread (profiles, categories) ->
    res.locals.sd.MAIN_PROFILES = profiles.toJSON()
    res.locals.sd.CATEGORIES = _.map(categories, (c) -> _.pick c, 'id', 'name')

    res.render 'index',
      ViewHelpers: ViewHelpers
      showAZLink: true
      type: type
      profiles: profiles.models
      categories: _.shuffle categories
      facets: facetDefaults
      state: if _.isEmpty(searchParams) then 'landing' else 'search'

  .catch next
  .done()

# A to Z page

@partnersAZ = (req, res, next) ->
  type = mapType[req.params.type]

  partners = new Partners()
  partners.fetchUntilEndInParallel
    cache: true
    data:
      size: 20
      type: mapTypeClasses[req.params.type]
      sort: 'sortable_id'
      has_full_profile: true
      eligible_for_listing: true

  .then ->
    aToZGroup = partners.groupByAlphaWithColumns 3
    res.render 'a_z',
      type: type
      showAZLink: false
      aToZGroup: aToZGroup

  .catch next
  .done()

