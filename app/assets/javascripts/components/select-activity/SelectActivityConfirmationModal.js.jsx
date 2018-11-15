// eslint-disable-next-line no-unused-vars
class SelectActivityConfirmationModal extends React.Component {
  constructor(props) {
    super(props);

    this.heapTracked = false;
    this.expanded = false;
    this.track = this.track.bind(this);

    this.textLengthFull = this.props.text.length;
  }

  clickKeep() {
    this.track('Kept');
    this.$modal.close();
  }

  clickRemove() {
    this.track('Deselected');
    this.props.callback();
    this.$modal.close();

    let header = document.querySelector('.sticky.is-stuck');
    let offset = header ? header.clientHeight : 0;
    $('html, body').animate({
      scrollTop: $(document.getElementById(this.props.item.id)).offset().top - offset - 10
    }, 'fast');
  }

  closeModal() {
    this.heapTracked || this.track('Close');
    this.heapTracked = false; // restore state
  }

  componentDidMount() {
    if (!this.body) return;

    const $body = $(this.body);

    $body.on('open.zf.reveal', () => {
      let innerText = this.text.querySelector('.js-text');
      if (!innerText) return;

      if (this.text.scrollHeight > this.text.clientHeight) {
        let chunks = this.props.text.trim().split(/\s+/);
        while (this.text.scrollHeight > this.text.clientHeight) {
          chunks.splice(chunks.length - 1, 1);
          innerText.textContent = chunks.join(' ');
        }
        innerText.classList.remove('js-text');
        this.textLengthShort = innerText.textContent.length;
      } else {
        this.text.textContent = this.props.text;
      }
    });

    $body.on('closed.zf.reveal', this.closeModal.bind(this));

    if (this.props.item.isOptional) {
      this.props.callback();
    } else {
      this.$modal = new Foundation.Reveal($body);
      this.$modal.$element.on('click', '.js-confirm', this.clickRemove.bind(this));
      this.$modal.$element.on('click', '.js-expand', this.expandText.bind(this));
      this.$modal.$element.on('click', '.js-keep', this.clickKeep.bind(this));
    }
  }

  expandText() {
    setTimeout(() => {
      this.text.classList.add('o-ld-selection-modal__content--expanded');
      this.text.textContent = this.props.text;
      this.expanded = true;
      this.track('Learn More');
      this.heapTracked = false; // ^^ is not a final event
    });
  }

  render() {
    const modalId = `confirm-${this.props.item.id}`;

    return (
      <div className="o-ld-selection-modal reveal" data-reveal id={modalId} ref={x => this.body = x}>
        <h1 className="o-ld-selection-modal__title">Before removing, consider the activity's purpose:</h1>
        <div className="u-hr-small" />
        <p className="o-ld-selection-modal__content" ref={x => this.text = x}>
          <span className="js-text">{this.props.text}</span>
          <span className="u-margin-left--xs js-ellipsis">
            ...
            <a className="cs-txt-link--dark-gold js-expand u-margin-left--xs" href="javascript:">Read More</a>
          </span>
        </p>
        <div className="u-text--right">
          <button className="js-confirm o-btn o-btn--xs-full o-btn--bordered-yellow u-color--base u-margin-right--base" type="button">Remove Activity</button>
          <button className="js-keep o-btn o-btn--yellow o-btn--xs-full" type="button">Keep Activity</button>
        </div>
      </div>
    );
  }

  track(event, extras = {}) {
    if (!this.props.heapEnabled) return;
    this.heapTracked = true;
    const data = _.extend(extras, { textLengthShort: this.textLengthShort, textLengthFull: this.props.text.length });
    heapTrack(`Activity ${event}`, { id: this.props.item.id, learnMore: this.expanded, ...data });
  }
}
