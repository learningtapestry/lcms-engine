// eslint-disable-next-line no-unused-vars
class ExploreCurriculumPage extends React.Component {
  constructor(props) {
    super(props);

    this.state = this.buildStateFromProps(props);
    this.ANIMATION_DURATION = 400;
    this._curriculumList = null;
  }

  updateUrl($active) {
    if (!$active && !/p=/.test(location.search)) return;
    if ($active && !$active.length) return;

    let query = { p: null, e: null };
    if ($active) {
      query['p'] = $active[0].getAttribute('name');
      if ( this.state.active[this.state.active.length - 2] === $active[0].id ) {
        query['e'] = '1';
      }
    }

    urlHistory.update(query, { replace: true });
  }

  componentDidMount() {
    this._curriculumList = $('#curriculumList');
    new Foundation.MaggelanHash(this._curriculumList,
      { deepLinking: true,
        updateUrl: this.updateUrl.bind(this),
        threshold: 20,
        animationDuration: this.ANIMATION_DURATION,
        onScrollFinished: this.onScrollFinished.bind(this)
      });
    let elm;
    if (this.scrollImmediately === 'item') {
      elm = document.getElementById(this.state.active[this.state.active.length-1]);
      if (!elm) {
        elm = document.getElementById(this.state.active[this.state.active.length-2]);
      }
      this.scrollToActive(elm);
    } else if (this.scrollImmediately === 'expanded') {
      elm = document.getElementById(this.state.active[this.state.active.length-2]);
      this.scrollToActive(elm);
    }
  }

  componentWillUnmount() {
    if (this._curriculumList) {
      this._curriculumList.foundation('destroy');
    }
  }

  componentWillUpdate(_nextProps, _nextState) {
    if (this._curriculumList) {
      this._curriculumList.foundation('mutexScrollLock');
    }
  }

  componentDidUpdate(_prevProps, _prevState) {
    if (this._curriculumList) {
      this._curriculumList.foundation('mutexScrollUnlock');
    }
  }

  onScrollFinished(el) {
    _.delay(() => { if (el && $(el).length) {
      const yOffset = $(el).offset().top;
      // fix animation sync, will get inside in very rare cases
      if (Math.abs($(document).scrollTop() - yOffset) > 25) {
        $('html, body').scrollTop(yOffset);
      }
    }
    this._curriculumList.foundation('mutexScrollUnlock');
    this._curriculumList.foundation('reflow');
    }, this.ANIMATION_DURATION / 4);
  }

  scrollToActive(el) {
    if (el && $(el).length) {
      this._curriculumList.foundation('mutexScrollLock');
      this._curriculumList.foundation('scrollToLoc', el);
    }
    else {
      this.updateUrl(null);
    }
  }

  reflow() {
    this._curriculumList.foundation('reflow');
  }

  buildStateFromProps(props) {
    let active;

    if (props.active) {
      active = props.active;

      if (props.expanded) {
        this.scrollImmediately = 'expanded';
      } else {
        this.scrollImmediately = 'item';
      }
    } else {
      active = props.results.length ? [props.results[0].id] : null;
    }

    return {
      curriculums: props.results,
      curriculumsIndex: this.buildIndex(props.results),
      filterbar: props.filterbar,
      active: active
    };
  }

  buildIndex(curriculums, zip = {}) {
    _.forEach(curriculums, curriculum => {
      zip[curriculum.id] = curriculum;

      if (curriculum.children.length) {
        this.buildIndex(curriculum.children, zip);
      }
    });

    return zip;
  }

  createQuery(state) {
    return {
      format: 'json',
      ...state.filterbar
    };
  }

  fetch(state) {
    const query = this.createQuery(state);
    const url = Routes.explore_curriculum_index_path(query);
    return $.getJSON(url);
  }

  fetchOne(id) {
    const url = Routes.explore_curriculum_path(id);
    return $.getJSON(url);
  }

  getActive(parentage, cur) {
    return cur.children.length > 0 ?
      [...parentage, cur.children[0].id] :
      [...parentage];
  }

  setActive(parentage, cur, el) {
    this.setState({
      ...this.state,
      active: this.getActive(parentage, cur)
    }, this.scrollToActive.bind(this, el));
  }

  handleClickExpand(parentage, e) {
    if (e.target.nodeName === 'A') return;
    e.preventDefault();
    const currentTarget = `#${e.currentTarget.id}`;
    if (parentage[parentage.length-1] === this.state.active[parentage.length-1]) {
      this.setState({
        ...this.state,
        active: parentage
      }, this.scrollToActive.bind(this, currentTarget));
    } else {
      this.handleClickViewDetails(parentage, e);
    }
  }

  handleClickViewDetails(parentage, e) {
    if ((e.target.nodeName === 'A') || (e.target.nodeName === 'I'))  return;
    e.preventDefault();
    const currentTarget = `#${e.currentTarget.id}`;
    const id = _.last(parentage);
    const cur = this.state.curriculumsIndex[id];
    const hasCached = cur &&
      (cur.requested ||
        (cur.children.length &&
          this.state.curriculumsIndex[cur.children[0].id]));

    if (hasCached) {
      this.setActive(parentage, cur, currentTarget);
    } else {
      this.fetchOne(id).then(response => {
        response.requested = true;
        const newIndex = { ...this.state.curriculumsIndex };
        this.buildIndex([response], newIndex);
        this.setState({
          ...this.state,
          curriculumsIndex: newIndex,
          active: this.getActive(parentage, response)
        }, this.scrollToActive.bind(this, currentTarget));
      });
    }
  }

  handleFilterbarUpdate(filterbar) {
    const newFilterbar = _.omit(filterbar, 'search_term');
    const oldFilterbar = _.omit(this.state.filterbar, 'search_term');
    const onlyChangedSearchTerm = $.param(newFilterbar) === $.param(oldFilterbar);

    const newState = _.assign({}, this.state, { filterbar: filterbar });

    if (onlyChangedSearchTerm) {
      this.setState(newState);
    } else {
      this.fetch(newState).then(response => {
        this.setState(this.buildStateFromProps(response),
          this.reflow.bind(this));
      });
    }
  }

  render() {
    const curriculums = this.state.curriculums.map(
      c => <ExploreCurriculumItem
        key={c.id}
        id={c.id}
        index={this.state.curriculumsIndex}
        onClickExpand={this.handleClickExpand.bind(this)}
        onClickViewDetails={this.handleClickViewDetails.bind(this)}
        parentage={[c.id]}
        active={this.state.active} />
    );

    return (
      <div>
        <div className="u-bg--base-gradient">
          <div className="o-page">
            <div className="o-page__module">
              <div className="o-filterbar-title">
                <h2>Explore Curriculum</h2>
                <div className="o-filterbar-title__subheader">
                  Explore ELA and Math lessons for the grades below. Review, adapt, download, and share.
                </div>
              </div>
              <FilterbarResponsive
                onUpdate={this.handleFilterbarUpdate.bind(this)}
                searchLabel='What do you want to teach?'
                withSearch={true}
                withDropdown={true}
                {...this.state.filterbar} />
            </div>
          </div>
        </div>
        <div className="o-page o-page--margin-bottom">
          <div className="o-page__module">
            <ExploreCurriculumHeader totalItems={this.state.curriculums.length} />
            {curriculums}
          </div>
        </div>
      </div>
    );
  }
}
