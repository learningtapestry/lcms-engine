// eslint-disable-next-line no-unused-vars
class CurriculumMapModule extends React.Component {
  constructor(props) {
    super(props);
    this.state = { isHovering: false, resource: { title: '' } };
    this._handlePopupState = this.handlePopupState.bind(this);
    this.WINDOW_BREAKPOINT = 768;
  }

  handlePopupState(newState) {
    if ((newState === this.state) || ($(window).width() < this.WINDOW_BREAKPOINT)) return;
    this.setState(newState);
  }

  render() {
    const props = this.props;
    const curriculum = props.curriculum;
    const isActive = _.includes(props.active, curriculum.id);
    const cssClasses = classNames(
      [ `o-c-map__module ${props.mapType}-module--${props.subject}`],
      {
        [`${props.mapType}-bg--base`]: !isActive,
        [`${props.mapType}-bg--${props.colorCode} ${props.mapType}-bg--active`]: isActive
      }
    );

    const units = isActive ? curriculum.children.map(
      unit =>
        <CurriculumMapUnit blank={props.blank}
          key={unit.resource.id}
          curriculum={unit}
          colorCode={props.colorCode}
          isActiveBranch={_.first(props.active) === curriculum.id}
          active={props.active}
          mapType={props.mapType}
          handlePopupState={this._handlePopupState} />
    ) : null;
    return (
      <div>
        <div className='o-c-map__module-wrap' ref={ (m) => this.domModule = m }>
          <ResourceHover blank={props.blank}
            cssClasses={cssClasses}
            styles={props.styles}
            resource={curriculum.resource}
            resourceHtml={curriculum.resource.short_title}
            handlePopupState={this._handlePopupState} />
          <ResourcePreview anchor={this.domModule}
            isHovering={this.state.isHovering}
            resource={this.state.resource} />
        </div>
        <div className='o-c-map__units-wrap'>
          <div className='o-c-map__units'>
            {units}
          </div>
        </div>
      </div>
    );
  }
}
