// from https://github.com/AdeleD/react-paginate (converted)

import React from 'react';
import PageView from './PageView';
import PropTypes from 'prop-types';

class PaginationListView extends React.Component {
  lessPageRangeItems() {
    let result = {};
    for (let index = 0; index < this.props.pageNum; index++) {
      result['key' + index] = this.pageViewElement(index);
    }
    return result;
  }

  pageViewElement(index) {
    return (
      <PageView
        // eslint-disable-next-line react/jsx-no-bind
        onClick={this.props.onPageSelected.bind(null, index)}
        selected={this.props.selected === index}
        pageClassName={this.props.pageClassName}
        pageLinkClassName={this.props.pageLinkClassName}
        activeClassName={this.props.activeClassName}
        page={index + 1}
      />
    );
  }

  render() {
    let items = {};

    if (this.props.pageNum <= this.props.pageRangeDisplayed) {
      items = this.lessPageRangeItems();
    } else {
      let leftSide = this.props.pageRangeDisplayed / 2;
      let rightSide = this.props.pageRangeDisplayed - leftSide;

      if (this.props.selected > this.props.pageNum - this.props.pageRangeDisplayed / 2) {
        rightSide = this.props.pageNum - this.props.selected;
        leftSide = this.props.pageRangeDisplayed - rightSide;
      } else if (this.props.selected < this.props.pageRangeDisplayed / 2) {
        leftSide = this.props.selected;
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

        if (index >= this.props.selected - leftSide && index <= this.props.selected + rightSide) {
          items['key' + index] = pageView;
          continue;
        }

        let keys = Object.keys(items);
        let breakLabelKey = keys[keys.length - 1];
        let breakLabelValue = items[breakLabelKey];

        if (breakLabelValue !== this.props.breakLabel) {
          items['key' + index] = this.props.breakLabel;
        }
      }
    }

    let itemsToRender = [];
    for (let key in Object.keys(items)) {
      itemsToRender.push({
        key: key,
        value: items[key],
      });
    }

    return (
      <ul className={this.props.subContainerClassName}>
        {itemsToRender.map(item => (
          <React.Fragment key={item.key}>{item.value}</React.Fragment>
        ))}
      </ul>
    );
  }
}

PaginationListView.propTypes = {
  pageNum: PropTypes.number.isRequired,
  onPageSelected: PropTypes.func.isRequired,
  selected: PropTypes.number.isRequired,
  pageClassName: PropTypes.string,
  pageLinkClassName: PropTypes.string,
  activeClassName: PropTypes.string,
  pageRangeDisplayed: PropTypes.number.isRequired,
  marginPagesDisplayed: PropTypes.number.isRequired,
  breakLabel: PropTypes.node,
  subContainerClassName: PropTypes.string,
};

export default PaginationListView;
