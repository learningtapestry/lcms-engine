"use strict";

(function () {
  function initSurvey() {
    $('.o-survey-form #survey_form_district_or_system').change(function (ev) {
      return toggleOther(ev.target);
    });
    $('.o-survey-form #survey_form_subject_or_grade').change(function (ev) {
      return toggleOther(ev.target);
    });
    $('.o-survey-form #survey_form_additional_period').change(function (ev) {
      return toggleOther(ev.target);
    });
  }

  function toggleOther(target) {
    var el = $(target);
    var other = el.parent().siblings('.o-survey-form__other');

    if (el.val() === 'Other' || el.val() === 'Yes') {
      other.slideDown('fast');
    } else {
      other.slideUp('fast');
    }
  }

  window.initializeSurvey = function () {
    if (!$('.o-survey-form').length) return;
    initSurvey();
  };
})();
