window.initializeSubscribePlaceholder = function() {
  function setPlaceholder() {
    $('#mce-EMAIL').attr('placeholder',
      ($(window).width() < 640) ? 'Enter your email address' :
      'Enter your email address, and we will be in touch soon.');
  }

  $(window).resize(setPlaceholder);
  setPlaceholder();
};
