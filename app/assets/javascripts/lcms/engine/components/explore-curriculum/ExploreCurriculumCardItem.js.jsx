// eslint-disable-next-line no-unused-vars
class ExploreCurriculumCardItem extends React.Component {
  componentDidMount() {
    if (this._dropdown) {
      new Foundation.DropdownMenu($(this._dropdown),
        { 'alignment': 'right',
          'forceFollow': false,
          'closingTime': Modernizr.touchevents ? 0 : 5000 });
    }
  }

  componentWillUnmount() {
    if (this._dropdown) {
      $(this._dropdown).foundation('destroy');
    }
  }

  render() {
    const props = this.props;
    const resource = props.curriculum.resource;
    const hasDownloads = resource.downloads && resource.downloads.length > 0;
    const hasRelated = resource.has_related;
    const colorCode = props.colorCode;

    const curriculumComponent = {
      // eslint-disable-next-line no-undef
      'grade': ExploreCurriculumGradeMap,
      // eslint-disable-next-line no-undef
      'module': ExploreCurriculumModuleMap,
      // eslint-disable-next-line no-undef
      'unit': ExploreCurriculumUnitMap,
      // eslint-disable-next-line no-undef
      'lesson': ExploreCurriculumGradeMap
    }[props.curriculum.type];

    const curriculumMap = React.createElement(curriculumComponent, {
      expanded: props.shouldItemExpand,
      curriculum: props.curriculum,
      colorCode: colorCode
    });

    const cssClasses = classNames(
      'o-cur-card',
      `o-cur-card-hover--${props.colorCode}`,
      { [`o-cur-card-active--${props.colorCode}`]: props.isActive},
      { 'o-cur-card--short': !props.shouldItemExpand },
      `o-cur-card--${props.curriculum.type}`
    );

    const cssBodyClasses = classNames(
      'o-cur-card__body',
      { 'o-cur-card__body--medium': props.shouldItemExpand },
      { 'o-cur-card__body--short': !props.shouldItemExpand }
    );

    const cssActionClasses = classNames(
      'o-cur-card__actions',
      {'o-cur-card__actions--short': !props.shouldItemExpand },
      {'u-hidden': _.includes(['grade', 'module'], props.curriculum.type) || resource.is_assessment}
    );

    const cssActionDropdownClasses = classNames(
      'o-cur-card__menu o-cur-card__menu--short o-cur-card--show-short',
      {'u-hidden': _.includes(['grade', 'module'], props.curriculum.type)}
    );

    const cssDownloadBtnClasses = classNames(
      'o-ub-btn', 'o-ub-btn--bordered', 'o-ub-btn--curriculum',
      {'o-ub-btn--disabled': !hasDownloads }
    );

    const cssRelatedBtnClasses = classNames(
      'o-ub-btn', 'o-ub-btn--bordered', 'o-ub-btn--curriculum',
      {'o-ub-btn--disabled': !hasRelated }
    );

    const cssDownloadLinkClasses = classNames(
      {'u-link--disabled': !hasDownloads }
    );

    const cssHeaderClasses = classNames(
      `cs-txt--${colorCode}`,
      {'o-title__type o-title__type--top-align': props.shouldItemExpand},
      {'o-title__type--short': !props.shouldItemExpand },
      {'u-hidden': resource.is_assessment}
    );

    const cssTitleClasses = classNames(
      {'u-txt--card-title-medium': props.shouldItemExpand && !resource.is_assessment },
      {'u-txt--card-title-short': !props.shouldItemExpand && !resource.is_assessment },
      {'u-txt--card-assesment-medium': props.shouldItemExpand && resource.is_assessment },
      {'u-txt--card-assesment-short': !props.shouldItemExpand && resource.is_assessment }
    );

    const cssShow = classNames(
      'u-hidden'
    );

    const resourceType = resource.type.name === 'grade' ? 'curriculum' : resource.type.name;
    const downloadBtnLabel = `Download ${_.capitalize(resourceType)}`;
    const downloadModalId = `downloads-modal-${resource.id}`;

    return (
      <div id={props.curriculum.id} name={resource.path} onClick={props.onClickElement} className={cssClasses} data-magellanhash-target>
        {curriculumMap}
        <div className={cssBodyClasses}>
          <div className="o-title u-text--uppercase show-for-ipad">
            <span className={cssHeaderClasses}>{resource.short_title}</span>
            <span className={`${cssShow} o-title__duration o-cur-card--show-medium`}><TimeToTeach duration={resource.time_to_teach} /></span>
          </div>
          <h3 className={cssTitleClasses}>{resource.title}</h3>
          <div className={`${cssShow} o-title u-text--uppercase hide-for-ipad u-padding-top--xs`}>
            <span className="o-title__duration u-float-none"><TimeToTeach duration={resource.time_to_teach} /></span>
          </div>
          <div className="o-cur-card--show-medium o-cur-card__dsc">{resource.teaser}</div>
        </div>
        <div className={cssActionClasses}>
          <ul className="o-cur-card__menu o-cur-card__menu--medium o-cur-card--show-medium">
            <li>
              <a className="o-ub-btn o-ub-btn--yellow o-ub-btn--subtle" href={resource.path}>
                View Details
              </a>
            </li>
            <li>
              <a className={cssDownloadBtnClasses} data-open={downloadModalId}>
                {downloadBtnLabel}
              </a>
            </li>
            <li>
              <a className={cssRelatedBtnClasses} href={`${resource.path}#related-instruction`}>
                Related Resources
              </a>
            </li>
          </ul>
          <div className={`${cssHeaderClasses} u-text--uppercase hide-for-ipad`}>
            {resource.short_title}
          </div>
          <ul className={cssActionDropdownClasses} ref={(ref) => this._dropdown = ref}>
            <li>
              <a href="" data-turbolinks="false" className="o-cur-card__ellipsis"><i className="ub-ellipsis fa-3x"></i></a>
              <ul className="menu">
                <li><a href={resource.path}>View Details</a></li>
                <li><a className={cssDownloadLinkClasses} data-open={downloadModalId}>{downloadBtnLabel}</a></li>
                <li><a className="u-link--disabled">Related Instruction</a></li>
              </ul>
            </li>
          </ul>
        </div>
      </div>
    );
  }
}
