function SearchResultsHeader(props) {
  const startNum = (props.current_page - 1) * props.per_page + 1;
  const endNum = startNum + props.num_items - 1;

  return (
    <div className="o-s-header o-page__wrap--row-nest">
      <div className="o-s-header__item">
        <p>Showing {startNum}&mdash;{endNum} of {props.total_hits}</p>
      </div>
      <div className="o-s-header__item">
        <div className="o-s-select">
          {
            (props.onChangeOrder) ?
              <div className="o-s-select__item">
                <select value={props.order} onChange={props.onChangeOrder}>
                  <option value="asc">Sort by asc</option>
                  <option value="desc">Sort by desc</option>
                </select>
              </div>

            : false
          }

          {
            (props.onChangePerPage) ?
              <div className="o-s-select__item">
                <select value={props.per_page} onChange={props.onChangePerPage}>
                  <option value="20">20 per page</option>
                  <option value="50">50 per page</option>
                  <option value="100">100 per page</option>
                  <option value="200">200 per page</option>
                </select>
              </div>

            : false
          }
        </div>
      </div>
    </div>
  );
}
