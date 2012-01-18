require 'carrierwave/test/matchers'
require 'spec_helper'

describe AvatarUploader do
  include CarrierWave::Test::Matchers

  before do
    AvatarUploader.enable_processing = true
    @uploader = AvatarUploader.new(User.new, :avatar)
    @uploader.store!(File.open(File.join(Rails.root, "spec/fixtures/avatar.gif")))
  end

  after do
    AvatarUploader.enable_processing = false
  end

  it 'should resize avatars to the right size' do
    @uploader.small.should have_dimensions(100, 100)
    @uploader.large.should have_dimensions(300, 300)
  end
end
