module GeoHex

  # GeoHex Encoder
  # @see GeoHex::Encoder.encode
  module Encoder

    # @param [Float] lat the latitude
    # @param [Float] lon the longitude
    # @param [Integer] level the level
    # @return [GeoHex::Zone] the encoded zone
    def self.encode(lat, lon, level = 7)
      tile  = LL.new(lat, lon).to_tile(level)
      ll    = tile.to_ll # LL normalized to the tile

      if H_BASE - tile.easting < tile.unit.size
        ll.lon = 180
        tile.invert!
      end

      Zone.new ll, tile, tile.encode
    end

  end
end
