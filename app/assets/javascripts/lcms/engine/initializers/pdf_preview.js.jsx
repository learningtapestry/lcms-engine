window.initializePDFPreview = () => {
  if (!$('.o-resource__pdf-preview--full').length) return;

  const options = {
    pdfOpenParams: { page: 1, view: 'Fit' },
    PDFJS_URL: Routes.pdfjs_full_path()
  };
  PDFObject.embed(pdfUrl, '.o-resource__pdf-preview--full', options);
};
