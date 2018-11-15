const EVENTS = {
  MENU_COLLAPSE: 1,
  MOBILE_HIDE: 2,
  MOBILE_SHOW: 4,
  MOBILE_SHOW_MENU: 8,
  SCROLL: 16,
  UPDATE_MENU: 32
};

const SCROLLING_THRESHOLD = 15;

// eslint-disable-next-line no-unused-vars
class SideBar {
  constructor(observers, opts) {
    _.assign(this, opts);
    this.observers = observers;
    this._clear();
    this._initSticky();
    this._initScroll();
  }

  update(e) {
    _.forEach(this.observers, o => o.handleUpdate(e));
  }

  _clear() {
    this.isScrolling = false;
    this.lastScrollTop = 0;
  }

  _initScroll() {
    $(`.o-page--${this.clsPrefix}, #${this.clsPrefix}-contents-modal, #${this.clsPrefix}-dropdown`)
      .smoothscrolling(s => this._setScrollingState(s), `#${this.clsPrefix}-sticky-header > .sticky`);
    $(`#${this.clsPrefix}-page`).off('scrollme.zf.trigger')
      .on('scrollme.zf.trigger', () => this._handleScroll());
  }

  _initSticky() {
    let sidebar = document.getElementById(`${this.clsPrefix}-sidebar`);
    if (sidebar === null) return;
    new Foundation.Sticky($(sidebar),
      {
        checkEvery: 0,
        stickyOn: 'small',
        anchor: `c-${this.clsPrefix}-content`,
        marginTop: 0
      });
    $(window).trigger('load.zf.sticky');
    $(window).off('sticky.zf.unstuckfrom:top').on('sticky.zf.unstuckfrom:top', () => {
      this.update(EVENTS.MOBILE_HIDE);
      this._clear();
    });
  }

  _handleMobileScroll() {
    if (!this.bHandleMobile) return;
    if (this.isScrolling || !$(`#${this.clsPrefix}-sidebar.is-stuck`).length) return;
    const st = $(window).scrollTop();
    if (st < this.lastScrollTop - SCROLLING_THRESHOLD) {
      this.update(EVENTS.MOBILE_SHOW);
      $('#cg-sidebar-xs__action').unbind().click((e) => {
        e.preventDefault();
        this.update(EVENTS.MOBILE_SHOW_MENU);
      });
    }
    if (st > this.lastScrollTop + SCROLLING_THRESHOLD) this.update(EVENTS.MOBILE_HIDE);
    this.lastScrollTop = st;
  }

  _handleScroll() {
    if (this.isScrolling) return;
    if (Foundation.MediaQuery.atLeast('ipad')) {
      this._clear();
      this.update(EVENTS.UPDATE_MENU);
    } else {
      this._handleMobileScroll();
    }
    this.update(EVENTS.SCROLL);
  }

  _setScrollingState(state) {
    this.isScrolling = state;
    this.lastScrollTop = $(window).scrollTop();
    this.isScrolling ? this.update(EVENTS.SCROLLING) : this._handleScroll();
  }
}
