# PDF Generation

We're using [puppeteer](https://pptr.dev/) with headless chrome for PDF generation.

## PDF security policy
After fresh server installation ImageMagick security policies have to be updated. Complete the following steps:

1. Locate the file `/etc/ImageMagick-6/policy.xml`
2. Find the policy for PDF format. It looks like this
```xml
<policy domain="coder" rights="none" pattern="PDF" />
```
3. Change it to this
```xml
<policy domain="coder" rights="read|write" pattern="PDF" />
```

## Local development
1. install Puppeteer + maybe some missed libraries for Chrome (see details on #puppeteer), install `puppeteer`: `nvm use && yarn install`
2. set `ENABLE_BASE64_CACHING` as `false` or don't forger to clean cache on pdf related css/images changes (see below)
3. set up own s3 bucket to avoid overwriting conflicts (`AWS_S3_BUCKET_NAME`)

## Deployment
1. on setting up new stack: add blank pages to s3 bucket (`rake openscied_core:s3_blank_page`)
2. on deploying new version with changes at pdf related css/images: clean cached assets (`rake cache:reset_base64`)

## Puppeteer
Chrome version will come with Puppeteer, but there maybe some missed libraries or other issues, please check [troubleshooting](https://pptr.dev/troubleshooting).

Starting from Puppeteer version `19.0` Puppeteer will download browsers into `~/.cache/puppeteer` using `os.homedir` for better caching between Puppeteer upgrades. As c66 deployment is done by different user the recommended `.puppeteerrc.cjs` config is
```
const {join} = require('path');

/**
 * @type {import("puppeteer").Configuration}
 */
module.exports = {
  // Changes the cache location for Puppeteer.
  cacheDirectory: process.env['STACK_BASE'] ? join(__dirname, '.cache', 'puppeteer') : null,
};
```

Starting from `wicked_pdf` 2.0.5 it's possible to switch between [Chrome headless mode](https://developer.chrome.com/docs/chromium/new-headless) with `PUPPETEER_HEADLESS_MODE` env var, default value will be old (true).