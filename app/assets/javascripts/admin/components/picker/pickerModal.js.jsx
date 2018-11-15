// eslint-disable-next-line no-unused-vars
function pickerModal() {
  new Foundation.Reveal(this.jqmodal);
  this.jqmodal.on('open.zf.reveal', () => this.jqmodal.css({ top: '15px' }));
  this.jqmodal.on('closed.zf.reveal', () => {
    ReactDOM.unmountComponentAtNode(this.modal);
  });
}
