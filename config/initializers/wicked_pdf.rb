# frozen_string_literal: true

WickedPdf.config = {
  exe_path: ENV.fetch('WKHTMLTOPDF_PATH', '/usr/local/bin/wkhtmltopdf'),
  use_puppeteer: true
}
