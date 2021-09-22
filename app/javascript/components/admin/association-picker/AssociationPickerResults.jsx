import React from 'react';
import PropTypes from 'prop-types';
import _ from 'lodash';

function AssociationPickerResults(props) {
  let items;

  const shouldAllowCreate =
    _.isString(props.value) && props.value.length > 0 && props.allowCreate && props.items.length === 0;

  const selectedIds = _.map(props.selectedItems, 'id');
  const isSelected = item => {
    return _.includes(selectedIds, item.id);
  };

  if (shouldAllowCreate) {
    let newItem = { id: props.value, name: props.value, _create: true };
    items = [
      /* eslint-disable react/jsx-no-bind */
      <tr key={newItem.id}>
        <td onClick={() => props.onSelectItem(newItem)}>
          {props.value}
          <span className="o-assocpicker-create">(Create)</span>
        </td>
      </tr>,
      /* eslint-enable react/jsx-no-bind */
    ];
  } else {
    items = props.items.map(item => {
      let newItem = {
        id: item.id,
        name: item.name,
        _create: false,
        _selected: isSelected(item),
      };
      return (
        /* eslint-disable react/jsx-no-bind */
        <tr key={newItem.id} className={newItem._selected ? 'active' : ''}>
          <td onClick={() => props.onSelectItem(newItem)}>{newItem.name}</td>
        </tr>
        /* eslint-enable react/jsx-no-bind */
      );
    });
  }

  return (
    <table className="c-admcur-items">
      <thead>
        <tr>
          <th>Name</th>
        </tr>
      </thead>
      <tbody>
        {items.length ? (
          items
        ) : (
          <tr>
            <td>Nothing to select</td>
          </tr>
        )}
      </tbody>
    </table>
  );
}

AssociationPickerResults.propTypes = {
  value: PropTypes.string,
  allowCreate: PropTypes.bool,
  items: PropTypes.array,
  selectedItems: PropTypes.array,
  onSelectItem: PropTypes.func,
};

export default AssociationPickerResults;
