$(function () {

  Datajam.pollForUpdates = function() {
    $.getJSON('/event/' + Datajam.eventId + '.json', function(event) {
      console.log('polled');

      // Update the DOM if there are new updates.
      if (Datajam.updates.length < event['content_updates'].length) {

        var lastUpdate = Datajam.updates[Datajam.updates.length - 1];
        if (lastUpdate) {
          _.each(event['content_updates'], function(contentUpdate) {
            console.log('ContentUpdate ' + contentUpdate['updated_at']);
            console.log('LastUpdate ' + lastUpdate['updated_at']);
            if (contentUpdate['updated_at'] > lastUpdate['updated_at']) {
              console.log('updating ' + contentUpdate['html']);
              $('#content_area_' + contentUpdate['id']).html(contentUpdate['html']);
              Datajam.updates.push(contentUpdate);
            }
          });
        }
      }
      setTimeout(function() { Datajam.pollForUpdates() }, 3000);
    });
  };

  $.getJSON('/event/' + Datajam.eventId + '.json', function(event) {

    // Display the toolbar if signed in.
    $.getJSON('/onair/signed_in', function(check) {

      if (check['signedIn']) {

        // Build the ON AIR toolbar.
        var topbarTemplate = Handlebars.compile($("script#topbarTemplate").html());
        $('body').prepend(topbarTemplate(event));
        $('body').addClass('topbarred');

        // Build the modals for each content area.
        var contentAreaModal = Handlebars.compile($("script#contentAreaModalTemplate").html());
        $.each(event['content_areas'], function(i, contentArea) {
          var contentAreaId = contentArea['_id'];
          // Add to the body.
          $('body').append(contentAreaModal(contentArea));

          // Define a click handler.
          $('#button-' + contentAreaId).click(function () {
            var payload = { event_id: event['_id'],
                            content_area_id: contentAreaId,
                            html: $('#textarea-' + contentAreaId).val() };
            $.post('/onair/update', payload, function(response) {
              $('#modal-' + contentAreaId).modal('hide');
            }, 'json');
          });
        });
      }

    });

    // Populate each Content Area.
    $.each(event.content_areas, function(i, content_area) {
      $('#content_area_' + content_area['_id']).html(content_area['html']);
    });

    Datajam.updates = event['content_updates'];
    Datajam.pollForUpdates();
  });

});

