/*jshint laxcomma:true, expr:true, evil:true */
(function(define, require, $, window, undefined){
  define([ 'text!datajam/templates/onairtoolbar.html',
           'datajam/init',
           'datajam/collections/content_area',
           'datajam/collections/content_update',
           'datajam/models/event',
           'datajam/models/content_area',
           'datajam/models/content_update',
           'datajam/views/content_area',
           'datajam/views/modal'
         ], function(onairToolbarTemplate){

    var App = window.Datajam;

    App.views.Event = Backbone.View.extend({

      events: {
        'click a[data-controls-modal]': 'handleToolbarItemClick'
      },
      templates: {},
      contentAreas: new App.collections.ContentArea(),
      contentUpdates: new App.collections.ContentUpdate(),

      initialize: function(){
        _.bindAll(this, 'authenticate'
                      , 'getSettings'
                      , 'handleKeyDown'
                      , 'handleToolbarItemClick'
                      , 'initializeAreas'
                      , 'initializeModals'
                      , 'initializeReminder'
                      , 'pollForUpdates'
                      , 'pollForAudience'
                      , 'renderToolbar'
                      , 'toggleModal'
                      );

        // set up event model
        this.model = new App.models.Event({ _id: App.eventId });
        this.model.view = this;

        // view bindings to content areas
        this.contentAreas.view = this;
        this.contentUpdates.view = this;

        // window event bindings
        $(window).on('keydown.datajam', this.handleKeyDown);

        $.when(this.model.fetch(), this.getSettings())
          .then(_.bind(function(){
            this.authenticate();
            this.initializeReminder();
            this.initializeAreas();
            this.pollForUpdates();
          }, this));

        return this;
      },

      authenticate: function(){
        var xhr = $.getJSON('/onair/signed_in.json', _.bind(function(data){
          if(data){
            if(data.csrfToken){
              $('meta[name="csrf-token"]').attr('content', data.csrfToken);
              $(document).trigger('csrfloaded');
            }
            if(data.signedIn === true){
              this.initializeModals();
              this.renderToolbar();
              this.pollForAudience();
            }
          }
        }, this));

        // return the xhr promise for callback chaining
        return xhr;
      },

      getSettings: function(){
        return $.getJSON('/settings.json', function(data){
          data && data.length && _.each(data, function(setting, i, data){
            App.settings[setting.name] = setting.value;
          });
        });
      },

      handleKeyDown: function(evt){
        if(evt.keyCode >= 49 && evt.keyCode <= 57 && evt.ctrlKey){
          try{
            this.toggleModal('#modal-' + this.contentAreas.models[evt.keyCode - 49].id);
          }catch(e){}
        }
      },

      handleToolbarItemClick: function(evt){
        evt.preventDefault();
        evt.stopPropagation();
        this.toggleModal('#' + $(evt.target).attr('data-controls-modal'));

        return this;
      },

      initializeAreas: function(){
        _.each(this.contentAreas.models, _.bind(function(area, i, areas){
          area.view = new App.views.ContentArea({
            el: $('#' + area.get('area_type') + '_' + area.id),
            model: area,
            collection: areas
          }).render();
        }, this));

        return this;
      },

      initializeModals: function(){
        _.each(this.contentAreas.models, _.bind(function(area, i, areas){
          var modal_class = area.get('modal_class');
          // require() the modal appropriate view class, then init
          require([_.pathify(modal_class)], _.bind(function(){
            var klass = _.constantize(modal_class);
            area.modal = new klass({
              el: $('<div id="modal-' + area.id + '" class="modal hide fade" style="display: none;">'),
              model: area
            });
            $('body').append(area.modal.el);
            area.modal.render();
            area.modal.$el.modal({
              backdrop: false,
              show: false
            });
          }, this));
        }, this));

        return this;
      },

      initializeReminder: function(){
        var eventTime = this.model.get('unix_scheduled_at'),
            currentTime = new Date().getTime()/1000;

        if(eventTime > currentTime){
          $('#event_reminder').show();
          $("#event_reminder form").on('ajax:success', function(event, data, status, xhr) {
            $(this).find('.response')
                   .text(data.message)
                   .attr({ 'class': 'response alert alert-' + data.type })
                   .fadeIn()
                   .delay(5000)
                   .fadeOut();
            $(this).find("input[name=email]").val('');
          });
        }
      },

      pollForUpdates: function(){
        this.contentUpdates.fetch({add: true});
        setTimeout(_.bind(this.pollForUpdates, this), App.settings.interval);

        return this;
      },

      pollForAudience: function(){
        if(! App.settings.chartbeat_api_key){
          this.$el.find('li.audience').hide();
          return this;
        }

        var url = '//api.chartbeat.com/live/quickstats/v3/';
        $.ajax({
          url: url,
          dataType: 'jsonp',
          jsonp: 'jsonp',
          callback: '?',
          data: {
            apikey: App.settings.chartbeat_api_key,
            host: location.hostname.replace(/^www\./, ''),
            path: location.pathname
          }
        }).then(_.bind(function(data){
          this.$el.find('li.audience .badge').html(data.people);
        }, this));
        setTimeout(_.bind(this.pollForAudience, this), 30000);

        return this;
      },

      remove: function() {
        // unbind keypress handler
        $(window).off('keydown.datajam');
        // TODO: remove dependent stuff
        BackboneView.prototype.remove.call(this);
      },

      renderToolbar: function() {
        // draw the onair toolbar
        App.templates['onairToolbar'] || (App.templates['onairToolbar'] = Handlebars.compile(onairToolbarTemplate));
        this.$el.html(
          App.templates['onairToolbar'](this.model.toJSON())
        );
        $('body').addClass('topbarred');

        return this;
      },

      toggleModal: function(id) {
        $('div.modal[id^=modal]').not('#' + id).trigger('hide');
        $(id).trigger('toggle');

        return this;
      }

    });
  });

})(define, require, jQuery, window);
