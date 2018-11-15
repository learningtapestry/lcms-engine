(function () {
  window.initializeResourcesForm = function() {
    const form = $('form#resource_form');
    if (!form.length) return;

    const opr_desc = form.find('.resource_opr_description');
    form.find('#resource_curriculum_type').change((ev) => {
      const el = $(ev.target);
      if (el.val() === 'unit') {
        opr_desc.slideDown();
      } else {
        opr_desc.slideUp();
      }
    });
  }
})();
