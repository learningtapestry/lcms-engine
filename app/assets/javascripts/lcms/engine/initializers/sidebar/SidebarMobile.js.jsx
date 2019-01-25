class SidebarMobile {
  constructor() {
  }

  handleUpdate(e) {
    switch (e) {
      case EVENTS.MOBILE_HIDE:
        this._hide();
        break;
      case EVENTS.MOBILE_SHOW:
        this._show();
        break;
      case EVENTS.MOBILE_SHOW_MENU:
        this._hide();
        this._showModal();
        break;
      case EVENTS.SCROLLING:
        this._hide();
        this._hideModal();
        break;
    }
  }

  _hide() {
    $('#cg-sidebar-xs').removeClass('o-sidebar-xs--show');
    $('#cg-sidebar-container').addClass('o-sidebar--tiny');
  }

  _hideModal() {
    $('#cg-contents-modal').foundation('close');
  }

  _show() {
    $('#cg-sidebar-xs').addClass('o-sidebar-xs--show');
    $('#cg-sidebar-container').removeClass('o-sidebar--tiny');
  }

  _showModal() {
    let $targets = $('li.expanded > ul.nested');
    $('#cg-menu-modal').foundation('down', $targets);
    $('#cg-contents-modal').foundation('open');
  }
}
