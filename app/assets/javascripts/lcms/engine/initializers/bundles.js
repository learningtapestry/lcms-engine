"use strict";

(function () {
  window.initializeBundles = function () {
    if (!$('.o-unit-bundles').length) return;
    $('.o-unit-bundles a').click(function () {
      var el = $(this);
      var data = el.data('heap-data');
      if (data) heapTrack('Download Unit Bundle', data);
    });
  };
})();
