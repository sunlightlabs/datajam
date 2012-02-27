User.where(username: 'admin').destroy_all
user = User.find_or_create_by(
  email: 'changeme@example.com',
  username: 'admin',
  password: 'changeme',
)
event_template = EventTemplate.find_or_create_by(
  name: 'Default',
  slug: 'default',
  template: <<-EOT.strip_heredoc
  <h2>{{ heading }}</h2>
  <div class="video">{{ content_area: Video Embed }}</div>
  EOT
)
event = Event.find_or_create_by(
  name: 'Your First Event',
  event_template_id: event_template._id,
  slug: 'your-first-event',
  scheduled_at: Time.now,
)