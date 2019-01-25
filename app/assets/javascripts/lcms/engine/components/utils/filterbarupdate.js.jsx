// eslint-disable-next-line no-unused-vars
function handleFilterbarUpdate(filterbar) {
  const newState = _.assign({}, this.state, { filterbar: filterbar, current_page: 1  });
  this.fetch(newState);
}
