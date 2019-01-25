// eslint-disable-next-line no-unused-vars
class ImportStatus extends React.Component {
  constructor(props) {
    super(props);
    this.state = { jobs: props.jobs };
    this.pollingInterval = 5000;
    this.chunkSize = 50;
    this.links = _.isEmpty(props.links) ? [`${props.type}/:id`] : props.links;
    this.path = _.isEmpty(props.path) ? `/admin/${this.props.type}/import_status` : props.path;
    this.withPdf = props.with_pdf || false;
  }

  componentDidMount() {
    this.intervalFn = setInterval(this.poll.bind(this), this.pollingInterval);
  }

  poll() {
    const pendingJobs = _.compact(_.map(this.state.jobs, (job, jid) => job.status !== 'done' ? jid : null));
    if (pendingJobs.length > 0) {
      _.each(_.chunk(pendingJobs, this.chunkSize), jids => this.updateChunkStatus(jids));
    } else {
      clearInterval(this.intervalFn);
    }
  }

  updateChunkStatus(jids) {
    $.getJSON(this.path, {
      jids: jids,
      type: this.props.type,
      _: Date.now(), // prevent cached response
    }).done(res => {
      let updatedJobs = {};
      _.each(res, (val, jid) => {
        updatedJobs[jid] = _.extend(this.state.jobs[jid], { status: val.status }, val.result);
      });
      this.setState({ jobs: _.extend(this.state.jobs, updatedJobs) });
    }).fail(res => {
      console.warn('check content export status', res);
    });
  }

  resourceButton(job) {
    if (this.withPdf) {
      return (
        <a href={job.link}
          className="o-adm-materials__resource ub-icon ub-file-pdf button primary u-margin-left--small u-margin-bottom--zero" target="_blank">
        </a>
      );
    }
    return _.map(this.links, (link, idx) => (
      <a key={`pl-${idx}`}
        href={linkWithParams(link, { id: job.model.id })}
        className="o-adm-materials__resource ub-icon ub-eye button primary u-margin-left--small u-margin-bottom--zero" target="_blank">
      </a>
    ));
  }

  spinner() {
    return <span className="o-adm-materials__spinner button primary u-margin-bottom--zero"><i className="fa fa-spin fa-spinner" /></span>;
  }

  render() {
    const waitingCount = _.filter(this.state.jobs, (job) =>  job.status !== 'done').length;
    const importedCount = _.filter(this.state.jobs, (job) =>  job.status === 'done' && job.ok ).length;
    const failedCount = _.filter(this.state.jobs, (job) =>  job.status === 'done' && !job.ok ).length;

    const results = _.map(this.state.jobs, (job, key) => {
      let status;
      if (job.status === 'done') {
        status = job.ok ? 'ok' : 'err';
      } else {
        status = job.status;
      }
      return (
        <li className={`o-adm-materials__result o-adm-materials__result--${status}`} key={key}>
          <div className="u-flex align-justify align-middle">
            <a href={job.link} target='_blank' className='o-adm-materials__link'>
              {job.link}
            </a>
            {job.status !== 'done' ? this.spinner() : null}
            {job.status === 'done' && job.ok ? <span>{this.resourceButton(job)}</span> : null}
          </div>
          {job.errors ? (<p dangerouslySetInnerHTML={{__html: _.join(job.errors, '<br/>')}}></p>) : null}
        </li>
      );
    });

    return (
      <div>
        <p className="o-adm-materials__summary">
          <span className='summary-entry'>• {waitingCount} Files(s) Processing</span>
          <span className='summary-entry'>{`✓ ${importedCount} File(s) ${this.withPdf ? 'Generated' : 'Imported'}`}</span>
          <span className='summary-entry'>x {failedCount} File(s) Failed</span>
        </p>
        <aside className='o-adm-materials__summary--aside u-margin-bottom--small'>
          After the (re){`${this.withPdf ? 'generation' : 'import'}`} the files for export are still in process of being generated in the background. They will appear soon after.
        </aside>
        <ul className="o-adm-materials__results">
          {results}
        </ul>
      </div>
    );
  }
}
