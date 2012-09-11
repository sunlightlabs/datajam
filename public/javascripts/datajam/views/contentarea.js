(function(define, require, $, window, undefined){

  var App = window.Datajam;

  define(['datajam/init'], function(){

    App.views.ContentArea = Backbone.View.extend({

      initialize: function(){
        _.bindAll(this, 'render');
        this.model.bind('change', this.render, this);
      },

      render: function(){
        this.$el.html(this.model.get('html'));
      }

    });

  });

})(define, require, jQuery, window);
