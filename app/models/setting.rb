class Setting
  include Mongoid::Document
  include Mongoid::Timestamps

  field :namespace, type: String
  field :name, type: String
  field :value, type: String

  index [[:namespace, Mongo::ASCENDING], [:name, Mongo::ASCENDING]], unique: true

  validates_presence_of :namespace, :name
  validates_uniqueness_of :name, :scope => :namespace

end
