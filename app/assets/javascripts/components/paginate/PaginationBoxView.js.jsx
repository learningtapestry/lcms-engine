// from https://github.com/AdeleD/react-paginate (converted)
'use strict';

class PaginationBoxView extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      selected: props.initialSelected ? props.initialSelected : 0
    };
  }

  componentDidMount() {
    // Call the callback with the initialSelected item:
    if (typeof(this.props.initialSelected) !== 'undefined') {
      //this.callCallback(this.props.initialSelected);
    }
  }

  handlePreviousPage(evt) {
    evt.preventDefault ? evt.preventDefault() : (evt.returnValue = false);
    if (this.state.selected > 0) {
      this.handlePageSelected(this.state.selected - 1, evt);
    }
  }

  handleNextPage(evt) {
    evt.preventDefault ? evt.preventDefault() : (evt.returnValue = false);
    if (this.state.selected < this.props.pageNum - 1) {
      this.handlePageSelected(this.state.selected + 1, evt);
    }
  }

  handlePageSelected(selected, evt) {
    evt.preventDefault ? evt.preventDefault() : (evt.returnValue = false);

    if (this.state.selected === selected) return;

    this.setState({ selected: selected });

    // Call the callback with the new selected item:
    this.callCallback(selected);
  }

  callCallback(selectedItem) {
    if (typeof(this.props.clickCallback) !== 'undefined' &&
        typeof(this.props.clickCallback) === 'function') {
      this.props.clickCallback({ selected: selectedItem });
    }
  }

  render() {
    const previousClasses = classNames(this.props.itemClassName, this.props.previousClassName,
      { [`${this.props.itemClassName}--disabled`]: this.state.selected === 0 });

    const nextClasses = classNames(this.props.itemClassName, this.props.nextClassName,
      { [`${this.props.itemClassName}--disabled`]: this.state.selected === this.props.pageNum - 1 });

    return (
      <ul className={this.props.containerClassName}>
        <li onClick={this.handlePreviousPage.bind(this)} className={previousClasses}>
          <a href="" className={this.props.previousLinkClassName}>{this.props.previousLabel}</a>
        </li>

        <li className={classNames(this.props.itemClassName, this.props.pagesClassName)}>
          <PaginationListView
            onPageSelected={this.handlePageSelected.bind(this)}
            selected={this.state.selected}
            pageNum={this.props.pageNum}
            pageRangeDisplayed={this.props.pageRangeDisplayed}
            marginPagesDisplayed={this.props.marginPagesDisplayed}
            breakLabel={this.props.breakLabel}
            subContainerClassName={this.props.subContainerClassName}
            pageClassName={this.props.pageClassName}
            pageLinkClassName={this.props.pageLinkClassName}
            activeClassName={this.props.activeClassName}
            disabledClassName={this.props.disabledClassName} />
        </li>

        <li onClick={this.handleNextPage.bind(this)} className={nextClasses}>
          <a href="" className={this.props.nextLinkClassName}>{this.props.nextLabel}</a>
        </li>
      </ul>
    );
  }

  componentWillReceiveProps(nextProps) {
    if (typeof nextProps.forceSelected !== 'undefined' && nextProps.forceSelected !== this.state.selected) {
      this.setState({ selected: nextProps.forceSelected });
    }
  }
}

PaginationBoxView.propTypes = {
  pageNum               : PropTypes.number.isRequired,
  pageRangeDisplayed    : PropTypes.number.isRequired,
  marginPagesDisplayed  : PropTypes.number.isRequired,
  previousLabel         : PropTypes.node,
  nextLabel             : PropTypes.node,
  breakLabel            : PropTypes.node,
  clickCallback         : PropTypes.func,
  initialSelected       : PropTypes.number,
  forceSelected         : PropTypes.number,
  containerClassName    : PropTypes.string,
  subContainerClassName : PropTypes.string,
  pagesClassName        : PropTypes.string,
  pageClassName         : PropTypes.string,
  pageLinkClassName     : PropTypes.string,
  activeClassName       : PropTypes.string,
  previousClassName     : PropTypes.string,
  nextClassName         : PropTypes.string,
  itemClassName         : PropTypes.string,
  previousLinkClassName : PropTypes.string,
  nextLinkClassName     : PropTypes.string,
  disabledClassName     : PropTypes.string
};

PaginationBoxView.defaultProps = {
  pageNum              : 10,
  pageRangeDisplayed   : 2,
  marginPagesDisplayed : 3,
  activeClassName      : 'selected',
  previousClassName    : 'previous',
  nextClassName        : 'next',
  previousLabel        : 'Previous',
  nextLabel            : 'Next',
  breakLabel           : '...',
  disabledClassName    : 'disabled'
};
