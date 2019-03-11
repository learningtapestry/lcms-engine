(function () {
  function initSCWidgets() {
    let arrWidgets = [];
    $('.c-cg-media__podcast').each((i, el) => {
      let id = el.id;
      let podcast = $(el).parent();
      let start = podcast.data('start');
      let stop = podcast.data('stop');

      let widget = SC.Widget(document.querySelector(`#${id} iframe`));
      arrWidgets.push({
        widget: widget,
        start: start ? parseInt(start) : 0,
        stop: stop ? parseInt(stop) : 0
      });
    });

    _.each(arrWidgets, (p) => {
      p.widget.bind(SC.Widget.Events.READY, () => {
        p.widget.bind(SC.Widget.Events.FINISH, () => {
          p.widget.seekTo(p.start * 1000);
          p.widget.unbind(SC.Widget.Events.PLAY_PROGRESS);
          p.widget.unbind(SC.Widget.Events.FINISH);
        });
        p.widget.bind(SC.Widget.Events.PLAY_PROGRESS, (e) => {
          let cp = Math.round(e.currentPosition / 1000);
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

  window.initializeSoundCloud = () => {
    const lessons = $('.o-page--ld').length > 0;
    const podcasts = $('.c-cg-media__podcast').length > 0;

    if (!(lessons || podcasts)) return;

    let sc = window.loadJSAsync('//w.soundcloud.com/player/api.js');
    sc.then(() => initSCWidgets());
  };
})();
