import '@hotwired/turbo-rails';
import * as bootstrap from 'bootstrap'; // eslint-disable-line
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
});
