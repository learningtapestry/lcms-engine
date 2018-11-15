// from https://github.com/AdeleD/react-paginate (converted)
'use strict';

// eslint-disable-next-line no-unused-vars
class PaginationListView extends React.Component {
  lessPageRangeItems() {
    let result = {};
    for (let index = 0; index < this.props.pageNum; index++) {
      result['key' + index] = this.pageViewElement(index);
    }
    return result;
  }

  pageViewElement(index) {
    return (<PageView
      onClick={this.props.onPageSelected.bind(null, index)}
      selected={this.props.selected === index}
      pageClassName={this.props.pageClassName}
      pageLinkClassName={this.props.pageLinkClassName}
      activeClassName={this.props.activeClassName}
      page={index + 1} />);
  }

  render() {
    let items = {};

    if (this.props.pageNum <= this.props.pageRangeDisplayed) {
      items = this.lessPageRangeItems();
    } else {
      let leftSide  = (this.props.pageRangeDisplayed / 2);
      let rightSide = (this.props.pageRangeDisplayed - leftSide);

      if (this.props.selected > this.props.pageNum - this.props.pageRangeDisplayed / 2) {
        rightSide = this.props.pageNum - this.props.selected;
        leftSide  = this.props.pageRangeDisplayed - rightSide;
      }
      else if (this.props.selected < this.props.pageRangeDisplayed / 2) {
        leftSide  = this.props.selected;
        rightSide = this.props.pageRangeDisplayed - leftSide;
      }

      let index;
      let page;

      for (index = 0; index < this.props.pageNum; index++) {
        page = index + 1;
        const pageView = this.pageViewElement(index);

        if (page <= this.props.marginPagesDisplayed) {
          items['key' + index] = pageView;
          continue;
        }

        if (page > this.props.pageNum - this.props.marginPagesDisplayed) {
          items['key' + index] = pageView;
          continue;
        }

        if ((index >= this.props.selected - leftSide) && (index <= this.props.selected + rightSide)) {
          items['key' + index] = pageView;
          continue;
        }

        let keys            = Object.keys(items);
        let breakLabelKey   = keys[keys.length - 1];
        let breakLabelValue = items[breakLabelKey];

        if (breakLabelValue !== this.props.breakLabel) {
          items['key' + index] = this.props.breakLabel;
        }
      }
    }

    return (
      <ul className={this.props.subContainerClassName}>
        {React.addons.createFragment(items)}
      </ul>
    );
  }
}
