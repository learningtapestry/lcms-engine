function FilterbarFacet(props) {
  const className = classNames(
    'o-filterbar__item',
    'o-filterbar__item--rectangle-big',
    'o-filterbar__item--facet',
    {'o-filterbar__item--deselected': !props.selected}
  );

  return (
    <div className={className} onClick={props.onClick}><span>{props.displayName}</span></div>
  );
}
