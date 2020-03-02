//= require turbolinks
//= require jquery2
//= require jquery_ujs
//= require jquery_nested_form
//= require i18n/translations
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

document.addEventListener('turbolinks:load', function () {
  $(document).initFoundation();

  $('.selectize').selectize({
    allowEmptyOption: true,
    plugins: ['remove_button']
  });

  if (window.ga) {
    ga('set', 'location', location.href.split('#')[0]);
    ga('send', 'pageview', {
      "title": document.title
    });
  }
});
