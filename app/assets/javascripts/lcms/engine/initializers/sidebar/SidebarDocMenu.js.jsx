/*
 * TODO: Keep 2 classes for sidebar menu for ld&cg till cg refactoring
 */
class SidebarDocMenu {
  constructor() {
    this.headings = $.makeArray($('.c-ld-toc'));
    this.sidebar = $('#ld-sidebar-menu');
    this._initToggler();
    // this._updateMenu();
  }

  handleUpdate(e) {
    switch(e) {
      case EVENTS.MOBILE_SHOW_MENU:
      case EVENTS.UPDATE_MENU:
        this._updateMenu();
        break;
      case EVENTS.SCROLLING:
        this._showShowAll();
        break;
    }
  }

  _initToggler() {
    this.bExpanded = false;
    $('.o-ld-sidebar-header__toggle--show').click(() => {
      this.sidebar.foundation('down', this.sidebar.find('.o-ld-sidebar__menu.nested'));
      this._showHideAll();
    });
    $('.o-ld-sidebar-header__toggle--hide').click(() => {
      this.sidebar.foundation('hideAll');
      this._showShowAll();
    });
  }

  _updateMenu() {
    const topHeader = $('#ld-sticky-header > .sticky').outerHeight(true) || 0;
    const index = _.findLastIndex(this.headings, (heading) => {
      return heading.getBoundingClientRect().top < (20 + topHeader);
    });
    const heading = this.headings[index];

    $('.o-ld-sidebar__item--active').removeClass('o-ld-sidebar__item--active');

    if (heading) {
      const itemSelector = `.o-ld-sidebar__item [href="#${heading.id}"]`;
      const $item = this.sidebar.find(itemSelector);
      $(itemSelector).parents('.o-ld-sidebar__item').addClass('o-ld-sidebar__item--active');
      if (this.bExpanded) return;
      const $currentBranch = $item.closest('.o-ld-sidebar__item').children('.o-ld-sidebar__menu--nested')
                                  .add($item.parents('.o-ld-sidebar__menu--nested'));
      this.sidebar.foundation('down', $currentBranch.not('[aria-hidden="false"]').not(':animated'));
      const $exceptCurrent = this.sidebar.find('.o-ld-sidebar__menu--nested[aria-hidden="false"]')
                                 .not($currentBranch).not(':animated');
      this.sidebar.foundation('up', $exceptCurrent);
    } else {
      if (!this.bExpanded) {
        const $allExpanded = this.sidebar.find('.o-ld-sidebar__menu--nested[aria-hidden="false"]').not(':animated');
        this.sidebar.foundation('up', $allExpanded);
      }
    }
  }

  _showHideAll() {
    this.bExpanded = true;
    $('.o-ld-sidebar-header__toggle--show').hide();
    $('.o-ld-sidebar-header__toggle--hide').show();
  }

  _showShowAll() {
    this.bExpanded = false;
    $('.o-ld-sidebar-header__toggle--show').show();
    $('.o-ld-sidebar-header__toggle--hide').hide();
  }
}
