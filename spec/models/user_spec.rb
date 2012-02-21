require 'spec_helper'

describe User do
  describe "changing the avatar" do
    include CarrierWave::Test::Matchers
    include ActionDispatch::TestProcess

    before do
      AvatarUploader.enable_processing = true
    end

    after do
      AvatarUploader.enable_processing = false
    end

    subject do
      User.create
    end

    it "should update the avatar" do
      avatar_path = Rails.root.join("spec/fixtures/avatar.gif")
      subject.update_attributes(avatar: File.open(avatar_path))
      subject.avatar.should be_present
    end

    it "defines a small_avatar_url" do
      avatar_path = Rails.root.join("spec/fixtures/avatar.gif")
      subject.update_attributes(avatar: File.open(avatar_path))
      subject.small_avatar_url.should be_present
    end
  end
end
