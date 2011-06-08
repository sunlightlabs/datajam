class Template
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :template, type: String
  has_many :events

  after_save :cache_template

  scope :site_templates, where(:name.ne => 'Site')
  protected

  def cache_template
    redis = Redis::Namespace.new(Rails.env.to_s, :redis => Redis.new)

    case self.name.downcase
    when 'site'
      redis.set '/', self.template
    end
  end
end
