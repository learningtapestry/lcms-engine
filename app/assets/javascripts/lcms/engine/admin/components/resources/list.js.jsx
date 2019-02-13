(function () {
  window.initializeResourcesList = function () {
    const page = $('.o-adm-list.o-adm-documents');
    if (!page.length) return;

    page.find('.c-reimport-with-materials__toggle input[type=checkbox]').change(function() {
      const value = $(this).prop('checked') ? 1 : 0;
      page.find('.c-reimport-doc-form .c-reimport-with-materials__field').val(value);
    });
  };
})();
