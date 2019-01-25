$(function () {
  window.initializeBundles = function() {
    if (!$('.o-unit-bundles').length) return;

    $('.o-unit-bundles a').click(function() {
      const el = $(this);
      const data = el.data('heap-data');
      if (data) heapTrack('Download Unit Bundle', data);
    });
  };
});
