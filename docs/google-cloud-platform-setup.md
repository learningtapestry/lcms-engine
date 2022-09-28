# Google Cloud Platform setup

An application calls the Google Application Script in order to post-process generated lesson materials. Instructions below contains all the necessary steps need to set up the integration.

All environment variables and user names provided here have been set up to automate deployment on [Cloud66](https://www.cloud66.com) service stacks. If you plan to use another service provider please change all the variables accordingly.

1. [Set up](#set-up)
2. [How to update Google Application Script](#how-to-update-google-application-script)

## Set up

### Login to google

All google docs will be saved under this account. Also, this Google Account should have access to all source documents which will be imported into the system.

### Create project

Name it whatever you like, i.e. LCMS-dev at [google cloud](https://console.cloud.google.com)

### Enable Google API

Enable Google Drive API, Google Apps Script Execution API for that [project](https://console.cloud.google.com/apis/library)

### Set up google auth

#### Credentials

Create credentials:
  - type oAuth Client ID
  - Application type: Web Application,
  - Application Name: up to you, i.e. lcms-cli-dev

Download credentials JSON file.

###### Local development

Copy downloaded JSON file to `config/google/client_secret.json`

###### Server

Make sure you're executing commands under _cloud66-user_
```bash
$ sudo -i -u cloud66-user
```

Make sure that the following directory exists on a server and is symlinked correctly
```bash
$ mkdir -p "$STACK_BASE/shared/google"
$ chown cloud66-user:cloud66-user "$STACK_BASE/shared/google"
$ ln -nsf "$STACK_BASE/shared/google" "$STACK_PATH/config/google"
```

Copy downloaded JSON file and set appropriate ownership and access rights for it (where `cloud66-user` is a system username under which web application is running)

```bash
$ cp client_secret.json $STACK_BASE/shared/google/
$ cd $STACK_BASE/shared/google
$ sudo chown cloud66-user:cloud66-user client_secret.json
$ sudo chmod 755 client_secret.json
```

#### Application token

If you generate token on a remote server, then make sure you're executing commands under _cloud66-user_

```bash
$ sudo -i -u cloud66-user
```

Run rake task providing the domain name which is registered as _Authorized redirect URIs_ in Google OAuth client.
You will be asked to go by link, give app permissions and paste code into the terminal

```bash
$ bundle exec rake google:setup_auth["https://example.com"]
```

This will create `config/google/app_token.yaml`. Change the ownership of the `app_token.yaml` otherwise it will not be accessible for the application:

```bash
$ cd $STACK_BASE/shared/google
$ chown cloud66-user:app_writers app_token.yaml
$ sudo chmod g+w app_token.yaml
```

#### Add Google App script

- go to https://www.google.com/script/start/
- copy-paste content of `config/scripts/Code.gs` there and save
- at top menu Resources->Cloud Platform Project set project from step 2 (you need to paste *project number*)
- at top menu Publish->Deploy As API Executable set version v1, access Only myself
- save Current API ID somewhere (wil be used for _GOOGLE_APPLICATION_SCRIPT_ID_), click Close on that annoying window (update will not close it)
- choose any function and run it, it'll request permissions - grant them (there will be security warnings, just ignore them)

### Create special folder in Google Drive

All materials will be saved there. Give view only to all by link, keep folder id (last part of url) for _GOOGLE_APPLICATION_FOLDER_ID_,
copy to the root of the this folder these documents and keep their IDs for (_GOOGLE_APPLICATION_TEMPLATE_LANSCAPE_, _GOOGLE_APPLICATION_TEMPLATE_PORTRAIT_):
- [LANDSCAPE](https://docs.google.com/document/d/1pXQDNKYOJYT6OTPnp8gsTWAydg5B9GTRibaWspmX4oE)
- [PORTRAIT](https://docs.google.com/document/d/1ijuZhGQXkPBxcZT4DRyNVY-qmI0xyVvSzVFqckOpsCc)

### Update corresponding env-file in the project
```
GOOGLE_APPLICATION_FOLDER_ID=
GOOGLE_APPLICATION_SCRIPT_ID=
GOOGLE_APPLICATION_TEMPLATE_PORTRAIT=
GOOGLE_APPLICATION_TEMPLATE_LANSCAPE=
```

## How to update Google Application Script

1. Proceed to Google Drive for an account which has been used to create the Google Application Script (see _Add script_ section in [Set up](#set-up))

2. Update script content

3. Re-publish the script:

- `Publish->Deploy As API Executable`
- Set new version
- `Update` & `Close`
- Choose any function and run it, it'll request permissions - grant them (there will be security warnings, just ignore them)
