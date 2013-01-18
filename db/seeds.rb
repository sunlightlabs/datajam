# Some initial settings

Setting.find_or_create_by(
  namespace: 'datajam-chat',
  name: 'page_size',
  value: 100
)
Setting.find_or_create_by(
  namespace: 'datajam-chat',
  name: 'default_avatar_url',
  value: 'http://a0.twimg.com/profile_images/55418705/100x100_sunlight_reasonably_small.png'
)

# Bootstrap a user

User.where(name: 'Admin').destroy_all
user = User.create!(
  email: 'demo@datajam.org',
  name: 'Admin',
  password: 'datajam',
)

# Basic site templates

site_template = SiteTemplate.find_or_create_by(
  name: 'Site',
  template: DEFAULT_SITE_TEMPLATE
)
event_template = EventTemplate.find_or_create_by(
  name: 'Default',
  slug: 'default',
  template: <<-EOT.strip_heredoc
  <div class="row" style="margin-top:2em;">
    <div class="span12">
      <h3>{{ heading }}</h3>
      <p>{{ description }}</p>
    </div>
  </div>
  <div class="row">
    <div class="span8">
      <div class="video">{{ content_area: Video Embed }}</div>
      <div class="row">
        <div class="span6">{{ chat_area: Live Chat }}</div>
      </div>
    </div>
    <div class="span4">
    <div class="datacard">{{ data_card_area: Data Card }}</div>
    </div>
  </div>
  EOT
)
if event_template.errors.any?
  event_template = EventTemplate.where(name: 'Default').first
end

event = Event.find_or_create_by(
  name: 'Your First Event',
  event_template_id: event_template._id,
  slug: 'your-first-event',
  scheduled_at: Time.now,
  template_data: {"heading" => "This is an Example Event", "description" => "The next upcoming event will be published to the root URL here."}
)

# Embed a video

if event and event.content_areas.any?
  event.content_areas.first.update_attributes(html: '<embed wmode="transparent" width="540" id="video-player-flash" height="334" type="application/x-shockwave-flash" src="http://s.ytimg.com/yt/swfbin/watch_as3-vflOU03g2.swf" allowscriptaccess="always" allowfullscreen="true" bgcolor="#000000" flashvars="el=embedded&fexp=907324%2C910104%2C901604&is_html5_mobile_device=false&allow_ratings=1&allow_embed=1&sendtmp=1&hl=en_US&use_tablet_controls=0&eurl=http%3A%2F%2Fdatajam-demo.herokuapp.com%2F&iurl=http%3A%2F%2Fi4.ytimg.com%2Fvi%2FGcf0xGyF37g%2Fhqdefault.jpg&view_count=3188&title=1021%20Days%20Later%20-%20Official%20Trailer&avg_rating=3.90909090909&video_id=Gcf0xGyF37g&length_seconds=86&iurlmaxres=http%3A%2F%2Fi4.ytimg.com%2Fvi%2FGcf0xGyF37g%2Fmaxresdefault.jpg&enablejsapi=1&sk=qc10_TLHn1TNptp-NNOf5pXsWOWt2KZlC&use_native_controls=false&rel=1&playlist_module=http%3A%2F%2Fs.ytimg.com%2Fyt%2Fswfbin%2Fplaylist_module-vflXXCNob.swf&iurlsd=http%3A%2F%2Fi4.ytimg.com%2Fvi%2FGcf0xGyF37g%2Fsddefault.jpg&jsapicallback=ytPlayerOnYouTubePlayerReady&playerapiid=player1&framer=http%3A%2F%2Fdatajam-demo.herokuapp.com%2F">')
end

# Set some data cards

data_card_1 = DataCard.find_or_create_by(
  title: 'Data Card 1',
  display_type: :html,
  html: "<h3>This is a data card</h3>\r\n<p>Data cards can be raw html, or csv parsed into a template.</p>\r\n<p>\r\n  This provides the flexibility to embed just about anything. \r\n  To change the data card, ensure you're logged in and then select\r\n  'Data Card' from the On Air toolbar.   \r\n</p>",
)
data_card_2 = DataCard.find_or_create_by(
  title: 'Data Card 2',
  display_type: :html,
  html: "<h3>Try creating your own!</h3><p>To create your own data cards, click 'Data Cards' in the admin site.</p>"
)
dca = event.content_areas.last
dca.update_attributes!({current_card_id: data_card_1._id, html: dca.render})

about_page = Page.find_or_create_by(
  slug: 'about',
  content: "<h2>This is Your About Page.</h2>\r\n<p>Edit it in the admin site, under 'pages.'</p>"
)

# Create a sample chat message

msg = ChatMessage.find_or_create_by(
  display_name: 'Welcome message',
  is_public: true,
  is_moderated: true,
  text: "Welcome to our live chat! Messages are moderated, and can be approved or rejected via the 'Live Chat' tab in the On Air toolbar for admins."
)
chat = event.content_areas[1].chat
chat.messages << msg
chat.save!

# Prime the cache

event.save!
