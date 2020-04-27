//= require turbolinks
//= require jquery2
//= require jquery_ujs
//= require jquery_nested_form
//= require lodash
//= require foundation.initialize
//= require ckeditor/init
//= require foundation
//= require microplugin
//= require sifter
//= require selectize
//= require html.sortable.min
//= require jquery.tagsinput
//= require jstree
//= require js-routes
//= require ../initializers/analytics.js

document.addEventListener('turbolinks:load', function () {
  $(document).initFoundation();

  $('.selectize').selectize({
    allowEmptyOption: true,
    plugins: ['remove_button']
  });

  window.initializeGoogleAnalytics();
});
