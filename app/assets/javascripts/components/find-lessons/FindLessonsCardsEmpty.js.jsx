function FindLessonsCardsEmpty(props) {
  return (
    <div className='o-search-results__empty'>
      <h2 className="u-text--centered">Your search for "{props.searchTerm}" did not return any results.</h2>

      <p>Please try searching a topic (e.g. volume), a text or author (e.g. Macbeth or Frederick Douglass), or a standard (e.g. 2.NBT.A.2).</p>

      <h3 className='u-text--large'>Suggestions</h3>
      <ul>
        <li>Check your spelling</li>
        <li>Try using fewer filters</li>
        <li>Try more general Terms</li>
      </ul>

    </div>
  );
}
