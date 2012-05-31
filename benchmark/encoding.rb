require File.expand_path("../helper", __FILE__)

GeoHex::BM.new(100_000) do

  report "Level 0" do
    GeoHex.encode(51.539212, -0.141748, 0)
  end

  report "Level 7" do
    GeoHex.encode(51.539212, -0.141748, 7)
  end

  report "Level 12" do
    GeoHex.encode(51.539212, -0.141748, 12)
  end

end
