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
1. install google chrome (see details on #google-chrome-version)
2. set `ENABLE_BASE64_CACHING` as `false` or don't forger to clean cache on pdf related css/images changes (see below)
3. install `puppeteer`: `nvm use && yarn install`
4. set up own s3 bucket to avoid overwriting conflicts (`AWS_S3_BUCKET_NAME`)

## Deployment
1. on setting up new stack: add blank pages to s3 bucket (`rake openscied_core:s3_blank_page`)
2. on deploying new version with changes at pdf related css/images: clean cached assets (`rake cache:reset_base64`)

## Google Chrome version
Chrome version is set as `70`, if we need to use newer release
1. check PDF generation
2. change deployment [hook](https://github.com/learningtapestry/openscied-lcms/blob/master/.cloud66/install_chrome.sh#L3) and redeploy (_NOTE_: maybe add `CHROME_VERSION` env variable?)
