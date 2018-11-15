var addthis_config = {
  ui_use_css: false,
  ui_email_note: 'Unbounded',
  data_track_addressbar: false,
  pubid: 'ra-57296f7d01842a01'
};
var addthis_share = {
  url_transforms : {
    shorten: {
      twitter: 'bitly'
    }
  },
  shorteners : {
    bitly : {}
  }
};

window.initializeSocialSharing = () => {
  let addthiDescription = $("meta[name='description']").attr('content');
  addthis_config.ui_email_note = addthiDescription ? addthiDescription : '';
  if (window.addthis) { addthis.toolbox('.addthis_toolbox'); }
}
