require 'spec_helper'

describe GeoHex::Encoder do

  it "should encode coordinates" do
    described_class.encode(0, 0, 0).should be_instance_of(GeoHex::Zone)
  end

  CSV.foreach(File.expand_path("../../cases.csv", __FILE__)) do |lat, lon, level, code|
    lat, lon, level = lat.to_f, lon.to_f, level.to_i

    it "should encode #{lat.round(3)}, #{lon.round(3)} with level #{level}" do
      described_class.encode(lat, lon, level).to_s.should == code
    end
  end

end
