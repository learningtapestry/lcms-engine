// eslint-disable-next-line no-unused-vars
function LessonCard(props) {
  const url = props.lesson.path;
  const is_prereq = props.lesson.is_prerequisite;
  const is_foundational = props.lesson.is_foundational;
  const is_opr = props.lesson.is_opr;
  const opr_standards = props.lesson.opr_standards;

  let title;
  if (is_opr) {
    title = 'PREREQUISITE LESSON';
  } else if (is_prereq) {
    const numeral = (/lesson (.*)/i).exec(props.lesson.short_title)[1];
    title = `LESSON ${numeral.toLowerCase()} • Prerequisite`;
  } else {
    title = props.with_breadcrumb ? props.lesson.breadcrumb_title : props.lesson.short_title.toUpperCase();
  }

  const prereq = <div className="o-lesson-card__header--prerequisite"></div>;

  return (
    <a className="o-lesson-card o-lesson-card--base" href={url}>
      <div className={classNames('o-lesson-card__wrap', `cs-bg--${props.colorCode}`)}>
        <div className="o-lesson-card__header cs-txt--light">
          {is_prereq || is_opr ? prereq : null}
          <span className="o-lesson-card__header--title u-txt--breadcrumbs">{title}</span>
        </div>
        <div className="o-lesson-card__content o-lesson-card__content--base cs-bg--light">
          <h3 className="o-lesson-card__dsc o-lesson-card__dsc--short">{is_foundational ? '' : props.lesson.title}</h3>
          <div className="o-lesson-card__duration u-hidden">
            <TimeToTeach duration={props.lesson.time_to_teach} />
          </div>
        </div>
        <div className="o-lesson-card__content o-lesson-card__content--hover">
          <div className="o-lesson-card__dsc o-lesson-card__dsc--full">
            { opr_standards &&
              <span className="u-txt--lesson-hover-standard u-text--uppercase">{opr_standards}<br/><br/></span>
            }
            {props.lesson.teaser}
          </div>
        </div>
      </div>
    </a>
  );
}
