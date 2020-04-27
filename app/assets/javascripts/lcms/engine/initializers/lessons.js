"use strict";

(function () {
  var COMPONENT_PREFIX = '.o-ld';

  var eachNode = function eachNode(selector, fn) {
    return [].forEach.call(document.querySelectorAll(selector), fn);
  };

  var initHAEvents = function initHAEvents() {
    [].forEach.call(document.querySelectorAll('.tm-ela2-unit-link'), function (x) {
      x.addEventListener('click', function (e) {
        // eslint-disable-next-line no-undef
        heapTrack('Resource section unit page opened', {
          link: e.target.href
        });
      });
    });
    [].forEach.call(document.querySelectorAll('.o-ld-pd .o-ld-cg .o-ub-ld-btn'), function (x) {
      x.addEventListener('click', function (e) {
        // eslint-disable-next-line no-undef
        heapTrack('PD link clicked', {
          link: e.target.href
        });
      });
    });
  }; // Collects properties for PdTag needed by Heap Analytics

  var heapPd = function heapPd(el) {
    var haTitleEl = el.find('.o-ld-pd__title');
    var haTitle = haTitleEl ? haTitleEl.text() : 'N/A';
    var haType = 'N/A';
    if (el.find('.o-ld-pd-pdf')) haType = 'PDF'; else if (el.find('.o-ld-pd__audio')) haType = 'Audio'; else if (el.find('.o-ld-pd__video')) haType = 'Video';
    var event = el.hasClass('o-ld-pd--collapsed') ? 'PD Expanded' : 'PD Collapsed'; // eslint-disable-next-line no-undef

    heapTrack(event, {
      title: haTitle,
      type: haType
    });
  };

  var initPd = function initPd() {
    var prefix = "".concat(COMPONENT_PREFIX, "-pd");
    var togglerSelector = "".concat(prefix, "-toggler");
    $("".concat(prefix, "__minimizer")).click(function () {
      $(this).closest(prefix).find(togglerSelector).click();
    });
    $(togglerSelector).click(function () {
      var el = $(this).closest(prefix);
      heapPd(el);
      el.toggleClass('o-ld-pd--collapsed o-ld-pd--expanded').find('.o-ld-pd__description').toggleClass('o-ld-pd__description--hidden');

      if (PDFObject.supportsPDFs) {
        embedPdf(el.find('.o-ld-pd-pdf__object[data-url]')[0]);
      }
    });

    var embedPdf = function embedPdf(el) {
      if (!el) return;
      var url = el.dataset.url;

      if (!PDFObject.supportsPDFs) {
        url = "".concat(Routes.lcms_engine_pdf_proxy_resources_path(), "?url=").concat(url);
      }

      PDFObject.embed(url, el, {
        pdfOpenParams: {
          page: 1,
          view: 'FitV'
        },
        PDFJS_URL: Routes.lcms_engine_pdfjs_full_path()
      });
    };

    eachNode('.o-ld-pd-pdf__object[data-url]', embedPdf);
  };

  function initSidebar() {
    var observers = [new SidebarDocMenu(), // eslint-disable-line no-undef
      new TopScroll(), // eslint-disable-line no-undef
      new SidebarSticky() // eslint-disable-line no-undef
    ]; // eslint-disable-next-line no-undef

    new SideBar(observers, {
      breakPoint: 'large',
      bHandleMobile: false,
      clsPrefix: 'ld',
      toTop: true
    });
  }

  function initToggler(component) {
    var prefix = "".concat(COMPONENT_PREFIX, "-").concat(component);
    $("".concat(prefix, "__toggler")).click(function () {
      $("".concat(prefix, "__content--hidden"), $(this).parent()).toggle();
      $("".concat(prefix, "__toggler--hide"), $(this)).toggle();
      $("".concat(prefix, "__toggler--show"), $(this)).toggle();
    });
  }

  var initSelects = function initSelects() {
    var menu = document.getElementById('ld-sidebar-menu');
    if (!menu) return;
    var lastParentIdx = null;
    var items = [].map.call(menu.querySelectorAll('[href][data-duration][data-level]'), function (x, i) {
      var level = parseInt(x.dataset.level);
      if (level === 1) lastParentIdx = i;
      return {
        active: true,
        // by default
        duration: parseInt(x.dataset.duration),
        id: x.getAttribute('href').substr(1),
        parent: level > 1 ? lastParentIdx : null
      };
    });
    var tagsExcluded = [];

    var durationString = function durationString(x) {
      return "".concat(x, " min").concat(x > 1 ? 's' : '');
    };

    var breakElement = document.querySelector('.o-ld-optbreak-wrapper');

    var handleOptBreak = function handleOptBreak() {
      if (!breakElement) return;
      breakElement.classList.toggle('hide', tagsExcluded.length !== 0);
    };

    var pollContentStatus = function pollContentStatus(id, key, link) {
      $(link).prepend('<i class="fas fa-spin fa-spinner u-margin-right--base" />');
      return new Promise(function (resolve, reject) {
        var poll = function poll() {
          $.getJSON("".concat(location.pathname, "/export/status"), {
            context: link.dataset.context,
            jid: id,
            key: key,
            _: Date.now() // prevent cached response

          }).done(function (x) {
            if (x.ready) {
              $(link).find('.fa').remove();
              resolve(x.url);
            } else {
              setTimeout(poll, 2000);
            }
          }).fail(function (x) {
            console.warn('check content export status', x);
            reject(x);
          });
        };

        setTimeout(poll, 2000);
      });
    };

    var toggleHandler = function toggleHandler(element, item) {
      var deselected = element.classList.toggle('deselected');
      item.active = item.isOptional ? deselected : !deselected;
      tagsExcluded = items.filter(function (x) {
        return x.parent !== null && x.active === false;
      }).map(function (x) {
        return x.id;
      });
      handleOptBreak();
      eachNode("[href=\"#".concat(item.id, "\"]"), function (x) {
        x.classList.toggle('o-ld-sidebar-item__content--disabled', itemIsActive(x));
      });
      updateDownloads();
      updateGroup(item.parent); // eslint-disable-next-line no-undef

      excludesStore.updateMaterialsList(tagsExcluded);
      setTimeout(function () {
        $('.doc-subject-ela .o-ld-sidebar__item.o-ld-sidebar-break').toggle(tagsExcluded.length === 0);
      });
    };

    var updateDownloads = function updateDownloads() {
      var excludesString = tagsExcluded.join(',');
      eachNode('a[data-contenttype]', function (link) {
        link.dataset.excludes = '';
        if (!link.dataset.originalTitle) link.dataset.originalTitle = link.textContent;
        link.textContent = excludesString ? link.dataset.customtitle : link.dataset.originalTitle;
      });
    };

    var itemIsActive = function itemIsActive(item) {
      return item.isOptional ? !item.active : item.active;
    };

    var updateGroup = function updateGroup(parentId) {
      var parent = items[parentId];
      var children = items.filter(function (x) {
        return x.parent === parentId;
      });
      var parentDuration = children.filter(itemIsActive).reduce(function (a, x) {
        return a + x.duration;
      }, 0);
      parentDuration = parentDuration > 0 ? durationString(parentDuration) : ''; // for ELA do not disable parent if all children are Optional Activities

      var parentEnabled;

      if (isEla && children.every(function (x) {
        return x.isOptional;
      })) {
        parentEnabled = true;
      } else {
        parentEnabled = children.some(itemIsActive);
      }

      var totalTime = durationString(items.filter(function (x) {
        return x.parent !== null && itemIsActive(x);
      }).reduce(function (a, x) {
        return a + x.duration;
      }, 0));
      eachNode("[href=\"#".concat(parent.id, "\"]"), function (parentNode) {
        parentNode.classList.toggle('o-ld-sidebar-item__content--disabled', !parentEnabled);
        parentNode.querySelector('.o-ld-sidebar-item__time').textContent = parentDuration;
      });
      var contentGroup = document.getElementById(parent.id);
      var groupDuration = contentGroup ? contentGroup.querySelector('.o-ld-title__time') : null;
      if (groupDuration) groupDuration.textContent = parentDuration;
      eachNode('.o-ld-sidebar-item__time--summary', function (x) {
        x.textContent = totalTime;
      });
    };

    var isEla = !!document.querySelector('[data-ela]');
    eachNode('a[data-contenttype]', function (link) {
      link.dataset.excludes = '';
      link.addEventListener('click', function (e) {
        var excludesString = tagsExcluded.join(',');

        if (!excludesString) {
          link.href = link.dataset.href;
          return;
        }

        if (link.dataset.excludes === excludesString) return;
        e.preventDefault();
        link.classList.add('o-ub-btn--disabled');
        link.dataset.excludes = excludesString;

        var finish = function finish() {
          link.classList.remove('o-ub-btn--disabled');
          link.textContent = link.dataset.originalTitle;
        };

        $.post("".concat(location.pathname, "/export"), {
          context: link.dataset.context,
          excludes: tagsExcluded,
          type: link.dataset.contenttype
        }).done(function (response) {
          link.href = response.url;

          if (response.id) {
            pollContentStatus(response.id, response.key, link).then(function (url) {
              if (url) link.href = url;
              finish();
            });
          } else {
            finish();
          }
        }).fail(function (x) {
          console.warn('export content', x);
          finish();
        });
      });
    });
    items.filter(function (x) {
      return x.parent !== null;
    }).forEach(function (item) {
      var prefix = isEla ? '[data-deselectable]' : '';
      var content = document.querySelector("".concat(prefix, "[data-id=\"").concat(item.id, "\"]"));
      if (!content) return;
      item.isOptional = content.hasAttribute('data-optional');
      item.tag = content.dataset.tag;
      var container = document.createElement('div');
      content.appendChild(container); // eslint-disable-next-line no-undef

      var component = React.createElement(SelectActivityToggle, {
        callback: toggleHandler.bind(null, content, item),
        item: item,
        preface: content.querySelector('.o-ld-title .dropdown-pane'),
        meta: content.querySelector('.o-ld-activity__metacognition')
      });
      ReactDOM.render(component, container);
    });
  };

  window.initializeLessons = function () {
    if (!$('.o-page--ld').length) return;
    initHAEvents();
    initPd();
    if (!document.querySelector('#c-ld-content[data-assessment]')) initSelects();
    initSidebar();
    initToggler('expand');
    initToggler('materials');
  };
})();
