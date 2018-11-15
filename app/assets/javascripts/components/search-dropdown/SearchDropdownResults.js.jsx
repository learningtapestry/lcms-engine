// eslint-disable-next-line no-unused-vars
function SearchDropdownResults(props) {
  const resultCls = 'o-search-dropdown-result';
  const resultMoreCls = 'o-search-dropdown-result o-search-dropdown-result--more';

  if (props.resources.length === 0) {
    if (props.isSearching) {
      return <div className={resultCls}>Searching...</div>;
    } else if (props.search_term && props.search_term.length > 0) {
      return <div className={resultCls}>Nothing found.</div>;
    }
    return <div className={resultCls}>Enter terms to start searching.</div>;
  }

  const results = props.resources.map((resource, idx) => {
    const key = `${resource.curriculum_id}_${resource.id}`;
    return <SearchDropdownResult
      key={key}
      resource={resource}
      selected={props.selected === idx} />;
  });

  const showMore = (
    <a className={resultMoreCls}
      href={Routes.search_path({ search_term: props.search_term })}>
      Show more results...
    </a>
  );

  return (
    <div>
      {results}
      {showMore}
    </div>
  );
}
