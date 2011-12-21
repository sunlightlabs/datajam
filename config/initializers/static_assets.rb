HEAD_ASSETS = <<-HEAD.strip_heredoc
<link rel="stylesheet" href="/datajam.css" type="text/css" media="screen, projection">
<script src="http://cdnjs.cloudflare.com/ajax/libs/modernizr/2.0.6/modernizr.min.js" type="text/javascript"></script>
<script type="text/javascript">
  # predefine curl.js paths to avoid duplicate downloading
  window.curl || (curl = {
    baseUrl: '/javascripts',
    pluginPath: '/javascripts/curl/plugin',
    paths: {
      json: 'http://cdnjs.cloudflare.com/ajax/libs/json2/20110223/json2.js',
      jquery: 'http://cdnjs.cloudflare.com/ajax/libs/jquery/1.7/jquery.min.js',
      jqueryui: 'http://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.8.13/jquery-ui.min.js',
      underscore: 'http://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.2.1/underscore-min.js',
      backbone: 'http://cdnjs.cloudflare.com/ajax/libs/backbone.js/0.5.3/backbone-min.js',
      handlebars: 'http://cdnjs.cloudflare.com/ajax/libs/handlebars.js/1.0.0.beta2/handlebars.min.js'
    }
  })
</script>
HEAD

BODY_ASSETS = <<-BODY.strip_heredoc
<script src="http://cdnjs.cloudflare.com/ajax/libs/json2/20110223/json2.js" type="text/javascript"></script>
<script src="http://cdnjs.cloudflare.com/ajax/libs/jquery/1.7/jquery.min.js" type="text/javascript"></script>
<script src="http://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.2.1/underscore-min.js" type="text/javascript"></script>
<script src="http://cdnjs.cloudflare.com/ajax/libs/backbone.js/0.5.3/backbone-min.js" type="text/javascript"></script>
<script src="http://cdnjs.cloudflare.com/ajax/libs/handlebars.js/1.0.0.beta2/handlebars.min.js" type="text/javascript"></script>
<script src="/datajam.js" type="text/javascript"></script>
<script src="/bootstrap-modal.js" type="text/javascript"></script>
<script src="/javascripts/curl/curl.js" type="text/javascript"></script>

<script id="topbarTemplate" type="text/x-handlebars-template">
<div class="topbar">
  <div class="topbar-inner">
    <div class="container">
      <span class="brand">ON AIR</span>
      {{#each content_areas}}
      <ul class="nav">
        <a data-controls-modal="modal-{{ _id }}" data-keyboard="true" href="#">{{ name }}</a>
      </ul>
      {{/each}}
    </div>
  </div>
</div>
</script>

<script id="contentAreaModalTemplate" type="text/x-handlebars-template">
<div id="modal-{{ _id }}" class="modal hide fade" style="display: none;">
  <div class="modal-header">
    <a href="#" class="close">&times;</a>
    <h3>{{ name }}</h3>
  </div>
  <div class="modal-body">
    <textarea id="textarea-{{ _id }}" rows="15" cols="60">{{{ html }}}</textarea>
  </div>
  <div class="modal-footer">
    <a href="#" id="button-{{ _id }}" class="btn">Update</a>
  </div>
</div>
</script>
BODY

