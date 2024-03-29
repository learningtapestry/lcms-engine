import React from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';
import _ from 'lodash';
import ResourcePickerWindow from './ResourcePickerWindow';
import ResourcePickerResource from './ResourcePickerResource';
import PickerButton from '../picker/PickerButton';
import pickerWindowWrapper from '../picker/pickerWindowWrapper';
import pickerModal from '../picker/pickerModal';
import { Foundation } from 'foundation-sites';
import $ from 'jquery';

class ResourcePicker extends React.Component {
  constructor(props) {
    super(props);

    const resources = 'resources' in props ? props.resources : [];

    this.state = {
      resources: resources,
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
    Foundation.addToJquery($);
    // eslint-disable-next-line no-undef
    pickerModal.call(this);
  }

  onClickSelect() {
    // eslint-disable-next-line no-undef
    const pickerComponent = pickerWindowWrapper(ResourcePickerWindow, 'lcms_engine_admin_resource_picker_path');
    const picker = React.createElement(
      pickerComponent,
      {
        onSelectResource: this.selectResource.bind(this),
      },
      null
    );
    ReactDOM.render(picker, this.modal);
    this.jqmodal.foundation('open');
  }

  selectResource(resource) {
    this.jqmodal.foundation('close');

    const newResources = this.allowMultiple ? [...this.state.resources, resource] : [resource];

    this.setState({
      ...this.state,
      resources: newResources,
    });
  }

  removeResource(resource) {
    this.setState({
      ...this.state,
      resources: _.filter(this.state.resources, r => r.id !== resource.id),
    });
  }

  render() {
    const resources = this.state.resources.map(resource => {
      return (
        <ResourcePickerResource
          key={resource.id}
          name={this.props.name}
          resource={resource}
          // eslint-disable-next-line react/jsx-no-bind
          onClickClose={() => this.removeResource(resource)}
        />
      );
    });

    const input = <input type="hidden" name={this.props.name} value="" />;

    return (
      <PickerButton
        content={resources}
        hiddenInputs={input}
        // eslint-disable-next-line react/jsx-no-bind
        onClick={this.onClickSelect.bind(this)}
        // eslint-disable-next-line react/jsx-no-bind
        onRef={m => (this.modal = m)}
      />
    );
  }
}

ResourcePicker.propTypes = {
  name: PropTypes.string,
  resources: PropTypes.array,
  allow_multiple: PropTypes.bool,
};

export default ResourcePicker;
