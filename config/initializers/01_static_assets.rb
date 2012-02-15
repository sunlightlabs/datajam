HEAD_ASSETS = <<-HEAD.strip_heredoc
<link rel="stylesheet" href="/datajam.css" type="text/css" media="screen, projection">
<script src="http://cdnjs.cloudflare.com/ajax/libs/modernizr/2.0.6/modernizr.min.js" type="text/javascript"></script>
<script type="text/javascript">
  window.curl || (curl = {
    baseUrl: '/javascripts',
    pluginPath: '/javascripts/curl/plugin',
    paths: {}
  })
</script>
HEAD

BODY_ASSETS = <<-BODY.strip_heredoc
<script src="http://cdnjs.cloudflare.com/ajax/libs/json2/20110223/json2.js" type="text/javascript"></script>
<script src="http://cdnjs.cloudflare.com/ajax/libs/jquery/1.7/jquery.min.js" type="text/javascript"></script>
<script src="http://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.2.1/underscore-min.js" type="text/javascript"></script>
<script src="http://cdnjs.cloudflare.com/ajax/libs/backbone.js/0.5.3/backbone-min.js" type="text/javascript"></script>
<script src="http://cdnjs.cloudflare.com/ajax/libs/handlebars.js/1.0.0.beta2/handlebars.min.js" type="text/javascript"></script>
<script src="/javascripts/rails.js" type="text/javascript"></script>
<script src="/datajam.js" type="text/javascript"></script>
<script src="/bootstrap-modal.js" type="text/javascript"></script>
<script type="text/javascript">
  // don't allow curl.js to pollute the global namespace; ACE has its own require...
  window._define = window.define;
</script>
<script src="/javascripts/curl/curl.js" type="text/javascript"></script>
<script type="text/javascript">
  window.define = window._define;
</script>

<script id="topbar_template" type="text/x-handlebars-template">
<div class="topbar offair">
  <div class="topbar-inner">
    <div class="container">
      <ul class="nav">
        <li><a href="/archives">Archives</a></li>
      </ul>
      <ul class="nav secondary-nav">
        <li>
          <a href="/admin">Admin &raquo;</a>
        </li>
      </ul>
    </div>
  </div>
</div>
</script>

<script id="onair_topbar_template" type="text/x-handlebars-template">
<div class="topbar onair">
  <div class="topbar-inner">
    <div class="container">
      <span class="brand">ON AIR</span>
      <ul class="nav">
        {{#each content_areas}}
        <li>
          <a data-controls-modal="modal-{{ _id }}" data-keyboard="true" href="#">{{ name }}</a>
        </li>
        {{/each}}
        <li><a href="/archives">Archives</a></li>
      </ul>
      <ul class="nav secondary-nav">
        <li>
          <a href="/admin">Admin &raquo;</a>
        </li>
      </ul>
    </div>
  </div>
</div>
</script>

<script id="content_area_modal_template" class="modalTemplate" type="text/x-handlebars-template">
<div id="modal-{{ _id }}" class="modal hide fade" style="display: none;">
  <div class="modal-header">
    <a href="#" class="close">&times;</a>
    <h3>{{ name }}</h3>
  </div>
  <div class="modal-body">
    <textarea id="textarea-{{ _id }}" rows="15" cols="60">{{{ html }}}</textarea>
  </div>
  <div class="modal-footer">
    <a href="#" id="button-{{ _id }}" class="btn modal-update">Update</a>
  </div>
</div>
</script>

<script id="dataCardModalTemplate" type="text/x-handlebars-template">
<div id="modal-{{ _id }}" class="modal hide fade" style="display: none;">
  <div class="modal-header">
    <a href="#" class="close">&times;</a>
    <h3>{{ name }}</h3>
  </div>
  <div class="modal-body">
    <select id="select-{{ _id }}">
      {{#each data_cards}}
      <option value="{{ this.id }}">{{ this.title }}</option>
      {{/each}}
   </select>
  </div>
  <div class="modal-footer">
    <a href="#" id="button-{{ _id }}" class="btn modal-update">Update</a>
  </div>
</div>
</script>
BODY

REMINDER_ASSETS = <<-REMINDER
<div id="event_reminder">
  <h3>Notify me:</h3>
  <div id="notification_response"></div>
  <form action="/reminders" id="remind_event" class="reminder_form" method="post" data-remote=true>
    <input type="hidden" name="event_id" value="{{event_id}}" />
    <label> Email: <input name="email" type="" /> </label>
    <input type="submit" />
  </form>
</div>
REMINDER
