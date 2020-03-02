//= require turbolinks
//= require jquery2
//= require jquery_ujs
//= require i18n/translations
//= require modernizr-custom
//= require swiper.jquery
//= require smoothscrolling
//= require lodash
//= require foundation
//= require foundation.initialize
//= require foundation.magellanex
//= require foundation.initialize
//= require tabs
//= require js-routes
//= require ./initializers/heap_analytics
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

document.addEventListener('turbolinks:load', function () {
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
