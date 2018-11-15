// eslint-disable-next-line no-unused-vars
class FilterbarSearch extends React.Component {

  componentWillMount() {
    this.setState({value: this.props.searchTerm || ''});

    this.props.searchBus.on('clearSearch', _e => {
      this.setState({value: ''});
    });

    const debounceTimeout = 500; // 500 msec
    this.debouncedUpdate = _.debounce(function(value) {
      if ('onUpdate' in this.props) {
        this.props.onUpdate( value );
      }
    }, debounceTimeout);
  }

  handleChange (event) {
    this.setState({value: event.target.value || ''});
    this.debouncedUpdate(event.target.value);
  }

  render() {
    const pushToBus = eventName => {
      return e => this.props.searchBus.emit(eventName, e);
    };

    return (
      <div className="o-page__wrap--row">
        <div className="o-filterbar-search__label show-for-ipad">
          <span>{this.props.searchLabel}</span>
        </div>
        <div className="o-filterbar-search__input">
          <input className="o-filterbar-search__field" type="text"
            placeholder='Enter Terms (e.g: writing, geometry, etc)'
            value={this.state.value}
            onKeyUp={pushToBus('keyup')}
            onFocus={pushToBus('focus')}
            onBlur={pushToBus('blur')}
            onChange={e => { pushToBus('change')(e); this.handleChange(e); }}
            ref={r => this.input = r}
          />
          <i className="ub-search o-filterbar-search__icon"></i>
        </div>
      </div>);
  }
}
