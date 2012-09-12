/*jshint laxcomma:true, expr:true, evil:true */

(function(define, require, $, window, undefined){

  define([], function(){
    // Constantize for dot-delimited strings; used to instantiate modals
    _.mixin({
      constantize: function(str, scope){
        scope || (scope = window);
        var parts = str.split('.');
        _.each(parts, function(part, i, parts){
          scope = scope[part];
        });

        return scope;
      }
    });

    // Emulate HTTP via _method param
    Backbone.emulateHTTP = true;
    Backbone.emulateJSON = true;

    // Use mongo's _id as the id attr
    Backbone.Model.prototype.idAttribute = '_id';

    // Always hang a ref to the view on this.el
    _.extend(Backbone.View.prototype, {
      initialize: function() {
        this.$el.data('view', this);
        return this;
      }
    });

    window.Datajam || (Datajam = {});
    Datajam.models || (Datajam.models = {});
    Datajam.views || (Datajam.views = {});
    Datajam.collections || (Datajam.collections = {});
    Datajam.templates || (Datajam.templates = {});
    Datajam.modalRenderers || (Datajam.modalRenderers = {});
    Datajam.settings || (Datajam.settings = {
      'debug': true,
      'interval': 5000
    });
    Datajam.csrf = {
      csrf_param: $('meta[name=csrf-param]').attr('content'),
      csrf_token: $('meta[name=csrf-token]').attr('content')
    };
    // get the real token when it comes
    $('document').bind('csrfloaded', function(){
      Datajam.csrf.csrf_token = $('meta[name=csrf-token]').attr('content');
    });

  });

})(define, require, jQuery, window);
