// eslint-disable-next-line no-unused-vars
function EnhanceInstructionCards(props) {
  const items = props.items.map(item => (
    item.instruction_type === 'generic' ?
      <GenericResourceCard key={item.id} item={item} /> :
      <InstructionCard key={item.id} item={item} />
  ));
  return (
    <div className="o-page__wrap--row-nest">
      {items}
    </div>
  );
}
