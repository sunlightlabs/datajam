/*jshint laxcomma:true, expr:true, evil:true */
(function(define, require, $, window, undefined){

  require(['datajam/init', 'datajam/views/event'], function(){
    var el = $('body').prepend('<div class="datajam-event" />').find('.datajam-event');
    Datajam.event = new Datajam.views.Event({ el: el });
  });

  // doc ready handler
  $(function(){
    // bind reminder form
    $('#remind_event')
      .bind("ajax:success", function(evt, data, status, xhr){
        $("#notification_response").text(data.message).attr({ 'class': 'alert alert-' + data.type });
        $(this).find("input[name=email]").val('');
      });
  });

})(define, require, jQuery, window);
