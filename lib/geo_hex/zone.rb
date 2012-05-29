module GeoHex

  # GeoHex Zone
  class Zone < String

    # @param [Integer] level
    # @return [Float] zone size for the given `level`
    def self.size(level)
      H_BASE / 3**(level+1)
    end

    attr_reader  :ll, :pos

    # @param [GeoHex::LL] ll lat/lon coordinates
    # @param [GeoHex::Position] pos X/Y position
    # @param [Integer] level the granularity level
    def initialize (ll, pos, code = nil)
      @ll, @pos = ll, pos
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

    # @return [Hash] attributes
    def to_hash
      { lat: lat, lon: lon, level: level }
    end

  end

end