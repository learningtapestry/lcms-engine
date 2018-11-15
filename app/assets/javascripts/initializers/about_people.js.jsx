window.initializeAboutPeople = () => {
  $('.c-stp-staff__dsc').on('on.zf.toggler', function(e) {
    const elements = `.c-stp-staff__dsc[id!="${this.id}"]`;
    $(elements).removeClass('u-show');
  });
}
