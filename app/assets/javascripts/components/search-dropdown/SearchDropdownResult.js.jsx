function SearchDropdownResult(props) {
  const classes = classNames({
    'o-search-dropdown-result': true,
    'o-search-dropdown-result__selected': props.selected
  });

  return (
    <a className={classes} href={props.resource.path}>
      <strong>{props.resource.type_name}:</strong> {props.resource.title}
    </a>
  );
}
