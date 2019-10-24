"use strict";

(function () {
  function initSwipers() {
    var swiperVideos = new Swiper('.c-ls-slides--a', {
      slidesPerView: 'auto',
      nextButton: '.c-ls-slides--a__next',
      prevButton: '.c-ls-slides--a__prev',
      spaceBetween: 20
    });
    var swiperPosts = new Swiper('.c-ls-slides--l', {
      slidesPerView: 'auto',
      nextButton: '.c-ls-slides--l__next',
      prevButton: '.c-ls-slides--l__prev'
    });
  }

  window.initializeLeadership = function () {
    if (!$('.c-ls-hero').length) return;
    initSwipers();
  };
})();
