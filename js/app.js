(function($){
  $(function(){

    // // scrolling
    // var nav = $('.navbar') // nav element
    //   , navY = nav.offset().top * 1.5 // default position
    //   , navHeight = nav.height() // nav height for calculating offsets
    //   , navLinks = nav.find('a[href^="#"]') // on-page links in nav
    //   , pageHeight = $('body').height()
    //   , sections = $('div[role=main]').find('h2[id]').reverse() // reversed set of nav sections
    //   , scrollPos = $(window).scrollTop(); // where are we on the page?
    //     $(window).scroll(function(){
    //       scrollPos = $(this).scrollTop();
    //       // get the active nav item
    //       navLinks.each(function(){
    //         $(this).parents('li').removeClass('active');
    //       });
    //       sections.each(function(){
    //         if(scrollPos + navHeight >= $(this).offset().top){
    //           navLinks.filter('a[href=#' + $(this).attr('id') + ']').parents('li').addClass('active');
    //           return false;
    //         }
    //       });
    //       if(! nav.find('li.active').length){
    //         $('a[href=#overview]').parents('li').addClass('active');
    //       }

    //     });
    //     // scrollTo on nav click
    //     navLinks.click(function(e){
    //       e.preventDefault();
    //       var destination = $( $(this).attr('href') ).offset().top,
    //           distance;
    //       // have we taken the nav out of flow? offset by navHeight if so
    //       if(destination > navY){
    //         destination -= navHeight;
    //       }
    //       // distance to scroll as a percent of total height of page
    //       distance = Math.abs((scrollPos - destination) / pageHeight);
    //       // sqrt the distance to compress the difference a bit
    //       // otherwise, short distances will appear to scroll too fast, long ones too slowly
    //       // goal is to feel as 'proportional' as possible without actual linearity
    //       // this is based on a 1s scroll time for the whole page, adjust as needed
    //       $(window).scrollTo(destination, Math.sqrt(distance) * 1000, {easing: 'swing'});
    //     });

    //     //set active state on domready
    //     $(window).scroll()
    //       // update anything that could be affected by image heights
    //       .load(function(){
    //         navY = nav.offset().top;
    //         pageHeight = $('body').height();
    //       });

    // highlight the appropriate item in the main nav
    (function(){
      var parts = location.pathname.split('/'),
          section = parts[1] || 'home';
      $('ul.nav>li[id]').removeClass('active').filter('#nav_' + section).addClass('active');
    })();

    (function(){
      // Build nav from h2s & h3s
      var navItems = $('[role="main"] h2, [role="main"] h3, [role="main"] h5');
      var nav = $('[role="main"] ul.subnav').eq(0);
      if(! nav.length) return;
      var navItem;
      navItems.each(function(){
        var el = $(this);
        if(el.is('h2')){
          // if it's an h2, create a new top-level nav item
          navItem = $('<li><a href="#' + el.attr('id') + '">' + el.text() + '</a></li>');
          nav.append(navItem);
        }else if(el.is('h3')){
          var subNavItem = $('<li><a href="#' + el.attr('id') + '">' + el.text() + '</a></li>');
          var subNav = navItem.find('ul');
          if(! subNav.length){
            subNav = navItem.append('<ul class="nav nav-list"></ul>').find('ul');
          }
          subNav.append(subNavItem);
        }else{
          if(! nav.find('li:last').is('li.more, li.divider')){
            nav.append('<li class="divider"></li>');
          }
          navItem = $('<li class="more"><a href="' + el.attr('href') + '">' +
                       el.html().replace(/( »|« )/, '') +
                       '</a></li>');
          nav.append(navItem);
        }
      });
    })();

    // Manage sticky state of subnav
    (function(){
      var nav = $('[role="main"] ul.subnav').eq(0);
      if(! nav.length) return;
      var contentArea = nav.parent().next();
      // nav.parent().css('height', contentArea.height());
      var navTop = nav.offset().top,
          navBottom = navTop + contentArea.height(),
          navOffset = $('.navbar-inner').eq(0).height() + 20;
      $(window).scroll(function(){
        var pos = $(window).scrollTop();
        if(pos + navOffset > navTop && pos + navOffset + nav.height() < navBottom){
          nav.addClass('affixed').css({
            position: 'fixed',
            top: navOffset
          });
        }else if(pos + navOffset <= navTop){
          nav.removeClass('affixed').css({
            top: navOffset,
            position: 'absolute'
          });
        }
        if(pos + navOffset + nav.height() >= navBottom){
          nav.removeClass('affixed').css({
            top: navOffset + contentArea.height() - nav.height(),
            position: 'absolute'
          });
        }else{
          nav.css({
            bottom: 'auto'
          });
        }
      });

    })();

    // Cycles
    $('body').imagesLoaded(function(){
      $('.cycle ul').each(function(i, el){
      if($(this).children().length){
        $(this).before('<ul class="imgbtns" id="cycle' + i + 'pager"></ul>');
        $(this).parents('.cycle').addClass('active');
      }
      $(this).cycle({
        speed: 400,
        sync: 0,
        timeout: 8000,
        pager: '#cycle' + i + 'pager',
        activePagerClass: 'active',
        pagerAnchorBuilder: function(i, el){
          return '<li><a class="textreplace" href="#">button' + i + '</a></li>';
        },
        updateActivePagerLink: function(pager, i, classname){
          $(pager).find('li a').removeClass(classname).eq(i).addClass(classname);
        }
      });
    });
    });

  });
})(jQuery);