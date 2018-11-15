class RelatedInstruction extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      id: props.id,
      resourceType: props.resource_type || 'Resource',
      instructions: props.instructions,
      expandedInstructions: [],
      expanded: false,
      hasMore: props.has_more,
    };
  }

  fetch() {
    return $.getJSON(Routes.related_instruction_path(this.state.id, {expanded: !this.state.expanded})).then(response => {
      let sum = 0;
      let sliceIdx = _.findIndex(response.instructions,
        item => { sum += item.instruction_type === 'instruction' ? 2 : 1;
          return sum > 4; }
      );
      if (sliceIdx == -1) sliceIdx = response.instructions.length;
      const newState = { instructions:  _.take(response.instructions, sliceIdx),
        expandedInstructions:  _.slice(response.instructions, sliceIdx),
        hasMore: false,
        expanded: true
      };
      this.setState(_.assign({}, this.state, newState));
    })
  }

  handleBtnClick(evt) {
    this.fetch();
  }

  render () {
    const allInstructionsPath = Routes.enhance_instruction_index_path();
    const instructions = this.state.instructions.map(
        item => <InstructionCard key={item.id} item={item} />
    );
    const expandedInstructions = this.state.expandedInstructions.map(
        item => <InstructionCard key={item.id} item={item} />
    );
    const actions = (this.state.instructions.length == 0) ?
      <p className="o-related-instruction__empty u-txt--teaser">
        There are no related guides or videos. To see all our guides, please visit the Enhance Instruction section <a href={allInstructionsPath}>here</a>.
      </p> :
      <ul className="o-related-instruction__actions">
        { this.state.hasMore ?
          <li><a className="o-ub-btn o-ub-btn--yellow u-margin-bottom--zero" onClick={this.handleBtnClick.bind(this)}>More Instruction</a></li>
          : false
        }
        <li><a className="o-ub-btn o-ub-btn--2bordered-gray u-margin-bottom--zero" href={allInstructionsPath}>See All Guides</a></li>
      </ul>;

    return (
      <div className="o-related-instruction o-page__module u-pd-content--xlarge">
        <h2 className="o-related-instruction__title">Related Guides and Multimedia</h2>
        <p className="o-related-instruction__teaser u-txt--teaser">
          Our professional learning resources include teaching guides, videos, and podcasts that build educators' knowledge of content related to the standards and their application in the classroom.
        </p>
        <div className="o-related-instruction__list o-page__wrap--row-nest u-padding-top--gutter">
          {instructions}
        </div>
        <div className="o-related-instruction__list">
          <React.addons.CSSTransitionGroup transitionName="m-fadeIn" transitionEnterTimeout={400} transitionLeaveTimeout={0} component="div" className="o-page__wrap--row-nest">
            {expandedInstructions}
          </React.addons.CSSTransitionGroup>
        </div>
        {actions}
      </div>
     );
   }
}
