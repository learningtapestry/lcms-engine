(function($) {
  $.fn.smoothscrolling = function(fnScrollingState, topMarginSelector = null) {
    this.find('a[href^="#"], div[href^="#"]').on('click', function(event) {
      const target = $(event.target.attributes.href ? event.target.attributes.href.value : event.target.parentElement.attributes.href.value);
      if( target.length ) {
        event.preventDefault();
        if (fnScrollingState) fnScrollingState(true);
        const topMargin = topMarginSelector ? $(topMarginSelector).outerHeight(true) || 0 : 0;
        $('html, body').animate({ scrollTop: target.offset().top - topMargin }, 500)
                       .promise()
                       .always(function() { if (fnScrollingState) fnScrollingState(false); });
      }
    });
    return this;
  };

})(jQuery);
