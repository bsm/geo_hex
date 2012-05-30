module GeoHex

  # Lat/Lon coordinates
  class LL < Struct.new(:lat, :lon)

    # Converts coordinates to Tile
    # @param [Integer] level the level
    # @return [GeoHex::Tile] the coordinates
    def to_tile(level)
      easting  = lon * H_RAD
      northing = Math.log(Math.tan((90 + lat) * H_D2R / 2)) / H_D2R * H_RAD
      Tile.normalize(easting, northing, level)
    end

  end

end