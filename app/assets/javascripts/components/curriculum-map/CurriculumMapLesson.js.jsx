// eslint-disable-next-line no-unused-vars
function CurriculumMapLesson(props) {
  const curriculum = props.curriculum;
  const isActive = _.includes(props.active, curriculum.id) || props.isActiveBranch;
  const cssClasses = classNames(
    'o-c-map__lesson',
    {[`${props.mapType}-bg--base`]: !isActive,
      [`${props.mapType}-bg--${props.colorCode} ${props.mapType}-bg--active`]: isActive,
      [`o-c-map__assessment--${isActive ? props.colorCode : 'base'} ${props.mapType}-bg--assessment`]: props.isAssessment,
      ['o-c-map__prerequisite']: props.isPrerequisite }
  );
  return (
    <ResourceHover cssClasses={cssClasses}
      blank={props.blank}
      resource={curriculum.resource}
      handlePopupState={props.handlePopupState}/>
  );
}
