// eslint-disable-next-line no-unused-vars
class AssociationPickerWindow extends React.Component {
  constructor(props) {
    super(props);

    this.state = { ...props, selectedItems: [] };
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
              <label className="medium-3 columns">Name
              <input type="text" value={q || ''} onChange={ this.props.onFilterChange.bind(this, 'q') }/>
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
              onSelectItem={this.selectItem.bind(this)}
            />

            { this.props.pagination() }

            { (this.props.allowMultiple) ?
              <button type="button"
                className="button c-assocpicker-submit"
                onClick={this.props.onClickDone}>Submit</button>
              : null
            }
          </div>
        </div>
      </div>
    );
  }
}
