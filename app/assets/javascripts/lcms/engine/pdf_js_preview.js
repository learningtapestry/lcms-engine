//= require vendor/pdf.js

/**
 * Get page info from document, set scale/canvas accordingly, and render page.
 * @param pdfDoc Pdf file.
 * @param num Page number.
 */
function renderPage(pdfDoc, num) {
  var canvas = document.getElementById('o-generic-preview__canvas');
  var context = canvas.getContext('2d');
  // Using promise to fetch the page
  pdfDoc.getPage(num).then(function(page) {
    var viewport = page.getViewport(1);
    var desiredWidth = $('.o-generic-preview').width();
    var scale = desiredWidth / viewport.width;
    var scaledViewport = page.getViewport(scale);
    canvas.height = scaledViewport.height;
    canvas.width = scaledViewport.width;

    // Render PDF page into canvas context
    var renderContext = {
      canvasContext: context,
      viewport: scaledViewport
    };
    page.render(renderContext);
    replacePDF(scaledViewport.height);
  });
}

function replacePDF(height) {
  $('.o-generic-preview__btn').removeClass('o-ub-btn--force-disabled');
  $('.o-generic-preview__btn').click(function(e) {
    e.preventDefault();
    const options = {
      pdfOpenParams: { page: 1, view: 'Fit' },
      PDFJS_URL: Routes.pdfjs_full_path(),
    };
    $('.o-generic-preview').height(height);
    var myPDF = PDFObject.embed(pdfUrl, '.o-generic-preview', options);
  });
}

document.addEventListener('turbolinks:load', function() {
  PDFJS.workerSrc = window._PDFJSworkerSrc;

  if (!$('.o-generic-preview').length) return;
  PDFJS.getDocument(pdfUrl).then(function (pdfDoc) {
    // first page rendering
    renderPage(pdfDoc, 1);
  });

});
