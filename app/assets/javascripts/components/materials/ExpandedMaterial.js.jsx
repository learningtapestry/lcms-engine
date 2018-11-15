// eslint-disable-next-line no-unused-vars
class ExpandedMaterial extends React.Component {
  componentDidMount() {
    let { id, pdf_url } = this.props;
    const options = {
      pdfOpenParams: { page: 1, view: 'FitV' },
      PDFJS_URL: Routes.pdfjs_full_path()
    };
    if (!PDFObject.supportsPDFs) {
      pdf_url = `${Routes.pdf_proxy_resources_path()}?url=${pdf_url}`;
    }
    PDFObject.embed(pdf_url, `#pdfobject-${id}`, options);
  }

  render() {
    const { gdoc_url, id, index, onMinimize, onClick, orientation, source_type, pdf_url } = this.props;
    const isPDF = source_type === 'pdf';
    const clsBtn = 'o-btn o-btn--bordered-base o-ub-ld-btn--material u-preserve-style';
    const clsBtnExt = `${clsBtn} u-margin-right--xs`;
    const clsBtnExtLast = classNames(clsBtn, { 'u-margin-right--xs': !isPDF});
    return (
      <div className="o-m-preview__wrap u-padding-top--base">
        <div className="o-m-preview__actions u-padding-top--base">
          <a className={clsBtnExt} onClick={() => onMinimize(false)}>Minimize</a>
          <a className={clsBtnExt} href={pdf_url} onClick={() => onClick('print', index)} target="_blank">Print</a>
          <a className={clsBtnExtLast} href={pdf_url} onClick={() => onClick('view', index)} target="_blank">View PDF</a>
          { !isPDF &&  <a className={clsBtn} href={gdoc_url} onClick={() => onClick('gdoc', index)} target="_blank">View GDOC</a> }
        </div>
        <div className={`o-m-preview--${orientation}`}>
          <div id={`pdfobject-${id}`} className="o-m-preview pdfobject-container content">
          </div>
        </div>
      </div>
    );
  }

}
