# Public: Mixin that can be included into different classes that should be
# tagged.
module Tag::Taggable
  extend ActiveSupport::Concern

  included do
    before_save :_sync_tags
  end

  # Public: Get the list of Tag objects to which this Taggable is associated.
  #
  # Returns a list of Tags.
  def tags
    ::Tag.where(
      "taggable_references.taggable_id"   => id,
      "taggable_references.taggable_type" => self.class.to_s
    )
  end

  # Public: Get the list of tags as strings.
  #
  # Returns a list of Strings.
  def tag_list
    tags.map(&:to_s)
  end

  # Public: set the new list of tags. Pass either a list of strings, a list of
  # Tag objects, or a string that can be separated by #tag_delimiter.
  #
  # list - either a String of tags separated by #tag_delimiter, an array of Tag
  #        objects, or an array of strings (tag names).
  #
  # Returns the list passed.
  def tag_list=(list)
    list = list.split(tag_delimiter) if list.respond_to?(:to_str)
    list = Array.wrap(list).map(&:to_s)

    # cache to avoid hitting mongo multiple times
    old_tags = tag_list

    # Flag any tags for removal that aren't on the new list of tags.
    @_tags_to_delete = old_tags.select { |t| list.exclude?(t) }

    # Add new tags (ignore those with which it's already tagged)
    @_tags_to_create = list.reject { |t| old_tags.include?(t) }
  end
  alias_method :tags=, :tag_list=

  # Public: The delimiter to separate tags. Redefine this in child models to use
  # something different than a comma.
  #
  # Returns a String.
  def tag_delimiter
    ","
  end

  # Private: remove the object from any tag that has been marked for untagging,
  # and save any new tags that have been added to this object. This method is
  # automatically called whenever you save the Taggable object.
  def _sync_tags
    Array.wrap(@_tags_to_delete).each do |tag|
      ::Tag.by_name(tag).untag!(self)
    end

    Array.wrap(@_tags_to_create).each do |tag|
      ::Tag.by_name(tag).tag!(self)
    end
  end
end
