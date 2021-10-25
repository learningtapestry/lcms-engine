//= require turbolinks
//= require jquery2
//= require jquery_ujs
//= require jquery_nested_form
//= require foundation
//= require html.sortable.min
//= require js-routes
//= require 'selectize.min'
//= require '../initializers/foundation'

document.addEventListener('turbolinks:load', function () {
  $('.selectize').selectize({
    allowEmptyOption: true,
    plugins: ['remove_button'],
  });
});
