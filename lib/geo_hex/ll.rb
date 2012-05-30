module GeoHex

  # Lat/Lon coordinates
  class LL < Struct.new(:lat, :lon)

    # Converts coordinates to Tile
    # @param [Integer] level the level
    # @return [GeoHex::Tile] the coordinates
    def to_tile(level)
      easting  = lon * H_BASE / 180.0
      northing = Math.log(Math.tan((90 + lat) * H_D2R / 2)) / Math::PI * H_BASE
      Tile.normalize(easting, northing, level)
    end

  end

end