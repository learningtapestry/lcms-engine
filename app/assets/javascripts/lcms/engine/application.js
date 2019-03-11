//= require turbolinks
//= require jquery2
//= require jquery_ujs
//= require i18n/translations
//= require ./vendor/modernizr-custom
//= require ./vendor/swiper.jquery
//= require ./vendor/pdfobject.js
//= require ./jquery/smoothscrolling
//= require foundation
//= require ./jquery/foundation.magellanex
//= require ./jquery/foundation.initialize
//= require ./jquery/tabs
//= require ./prerender_polyfill
//= require react
//= require react_ujs
//= require js-routes
//= require ./initializers/heap_analytics
//= require ./components
//= require ./initializers/about_people
//= require ./initializers/bundles
//= require ./initializers/google_analytics
//= require ./initializers/header_dropdown
//= require ./initializers/leadership
//= require ./initializers/lessons
//= require ./initializers/loadasync
//= require ./initializers/pdf_preview
//= require ./initializers/resource_details
//= require ./initializers/social_sharing
//= require ./initializers/soundcloud
//= require ./initializers/subscribe_placeholder
//= require ./initializers/survey
//= require_tree ./initializers/sidebar

document.addEventListener('turbolinks:load', function() {
  $(document).initFoundation();
  $('.o-page--resource').smoothscrolling();
  window.initializeHeaderDropdown();
  window.initializeAboutPeople();
  window.initializeSocialSharing();
  window.initializeLeadership();
  //window.initializeFreshdesk();
  window.initializeGoogleAnalytics();
  window.initializeSoundCloud();
  window.initializeSubscribePlaceholder();
  window.initializeSurvey();
  window.initializePDFPreview();
  window.initializeResourceDetails();
  window.initializeTabs();
  window.initializeLessons();
  window.initializeBundles();
});

//= require ./initializers/events
