// eslint-disable-next-line no-unused-vars
function AssociationPickerItem(props) {
  let input;

  if (props.item._create) {
    input = <input type="hidden" name={`${props.createName}[]`} value={props.item.name} />;
  } else if (props.allowMultiple) {
    input = <input type="hidden" name={`${props.name}[]`} value={props.item.id} />;
  } else {
    input = <input type="hidden" name={props.name} value={props.item.id} />;
  }

  return (
    <div className="o-assocpicker-selection">
      {input}
      <div className="o-assocpicker-title">
        {props.item.name}
        <span className="o-assocpicker-close" onClick={props.onClickClose}>×</span>
      </div>
    </div>
  );
}
