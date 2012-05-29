require 'spec_helper'

describe GeoHex::Decoder do

  def distance(zone, lat, lon)
    d_lat = (zone.lat-lat).abs * GeoHex::H_D2R / 2.0
    d_lon = (zone.lon-lon).abs * GeoHex::H_D2R / 2.0
    lat1  = zone.lat * GeoHex::H_D2R
    lat2  = lat * GeoHex::H_D2R
    a     = Math.sin(d_lat) * Math.sin(d_lon) +
            Math.sin(d_lon) ** 2 * Math.cos(lat1) * Math.cos(lat2)
    GeoHex::H_BASE * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
  end

  it "should decode strings" do
    described_class.decode("OY").should be_instance_of(GeoHex::Zone)
  end

  CSV.foreach(File.expand_path("../../cases.csv", __FILE__)) do |lat, lon, level, code|
    lat, lon, level = lat.to_f, lon.to_f, level.to_i

    it "should decode #{code} (level: #{level})" do
      zone = described_class.decode(code)
      zone.level.should == level
      distance(zone, lat, lon).should < GeoHex::Zone.size(level)
    end
  end

end
