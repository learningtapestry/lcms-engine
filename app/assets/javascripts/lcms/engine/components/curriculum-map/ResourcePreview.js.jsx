class ResourcePreview extends React.Component {
  constructor(props) {
    super(props);
    this.hOffset = 30;
  }

  render() {
    const props = this.props;
    let styles;
    if (props.isHovering) {
      let $anchorDims = Foundation.Box.GetDimensions(props.anchor);
      styles = { left: $anchorDims.offset.left + $anchorDims.width + this.hOffset,
                 top: $anchorDims.offset.top
                };
    }
    const cssStyles = classNames( 'dropdown-pane', 'o-resource__preview',
                                 { 'is-open': props.isHovering });
    const previewTitle = `${_.capitalize(props.resource.short_title)} - ${props.resource.title}`;

    return (
      <div className={cssStyles} style={styles}>
        <div className='u-txt--resource-preview-title'>
          {previewTitle}
        </div>
        <div className='u-txt--resource-preview-body'>{props.resource.teaser}</div>
      </div>
    );
  }
}
