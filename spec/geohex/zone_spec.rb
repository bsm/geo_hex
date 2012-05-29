require 'spec_helper'

describe GeoHex::Zone do

  describe "encoding" do

    it "should encode to GeoHex::Zone" do
      described_class.encode(0, 0, 0).should be_instance_of(described_class)
      described_class.encode(52.200432, 0.134328, 7)
    end

    CSV.foreach(File.expand_path("../cases.csv", __FILE__)) do |lat, lon, level, result|
      lat, lon, level = lat.to_f, lon.to_f, level.to_i

      it "should encode #{lat.round(3)}, #{lon.round(3)} with level #{level}" do
        described_class.encode(lat, lon, level).to_s.should == result
      end
    end

  end
end
