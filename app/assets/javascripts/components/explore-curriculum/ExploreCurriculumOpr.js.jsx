// eslint-disable-next-line no-unused-vars
class ExploreCurriculumOpr extends React.Component {
  constructor(props) {
    super(props);
    this.children = _
      .filter(this.props.curriculum.children, x => x.resource.is_opr)
      .sort((a, b) => parseInt(a.resource.short_title.split(' ')[1]) - parseInt(b.resource.short_title.split(' ')[1]));
    this.state = { renderChildren: false };
    this.oprDescription = this.props.curriculum.resource.opr_description;

    // Amount of OPR lessons to show in the expanded version of the block
    this.numLessonsToTake = 5;
  }

  onClick() {
    this.setState({renderChildren: !this.state.renderChildren});
  }

  render() {
    if (this.children.length === 0) return (null);

    const operationLabel = this.state.renderChildren ? 'Hide' : 'View';

    const containerClasses = 'c-ec-cards__children c-ec-cards__children--expanded c-ec-cards-opr';
    const titleClasses = 'c-ec-cards-opr__title';
    const wrapperClasses = 'c-ec-cards-opr__wrapper';

    const childrenComponents = () => {
      const childrenElements = _.take(this.children, this.numLessonsToTake).map(c => {
        return <LessonCard key={c.resource.id} lesson={c.resource} with_breadcrumb={false}
          colorCode={this.props.colorCode}/>;
      });

      const lessonClasses = 'c-ec-cards__children--lessons';

      const oprDescElement = (this.oprDescription && this.oprDescription.length) ?
        <div className="c-ec-cards__children c-ec-cards-opr">{this.props.curriculum.resource.opr_description}</div>
        : null;

      return (
        <div>
          {oprDescElement}
          <div className={lessonClasses}>
            {childrenElements}
          </div>
        </div>
      );
    };

    return (
      <div className={wrapperClasses}>
        <div className={containerClasses}>
          <div className={titleClasses}>Need additional Prerequisite Lessons to help students access core learning?</div>
          <div>
            <button className="button" type="button" onClick={this.onClick.bind(this)}>{operationLabel} Recommendations</button>
          </div>
        </div>
        {this.state.renderChildren ? childrenComponents() : null}
      </div>
    );
  }
}
