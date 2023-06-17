$(window).scroll(function() {
  if ($(window).scrollTop() > $(document).height() - $(window).height() - 50) {
    $.getScript($('.pagination a.next_page').attr('href'));
  }
});
