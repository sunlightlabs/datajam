(function($){
  $(function(){

    // scrolling
    var nav = $('.navbar') // nav element
      , navY = nav.offset().top * 1.5 // default position
      , navHeight = nav.height() // nav height for calculating offsets
      , navLinks = nav.find('a[href^="#"]') // on-page links in nav
      , pageHeight = $('body').height()
      , sections = $('div[role=main]').find('h2[id]').reverse() // reversed set of nav sections
      , scrollPos = $(window).scrollTop(); // where are we on the page?
        $(window).scroll(function(){
          scrollPos = $(this).scrollTop();
          // get the active nav item
          navLinks.each(function(){
            $(this).parents('li').removeClass('active');
          });
          sections.each(function(){
            if(scrollPos + navHeight >= $(this).offset().top){
              navLinks.filter('a[href=#' + $(this).attr('id') + ']').parents('li').addClass('active');
              return false;
            }
          });
          if(! nav.find('li.active').length){
            $('a[href=#overview]').parents('li').addClass('active');
          }

        });
        // scrollTo on nav click
        navLinks.click(function(e){
          e.preventDefault();
          var destination = $( $(this).attr('href') ).offset().top,
              distance;
          // have we taken the nav out of flow? offset by navHeight if so
          if(destination > navY){
            destination -= navHeight;
          }
          // distance to scroll as a percent of total height of page
          distance = Math.abs((scrollPos - destination) / pageHeight);
          // sqrt the distance to compress the difference a bit
          // otherwise, short distances will appear to scroll too fast, long ones too slowly
          // goal is to feel as 'proportional' as possible without actual linearity
          // this is based on a 1s scroll time for the whole page, adjust as needed
          $(window).scrollTo(destination, Math.sqrt(distance) * 1000, {easing: 'swing'});
        });

        //set active state on domready
        $(window).scroll()
          // update anything that could be affected by image heights
          .load(function(){
            navY = nav.offset().top;
            pageHeight = $('body').height();
          });

    // highlight the appropriate nav item
    (function(){
      var parts = location.pathname.split('/'),
          section = parts[1] || 'home';
      $('ul.nav>li[id]').removeClass('active').filter('#nav_' + section).addClass('active');
    })();

  });
})(jQuery);