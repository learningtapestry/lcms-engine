# CKEEditor usage

Current version is 4.22.1 - this is the latest OpenSource version and the latest with v4.x family.

If you override `app/views/layouts/lcms/engine/admin.html.erb` layout add the following line to it:

```html
<head>
    <!-- ...  -->
    <%= javascript_include_tag Ckeditor.cdn_url, "data-turbo-track": "reload", defer: true %>
    <!-- ...  -->
</head>
```
