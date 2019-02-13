// eslint-disable-next-line no-unused-vars
class ResourcePicker extends React.Component {
  constructor(props) {
    super(props);

    const resources = 'resources' in props ? props.resources : [];

    this.state = {
      resources:  resources
    };
  }

  get jqmodal() {
    return $(this.modal);
  }

  get allowMultiple() {
    if (_.isUndefined(this.props.allow_multiple) || this.props.allow_multiple === null) {
      return true;
    }
    return this.props.allow_multiple;
  }

  componentDidMount() {
    // eslint-disable-next-line no-undef
    pickerModal.call(this);
  }

  onClickSelect() {
    // eslint-disable-next-line no-undef
    const pickerComponent = pickerWindowWrapper(ResourcePickerWindow, 'admin_resource_picker_path');
    const picker = React.createElement(pickerComponent, {
      onSelectResource: this.selectResource.bind(this),
    }, null);
    ReactDOM.render(picker, this.modal);
    this.jqmodal.foundation('open');
  }

  selectResource(resource) {
    this.jqmodal.foundation('close');

    const newResources = this.allowMultiple ?
      [...this.state.resources, resource] :
      [resource];

    this.setState({
      ...this.state,
      resources: newResources
    });
  }

  removeResource(resource) {
    this.setState({
      ...this.state,
      resources: _.filter(this.state.resources, r => r.id !== resource.id)
    });
  }

  render() {
    const resources = this.state.resources.map(resource => {
      return <ResourcePickerResource
        key={resource.id}
        name={this.props.name}
        resource={resource}
        onClickClose={() => this.removeResource(resource)}
      />;
    });

    const input = <input type="hidden" name={this.props.name} value="" />;

    return (
      <PickerButton
        content={resources}
        hiddenInputs={input}
        onClick={this.onClickSelect.bind(this)}
        onRef={m => this.modal = m}
      />
    );
  }
}
