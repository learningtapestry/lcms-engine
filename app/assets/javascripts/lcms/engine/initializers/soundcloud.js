"use strict";

(function () {
  function initSCWidgets() {
    var arrWidgets = [];
    $('.c-cg-media__podcast').each(function (i, el) {
      var id = el.id;
      var podcast = $(el).parent();
      var start = podcast.data('start');
      var stop = podcast.data('stop');
      var widget = SC.Widget(document.querySelector("#".concat(id, " iframe")));
      arrWidgets.push({
        widget: widget,
        start: start ? parseInt(start) : 0,
        stop: stop ? parseInt(stop) : 0
      });
    });

    _.each(arrWidgets, function (p) {
      p.widget.bind(SC.Widget.Events.READY, function () {
        p.widget.bind(SC.Widget.Events.FINISH, function () {
          p.widget.seekTo(p.start * 1000);
          p.widget.unbind(SC.Widget.Events.PLAY_PROGRESS);
          p.widget.unbind(SC.Widget.Events.FINISH);
        });
        p.widget.bind(SC.Widget.Events.PLAY_PROGRESS, function (e) {
          var cp = Math.round(e.currentPosition / 1000);

          if (cp < p.start) {
            p.widget.seekTo(p.start * 1000);
          }

          if (p.stop !== 0 && cp === p.stop) {
            p.widget.pause();
            p.widget.seekTo(p.start * 1000);
            p.widget.unbind(SC.Widget.Events.PLAY_PROGRESS);
          }
        });
      });
    });
  }

  window.initializeSoundCloud = function () {
    var lessons = $('.o-page--ld').length > 0;
    var podcasts = $('.c-cg-media__podcast').length > 0;
    if (!(lessons || podcasts)) return;
    var sc = window.loadJSAsync('//w.soundcloud.com/player/api.js');
    sc.then(function () {
      return initSCWidgets();
    });
  };
})();
