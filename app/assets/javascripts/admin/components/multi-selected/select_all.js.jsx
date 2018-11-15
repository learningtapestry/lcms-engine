(function () {
  window.initializeSelectAll = function() {
    if (!$('.c-multi-selected--select-all').length) return;

    $('.c-multi-selected--select-all input').change((ev) => {
      const el = $(ev.target);
      const checked = el.prop('checked');
      $('.table input[type=checkbox][name="selected_ids[]"]').prop('checked', checked);
    });
  }
})();
