// eslint-disable-next-line no-unused-vars
function CurriculumMapUnit(props) {
  const curriculum = props.curriculum;
  const isActive = _.includes(props.active, curriculum.id) || props.isActiveBranch;
  const isAssessment = curriculum.resource.is_assessment;
  const cssClasses = classNames( 'o-c-map__unit-title',
    { [`${props.mapType}-txt-link--base`]: !isActive,
      [`${props.mapType}-txt-link--${props.colorCode} ${props.mapType}-txt-link--active`]: isActive });
  let lessons;
  let isActiveBranch = _.first(props.active) === curriculum.id || props.isActiveBranch;
  if (isAssessment) {
    lessons = [
      <CurriculumMapLesson key={curriculum.resource.id}
        blank={props.blank}
        curriculum={curriculum}
        colorCode={props.colorCode}
        active={props.active}
        mapType={props.mapType}
        isAssessment={isAssessment}
        isPrerequisite={curriculum.resource.is_prerequisite}
        isActiveBranch={isActiveBranch}
        handlePopupState={props.handlePopupState} />
    ];
  } else {
    lessons = _.filter(curriculum.children, x => !x.resource.is_opr);
    lessons = lessons.map(
      lesson => <CurriculumMapLesson key={lesson.resource.id}
        blank={props.blank}
        curriculum={lesson}
        colorCode={props.colorCode}
        active={props.active}
        mapType={props.mapType}
        isAssessment={lesson.resource.is_assessment}
        isPrerequisite={lesson.resource.is_prerequisite}
        isActiveBranch={isActiveBranch}
        handlePopupState={props.handlePopupState} />
    );
  }

  let resourceHtml;
  if (isAssessment) {
    resourceHtml = /mid/.test(curriculum.resource.short_title) ? 'MID' : 'END';
  } else {
    resourceHtml = curriculum.resource.short_title;
  }
  return (
    <div className='o-c-map__unit'>
      <ResourceHover blank={props.blank}
        cssClasses={cssClasses}
        resource={curriculum.resource}
        resourceHtml={resourceHtml}
        handlePopupState={props.handlePopupState}/>
      {lessons}
    </div>
  );
}
