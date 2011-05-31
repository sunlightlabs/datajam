class Template
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  mount_uploader :template, TemplateUploader
end
