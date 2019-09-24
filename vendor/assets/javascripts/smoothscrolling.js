"use strict";

(function ($) {
  $.fn.smoothscrolling = function (fnScrollingState) {
    var topMarginSelector = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : null;
    this.find('a[href^="#"], div[href^="#"]').on('click', function (event) {
      var target = $(event.target.attributes.href ? event.target.attributes.href.value : event.target.parentElement.attributes.href.value);

      if (target.length) {
        event.preventDefault();
        if (fnScrollingState) fnScrollingState(true);
        var topMargin = topMarginSelector ? $(topMarginSelector).outerHeight(true) || 0 : 0;
        $('html, body').animate({
          scrollTop: target.offset().top - topMargin
        }, 500).promise().always(function () {
          if (fnScrollingState) fnScrollingState(false);
        });
      }
    });
    return this;
  };
})(jQuery);
