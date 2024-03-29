import React from 'react';
import PropTypes from 'prop-types';

function ResourcePickerResource(props) {
  return (
    <div className="o-assocpicker-selection">
      <input type="hidden" name={props.name} value={props.resource.id} />
      <div className="o-assocpicker-title">
        {props.resource.title}
        <span className="o-assocpicker-close" onClick={props.onClickClose}>
          ×
        </span>
      </div>
    </div>
  );
}

ResourcePickerResource.propTypes = {
  name: PropTypes.string,
  resource: PropTypes.object,
  onClickClose: PropTypes.func,
};

export default ResourcePickerResource;
