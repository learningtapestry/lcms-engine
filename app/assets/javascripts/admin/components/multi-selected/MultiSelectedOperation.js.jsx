// eslint-disable-next-line no-unused-vars
class MultiSelectedOperation extends React.Component {
  componentDidMount() {
    const $this = $(ReactDOM.findDOMNode(this));
    $this.parent().addClass('c-multi-selected-btn');
  }

  onSubmit(evt) {
    if (this.props.operation === 'delete' && !confirm('Are you sure?')) return;

    const entries = $('.o-page .table input[name="selected_ids[]"]');
    const ids = _.filter(entries, (e) => e.checked).map((e) => e.value);
    if (ids.length === 0) return evt.preventDefault();

    const form = $(this.formRef);
    form.find('input[name=selected_ids]').val(ids.join(','));
    form.find('[type=submit]').prop('disabled', true);
  }

  render() {
    const btnClass = `button ${this.props.btn_style}`;
    const method = (this.props.operation === 'delete') ? 'delete' : 'post';
    const csrf_token = $('meta[name=csrf-token]').attr('content');
    return (
      <form ref={ ref => { this.formRef = ref; }} action={this.props.path} acceptCharset="UTF-8" method='post' className="c-reimport-doc-form" onSubmit={this.onSubmit.bind(this)} >
        <input name="utf8" value="✓" type="hidden" />
        <input name="_method" value={method} type="hidden" />
        <input name="authenticity_token" value={csrf_token} type="hidden" />
        <input name="selected_ids" type="hidden" />
        <input name="with_materials" type="hidden" className="c-reimport-with-materials__field"/>
        <input value={this.props.text} className={btnClass} type="submit" />
      </form>
    );
  }
}
