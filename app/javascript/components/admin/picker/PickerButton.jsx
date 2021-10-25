import React from 'react';
import PropTypes from 'prop-types';
import ResourcePicker from '../resource-picker/ResourcePicker'; // eslint-disable-line no-unused-vars

function PickerButton(props) {
  return (
    <div className="o-assocpicker-container">
      <button type="button" className="o-assocpicker-add button" onClick={props.onClick}>
        Select
      </button>
      <div className="o-assocpicker-selections">
        {props.hiddenInputs}
        {props.content}
      </div>
      <div className="o-assocpicker-modal reveal" ref={props.onRef}></div>
    </div>
  );
}

PickerButton.propTypes = {
  onClick: PropTypes.func,
  hiddenInputs: PropTypes.node,
  content: PropTypes.array,
  onRef: PropTypes.func,
};

export default PickerButton;
