## Required variables

- APP_NAME
- APPLICATION_DOMAIN
- AWS_ACCESS_KEY_ID
- AWS_REGION
- AWS_S3_BUCKET_NAME
- AWS_SECRET_ACCESS_KEY
- BACKGROUND_JOBS
- ELASTICSEARCH_ADDRESS
- NODE_ENV
- POSTGRESQL_ADDRESS
- POSTGRESQL_DATABASE
- POSTGRESQL_USERNAME
- POSTGRESQL_PASSWORD
- POSTGRESQL_PORT
- WEBPACKER_CHECK_YARN
- WKHTMLTOPDF_PATH

## All other variables

* [AirBrake](#airbrake-config)
* [Amazon](#amazon-config)
* [Google](#google-config)
* [Miscellaneous settings](#miscellaneous-settings)
* [PDF](#pdf-related-config)
* [Postgres](#postgres-config)

### AirBrake config
The project is set up to support Airbrake, if you use it. You can provide an Airbrake ID and key in the config to enable it (Should be omitted for `development`&`test` environments)

|Name|Description|
|----|-----------|
|AIR_BRAKE_PROJECT_ID|Project id in the AirBrake service|
|AIR_BRAKE_PROJECT_KEY|Project key in the AirBrake service|

### Amazon config
The project uses AWS S3 to store and serve generated PDFs of learning content. You will need to set up an S3 bucket and provide a key and secret here:

|Name|Description|
|----|-----------|
|AWS_ACCESS_KEY_ID|Public part of the AWS credentials|
|AWS_REGION|Name of the region used for AWS service|
|AWS_SECRET_ACCESS_KEY|Private part of the AWS credentials|
|AWS_S3_BUCKET_NAME|Bucket used by application to store generated files|

### Google config
The project uses several Google products, including analytics, OAuth for allowing the application to use Google APIs, and several Google Drive folders.

|Name|Description|
|----|-----------|
|GOOGLE_APPLICATION_FOLDER_ID|Id of the Google Drive folder where generated lessons and materials will be placed(It's `0B7` for url like `https://drive.google.com/drive/u/0/folders/0B7/...`)|
|GOOGLE_APPLICATION_SCRIPT_ID|Id of the Google Script created to post-process generated Google documents. More details can be found [here](google-cloud-platform-setup.md)|
|GOOGLE_APPLICATION_SCRIPT_FUNCTION|Name of the function to call to start post-processing|
|GOOGLE_APPLICATION_TEMPLATE_PORTRAIT|Id of the Google document which is a template for portrait materials(can be identified the same way as `GOOGLE_APPLICATION_FOLDER_ID `)|
|GOOGLE_APPLICATION_TEMPLATE_LANDSCAPE|Id of the Google document which is a template for landscape materials(can be identified the same way as `GOOGLE_APPLICATION_FOLDER_ID `)|
|GOOGLE_APPLICATION_PREVIEW_FOLDER_ID| Folder ID where preview documents should get placed
|GOOGLE_API_CLIENT_UPLOAD_RETRIES||
|GOOGLE_API_CLIENT_UPLOAD_TIMEOUT||

### Miscellaneous settings
|Name|Description|
|----|-----------|
|APP_NAME|The title which will be shown in the page title and in other places. Something like `OpenSciEd LCMS`|
|BITLY_API_TOKEN|Token of the Bitly service|
|RESQUE_NAMESPACE|Value is used to separate data stored in Redis when the same redis server is used by multiple environments|
|PUPPETEER_TIMEOUT|Default is 30 sec|
|WORKERS_COUNT|Used on the servers. Specifies the number of workers to be started|
|ELASTICSEARCH_ADDRESS|Elasticsearch server address|

Obs: if you're setting a local dev machine on OSX and getting small fonts when generating pdfs, try downgrading wkhtmltopdf to `0.12.3`

### PDF related config
|Name|Description|
|----|-----------|
|ENABLE_BASE64_CACHING|Turns on/off caching of assets used for PDF generation (`true` by default, recommended as `false` for local env)|
|NODE_ENV|We're using puppeteer(npm package) for PDF Generation, should be set as `production` for other env than local|
|WKHTMLTOPDF_PATH|Path to the [wkhtmltopdf](https://wkhtmltopdf.org) binary. Default to `/usr/local/bin/wkhtmltopdf`. Will be removed when we will be certain on puppeteer|

### Postgres config
|Name|
|----|
|POSTGRESQL_ADDRESS|
|POSTGRESQL_DATABASE|
|POSTGRESQL_USERNAME|
|POSTGRESQL_PASSWORD|
|POSTGRESQL_PORT|
