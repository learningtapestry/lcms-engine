class SidebarSticky {
  constructor() {
    this.dropdownMenu = $('#ld-dropdown');
    this._handleClickOutsideStickyDropdown();
    this._handleToggle();
    this._hideStikyDropdown();
  }

  handleUpdate(e) {
    switch(e) {
      case EVENTS.SCROLLING:
        this._hideStikyDropdown();
        break;
    }
  }

  _handleClickOutsideStickyDropdown() {
    $(document).on('click', (e) => {
      if (!$(e.target).closest('.c-sticky-header-menu').length) {
        this._hideStikyDropdown();
      }
    });
  }

  _handleToggle() {
    this.dropdownMenu.off('on.zf.toggler').on('on.zf.toggler', () => {
      const $targets = this.dropdownMenu.find('.o-ld-sidebar__item--active').closest('.o-ld-sidebar__menu.nested');
      this.dropdownMenu.find('> .o-ld-sidebar__menu').foundation('down', $targets);
    });
    $('#ld-sitemenu').off('on.zf.toggler').on('on.zf.toggler', () => {
      $('.c-sticky-header-toggle__overlay').addClass('c-sticky-header-toggle__overlay--active');
    });
    $('#ld-sitemenu').off('off.zf.toggler').on('off.zf.toggler', () => {
      $('.c-sticky-header-toggle__overlay').removeClass('c-sticky-header-toggle__overlay--active');
    });
  }

  _hideStikyDropdown() {
    let $openedDropdowns = $('.c-sticky-header-menu[aria-expanded=true]');
    if (!$openedDropdowns.length) return;
    $openedDropdowns.foundation('toggle');
  }
}
