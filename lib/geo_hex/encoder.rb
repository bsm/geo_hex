module GeoHex

  # GeoHex Encoder
  # @see GeoHex::Encoder.encode
  module Encoder

    # @param [Float] lat the latitude
    # @param [Float] lon the longitude
    # @param [Integer] level the level
    # @return [GeoHex::Zone] the encoded zone
    def self.encode(lat, lon, level = 7)
      LL.new(lat, lon).to_tile(level).encode
    end

  end
end
