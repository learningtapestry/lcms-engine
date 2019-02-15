(function () {
  const COMPONENT_PREFIX = '.o-ld';

  const eachNode = (selector, fn) => [].forEach.call(document.querySelectorAll(selector), fn);

  const initHAEvents = () => {
    [].forEach.call(document.querySelectorAll('.tm-ela2-unit-link'), (x) => {
      x.addEventListener('click', (e) => {
        // eslint-disable-next-line no-undef
        heapTrack('Resource section unit page opened', { link: e.target.href });
      });
    });

    [].forEach.call(document.querySelectorAll('.o-ld-pd .o-ld-cg .o-ub-ld-btn'), (x) => {
      x.addEventListener('click', (e) => {
        // eslint-disable-next-line no-undef
        heapTrack('PD link clicked', { link: e.target.href });
      });
    });
  };

  // Collects properties for PdTag needed by Heap Analytics
  const heapPd = (el) => {
    const haTitleEl = el.find('.o-ld-pd__title');
    const haTitle = haTitleEl ? haTitleEl.text() : 'N/A';

    let haType = 'N/A';
    if (el.find('.o-ld-pd-pdf')) haType = 'PDF';
    else if (el.find('.o-ld-pd__audio')) haType = 'Audio';
    else if (el.find('.o-ld-pd__video')) haType = 'Video';

    const event = el.hasClass('o-ld-pd--collapsed') ? 'PD Expanded' : 'PD Collapsed';
    // eslint-disable-next-line no-undef
    heapTrack(event, { title: haTitle, type: haType });
  };

  const initPd = () => {
    const prefix = `${COMPONENT_PREFIX}-pd`;
    const togglerSelector = `${prefix}-toggler`;

    $(`${prefix}__minimizer`).click(function() {
      $(this).closest(prefix).find(togglerSelector).click();
    });

    $(togglerSelector).click(function() {
      const el = $(this).closest(prefix);
      heapPd(el);
      el.toggleClass('o-ld-pd--collapsed o-ld-pd--expanded')
        .find('.o-ld-pd__description')
        .toggleClass('o-ld-pd__description--hidden');

      if (PDFObject.supportsPDFs) { embedPdf(el.find('.o-ld-pd-pdf__object[data-url]')[0]); }
    });

    const embedPdf = (el) => {
      if (!el) return;

      let url = el.dataset.url;

      if (!PDFObject.supportsPDFs) {
        url = `${Routes.lcms_engine_pdf_proxy_resources_path()}?url=${url}`;
      }

      PDFObject.embed(url, el, {
        pdfOpenParams: { page: 1, view: 'FitV' },
        PDFJS_URL: Routes.lcms_engine_pdfjs_full_path()
      });
    };

    eachNode('.o-ld-pd-pdf__object[data-url]', embedPdf);
  };

  function initSidebar() {
    const observers = [
      new SidebarDocMenu(), // eslint-disable-line no-undef
      new TopScroll(), // eslint-disable-line no-undef
      new SidebarSticky(), // eslint-disable-line no-undef
    ];
    // eslint-disable-next-line no-undef
    new SideBar(observers, { breakPoint: 'large', bHandleMobile: false, clsPrefix: 'ld', toTop: true });
  }

  function initToggler(component) {
    let prefix = `${COMPONENT_PREFIX}-${component}`;
    $(`${prefix}__toggler`).click(function() {
      $(`${prefix}__content--hidden`, $(this).parent()).toggle();
      $(`${prefix}__toggler--hide`, $(this)).toggle();
      $(`${prefix}__toggler--show`, $(this)).toggle();
    });
  }

  const initSelects = () => {
    const menu = document.getElementById('ld-sidebar-menu');
    if (!menu) return;

    let lastParentIdx = null;
    const items = [].map.call(menu.querySelectorAll('[href][data-duration][data-level]'), (x, i) => {
      let level = parseInt(x.dataset.level);
      if (level === 1) lastParentIdx = i;
      return {
        active: true, // by default
        duration: parseInt(x.dataset.duration),
        id: x.getAttribute('href').substr(1),
        parent: level > 1 ? lastParentIdx : null
      };
    });
    let tagsExcluded = [];

    const durationString = x => `${x} min${x > 1 ? 's' : ''}`;

    const breakElement = document.querySelector('.o-ld-optbreak-wrapper');
    const handleOptBreak = () => {
      if (!breakElement) return;
      breakElement.classList.toggle('hide', tagsExcluded.length !== 0);
    };

    const pollContentStatus = (id, key, link) => {
      $(link).prepend('<i class="fa fa-spin fa-spinner u-margin-right--base" />');

      return new Promise((resolve, reject) => {
        let poll = () => {
          $.getJSON(`${location.pathname}/export/status`, {
            context: link.dataset.context,
            jid: id,
            key: key,
            _: Date.now() // prevent cached response
          }).done(x => {
            if (x.ready) {
              $(link).find('.fa').remove();
              resolve(x.url);
            } else {
              setTimeout(poll, 2000);
            }
          }).fail(x => {
            console.warn('check content export status', x);
            reject(x);
          });
        };
        setTimeout(poll, 2000);
      });
    };

    const toggleHandler = (element, item) => {
      const deselected = element.classList.toggle('deselected');
      item.active = item.isOptional ? deselected : !deselected;
      tagsExcluded = items.filter(x => x.parent !== null && x.active === false).map(x => x.id);

      handleOptBreak();

      eachNode(`[href="#${item.id}"]`, x => {
        x.classList.toggle('o-ld-sidebar-item__content--disabled', itemIsActive(x));
      });

      updateDownloads();
      updateGroup(item.parent);

      // eslint-disable-next-line no-undef
      excludesStore.updateMaterialsList(tagsExcluded);

      setTimeout(() => {
        $('.doc-subject-ela .o-ld-sidebar__item.o-ld-sidebar-break').toggle(tagsExcluded.length === 0);
      });
    };

    const updateDownloads = () => {
      let excludesString = tagsExcluded.join(',');

      eachNode('a[data-contenttype]', link => {
        link.dataset.excludes = '';
        if (!link.dataset.originalTitle) link.dataset.originalTitle = link.textContent;
        link.textContent = excludesString ? link.dataset.customtitle : link.dataset.originalTitle;
      });
    };

    const itemIsActive = item => item.isOptional ? !item.active : item.active;

    const updateGroup = parentId => {
      const parent = items[parentId];
      const children = items.filter(x => x.parent === parentId);

      let parentDuration = children.filter(itemIsActive).reduce((a, x) => a + x.duration, 0);
      parentDuration = parentDuration > 0 ? durationString(parentDuration) : '';

      // for ELA do not disable parent if all children are Optional Activities
      let parentEnabled;
      if (isEla && children.every(x  => x.isOptional)) {
        parentEnabled = true;
      } else {
        parentEnabled = children.some(itemIsActive);
      }

      const totalTime = durationString(items.filter(x => x.parent !== null && itemIsActive(x))
        .reduce((a, x) => a + x.duration, 0));

      eachNode(`[href="#${parent.id}"]`, parentNode => {
        parentNode.classList.toggle('o-ld-sidebar-item__content--disabled', !parentEnabled);
        parentNode.querySelector('.o-ld-sidebar-item__time').textContent = parentDuration;
      });

      let contentGroup = document.getElementById(parent.id);
      let groupDuration = contentGroup ? contentGroup.querySelector('.o-ld-title__time') : null;
      if (groupDuration) groupDuration.textContent = parentDuration;

      eachNode('.o-ld-sidebar-item__time--summary', x => { x.textContent = totalTime; });
    };

    const isEla = !!document.querySelector('[data-ela]');

    eachNode('a[data-contenttype]', link => {
      link.dataset.excludes = '';

      link.addEventListener('click', e => {
        let excludesString = tagsExcluded.join(',');
        if (!excludesString) {
          link.href = link.dataset.href;
          return;
        }
        if (link.dataset.excludes === excludesString) return;

        e.preventDefault();

        link.classList.add('o-ub-btn--disabled');
        link.dataset.excludes = excludesString;

        let finish = () => {
          link.classList.remove('o-ub-btn--disabled');
          link.textContent = link.dataset.originalTitle;
        };

        $.post(`${location.pathname}/export`, {
          context: link.dataset.context,
          excludes: tagsExcluded,
          type: link.dataset.contenttype
        }).done(response => {
          link.href = response.url;
          if (response.id) {
            pollContentStatus(response.id, response.key, link).then(
              url => { if (url) link.href = url; finish(); }
            );
          } else {
            finish();
          }
        }).fail(x => {
          console.warn('export content', x);
          finish();
        });
      });
    });

    items
      .filter(x => x.parent !== null)
      .forEach(item => {
        const prefix = isEla ? '[data-deselectable]' : '';
        let content = document.querySelector(`${prefix}[data-id="${item.id}"]`);
        if (!content) return;

        item.isOptional = content.hasAttribute('data-optional');
        item.tag = content.dataset.tag;

        let container = document.createElement('div');
        content.appendChild(container);

        // eslint-disable-next-line no-undef
        let component = React.createElement(SelectActivityToggle, {
          callback: toggleHandler.bind(null, content, item),
          item,
          preface: content.querySelector('.o-ld-title .dropdown-pane'),
          meta: content.querySelector('.o-ld-activity__metacognition'),
        });
        ReactDOM.render(component, container);
      });
  };

  window.initializeLessons = function() {
    if (!$('.o-page--ld').length) return;
    initHAEvents();
    initPd();
    if (!document.querySelector('#c-ld-content[data-assessment]')) initSelects();
    initSidebar();
    initToggler('expand');
    initToggler('materials');
  };
})();
