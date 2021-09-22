import React from 'react';
import _ from 'lodash';
import PropTypes from 'prop-types';
import AssociationPickerResults from './AssociationPickerResults';

class AssociationPickerWindow extends React.Component {
  constructor(props) {
    super(props);

    this.state = { ...props, selectedItems: [] };

    this.selectItem = this.selectItem.bind(this);
  }

  selectItem(item) {
    const operation = this.updateSelectedItems(item);
    if ('onSelectItem' in this.props) {
      this.props.onSelectItem(item, operation);
    }
  }

  updateSelectedItems(item) {
    let operation, newItems;
    if (item._selected) {
      newItems = _.filter(this.state.selectedItems, r => r.id !== item.id);
      operation = 'removed';
    } else {
      newItems = [...this.state.selectedItems, item];
      operation = 'added';
    }
    this.setState(...this.state, { selectedItems: newItems });
    return operation;
  }

  render() {
    const { q, results } = this.props;

    return (
      <div className="o-assocpicker">
        <div className="o-page">
          <div className="o-page__module">
            <h4 className="text-center">Select item</h4>
            <div className="row">
              <label className="medium-3 columns">
                Name
                {/*
                  eslint-disable react/jsx-no-bind
                */}
                <input type="text" value={q || ''} onChange={this.props.onFilterChange.bind(this, 'q')} />
                {/*
                  eslint-enable react/jsx-no-bind
                */}
              </label>
            </div>
          </div>
        </div>

        <div className="o-page">
          <div className="o-page__module">
            <AssociationPickerResults
              value={q}
              items={results}
              selectedItems={this.state.selectedItems}
              allowCreate={this.props.allowCreate}
              onSelectItem={this.selectItem}
            />

            {this.props.pagination()}

            {this.props.allowMultiple ? (
              <button type="button" className="button c-assocpicker-submit" onClick={this.props.onClickDone}>
                Submit
              </button>
            ) : null}
          </div>
        </div>
      </div>
    );
  }
}

AssociationPickerWindow.propTypes = {
  onSelectItem: PropTypes.func,
  q: PropTypes.string,
  results: PropTypes.array,
  onFilterChange: PropTypes.func,
  allowCreate: PropTypes.bool,
  pagination: PropTypes.node,
  allowMultiple: PropTypes.bool,
  onClickDone: PropTypes.func,
};

export default AssociationPickerWindow;
