"use strict";

window.initializeAboutPeople = function () {
  $('.c-stp-staff__dsc').on('on.zf.toggler', function (e) {
    var elements = ".c-stp-staff__dsc[id!=\"".concat(this.id, "\"]");
    $(elements).removeClass('u-show');
  });
};
