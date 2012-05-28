require 'csv'
require 'rspec'
require 'geohex'

describe GeoHex::Zone do

  CSV.foreach(File.expand_path("../cases.csv", __FILE__)) do |lat, lon, level, result|
    lat, lon, level = lat.to_f, lon.to_f, level.to_i

    it "should encode location (#{lat.round(3)}, #{lon.round(3)}) with level #{level}" do
      described_class.encode(lat, lon, level).should == result
    end
  end

end
