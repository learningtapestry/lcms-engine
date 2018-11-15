// eslint-disable-next-line no-unused-vars
function ExploreCurriculumGradeMap(props) {
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

  const details = props.expanded ?
    <div className="o-ch-map__details">
      <span>Show Modules</span>
    </div> : '';

  const min = Math.min(...props.curriculum.module_sizes),
    max = Math.max(...props.curriculum.module_sizes);

  // eslint-disable-next-line no-undef
  const scale = _.curry(scaleNumber)(70, 100, min, max);
  const bemClass = _.partial(convertToBEM, mainClass);

  const grades = props.curriculum.module_sizes.map((size, i) => {
    const styles = { width: `${scale(size)}%` };
    return (
      <div key={i} className={bemClass('module-wrap')}>
        <div className={classNames(bemClass('module'), `cs-bg--${props.colorCode}`)} style={styles}></div>
      </div>
    );
  });

  return (
    <div className={mapClass}>
      <div className={mainClass}>
        {grades}
      </div>
      {details}
    </div>
  );
}
