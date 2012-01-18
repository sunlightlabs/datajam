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
      subject.update_attributes(
        avatar: File.open("spec/fixtures/avatar.gif")
      )

      subject.avatar.should be_present
    end
  end
end
