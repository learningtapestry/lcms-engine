const SCROLLING_TOPBUTTON_OFFSET = 300;

class TopScroll {
  constructor() {
    if (!$('.o-top-scroll-button').length) return;
    this.topButton = $('.o-top-scroll-button');
    this.topButton.click(() => {
      $('html, body').animate({ scrollTop: 0 }, 700);
      return false;
    });
  }

  handleUpdate(e) {
    if (!this.topButton || e != EVENTS.SCROLL) return;
    if ($(document).scrollTop() > SCROLLING_TOPBUTTON_OFFSET) {
      this.topButton.fadeIn('slow');
    } else {
      this.topButton.fadeOut('slow');
    }
  }
}
