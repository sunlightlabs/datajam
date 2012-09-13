/*jshint laxcomma:true, expr:true, evil:true */
(function(define, require, $, window, undefined){

  var App = window.Datajam;

  define(['datajam/init'], function(){

    App.views.ContentArea = Backbone.View.extend({

      initialize: function(){
        _.bindAll(this, 'render');
        this.model.bind('change', this.render, this);

        return this;
      },

      render: function(){
        this.$el.html(this.model.get('html'));

        return this;
      }

    });

  });

})(define, require, jQuery, window);
