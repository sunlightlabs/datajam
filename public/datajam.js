Datajam.Event = Backbone.Model.extend({
  id: Datajam.eventId,
  url: '/event/' + Datajam.eventId + '.json'
});

Datajam.Check = Backbone.Model.extend({
  url: '/onair/signed_in'
});

Datajam.ContentArea = Backbone.Model.extend({

});

Datajam.ContentUpdate = Backbone.Model.extend({
  save: function() {
    var contentArea = this.get('contentArea');
    var payload = { event_id: Datajam.event.get('_id'),
                    content_area_id: contentArea.get('_id'),
                    html: $('#textarea-' + contentArea.get('_id')).val() };
    $.post('/onair/update', payload, function(response) {
      $('#modal-' + contentArea.get('_id')).modal('hide');
    }, 'json');
  }
});

Datajam.DataCardUpdate = Backbone.Model.extend({
  save: function() {
    var contentArea = this.get('contentArea');
    var payload = { event_id: Datajam.event.get('_id'),
                    content_area_id: contentArea.get('_id'),
                    data: { current_card_id: $('#select-' + contentArea.get('_id') + ' option:selected').val() } };
    console.log(payload);
    $.post('/onair/update', payload, function(response) {
      $('#modal-' + contentArea.get('_id')).modal('hide');
    }, 'json');
  }
});

Datajam.OnairToolbar = Backbone.View.extend({
  render: function() {
    var topbarTemplate = Handlebars.compile($("script#topbar_template").html());
    $('body').prepend(topbarTemplate(this.model.toJSON()));
    $('body').addClass('topbarred');
    return this;
  }
});

Datajam.ContentAreaView = Backbone.View.extend({
  render: function() {
    $('#content_area_' + this.model.get('_id')).html(this.model.get('html'));
  }
});

Datajam.ContentUpdateModal = Backbone.View.extend({
  events: {
    'click .modal-update': 'save'
  },
  render: function() {
    var tmpl = Datajam.ModalTemplates[this.model.get('contentArea').get('area_type')];

    // Assign to this.el and add to body.
    this.el = $(tmpl(this.model.get('contentArea').toJSON()));
    $('body').append(this.el);

    // Rebind events since this.el was assigned.
    this.delegateEvents();

    return this;
  },
  save: function() {
    this.model.save();
  }
});

Datajam.DataCardModal = Backbone.View.extend({
  events: {
    'click .modal-update': 'save'
  },
  render: function() {
    // Generate the template.
    var tmpl = Handlebars.compile($("script#dataCardModalTemplate").html());

    // Assign to this.el and add to body.
    this.el = $(tmpl(this.model.get('contentArea').toJSON()));
    $('body').append(this.el);

    // Rebind events since this.el was assigned.
    this.delegateEvents();

    return this;
  },
  save: function() {
    this.model.save();
  }
});

Datajam.pollForUpdates = function() {
  $.getJSON('/event/' + Datajam.eventId + '/updates.json', function(updates) {

    if (updates['content_updates'] && updates['content_updates'].length > 0) {

      if (Datajam.updates.length == 0) {
        Datajam.updates = updates['content_updates'];
      }

      // Update the DOM if there are new updates.
      var lastUpdate = Datajam.updates[Datajam.updates.length - 1];
      if (lastUpdate) {
        _.each(updates['content_updates'], function(contentUpdate) {
          if (contentUpdate['updated_at'] > lastUpdate['updated_at']) {
            $('#content_area_' + contentUpdate['content_area_id']).html(contentUpdate['html']);
            Datajam.updates.push(contentUpdate);
          }
        });
      }
    }
    setTimeout(function() { Datajam.pollForUpdates(); }, 3000);
  });
};

$(function() {

  // Compile the modal template(s).
  var tmpls = {}
  $("script.modalTemplate").each(function(){
    var tmpl = $(this)
      , areaType = tmpl.attr('id').replace('_modal_template', '');
    tmpls[areaType] = Handlebars.compile(tmpl.html());
  });
  Datajam.ModalTemplates = tmpls;

  var event = new Datajam.Event();
  Datajam.event = event;
  event.fetch({
    success: function(model, response) {

      // Check that the viewer signed in.
      var check = new Datajam.Check();
      check.fetch({
        success: function(model,response) {

          if (check.get('csrfToken')) {
            $('meta[name=csrf-token]').attr('content', check.get('csrfToken'));
            $(document).trigger('csrfloaded');
          }

          if (check.get('signedIn')) {

            // Build the ON AIR toolbar.
            var toolbarView = new Datajam.OnairToolbar({ model: event });
            toolbarView.render();

            // Build the modals for each content area.
            $.each(event.get('content_areas'), function(i, contentAreaJSON) {
              var contentArea = new Datajam.ContentArea(contentAreaJSON);
              var contentAreaView = new Datajam.ContentAreaView({ model: contentArea });
              contentAreaView.render();

              if (contentArea.get('area_type') === 'data_card_area') {
                var dataCardUpdate = new Datajam.DataCardUpdate({contentArea: contentArea});
                var modal = new Datajam.DataCardModal({ model: dataCardUpdate,
                                                           id: contentArea.get('_id') });
                modal.render();
              } else {
                var contentUpdate = new Datajam.ContentUpdate({contentArea: contentArea});
                var modal = new Datajam.ContentUpdateModal({ model: contentUpdate,
                                                             id: contentArea.get('_id') });
                modal.render();
              }
            });

          }
        }
      });

      Datajam.updates = [];
      Datajam.pollForUpdates();
    }
  });

});

