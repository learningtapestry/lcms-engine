//= require ./searchPageWrapper.js

function SearchPage(props) {
  const searchResults = (props.data.length === 0) ?
    <SearchResultsEmpty searchTerm={props.filterbar.search_term} /> :

    <SearchResults
      resources={props.data}
      current_page={props.current_page}
      per_page={props.per_page}
      total_hits={props.total_hits} />;

  return (
    <div>
      <div className="u-bg--base-gradient">
        <div className="o-page">
          <div className="o-page__module">
            <div className="o-filterbar-title">
              <h2>Search results</h2>
              <div className="o-filterbar-title__subheader">
                Filter by subject or grade, or search to reveal assets.
              </div>
            </div>
            <FilterbarResponsive
              onUpdate={props.handleFilterBar}
              searchLabel='Search the site'
              withFacets={true}
              withSearch={true}
              {...props.filterbar} />
          </div>
        </div>
      </div>
      <div className="o-page o-page--margin-bottom">
        <div className="o-page__module">
          {searchResults}
          {props.pagination}
        </div>
      </div>
    </div>
  );
}

// eslint-disable-next-line no-unused-vars,no-undef
const SearchPageComponent = searchPageWrapper(SearchPage);
