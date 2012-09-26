(function($){
  $(function(){

    // highlight the appropriate item in the main nav on load
    (function(){
      var parts = location.pathname.split('/'),
          section = parts[1] || 'home';
      $('ul.nav>li[id]').removeClass('active').filter('#nav_' + section).addClass('active');
    })();

    // Build nav from h2s & h3s
    (function(){
      var navItems = $('[role="main"] h2, [role="main"] h3, [role="main"] h5').not(
        '#h1_tag, #h2_tag, #h3_tag, #h4_tag, #h5_tag, #h6_tag'
        );
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
          navItem = $('<li class="more">' +
                       el.html().replace(/( »|« )/, '') +
                       '</li>');
          nav.append(navItem);
        }
      });
    })();

    // These things all depend on images being loaded...
    $('body').imagesLoaded(function(){
      // Do Cycles
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

    // End ImagesLoaded
    });

  });
})(jQuery);