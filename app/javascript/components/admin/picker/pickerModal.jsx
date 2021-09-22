import ReactDOM from 'react-dom';

function pickerModal() {
  new Foundation.Reveal(this.jqmodal, null);
  this.jqmodal.on('open.zf.reveal', () => this.jqmodal.css({ top: '15px' }));
  this.jqmodal.on('closed.zf.reveal', () => {
    ReactDOM.unmountComponentAtNode(this.modal);
  });
}

export default pickerModal;
