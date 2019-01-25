// eslint-disable-next-line no-unused-vars
class AssociationPicker extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      items: this.props.items || []
    };
  }

  get jqmodal() {
    return $(this.modal);
  }

  componentDidMount() {
    // eslint-disable-next-line no-undef
    pickerModal.call(this);
  }

  onClickSelect() {
    // eslint-disable-next-line no-undef
    const pickerComponent = pickerWindowWrapper(AssociationPickerWindow, 'admin_association_picker_path');
    const picker = React.createElement(pickerComponent, {
      association: this.props.association,
      allowCreate: this.props.allow_create,
      allowMultiple: this.props.allow_multiple,
      onClickDone: this.closeModal.bind(this),
      onSelectItem: this.selectItem.bind(this),
      selectedItems: this.state.items
    }, null);
    ReactDOM.render(picker, this.modal);
    this.jqmodal.foundation('open');
  }

  selectItem(item, operation) {
    if (!this.props.allow_multiple) {
      this.closeModal();
    }
    operation === 'added' ? this.addItem(item) : this.removeItem(item);
  }

  closeModal() {
    this.jqmodal.foundation('close');
  }

  addItem(item) {
    const newItems = this.props.allow_multiple ?
      [...this.state.items, item] :
      [item];

    this.setState({
      ...this.state,
      items: newItems
    });
  }

  removeItem(item) {
    this.setState({
      ...this.state,
      items: _.filter(this.state.items, r => r.id !== item.id)
    });
  }

  render() {
    const items = this.state.items.map((item) => {
      return <AssociationPickerItem
        key={item.id}
        name={this.props.name}
        createName={this.props.create_name}
        association={this.props.association}
        allowMultiple={this.props.allow_multiple}
        item={item}
        onClickClose={() => this.removeItem(item)}
      />;
    });

    const blankInput = this.props.allow_multiple ?
      <input type="hidden" name={`${this.props.name}[]`} value="" /> :
      <span className="hide" />;

    return (
      <PickerButton
        content={items}
        hiddenInputs={blankInput}
        onClick={this.onClickSelect.bind(this)}
        onRef={m => this.modal = m}
      />
    );
  }
}
