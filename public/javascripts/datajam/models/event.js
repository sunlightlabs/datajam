(function(define, require, $, window, undefined){

  var App = window.Datajam;

  define(['datajam/init'], function(){

    App.models.Event = Backbone.Model.extend({

      url: function(){
        return '/event/' + this.id + '.json';
      },

      save: function(){
        App.debug('Datajam.models.event#save is not implemented.');
      },

      parse: function(data, xhr){
        // pulls out content areas and updates to add to their
        // associated collections (happens on bootstrap).
        if(data.content_areas && data.content_areas.length){
          this.view.contentAreas.add(data.content_areas);
          delete data.content_areas;
        }
        if(data.content_updates && data.content_updates.length){
          this.view.contentUpdates.add(data.content_updates);
          delete data.content_updates;
        }
        return data;
      },

      toJSON: function(options){
        var json = Backbone.Model.prototype.toJSON.call(this, options);
        return _.extend(json, {
          'content_areas': this.view.contentAreas.toJSON()
        });
      }

    });
  });

})(define, require, jQuery, window);
