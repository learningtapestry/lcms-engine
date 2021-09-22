// from https://github.com/AdeleD/react-paginate (converted)

import React from 'react';
import PropTypes from 'prop-types';

// eslint-disable-next-line no-unused-vars
class PageView extends React.Component {
  render() {
    const linkClassName = this.props.pageLinkClassName;
    let cssClassName = this.props.pageClassName;

    if (this.props.selected) {
      if (typeof cssClassName !== 'undefined') {
        cssClassName = cssClassName + ' ' + this.props.activeClassName;
      } else {
        cssClassName = this.props.activeClassName;
      }
    }

    /* eslint-disable jsx-a11y/anchor-is-valid */
    return (
      <li className={cssClassName}>
        <a onClick={this.props.onClick} className={linkClassName}>
          {this.props.page}
        </a>
      </li>
    );
    /* eslint-enable jsx-a11y/anchor-is-valid */
  }
}

PageView.propTypes = {
  pageLinkClassName: PropTypes.string,
  pageClassName: PropTypes.string,
  selected: PropTypes.bool,
  activeClassName: PropTypes.string,
  onClick: PropTypes.func.isRequired,
  page: PropTypes.number,
};

export default PageView;
