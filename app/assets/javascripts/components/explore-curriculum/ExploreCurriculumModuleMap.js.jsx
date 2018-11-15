// eslint-disable-next-line no-unused-vars
function ExploreCurriculumModuleMap(props) {
  const mapClass = classNames({
    'o-cur-card__map': true,
    'o-cur-card__map--medium': props.expanded,
    'o-cur-card__map--short': !props.expanded
  });

  const mainClass = classNames({
    'o-ch-map': true,
    'o-ch-map--medium': props.expanded,
    'o-ch-map--short': !props.expanded
  });

  const bemClass = _.partial(convertToBEM, mainClass);
  const colorCodeClass = `cs-bg--${props.colorCode}`;

  const details = props.expanded ?
    <div className="o-ch-map__details">
      <span>Show Units</span>
    </div> : '';

  const units = props.curriculum.unit_sizes.map((size, i) => {
    const lessons = [];
    const unit = props.curriculum.children[i];

    for (let j = 0; j < size; j++) {
      const child = unit ? unit.children[j] : null;
      if (child && child.resource.is_opr) continue;
      const prereqClass = child && child.resource.is_prerequisite ? 'o-ch-unit-map__prerequisite' : '';
      const assessmentClass =  unit && unit.resource.is_assessment ? `o-ch-unit-map__assessment--${props.colorCode}` : '';
      lessons.push((
        <div key={j} className={classNames(bemClass('lesson'), colorCodeClass, assessmentClass, prereqClass)}></div>
      ));
    }

    return (
      <div key={i} className={bemClass('unit')}>
        {lessons}
      </div>
    );
  });

  return (
    <div className={mapClass}>
      <div className={mainClass}>
        <div className={bemClass('module-wrap')}>
          <div className={classNames(bemClass('module'), colorCodeClass)}></div>
        </div>
        <div className={bemClass('units-wrap')}>
          <div className={bemClass('units')}>
            {units}
          </div>
        </div>
      </div>
      {details}
    </div>
  );
}
