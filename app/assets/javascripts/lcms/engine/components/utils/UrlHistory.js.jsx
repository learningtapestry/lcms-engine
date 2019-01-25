window.urlHistory = (function() {

  let state = {};

  let hasStateBeenConstructedFromTheUrl = false;

  let update = function(newState, options) {
    // options:
    //   skipKey: function which returns if a key should be skiped or not
    //   replace: if true uses replaceState instead the default pushState

    // Initialize state from the query string.
    if (!hasStateBeenConstructedFromTheUrl) {
      let qs = window.location.search.slice(1); // Remove leading '?'.
      let pairs = qs.split('&');

      _.forEach(pairs, function(pair) {
        pair = pair.split('=');
        let key = pair[0];
        let values = decodeURIComponent(pair[1] || '').split(',');

        if( state[key] ) {
          // This is an array encoded as repetitive query string values.
          // param=1&param=2&param=3
          if(_.isArray(state[key])) {
            state[key] = _.union(state[key], values);
          } else {
            state[key] = _.union([state[key]], values);
          }
        } else {
          if (values.length > 1) {
            // This is an array encoded by commas.
            state[key] = values;
          }
          else {
            // This isn't an array at all.
            state[key] = values[0];
          }
        }
      });

      hasStateBeenConstructedFromTheUrl = true;
    }

    let query = [];
    let mergedState = _.extend(state, newState);
    let opts = options || {};

    state = {};
    _.forEach(mergedState, (val, k) => {
      if (opts.skipKey && opts.skipKey(k, val)) { return; }

      if (val) {
        let urlVal = (_.isArray(val) && val.length) ? val.join(',') : val.toString();
        if (urlVal.length) {
          query.push( k + '=' + urlVal);
          state[k] = val;
        }
      }
    });
    query = query.join('&');
    let path = query ? '?' + query : window.location.pathname;

    if (opts.replace) {
      window.history.replaceState(params(path), null, path);
    } else {
      window.history.pushState(params(path), null, path);
    }
  };

  let params = function(url) {
    // Make pushState play nice with Turbolinks.
    // Ref https://github.com/turbolinks/turbolinks-classic/issues/363
    return { turbolinks: true, url: url };
  };

  let querystringToJSON = function () {
    const pairs = location.search.slice(1).split('&');

    let result = {};
    pairs.forEach(function(pair) {
      pair = pair.split('=');
      let val = decodeURIComponent(pair[1] || '');
      if (val.indexOf(',') > -1 ) val = val.split(',');
      result[pair[0]] = val;
    });

    return JSON.parse(JSON.stringify(result));
  };

  const updatePaginationParams = function(newState) {
    let params = {};

    params.page = (newState.current_page === 1) ? null : newState.current_page;
    params.per_page = (newState.per_page === 20) ? null : newState.per_page;
    params.tab = newState.activeTab;

    update(params);
  };

  const emptyState = function () {
    state = {};
    hasStateBeenConstructedFromTheUrl = false;
  };

  return {
    state: state,
    update: update,
    updatePaginationParams: updatePaginationParams,
    querystringToJSON: querystringToJSON,
    emptyState: emptyState,
  };
})();
