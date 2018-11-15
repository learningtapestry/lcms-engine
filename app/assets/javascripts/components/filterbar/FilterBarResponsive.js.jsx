class FilterbarResponsive extends React.Component {
  constructor(props) {
    super(props);
    this.state = { breakpoint: 'xxlarge' };
    this.WINDOW_BREAKPOINT = 768;
    this.WINDOW_BREAKPOINT_NAMES = ['small', 'medium'];
  }

  handleResize(event, newSize, oldSize) {
    if (_.intersection(this.WINDOW_BREAKPOINT_NAMES, [oldSize, newSize]).length > 0) {
      this.setState({ breakpoint: newSize });
    }
  }

  componentDidMount() {
    $(window).on('changed.zf.mediaquery.ubfilterbar', this.handleResize.bind(this));
    if ($(window).width() <  this.WINDOW_BREAKPOINT) {
      this.setState({ breakpoint: this.WINDOW_BREAKPOINT_NAMES[0] });
    }
  }

  componentWillUnmount() {
    $(window).off('changed.zf.mediaquery.ubfilterbar');
  }

  isMobile() {
    return _.indexOf(this.WINDOW_BREAKPOINT_NAMES, this.state.breakpoint) != -1;
  }

  onClickRefine() {
    $(this._modal).addClass('o-filterbar-modal--show');
  }

  handleRefineClick() {
    $(this._modal).removeClass('o-filterbar-modal--show');
  }

  render() {
    if (this.isMobile()) {
      const withSearch = this.props.withDropdown ? false: this.props.withSearch;
      return (
        <div className="text-center">
          <a className="o-btn o-btn--yellow u-margin-bottom--large" onClick={this.onClickRefine.bind(this)}>Refine Results</a>
          <div className="o-filterbar-modal" ref={(ref) => this._modal = ref}>
            <Filterbar
               {...this.props}
                withDropdown={false}
                withSearch={withSearch}
                onRefine={this.handleRefineClick.bind(this)} />
            <button className="close-button ub-close-button" aria-label="Close modal" type="button" onClick={this.handleRefineClick.bind(this)}>
              <span aria-hidden="true"><i className="ub-close"></i></span>
            </button>
          </div>
        </div>
      );
    }
    return (
      <Filterbar {...this.props}/>
    );
  }

}
