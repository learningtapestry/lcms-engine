// eslint-disable-next-line no-unused-vars
function pickerWindowWrapper(WrappedComponent, path) {
  return class extends React.Component {
    constructor(props) {
      super(props);

      this.state = {
        results: [],
        pagination: {
          current_page: 1,
          total_pages: 0
        },
        q: null
      };
    }

    componentDidMount() {
      this.fetch();
    }

    fetch() {
      const data = {
        page: this.state.pagination.current_page,
        q: this.state.q
      };
      const url = Routes[path].call(this, { ...data, ...this.props });
      $.getJSON(url).then(x => this.setState({ ...x }));
    }

    onFilterChange(field, event) {
      this.setState({ [field]: event.target.value }, this.fetch);
    }

    pageClick(data) {
      const selected = data.selected;
      this.setState({
        ...this.state,
        pagination: {
          ...this.state.pagination,
          current_page: selected + 1
        }
      }, this.fetch);
    }

    pagination() {
      const breakLabel = <li className="break"><a href="javascript:">...</a></li>;
      return (
        <PaginationBoxView previousLabel={'< Previous'}
          nextLabel={ 'Next >' }
          breakLabel={ breakLabel }
          pageNum={ this.state.pagination.total_pages }
          initialSelected={ this.state.pagination.current_page - 1 }
          forceSelected={ this.state.pagination.current_page - 1 }
          marginPagesDisplayed={ 2 }
          pageRangeDisplayed={ 5 }
          clickCallback={ this.pageClick.bind(this) }
          containerClassName={ 'o-pagination o-page__wrap--row-nest' }
          itemClassName={ 'o-pagination__item' }
          nextClassName={ 'o-pagination__item--next' }
          previousClassName={ 'o-pagination__item--prev' }
          pagesClassName={ 'o-pagination__item--middle' }
          subContainerClassName={ 'o-pagination__pages' }
          activeClassName={ 'o-pagination__page--active' } />
      );
    }

    render() {
      return (
        <div className="o-picker">
          <WrappedComponent { ...this.state } { ...this.props }
            onFilterChange={ this.onFilterChange.bind(this) }
            pagination={ this.pagination.bind(this) }
          />
        </div>
      );
    }
  };
}
