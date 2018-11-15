function SearchResultsEmpty(props) {
  const contact = "Contact Us";
  return (
    <div className='o-search-results__empty'>
      <h2>Sorry, No Results were found for "{props.searchTerm}"</h2>
      <br/>
      <h3 className='u-text--large'>Suggestions</h3>
      <ul>
        <li>Check your spelling</li>
        <li>Try using fewer filters</li>
        <li>Try more general Terms</li>
      </ul>

      <hr />

      <h3 className='u-text--large'>Or, Maybe We Can Help</h3>

      <ul>
        <li><a href={Routes.explore_curriculum_index_path()}>Explore Our Curriculum</a></li>
        <li><a href={Routes.find_lessons_path()}>Find Lessons in our Library</a></li>
        <li><FreshdeskBtn text={contact} /></li>
      </ul>
    </div>
  );
}
