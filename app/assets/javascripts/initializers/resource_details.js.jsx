window.initializeResourceDetails = () => {
  $('.o-resource-downloads__btn').click(function(){
    $('.o-resource-downloads__list', $(this).parent()).toggle('fast');
    $('.o-resource-downloads__btn--more', $(this).parent()).toggle();
    $('.o-resource-downloads__btn--less', $(this).parent()).toggle();
  });

  [].forEach.call(document.querySelectorAll('a.resource-attachment'), function(el) {
    if (!el.dataset.heapData) return;
    const data = JSON.parse(el.dataset.heapData);
    if (data) {
      el.addEventListener('click', function() {
        heapTrack('Resource download', data);
      });
    }
  });
};
