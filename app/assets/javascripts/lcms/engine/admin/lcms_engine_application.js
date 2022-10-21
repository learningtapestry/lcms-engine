//= require turbolinks
//= require jquery3
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

  if (typeof CKEDITOR === 'undefined' && document.getElementsByClassName('ckeditor').length) {
    let script = document.createElement('script');
    script.src = 'https://cdn.ckeditor.com/4.20.0/standard/ckeditor.js';
    document.head.append(script);
  }
});
