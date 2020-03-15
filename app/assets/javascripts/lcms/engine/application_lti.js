//= require turbolinks
//= require jquery2
//= require jquery_ujs
//= require modernizr-custom
//= require swiper.jquery
//= require smoothscrolling
//= require lodash
//= require foundation.initialize
//= require foundation.magellanex
//= require foundation.initialize
//= require tabs
//= require js-routes
//= require ./initializers/heap_analytics
//= require ./initializers/lessons
//= require ./initializers/loadasync
//= require ./initializers/pdf_preview
//= require ./initializers/soundcloud
//= require_tree ./initializers/sidebar

document.addEventListener('turbolinks:load', function () {
  $(document).initFoundation();
  $('.o-page--resource').smoothscrolling();
  window.initializeSoundCloud();
  window.initializePDFPreview();
  window.initializeTabs();
  window.initializeLessons();
});

//= require ./initializers/events
