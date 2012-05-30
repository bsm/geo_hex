require 'spec_helper'

describe GeoHex::Decoder do

  it "should decode strings" do
    described_class.decode("OY").should be_instance_of(GeoHex::Zone)
  end

  it "should decode correctly" do
    CSV.foreach(File.expand_path("../../cases.csv", __FILE__)) do |lat, lon, level, code|
      lat, lon, level = lat.to_f, lon.to_f, level.to_i
      tile = GeoHex::LL.new(lat, lon).to_tile(level)

      zone = described_class.decode(code)
      [zone.to_s, zone.level, zone.x, zone.y].should == [code, level, tile.x, tile.y]
      zone.lon.should be_within(180.0).of(0.0)
    end
  end

end
