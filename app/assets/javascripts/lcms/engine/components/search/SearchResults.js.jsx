function SearchResults(props) {
  return (
    <div className='o-search-results'>
      <SearchResultsHeader
        current_page={props.current_page}
        per_page={props.per_page}
        num_items={props.resources.length}
        total_hits={props.total_hits} />

      <ul className='o-search-results__list'>
        {props.resources.map((resource) => {
          return <SearchResult key={resource.id} resource={resource} />
        })}
      </ul>
    </div>
  );
}
