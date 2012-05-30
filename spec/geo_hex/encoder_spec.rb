require 'spec_helper'

describe GeoHex::Encoder do

  it "should encode coordinates" do
    described_class.encode(0, 0, 0).should be_instance_of(GeoHex::Zone)
  end

  it "should encode correctly" do
    CSV.foreach(File.expand_path("../../cases.csv", __FILE__)) do |lat, lon, level, code|
      lat, lon, level = lat.to_f, lon.to_f, level.to_i
      described_class.encode(lat, lon, level).to_s.should == code
    end
  end

end
