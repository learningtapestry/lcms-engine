import $ from 'jquery';
import React from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';
import _ from 'lodash';

class MultiSelectedOperation extends React.Component {
  constructor(props) {
    super(props);

    this.onSubmit = this.onSubmit.bind(this);
  }

  componentDidMount() {
    // eslint-disable-next-line react/no-find-dom-node
    const $this = $(ReactDOM.findDOMNode(this));
    $this.parent().addClass(`c-multi-selected-btn ${this.props.wrapperClass}`);
  }

  onSubmit(evt) {
    if (this.props.operation === 'delete' && !confirm('Are you sure?')) return; // eslint-disable-line no-restricted-globals

    const entries = $('.o-page .table input[name="selected_ids[]"]');
    const ids = _.filter(entries, e => e.checked).map(e => e.value);
    if (ids.length === 0) return evt.preventDefault();

    const form = $(this.formRef);
    form.find('input[name=selected_ids]').val(ids.join(','));
    form.find('[type=submit]').prop('disabled', true);
  }

  render() {
    const btnClass = `btn ${this.props.btnStyle}`;
    const method = this.props.operation === 'delete' ? 'delete' : 'post';
    const csrf_token = $('meta[name=csrf-token]').attr('content');
    return (
      <form
        ref={ref => {
          this.formRef = ref;
        }}
        action={this.props.path}
        acceptCharset="UTF-8"
        method="post"
        className="c-reimport-doc-form"
        onSubmit={this.onSubmit}
      >
        <input name="utf8" value="✓" type="hidden" />
        <input name="_method" value={method} type="hidden" />
        <input name="authenticity_token" value={csrf_token} type="hidden" />
        <input name="selected_ids" type="hidden" />
        <input name="with_materials" type="hidden" className="c-reimport-with-materials__field" />
        <input value={this.props.text} className={btnClass} type="submit" />
      </form>
    );
  }
}

MultiSelectedOperation.propTypes = {
  operation: PropTypes.string,
  btnStyle: PropTypes.string,
  wrapperClass: PropTypes.string,
  path: PropTypes.string,
  text: PropTypes.string,
};

export default MultiSelectedOperation;
