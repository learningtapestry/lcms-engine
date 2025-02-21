import React from 'react';
import PropTypes from 'prop-types';
import _ from 'lodash';
import $ from 'jquery';

class ImportStatus extends React.Component {
  constructor(props) {
    super(props);
    this.state = { jobs: props.jobs || [] };
    this.pollingInterval = props.pollingInterval || props.polling_interval || 5000;
    this.chunkSize = 50;
    this.links = _.isEmpty(props.links) ? [`${props.type}/:id`] : props.links;
    this.withPdf = props.with_pdf || props.withPdf || false;
  }

  componentDidMount() {
    this.startPolling();
  }

  componentWillUnmount() {
    this.poll();
  }

  hasPendingJobs = () => {
    return _.some(this.state.jobs, job => job.status !== 'done');
  };

  poll() {
    const pendingJobs = _.compact(_.map(this.state.jobs, (job, jid) => (job.status !== 'done' ? jid : null)));
    if (pendingJobs.length > 0) {
      const promises = _.map(_.chunk(pendingJobs, this.chunkSize), jids => this.updateChunkStatus(jids));
      Promise.allSettled(promises).then(() => {
        this.timeoutFn = setTimeout(() => this.poll(), this.pollingInterval); // Schedule the next poll
      });
    } else {
      this.stopPolling();
    }
  }

  startPolling = () => {
    this.stopPolling(); // Clear any existing timeout
    if (this.hasPendingJobs()) {
      this.poll();
    }
  };

  stopPolling = () => {
    if (this.timeoutFn) {
      clearTimeout(this.timeoutFn);
      this.timeoutFn = null;
    }
  };

  updateChunkStatus(jids) {
    $.getJSON(this.props.pollingPath || this.props.polling_path, {
      jids: jids,
      type: this.props.type,
      _: Date.now(), // prevent cached response
    })
      .done(res => {
        let updatedJobs = {};
        _.each(res, (val, jid) => {
          updatedJobs[jid] = _.extend(this.state.jobs[jid], { status: val.status }, val.result);
        });
        this.setState({ jobs: _.extend(this.state.jobs, updatedJobs) });
      })
      .fail(res => {
        console.warn('check content export status', res); // eslint-disable-line no-console
      });
  }

  resourceButton(job) {
    if (this.withPdf) {
      return (
        <a href={job.link} target="_blank" rel="noreferrer">
          <i className="fa-regular fa-file-pdf"></i>
        </a>
      );
    }

    let linkWithParams = function (route, params = {}) {
      let path = route;
      _.each(params, (v, k) => {
        path = _.replace(path, `:${k}`, v);
      });
      return path;
    };

    return _.map(this.links, (link, idx) => (
      <span className="m-2">
        <a
          key={`pl-${idx}`}
          href={typeof job.model === 'undefined' ? link : linkWithParams(link, { id: job.model.id })}
          target="_blank"
          rel="noreferrer"
        >
          <i className="fa-solid fa-eye"></i>
        </a>
      </span>
    ));
  }

  spinner() {
    return (
      <span>
        <i className="fas fa-spin fa-spinner" />
      </span>
    );
  }

  render() {
    const waitingCount = _.filter(this.state.jobs, job => job.status !== 'done').length;
    const importedCount = _.filter(this.state.jobs, job => job.status === 'done' && job.ok).length;
    const failedCount = _.filter(this.state.jobs, job => job.status === 'done' && !job.ok).length;

    const results = _.map(this.state.jobs, (job, key) => {
      let status;
      switch (job.status) {
        case 'done':
          if (job.ok) {
            status = _.isEmpty(job.warnings) ? 'list-group-item-success' : 'list-group-item-warning';
          } else {
            status = 'list-group-item-danger';
          }
          break;
        case 'running':
          status = 'list-group-item-primary';
          break;
        default:
          status = '';
      }
      return (
        <li className={`d-flex justify-content-between align-items-start list-group-item ${status}`} key={key}>
          <div className="me-auto">
            <a href={job.link} target="_blank" className="" rel="noreferrer">
              {job.status !== 'done' ? job.text || job.link : 'Done'}
            </a>
            {job.status === 'done' && job.ok ? <span className="m-2">{this.resourceButton(job)}</span> : null}
          </div>
          <div>
            {!_.isEmpty(job.errors) ? (
              <p className="mb-0" dangerouslySetInnerHTML={{ __html: _.join(job.errors, '<br/>') }}></p>
            ) : null}
            {!_.isEmpty(job.warnings) ? (
              <p className="mb-0 text-start" dangerouslySetInnerHTML={{ __html: _.join(job.warnings, '<br/>') }}></p>
            ) : null}
          </div>
          {job.status !== 'done' ? this.spinner() : null}
        </li>
      );
    });

    return (
      <div className="text-center p-1">
        <div className="row mb-3">
          <div className="col">{waitingCount} Files(s) Processing</div>
          <div className="col">{`${importedCount} File(s) ${this.withPdf ? 'Generated' : 'Imported'}`}</div>
          <div className="col">{failedCount} File(s) Failed</div>
        </div>
        <ul className="list-group">{results}</ul>
      </div>
    );
  }
}

ImportStatus.propTypes = {
  jobs: PropTypes.object.isRequired,
  links: PropTypes.array,
  type: PropTypes.string.isRequired,
  polling_path: PropTypes.string.isRequired,
  pollingPath: PropTypes.string.isRequired,
  pollingInterval: PropTypes.number,
  polling_interval: PropTypes.number,
  with_pdf: PropTypes.bool,
  withPdf: PropTypes.bool,
};

export default ImportStatus;
