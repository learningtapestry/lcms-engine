// from https://github.com/AdeleD/react-paginate (converted)
'use strict';

// eslint-disable-next-line no-unused-vars
class PageView extends React.Component {
  render() {
    const linkClassName = this.props.pageLinkClassName;
    let cssClassName = this.props.pageClassName;

    if (this.props.selected) {
      if (typeof(cssClassName) !== 'undefined') {
        cssClassName = cssClassName + ' ' + this.props.activeClassName;
      } else {
        cssClassName = this.props.activeClassName;
      }
    }

    return (
      <li className={cssClassName}>
        <a onClick={this.props.onClick} className={linkClassName}>
          {this.props.page}
        </a>
      </li>
    );
  }
}
