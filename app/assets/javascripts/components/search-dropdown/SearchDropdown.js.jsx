class SearchDropdown extends React.Component {
  constructor(props) {
    super(props);

    this.perPage = 5;

    this.state = this.emptyState();
  }

  emptyState() {
    return {
      resources: [],
      num_items: 0,
      total_hits: 0,
      visible: false,
      selected: null,
      isSearching: false
    };
  }

  componentDidMount() {
    this.props.searchBus.on('focus', this.onFocus, this);
    this.props.searchBus.on('keyup', this.onKeyUp, this);

    this.boundOnClickDocument = this.onClickDocument.bind(this);
    document.addEventListener('click', this.boundOnClickDocument);
  }

  componentWillUnmount() {
    this.props.searchBus.off('focus', this.onFocus, this);
    this.props.searchBus.off('keyup', this.onKeyUp, this);
    document.removeEventListener('click', this.boundOnClickDocument);
  }

  componentWillReceiveProps(nextProps) {
    const searchTerm = nextProps.filterbar.search_term;
    const searchHasChanged = searchTerm !== this.props.filterbar.search_term;
    const searchExists = _.isString(searchTerm);
    const searchIsEmpty = !searchExists || searchTerm.trim() === '';

    if (searchHasChanged && (!searchExists || searchIsEmpty)) {
      let newState = this.emptyState();
      newState.visible = true;
      this.setState(newState);
    } else {
      // Search, grades or subjects changed
      const hasChanged = !this.naiveCompare(
        nextProps.filterbar,
        this.props.filterbar
      );
      if (!searchIsEmpty && hasChanged) {
        this.fetch(nextProps);
      }
    }
  }

  onClickDocument(e) {
    const container = this.props.searchContainer();
    if (!container) return;

    if (!container.contains(e.target)) {
      this.setInvisible();
    }
  }

  onFocus() {
    this.setVisible();
  }

  onKeyUp(e) {
    const resLength = this.state.resources.length;

    if (resLength == 0) {
      return;
    }

    let selected = this.state.selected;

    const keyCode = e.keyCode;

    if (keyCode === 38) {
      // Up
      if (selected === null) {
        selected = 0;
      }
      selected = selected > 0 ? selected-1 : resLength-1;
    } else if (keyCode == 40) {
      // Down
      if (selected !== null) {
        selected = (selected != resLength-1) ? selected+1 : 0;
      } else {
        selected = 0;
      }
    } else if (keyCode == 13) {
      Turbolinks.visit(this.state.resources[selected].path);
      return;
    }

    this.setState({ ...this.state, selected: selected });
  }

  setVisible() {
    this.setState({ ...this.state, visible: true });
  }

  setInvisible() {
    this.setState({ ...this.state, visible: false });
  }

  buildStateFromResponse(response) {
    const newState = {
      ...this.emptyState(),
      visible: true,
      resources: response.results,
      num_items: response.pagination.num_items,
      total_hits: response.pagination.total_hits
    };

    return newState;
  }

  naiveCompare(a, b) {
    return JSON.stringify(a) === JSON.stringify(b);
  }

  fetch(props = this.props) {
    this.setState({ ...this.state, isSearching: true });

    const url = Routes.search_path({
      per_page: this.perPage,
      search_term: props.filterbar.search_term,
      grades: props.filterbar.grades,
      subjects: props.filterbar.subjects
    });

    return $.getJSON(url).then(response => {
      if (window.ga) {
        ga('send', 'pageview', url);
      }
      this.setState(this.buildStateFromResponse(response));
    });
  }

  render() {
    const results = this.state.visible ?
      <div className='o-search-dropdown'>
        <SearchDropdownResults
          resources={this.state.resources}
          num_items={this.state.num_items}
          total_hits={this.state.total_hits}
          search_term={this.props.filterbar.search_term}
          isSearching={this.state.isSearching}
          selected={this.state.selected} />
      </div>
      : <div className="hide"></div>;

    return results;
  }
}
