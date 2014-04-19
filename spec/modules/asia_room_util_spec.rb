require 'spec_helper'

describe AsiaRoomUtil do

  it "should remove double spaces" do
    coord = AsiaRoomUtil.extract_long_lat("hotel lat:15.18850 long:120.53794")
    coord[:latitude].should eq(15.18850)
    coord[:longitude].should eq(120.53794)
  end

end

