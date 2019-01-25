// eslint-disable-next-line no-unused-vars
class MaterialsContainer extends React.Component {
  constructor(props) {
    super(props);
    this.state = {bExpanded: false, activeTab: 0};
    this.toggleView = this.handleToggleView.bind(this);
    this.switchMaterial = this.handleSwitchMaterial.bind(this);
    this.trackOperation = this.trackOp.bind(this, '');
    this.trackOperationCollapsed = this.trackOp.bind(this, 'Collapsed');
  }

  handleSwitchMaterial(idx) {
    this.notifyHeap('Material Switched', idx - 1);
  }

  handleToggleView(newState, idx = 0) {
    this.setState({bExpanded: newState, activeTab: idx});
    const event = `Material ${newState ? 'Expanded' : 'Collapsed'}`;
    this.notifyHeap(event, idx);
  }

  notifyHeap(event, idx) {
    let data = {
      material_id: this.props.data[idx].id,
      material_pdf: this.props.data[idx].pdf,
      material_title: this.props.data[idx].title
    };
    data = _.extend(data, this.props.activity, this.props.lesson);
    heapTrack(event, data);
  }

  renderTab(m, idx) {
    return (
      <Tabs.Panel key={`p-${m.id}`} title={m.subtitle}>
        <ExpandedMaterial key={`exm${m.id}`} index={idx} {...m} onClick={this.trackOperation} onMinimize={this.toggleView}/>
      </Tabs.Panel>
    );
  }

  render() {
    const { data, content_type, subject } = this.props;
    if (!_.includes(['none', 'tm'], content_type)) return null;
    if (content_type === 'tm') {
      return (
        <MaterialsList {...this.props}/>
      );
    }
    let materials = null;
    if (this.state.bExpanded) {
      materials = data.map((m, idx) => this.renderTab(m, idx));
    } else {
      materials = data.map((m, idx) =>
        <CollapsedMaterial key={`cm-${m.id}`} index={idx} onClick={this.trackOperationCollapsed} onPreview={this.toggleView} {...m}/>
      );
    }
    const clsTitle = classNames(
      'u-txt--m-tab-title u-padding-bottom--gutter',
      {'o-m-title--underlined': !this.state.bExpanded }
    );

    const cssClasses = classNames(['u-padding-bottom--gutter', 'o-material-wrapper'],
      {
        [`o-material-wrapper--${subject}`]: !this.props.for_group,
        ['o-material-wrapper--bg-color']: this.props.color,
        ['o-page__section']: !this.props.for_group,
        ['o-material-wrapper--within-group']: this.props.for_group
      }
    );

    return (
      <div className={cssClasses}>
        <div className={clsTitle}>Materials</div>
        { this.state.bExpanded ? (
          <div key="key-m-wrap-expanded" className="o-page__wrap--row">
            <Tabs tabActive={this.state.activeTab + 1} className="o-page__module" onAfterChange={this.switchMaterial}>
              {materials}
            </Tabs>
          </div>
        ) : (
          <div key="key-m-wrap-collapsed" className="o-page__wrap--row-nest">
            {materials}
          </div>
        )
        }
      </div>
    );
  }

  trackOp(type, event, idx) {
    this.notifyHeap(`Material ${type} Click: ${event}`, idx);
  }
}
