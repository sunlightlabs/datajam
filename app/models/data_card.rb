class DataCard
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  include Tag::Taggable

  # Used for auto-routing
  def self.model_name
    ActiveModel::Name.new(self, nil, "Card")
  end

  field :title,       type: String
  field :table_head,  type: Array,     default: []
  field :table_body,  type: Array,     default: []
  field :csv,         type: String
  field :source,      type: String
  field :body,        type: String

  validates_presence_of :title

  before_save :parse_csv
  after_save :save_events
  after_destroy :save_events

  mount_uploader :csv_file, CsvUploader

  # Mongoid::Slug changes this to `self.slug`. Undo that.
  def to_param
    self.id.to_s
  end

  def render
    Handlebars.compile(template).call(self)
  end

  def template
    return body if body.present?

    return <<-TMPL.strip_heredoc
    <div id="liveCard">
    <h2>{{ title }}</h2>
    <table>

      <thead>
          <tr id="titles">
              {{#each table_head}}
              <th>{{this}}</th>
              {{/each}}
          </tr>
      </thead>

      <tbody>
      {{#each table_body}}
      <tr>
          {{#each this}}
          <td>{{this}}</td>
          {{/each}}
      </tr>
      {{/each}}
      </tbody>

    </table>

    <br/>
    {{#if source}}
    <div class="source">Source: {{{source}}}</div>
    {{/if}}
    </div>
    TMPL
  end

  protected

  def parse_csv
    return if csv.blank?

    parsed = CSV.parse(self.csv)
    self.table_head = parsed.first
    self.table_body = parsed.slice(1, parsed.length)
  end

  def save_events
    Event.all.each(&:save)
  end
end
