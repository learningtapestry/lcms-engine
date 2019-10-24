"use strict";

(function () {
  window.initializePDFPreview = function () {
    if (!$('.o-resource__pdf-preview--full').length) return;
    var options = {
      pdfOpenParams: {
        page: 1,
        view: 'Fit'
      },
      PDFJS_URL: Routes.lcms_engine_pdfjs_full_path()
    };
    PDFObject.embed(pdfUrl, '.o-resource__pdf-preview--full', options);
  };
})();
