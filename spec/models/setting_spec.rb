require 'spec_helper'

describe Setting do

  before(:each) do
    @setting = Setting.create!(:namespace => 'test',
                               :name => 'setting')
  end

  it "can be retrieved by namespace" do
    Datajam::Settings[:test].should == {:setting => nil}
  end

  it "can be retrieved individually" do
    Datajam::Settings[:test][:setting].should == nil
  end

  it "flushes when saved" do
    @setting.update_attributes!(:value => 'foo')
    Datajam::Settings[:test][:setting].should == 'foo'
  end

  it "runs callbacks after save" do
    class DummyCallback
      cattr_accessor :foo
    end

    Setting.class_eval do
      def test_setting_callback
        DummyCallback.foo = 'bar'
      end
    end
    @setting.update_attributes!(:value => 'foo')
    DummyCallback.foo.should == 'bar'
  end

  it "can be updated in bulk" do
    @setting2 = Setting.create!(:namespace => 'test',
                                :name => 'setting2')
    Setting.bulk_update(@setting._id => {:value => 'newvalue1'},
                        @setting2._id => {:value => 'newvalue2'})

    Datajam::Settings[:test].to_json.should include('newvalue1')
    Datajam::Settings[:test].to_json.should include('newvalue2')
  end

  it "returns an error status when bulk update fails" do
    @setting.update_attributes!(:required => true, :value => 'foo')
    batch = Setting.bulk_update(@setting._id => {:value => nil})
    batch[:updated].should == false
  end

end
