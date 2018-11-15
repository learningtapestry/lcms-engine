//= require ../search/searchPageWrapper.js

class FindLessonPage extends React.Component {
  handleChangePerPage(event) {
    const newPerPage = event.target.value;
    const newState = _.assign({}, this.props, { per_page: newPerPage, current_page: 1 });
    this.fetch(newState);
  }

  render() {
    const searchResultsHeader = (this.props.data.length > 0) ?
      <SearchResultsHeader
        onChangePerPage={this.handleChangePerPage.bind(this)}
        current_page={this.props.current_page}
        per_page={this.props.per_page}
        num_items={this.props.data.length}
        total_hits={this.props.total_hits}
        order={this.props.order} />

      : false;

    const searchResults = (this.props.data.length > 0) ?
      <FindLessonsCards lessons={this.props.data} />
      : <FindLessonsCardsEmpty searchTerm={this.props.filterbar.search_term} />;

    return (
      <div>
        <div className="u-bg--base-gradient">
          <div className="o-page">
            <div className="o-page__module">
              <div className="o-filterbar-title">
                <h2>Find Lessons</h2>
                <div className="o-filterbar-title__subheader">
                  Search our free collection for specific lessons or topics within a grade. Download, adapt, share.
                </div>
              </div>
              <FilterbarResponsive
                searchLabel='What do you want to teach?'
                withSearch={true}
                onUpdate={this.props.handleFilterBar}
                {...this.props.filterbar} />
            </div>
          </div>
        </div>
        <div className="o-page o-page--margin-bottom">
          <div className="o-page__module">
            {searchResultsHeader}
            {searchResults}
            {this.props.pagination}
          </div>
        </div>
      </div>
    );
  }
}

// eslint-disable-next-line no-unused-vars,no-undef
const FindLessonPageComponent = searchPageWrapper(FindLessonPage);
