function FilterbarSubject(props) {
  const className = classNames(
    'o-filterbar__item',
    `o-filterbar__item--rectangle-${props.cssModifier}`,
    `o-filterbar__item--${props.colorCode}`,
    {'o-filterbar__item--deselected': !props.selected}
  );

  return (
    <div className={className} onClick={props.onClick}><span>{props.displayName}</span></div>
  );
}
