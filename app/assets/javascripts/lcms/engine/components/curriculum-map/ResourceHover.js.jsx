// eslint-disable-next-line no-unused-vars
class ResourceHover extends React.Component {
  handleMouseOver () {
    if (Modernizr.touchevents) return;
    const newState = { isHovering: true, resource: this.props.resource };
    this.props.handlePopupState(newState);
  }

  handleMouseOut () {
    if (Modernizr.touchevents) return;
    const newState = { isHovering: false, resource: this.props.resource };
    this.props.handlePopupState(newState);
  }

  render () {
    const props = this.props;
    return (
      <a href={props.resource.path}
        className={props.cssClasses}
        style={props.styles}
        target={props.blank ? '_blank' : ''}
        onMouseOver={this.handleMouseOver.bind(this)}
        onMouseOut={this.handleMouseOut.bind(this)}>{props.resourceHtml}
      </a>
    );
  }
}
