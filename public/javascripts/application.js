(function(define, require, $, window, undefined){

  Backbone.Model.prototype.idAttribute = '_id';
  _.extend(Backbone.View.prototype, {
    initialize: function() {
      // always hang a reference to the view on this.el
      this.$el.data('view', this);
      return this;
    }
  });

  define('datajam/init', [], function(){
    window.Datajam || (Datajam = {});
    Datajam.models = {};
    Datajam.views = {};
    Datajam.collections = {};
    Datajam.templates = {};
    Datajam.modalRenderers = {};
    Datajam.settings = {
      'debug': true,
      'interval': 5000
    };
  });

  require(['datajam/init', 'datajam/views/event'], function(){
    var el = $('body').prepend('<div class="datajam-event" />').find('.datajam-event');
    Datajam.event = new Datajam.views.Event({ el: el });
  });

})(define, require, jQuery, window);
