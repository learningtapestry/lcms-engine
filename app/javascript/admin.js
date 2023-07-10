import '@hotwired/turbo-rails';
import * as bootstrap from 'bootstrap'; // eslint-disable-line
// import './vendor/html.sortable.min';
import TomSelect from 'tom-select';
import Initializer from './components/admin/Initializer';

document.addEventListener('turbo:load', () => {
  Initializer.initialize();

  document.querySelectorAll('.selectize').forEach(el => {
    let settings = {
      plugins: {
        remove_button: {
          title: 'Remove',
        },
      },
    };
    new TomSelect(el, settings);
  });

  if (typeof CKEDITOR === 'undefined' && document.getElementsByClassName('ckeditor').length) {
    const script = document.createElement('script');
    script.src = 'https://cdn.ckeditor.com/4.20.0/standard/ckeditor.js';
    document.head.append(script);
  }
});
