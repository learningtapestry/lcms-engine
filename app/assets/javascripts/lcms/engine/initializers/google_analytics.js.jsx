window.initializeGoogleAnalytics = () => {
  if (window.ga) {
    ga('set',  'location', location.href.split('#')[0]);
    ga('send', 'pageview', { "title": document.title });
  }
}
