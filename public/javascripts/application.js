/*jshint laxcomma:true, expr:true, evil:true */
(function(define, require, $, window, undefined){

  require(['datajam/init', 'datajam/views/event'], function(){
    if(! Datajam.eventId) return false;
    var el = $('body').prepend('<div class="datajam-event" />').find('.datajam-event');
    Datajam.event = new Datajam.views.Event({ el: el });
  });

})(define, require, jQuery, window);
