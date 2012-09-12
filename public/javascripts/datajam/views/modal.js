/*jshint laxcomma:true, expr:true, evil:true */
(function(define, require, $, window, undefined){

  var App = window.Datajam;

  define([ 'text!datajam/templates/modal.html',
           'datajam/init',
           'datajam/models/content_update'
         ], function(modalTemplate){

    App.views.Modal = Backbone.View.extend({

      events: {
        'toggle': 'toggle',
        'hide': 'hide',
        'click .modal-update': 'save',
        'click .close': 'hide',
        'keydown': 'handleKeyDown'
      },
      templates: {},

      initialize: function(){
        _.bindAll(this, 'handleKeyDown'
                      , 'hide'
                      , 'render'
                      , 'save'
                      , 'toggle'
                      );

        App.templates['modal'] || (App.templates['modal'] = Handlebars.compile(modalTemplate));

        this.$el = $(this.el);
        this.delegateEvents();
        this.$el.data('modalView', this);
        this.model.bind('change', this.render, this);

      },

      handleKeyDown: function(evt){
        if(evt.keyCode == 13 &&
          (evt.metaKey || evt.ctrlKey)){

          evt.preventDefault();
          evt.stopPropagation();
          this.save();
        }
      },

      hide: function(evt){
        try{
          evt.preventDefault();
          evt.stopPropagation();
        }catch(e){}

        this.$el.modal('hide');
      },

      render: function(){
        var tmpl = this.template && this.template() || App.templates['modal'];
        this.$el.html(tmpl(this.model.toJSON()));

        return this;
      },

      save: function(evt){
        try{
          evt.preventDefault();
          evt.stopPropagation();
        }catch(e){}

        new App.models.ContentUpdate({
          contentArea: this.model,
          html: this.$el.find('textarea').val()
        }).save()
          .then(_.bind(function(){
            this.hide();
          }, this))
          .fail(_.bind(function(){

          }, this));

        return this;
      },

      toggle: function(evt){
        try{
          evt.preventDefault();
          evt.stopPropagation();
        }catch(e){}

        var visible = this.$el.is(':visible');
        this.$el.modal('toggle');
        if(! visible) this.$el.find('input, select, textarea').eq(0).focus();
      }

    });
  });

})(define, require, jQuery, window);
