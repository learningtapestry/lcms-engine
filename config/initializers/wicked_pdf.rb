# frozen_string_literal: true

WickedPdf.config = {
  exe_path: ENV.fetch('WKHTMLTOPDF_PATH', '/usr/local/bin/wkhtmltopdf'),
  puppeteer_timeout: ENV.fetch('PUPPETEER_TIMEOUT', 30000),
  use_puppeteer: true
}
