import '@hotwired/turbo-rails';
import * as bootstrap from "bootstrap"
import 'selectize'
import './vendor/html.sortable.min'
import $ from 'jquery';
import Initializer from './components/admin/Initializer';

document.addEventListener('turbo:load', () => {
  Initializer.initialize();

  $('.selectize').selectize({
    allowEmptyOption: true,
    plugins: ['remove_button'],
  });

  if (typeof CKEDITOR === 'undefined' && document.getElementsByClassName('ckeditor').length) {
    var script = document.createElement('script');
    script.src = 'https://cdn.ckeditor.com/4.20.0/standard/ckeditor.js';
    document.head.append(script);
  }
});

console.log('Inside admin.js');
