// copy with just changes css classes from https://github.com/pedronauck/react-simpletabs
// eslint-disable-next-line no-undef
const Tabs = createReactClass({
  displayName: 'Tabs',
  propTypes: {
    className: PropTypes.oneOfType([
      PropTypes.array,
      PropTypes.string,
      PropTypes.object
    ]),
    tabActive: PropTypes.number,
    onMount: PropTypes.func,
    onBeforeChange: PropTypes.func,
    onAfterChange: PropTypes.func,
    children: PropTypes.oneOfType([
      PropTypes.array,
      PropTypes.element
    ]).isRequired
  },
  getDefaultProps () {
    return { tabActive: 1 };
  },
  getInitialState () {
    return {
      tabActive: this.props.tabActive
    };
  },
  componentDidMount() {
    const index = this.state.tabActive;
    const $selectedPanel = this.refs['o-tab__panel'];
    const $selectedMenu = this.refs[`o-tab-menu-${index}`];

    if (this.props.onMount) {
      this.props.onMount(index, $selectedPanel, $selectedMenu);
    }
  },
  componentWillReceiveProps: function(newProps){
    if(newProps.tabActive && newProps.tabActive !== this.props.tabActive){
      this.setState({ tabActive: newProps.tabActive });
    }
  },
  render () {
    const className = classNames('o-tab', this.props.className);
    return (
      <div className={className}>
        {this._getMenuItems()}
        {this._getSelectedPanel()}
      </div>
    );
  },
  setActive(index, e) {
    e.preventDefault();

    const onAfterChange = this.props.onAfterChange;
    const onBeforeChange = this.props.onBeforeChange;
    const $selectedPanel = this.refs['o-tab__panel'];
    const $selectedTabMenu = this.refs[`o-tab-menu-${index}`];

    if (onBeforeChange) {
      const cancel = onBeforeChange(index, $selectedPanel, $selectedTabMenu);
      if(cancel === false){ return; }
    }

    this.setState({ tabActive: index }, () => {
      if (onAfterChange) {
        onAfterChange(index, $selectedPanel, $selectedTabMenu);
      }
    });
  },
  _getMenuItems () {
    if (!this.props.children) {
      throw new Error('Tabs must contain at least one Tabs.Panel');
    }

    if (!Array.isArray(this.props.children)) {
      this.props.children = [this.props.children];
    }

    const $menuItems = this.props.children
      .map($panel => typeof $panel === 'function' ? $panel() : $panel)
      .filter($panel => $panel)
      .map(($panel, index) => {
        const ref = `o-tab-menu-${index + 1}`;
        const title = $panel.props.title;
        const classes = classNames(
          'o-tab-menu__item',
          { 'o-tab-menu__item--active': this.state.tabActive === (index + 1) }
        );

        return (
          <li ref={ref} key={index} className={classes}>
            <a onClick={this.setActive.bind(this, index + 1)} className="u-preserve-style">
              {title}
            </a>
          </li>
        );
      });

    return (
      <nav className="o-tab__navigation">
        <ul className="o-tab-menu">{$menuItems}</ul>
      </nav>
    );
  },
  _getSelectedPanel () {
    const index = this.state.tabActive - 1;
    const $panel = this.props.children[index];

    return (
      <div ref="o-tab__panel" className="o-tab__panel">
        {$panel}
      </div>
    );
  }
});

// eslint-disable-next-line no-undef
Tabs.Panel = createReactClass({
  displayName: 'Panel',
  propTypes: {
    title: PropTypes.string.isRequired,
    children: PropTypes.oneOfType([
      PropTypes.array,
      PropTypes.element
    ]).isRequired
  },
  render () {
    return <div>{this.props.children}</div>;
  }
});
