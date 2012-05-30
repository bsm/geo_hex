module GeoHex

  # GeoHex Zone, similar Tile, but additionally contains:
  #  * Full lat/long coordinate information
  #  * GeoHex code
  class Zone < String

    attr_reader  :ll, :tile

    # @param [GeoHex::LL] ll the lat/lon coordinates
    # @param [GeoHex::Tile] tile the tile
    # @param [String] code the GeoHex code
    def initialize (ll, tile, code = nil)
      @ll, @tile = ll, tile
      super(code)
    end

    # @return [Integer] level
    def level
      @level ||= size - 2
    end

    # @return [Float] latitude
    def lat
      ll.lat
    end

    # @return [Float] longitude
    def lon
      ll.lon
    end

    # @return [Integer] X tile position
    def x
      tile.x
    end

    # @return [Integer] Y tile position
    def y
      tile.y
    end

    # @return [Hash] attributes
    def to_hash
      { lat: lat, lon: lon, x: x, y: y, level: level }
    end

  end

end