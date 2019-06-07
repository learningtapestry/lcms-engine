# frozen_string_literal: true

if defined?(WickedPdf)
  WickedPdf.config = {
    exe_path: ENV.fetch('WKHTMLTOPDF_PATH', '/usr/local/bin/wkhtmltopdf'),
    puppeteer_timeout: ENV.fetch('PUPPETEER_TIMEOUT', 30_000),
    use_puppeteer: true
  }
end
