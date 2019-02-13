//= require jquery
//= require jquery_ujs
//= require jquery_nested_form
//= require i18n/translations
//= require ../jquery/foundation.initialize
//= require ckeditor/init
//= require foundation
//= require microplugin
//= require sifter
//= require selectize
//= require react
//= require react_ujs
//= require ../vendor/html.sortable.min
//= require ../vendor/jquery.tagsinput
//= require jstree
//= require js-routes
//= require ../components
//= require_tree ./components
//= require ../initializers/google_analytics

document.addEventListener('DOMContentLoaded', function() {
  $(document).initFoundation();

  $('.selectize').selectize({
    allowEmptyOption: true,
    plugins: ['remove_button']
  });

  window.initializeSelectAll();
  window.initializeResourcesForm();
  window.initializeResourcesList();
  window.initializeGoogleAnalytics();
});
