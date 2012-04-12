require "spec_helper"

describe Tag::Taggable do
  class TestModel
    include Mongoid::Document
    include Tag::Taggable
  end

  after :all do
    TestModel.destroy_all
  end

  context "tagging objects" do
    it "tags from a comma separated list" do
      model = TestModel.create!(tag_list: "foo, bar")
      model.tag_list.should == ["foo", "bar"]
    end

    it "retreives the same tags it created" do
      model = TestModel.create!(tag_list: %w(foo bar))
      model.tag_list.should == ["foo", "bar"]
    end

    it "does not create duplicated tags" do
      foo = TestModel.create!(tag_list: %w(foo bar))
      bar = TestModel.create!(tag_list: %w(bar baz))

      Tag.where(name: "bar").count.should == 1
    end
  end

  context "updating the tags of objects" do
    let! :model do
      TestModel.create!(tag_list: "foo, bar")
    end

    it "adds new tags" do
      model.update_attributes(tag_list: "foo, bar, baz")
      model.tag_list.should == ["foo", "bar", "baz"]
    end

    it "removes references to tags when a taggable is no longer tagged" do
      model.update_attributes(tag_list: "foo")
      model.reload.tag_list.should_not include("bar")
    end

    it "removes unused tags that aren't used anymore" do
      other_model = TestModel.create!(tag_list: "foo")
      model.update_attributes(tag_list: "")

      Tag.where(name: "bar").to_a.should be_empty
    end
  end
end
