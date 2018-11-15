/*
 * TODO: Keep 2 classes for sidebar menu for ld&cg till cg refactoring
 */
class SidebarCGMenu {
  constructor() {
    this.headings = $.makeArray($('.c-cg-heading'));
    this._updateMenu();
  }

  handleUpdate(e) {
    switch(e) {
      case EVENTS.MOBILE_SHOW_MENU:
      case EVENTS.UPDATE_MENU:
        this._updateMenu();
        break;
    }
  }

  _updateMenu() {
    const topHeader = $('#cg-sidebar-xs').outerHeight(true);
    const index = _.findLastIndex(this.headings, function(heading) {
      return heading.getBoundingClientRect().bottom < (50 + topHeader);
    });
    if (index == -1) return;
    const heading = this.headings[index];

    $('.o-sidebar-nav .active').removeClass('active');
    $('.o-sidebar-nav__item').removeClass('expanded');

    if (heading) {
      var $item = $('.o-sidebar-nav__item [href="#' + heading.id + '"]');
      $item.addClass('active').addClass('expanded');
      $item.parent('a').addClass('active');
      $item.parents('.o-sidebar-nav__item').addClass('expanded');
    }
  }
}
