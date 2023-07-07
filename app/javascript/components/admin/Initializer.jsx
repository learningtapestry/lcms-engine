import $ from 'jquery';
import CurriculumEditor from './curriculum/CurriculumEditor';
import ImportStatus from './ImportStatus';
import MultiSelectedOperation from './MultiSelectedOperation';
import React from 'react';
import ReactDOM from 'react-dom';

class Initializer {
  static initialize() {
    // Mount internal components
    Initializer.#initializeCurriculumEditor();
    Initializer.#InitializeImportStatus();
    Initializer.#initializeMultiSelectedOperation();

    // Initialize simple HTML objects
    Initializer.#initializeResourcesList();
    Initializer.#initializeSelectAll();
  }

  static #initializeCurriculumEditor() {
    document.querySelectorAll('[id="#lcms-engine-CurriculumEditor"]').forEach(e => {
      const props = JSON.parse(e.dataset.content);
      e.removeAttribute('data-content');
      ReactDOM.render(<CurriculumEditor {...props} />, e);
    });
  }

  static #InitializeImportStatus() {
    document.querySelectorAll('[id="#lcms-engine-ImportStatus"]').forEach(e => {
      const props = JSON.parse(e.dataset.content);
      e.removeAttribute('data-content');
      ReactDOM.render(<ImportStatus {...props} />, e);
    });
  }

  static #initializeMultiSelectedOperation() {
    document.querySelectorAll('[id="#lcms-engine-MultiSelectedOperation"]').forEach(e => {
      const props = JSON.parse(e.dataset.content);
      e.removeAttribute('data-content');
      ReactDOM.render(<MultiSelectedOperation {...props} />, e);
    });
  }

  static #initializeResourcesList() {
    const page = $('.o-adm-list.o-adm-documents');
    if (!page.length) return;

    page.find('.c-reimport-with-materials__toggle input[type=checkbox]').change(() => {
      const value = $(this).prop('checked') ? 1 : 0;
      page.find('.c-reimport-doc-form .c-reimport-with-materials__field').val(value);
    });
  }

  static #initializeSelectAll() {
    const selector = $('.c-multi-selected--select-all');
    if (!selector.length) return;

    selector.find('input').change(ev => {
      const el = $(ev.target);
      const checked = el.prop('checked');
      $('.table input[type=checkbox][name="selected_ids[]"]').prop('checked', checked);
    });
  }
}

export default Initializer;
