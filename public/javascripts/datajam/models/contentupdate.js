(function(define, require, $, window, undefined){

  var App = window.Datajam;

  define(['datajam/init'], function(){

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
