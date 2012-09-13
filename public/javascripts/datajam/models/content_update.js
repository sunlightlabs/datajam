/*jshint laxcomma:true, expr:true, evil:true */
(function(define, require, $, window, undefined){
  define(['datajam/init'], function(){

    var App = window.Datajam;

    App.models.ContentUpdate = Backbone.Model.extend({
      // Content Updates post to a non-resourceful url
      save: function() {
        return $.post('/onair/update.json', {
          event_id: App.event.model.id,
          content_area_id: this.get('contentArea').id,
          html: this.get('html')
        });
      }
    });

  });

})(define, require, jQuery, window);
