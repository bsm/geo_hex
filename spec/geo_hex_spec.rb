require 'spec_helper'

describe GeoHex do

  it "should encode coordinates" do
    described_class.encode(0, 0, 0).should be_instance_of(GeoHex::Zone)
  end

  it "should encode correctly" do
    CSV.foreach(File.expand_path("../cases.csv", __FILE__)) do |lat, lon, level, code|
      lat, lon, level = lat.to_f, lon.to_f, level.to_i
      described_class.encode(lat, lon, level).to_s.should == code
    end
  end

  it "should decode strings" do
    described_class.decode("OY").should be_instance_of(GeoHex::Zone)
  end

  it "should decode correctly" do
    CSV.foreach(File.expand_path("../cases.csv", __FILE__)) do |lat, lon, level, code|
      lat, lon, level = lat.to_f, lon.to_f, level.to_i
      zone = GeoHex::LL.new(lat, lon).to_zone(level)

      decoded_zone = described_class.decode(code)
      [decoded_zone.to_s, decoded_zone.level, decoded_zone.x, decoded_zone.y].should == [code, level, zone.x, zone.y]
      zone.lon.should be_within(180.0).of(0.0)
    end
  end

end
