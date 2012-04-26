# Events can be "tagged", as well as any Taggable models (those that include
# Tag::Taggable).
class Tag
  include Mongoid::Document

  field :name, type: String
  embeds_many :taggable_references

  validates :name, presence: true, uniqueness: true

  def self.by_name(name)
    if name.respond_to?(:strip)
      find_or_initialize_by(name: name.strip)
    else
      name # if it's not a string that can be stripped, it's a Tag
    end
  end

  def tag!(taggable)
    taggable_references.find_or_initialize_by(
      taggable_id:   taggable.id,
      taggable_type: taggable.class.to_s
    ).save!
  end

  def untag!(taggable)
    taggable_references.where(
      taggable_id:   taggable.id,
      taggable_type: taggable.class.to_s
    ).destroy_all

    destroy if taggable_references.empty?
  end

  def objects_tagged
    taggable_references.count
  end

  def to_s
    name
  end
end

# Private: this class just lets us store a reference to taggable classes (those
# that can be tagged) inside a tag.
class TaggableReference
  include Mongoid::Document

  field :taggable_id,   type: BSON::ObjectId
  field :taggable_type, type: String

  embedded_in :tag
end
