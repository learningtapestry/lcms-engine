import $ from 'jquery';
import CurriculumEditor from './curriculum/CurriculumEditor';
import MultiSelectedOperation from './MultiSelectedOperation';
import React from 'react';
import ReactDOM from 'react-dom';

class Initializer {
  static initialize() {
    // Mount internal components
    Initializer.#initializeCurriculumEditor();
    Initializer.#initializeMultiSelectedOperation();

     // Initialize simple HTML objects
    Initializer.#initializeResourcesForm();
    Initializer.#initializeResourcesList();
    Initializer.#initializeSelectAll();
  };

  static #initializeCurriculumEditor() {
    document.querySelectorAll('[id="#lcms-engine-CurriculumEditor"]').forEach( e => {
      const props = JSON.parse(e.dataset.content);
      e.removeAttribute('data-content');
      ReactDOM.render(
        <CurriculumEditor {...props} />,
        e
      );
    })
  };

  static #initializeMultiSelectedOperation() {
    document.querySelectorAll('[id="#lcms-engine-MultiSelectedOperation"]').forEach( e => {
      const props = JSON.parse(e.dataset.content);
      e.removeAttribute('data-content');
      ReactDOM.render(
        <MultiSelectedOperation {...props} />,
        e
      );
    })
  };

  static #initializeResourcesForm() {
    const form = $('form#resource_form');
    if (!form.length) return;

    const opr_desc = form.find('.resource_opr_description');
    form.find('#resource_curriculum_type').change(ev => {
      const el = $(ev.target);
      if (el.val() === 'unit') {
        opr_desc.slideDown();
      } else {
        opr_desc.slideUp();
      }
    });
  };

  static #initializeResourcesList() {
    const page = $('.o-adm-list.o-adm-documents');
    if (!page.length) return;

    page.find('.c-reimport-with-materials__toggle input[type=checkbox]').change(() => {
      const value = $(this).prop('checked') ? 1 : 0;
      page.find('.c-reimport-doc-form .c-reimport-with-materials__field').val(value);
    });
  };

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
