(function(define, require, $, window, undefined){

  var App = window.Datajam;

  define(['datajam/init'], function(){

    App.collections.ContentUpdate = Backbone.Collection.extend({

      initialize: function(){
        _.bindAll(this, 'add'
                      , 'comparator'
                      , 'parse'
                      , 'url');
      },

      add: function(models, options){
        Backbone.Collection.prototype.add.call(this, models, options);

        models = _.isArray(models)? models.slice() : [models];
        _.each(models, _.bind(function(model, i, models){
          var area = this.view.contentAreas.get(model.content_area_id);
          if(model.action == 'update' &&
            model.updated_at > area.get('updated_at')){

            area.set({
              html: model.html,
              updated_at: model.updated_at
            });
          }
        }, this));
      },

      comparator: function(a, b){
        if(a.get('updated_at') > b.get('updated_at')) return -1;
        if(a.get('updated_at') < b.get('updated_at')) return 1;
        return 0;
      },

      parse: function(data){
        return data.content_updates || [];
      },

      url: function(){
        return '/event/' + Datajam.event.model.id + '/updates.json';
      }

    });

  });

})(define, require, jQuery, window);
