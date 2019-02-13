(function($) {
  /**
   * Initialize plugins on any elements within `elem` (and `elem` itself) that aren't already initialized.
   * without warning
   */
  function initPlugins(elem) {
    const plugins = Object.keys(Foundation._plugins);
    let $elemsToInit = null;
    $.each(plugins, (i, name) => {
      // Localize the search to all elements inside elem, as well as elem itself, unless elem === document
      const selector = `[data-${name}]`;
      let $elem = $(elem).find(selector).addBack(selector);
      // For each plugin found check if it was initialized
      $elem.each((j, el) => {
        const $el = $(el);
        if (!$el.data('zfPlugin')) {
          $elemsToInit = $elemsToInit? $elemsToInit.add($el): $el;
        }
      });
    });
    if ($elemsToInit) {
      $elemsToInit.foundation();
    }
    // fix initialization with turbolinks,
    // emulate what should happen on load event
    let $maggelan = $('[data-magellan]');
    if ($maggelan.length) {
      $maggelan.foundation('reflow');
    }
    let $sticky = $('[data-sticky]');
    if ($sticky.length) {
      $(window).trigger('load.zf.sticky');
    }
  }

  /**
   * Fix MediaQuery init bug for Opera
   * TODO issue number
   * @return {[type]} [description]
   */
  function fixMediaQuery() {
    // queries, need to be changed if brekpoints will be changed
    const extractedStyles = '"small=0em&medium=40em&ipad=48em&large=64em&xlarge=76.875em&xxlarge=90em"';
    let fQuery = Foundation.MediaQuery;
    // was initialized successfully
    if (fQuery.queries.length > 5) return;
    // add queries
    const namedQueries = parseStyleToObject(extractedStyles);
    for (let key in namedQueries) {
      fQuery.queries.push({
        name: key,
        value: `only screen and (min-width: ${namedQueries[key]})`
      });
    }
    // set current size correctly
    fQuery.current = fQuery._getCurrentSize();
  }

  function uniqMediaQuery() {
    // clear current queries (will be duplicated b/c of turbolinks)
    Foundation.MediaQuery.queries = _.uniq(Foundation.MediaQuery.queries, 'name');
  }

  // Copy-paste from Foundation.MediaQuery
  // Thank you: https://github.com/sindresorhus/query-string
  function parseStyleToObject(str) {
    let styleObject = {};

    if (typeof str !== 'string') {
      return styleObject;
    }

    str = str.trim().slice(1, -1); // browsers re-quote string style values

    if (!str) {
      return styleObject;
    }

    styleObject = str.split('&').reduce(function(ret, param) {
      let parts = param.replace(/\+/g, ' ').split('=');
      let key = parts[0];
      let val = parts[1];
      key = decodeURIComponent(key);

      // missing `=` should be `null`:
      // http://w3.org/TR/2012/WD-url-20120524/#collect-url-parameters
      val = val === undefined ? null : decodeURIComponent(val);

      if (!ret.hasOwnProperty(key)) {
        ret[key] = val;
      } else if (Array.isArray(ret[key])) {
        ret[key].push(val);
      } else {
        ret[key] = [ret[key], val];
      }
      return ret;
    }, {});

    return styleObject;
  }

  $.fn.initFoundation = function() {
    fixMediaQuery();
    initPlugins(this);
    uniqMediaQuery();
    Foundation.IHearYou();
    return this;
  };

})(jQuery);
