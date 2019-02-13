$(document).on('turbolinks:before-cache', function() {
  urlHistory.emptyState();
});
