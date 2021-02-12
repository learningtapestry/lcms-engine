import React from 'react'
import ReactDOM from 'react-dom'
import _ from 'lodash'
// eslint-disable-next-line no-unused-vars
import AssociationPickerItem from './AssociationPickerItem'
import AssociationPickerWindow from './AssociationPickerWindow'
// eslint-disable-next-line no-unused-vars
import PickerButton from '../picker/PickerButton'
import pickerModal from '../picker/pickerModal'
import pickerWindowWrapper from '../picker/pickerWindowWrapper'

class AssociationPicker extends React.Component {
  constructor(props) {
    super(props)

    this.state = {
      items: this.props.items || [],
    }
  }

  get jqmodal() {
    return $(this.modal)
  }

  componentDidMount() {
    // eslint-disable-next-line no-undef
    pickerModal.call(this)
  }

  onClickSelect() {
    // eslint-disable-next-line no-undef
    const pickerComponent = pickerWindowWrapper(AssociationPickerWindow, 'lcms_engine_admin_association_picker_path')
    const picker = React.createElement(pickerComponent, {
      association: this.props.association,
      allowCreate: this.props.allow_create,
      allowMultiple: this.props.allow_multiple,
      onClickDone: this.closeModal.bind(this),
      onSelectItem: this.selectItem.bind(this),
      selectedItems: this.state.items,
    }, null)
    ReactDOM.render(picker, this.modal)
    this.jqmodal.foundation('open')
  }

  selectItem(item, operation) {
    if (!this.props.allow_multiple) {
      this.closeModal()
    }
    operation === 'added' ? this.addItem(item) : this.removeItem(item)
  }

  closeModal() {
    this.jqmodal.foundation('close')
  }

  addItem(item) {
    const newItems = this.props.allow_multiple ?
      [...this.state.items, item] :
      [item]

    this.setState({
      ...this.state,
      items: newItems,
    })
  }

  removeItem(item) {
    this.setState({
      ...this.state,
      items: _.filter(this.state.items, r => r.id !== item.id),
    })
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
        // eslint-disable-next-line react/jsx-no-bind
        onClickClose={() => this.removeItem(item)}
      />
    })

    const blankInput = this.props.allow_multiple ?
      <input type="hidden" name={`${this.props.name}[]`} value="" /> :
      <span className="hide" />

    return (
      <PickerButton
        content={items}
        hiddenInputs={blankInput}
        // eslint-disable-next-line react/jsx-no-bind
        onClick={this.onClickSelect.bind(this)}
        // eslint-disable-next-line react/jsx-no-bind
        onRef={m => this.modal = m}
      />
    )
  }
}

export default AssociationPicker
