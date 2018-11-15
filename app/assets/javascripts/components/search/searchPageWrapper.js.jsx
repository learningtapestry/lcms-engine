// eslint-disable-next-line no-unused-vars
function searchPageWrapper(WrappedComponent) {
  return class extends React.Component {
    constructor(props) {
      super(props);

      this.state = this.buildStateFromProps(props);
    }

    buildStateFromProps(props) {
      return {
        data: props.results,
        per_page: props.pagination.per_page,
        order: props.pagination.order,
        current_page: props.pagination.current_page,
        total_pages: props.pagination.total_pages,
        num_items: props.pagination.num_items,
        total_hits: props.pagination.total_hits,
        filterbar: props.filterbar,
      };
    }

    fetch(newState) {
      const url = Routes.search_path({
        per_page: newState.per_page,
        order: newState.order,
        page: newState.current_page,
        ...newState.filterbar,
      });
      return $.getJSON(url).then(response => {
        if (window.ga) {
          ga('send', 'pageview', url);
        }
        this.setState(this.buildStateFromProps(response));
      });
    }

    handlePageClick(data) {
      let selected = data.selected;
      const newState = _.assign({}, this.state, { current_page: selected + 1 });
      this.fetch(newState);
    }

    componentWillUpdate(nextProps, nextState) {
      urlHistory.updatePaginationParams(nextState);
    }

    pagination() {
      return (<PaginationBoxView previousLabel={<i className="fa-2x ub-angle-left"></i>}
        nextLabel={<i className="fa-2x ub-angle-right"></i>}
        breakLabel={<li className="o-pagination__break">...</li>}
        pageNum={this.state.total_pages}
        initialSelected={this.state.current_page - 1}
        forceSelected={this.state.current_page - 1}
        marginPagesDisplayed={2}
        pageRangeDisplayed={5}
        clickCallback={this.handlePageClick.bind(this)}
        containerClassName={'o-pagination o-page__wrap--row-nest'}
        itemClassName={'o-pagination__item'}
        nextClassName={'o-pagination__item--next'}
        previousClassName={'o-pagination__item--prev'}
        pagesClassName={'o-pagination__item--middle'}
        subContainerClassName={'o-pagination__pages'}
        activeClassName={'o-pagination__page--active'} />);
    }

    render() {
      return(
        <WrappedComponent { ...this.state }
          // eslint-disable-next-line no-undef
          handleFilterBar={ handleFilterbarUpdate.bind(this) }
          pagination={ this.pagination() }
        />
      );
    }
  };
}
