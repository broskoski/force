(function () {
  'use strict'

  analyticsHooks.on('show_number:displayed', function () {
    analytics.track("Displayed 'show phone number' button", {nonInteraction: 1})
  })

  analyticsHooks.on('partner:non-claimed', function (options) {
    analytics.track('Non-claimed partner page', _.extend(options, {nonInteraction: 1}))
  })

  $('#partner-contact .email-gallery').click(function (e) {
    analytics.track('Clicked Contact Gallery Via Email', {
      partner_id: $(e.currentTarget).data('partner-id'),
      partner_slug: $(e.currentTarget).data('partner-slug')
    })
  })

  $('#partner-contact .partner-website').click(function (e) {
    analytics.track('Clicked Gallery Website', {
      partner_id: $(e.currentTarget).data('partner-id'),
      partner_slug: $(e.currentTarget).data('partner-slug')
    })
  })

  $('.main-layout-container').on('click', '#partner2-contact .email-gallery', function (e) {
    analytics.track('Click',{
      partner_id: $(e.currentTarget).data('partner-id'),
      label: "Contact gallery by email"
    })
  })

  $('.main-layout-container').on('click', '#partner2-contact .partner2-website', function (e) {
    analytics.track('Click', {
      partner_id: $(e.currentTarget).data('partner-id'),
      label: "External partner site",
      destination_path: $(e.currentTarget).attr('href')
    })
  })
})()
