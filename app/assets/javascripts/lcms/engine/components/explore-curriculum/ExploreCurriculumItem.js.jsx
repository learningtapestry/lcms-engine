// eslint-disable-next-line no-unused-vars
class ExploreCurriculumItem extends React.Component {
  curriculum() {
    return this.props.index[this.props.id];
  }

  downloadModal() {
    const resource = this.curriculum().resource;
    return (resource.downloads && resource.downloads.length > 0) ?
      <DownloadModal resource={resource} /> : '';
  }

  render() {
    const props = this.props;
    const curriculum = this.curriculum();
    const colorCode = colorCodeCss(curriculum.resource.subject, curriculum.resource.grade);

    // An item should expand if its parent is the last parent in the active branch.
    // Collapsed Grade -> Collapsed Mod -> Expanded Unit 1, Unit 2, Unit 3
    const activeParent = props.index[props.active[props.active.length - 2]];
    const shouldItemExpand = props.active.length === 1 ||
      _.some(activeParent.children, c => c.id === props.id);
    const isItemActive = props.active.length > 1 && props.active[props.active.length - 2] === props.id;

    let onClickItem = shouldItemExpand ? props.onClickViewDetails.bind(this, props.parentage) : props.onClickExpand.bind(this, props.parentage);
    if (curriculum.resource.is_assessment) {
      onClickItem = function() { location.href = curriculum.resource.path; };
    }

    const item =
      <ExploreCurriculumCardItem
        curriculum={curriculum}
        onClickElement={onClickItem}
        shouldItemExpand={shouldItemExpand}
        isActive={isItemActive}
        colorCode={colorCode} />;

    // Children should be rendered if the item is a parent in the active branch.
    const shouldRenderChildren = props.active.length > 1 &&
      _.includes(props.active, props.id) &&
      _.last(props.active) !== props.id;

    const cssClasses = classNames( 'c-ec-cards__children',
      { 'c-ec-cards__children--lessons': curriculum.type === 'unit',
        'c-ec-cards__children--expanded': shouldRenderChildren });

    const children = _.filter(curriculum.children, x => !x.resource.is_opr);

    const childrenElements = shouldRenderChildren ?
      children.map(c => (
        c.type === 'lesson' ?
          <LessonCard key={c.resource.id} lesson={c.resource} with_breadcrumb={false} colorCode={colorCode} /> :
          <ExploreCurriculumItem
            key={c.id}
            id={c.id}
            index={props.index}
            onClickExpand={props.onClickExpand}
            onClickViewDetails={props.onClickViewDetails}
            parentage={[...props.parentage, c.id]}
            active={props.active} />
      )) : [];

    const shouldRenderOpr = shouldRenderChildren && curriculum.type === 'unit';
    const opr = shouldRenderOpr ? <ExploreCurriculumOpr colorCode={colorCode} curriculum={curriculum}/> : [];

    return (
      <div>
        {item}
        {opr}
        {/*TODO: add React.addons.CSSTransitionGroup for animation*/}
        <div className={cssClasses}>
          {childrenElements}
        </div>
        {this.downloadModal()}
      </div>
    );
  }
}
