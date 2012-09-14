/*jshint laxcomma:true, expr:true, evil:true */

(function(define, require, $, window, undefined){

  define([], function(){
    _.mixin({
      /**
       * takes a string classpath and returns a matching object
       * from the passed-in scope.
       */
      constantize: function(str, scope){
        scope || (scope = window);
        var parts = str.split('.');
        _.each(parts, function(part, i, parts){
          scope = scope[part];
        });

        return scope;
      },
      /**
       * takes a string classpath and returns a string file path
       * relative to the passed-in root, suitable for requiring
       * modules using require.js
       */
      pathify: function(str, root){
        root || (root = '');
        var parts = str.split(/([A-Z]+|\.)/).slice(1);
        _.each(parts, function(part, i, parts){
          if(part.match(/[A-Z]+/)){
            if(root.match(/[a-z]$/)){
              root += '_';
            }
            root += part.toLowerCase();
          }else if(part == '.'){
            root += '/';
          }else{
            root += part;
          }
        });

        // if the path starts with datajam, but is not part of the datajam app,
        // (i.e., it's a plugin) strip datajam from the name.
        if(root.match(/^datajam\//) &&
          !root.match(/^datajam\/(views|models|collections|templates|init|libs)/)){
          root = root.replace('datajam/', '');
        }

        return root;
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

    window.Datajam         || (Datajam = {});
    Datajam.models         || (Datajam.models = {});
    Datajam.views          || (Datajam.views = {});
    Datajam.collections    || (Datajam.collections = {});
    Datajam.templates      || (Datajam.templates = {});
    // defaults
    Datajam.settings       || (Datajam.settings = {
      'debug': true,
      'interval': 5000
    });
    Datajam.csrf = {
      csrf_param: $('meta[name=csrf-param]').attr('content'),
      csrf_token: $('meta[name=csrf-token]').attr('content')
    };
    // get the real csrf token when it comes via ajax
    $('document').bind('csrfloaded', function(){
      Datajam.csrf.csrf_token = $('meta[name=csrf-token]').attr('content');
    });

  });

})(define, require, jQuery, window);
