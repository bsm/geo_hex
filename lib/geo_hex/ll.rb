module GeoHex

  # Lat/Lon coordinates
  class LL

    # @return [Float] latitude
    def self.normalize(lon)
      if lon < -180
        lon += 360
      elsif lon > 180
        lon -= 360
      else
        lon
      end
    end

    attr_reader :lat, :lon

    # @param [Float] lat the latitude
    # @param [Float] lon the longitude
    def initialize(lat, lon)
      @lat, @lon = lat, self.class.normalize(lon)
    end

    # @return [Float] mercator easting
    def easting
      @easting ||= lon * H_BASE / 180.0
    end

    # @return [Float] mercator easting
    def northing
      @northing ||= Math.log(Math.tan((90 + lat) * H_D2R / 2)) / Math::PI * H_BASE
    end

    # Converts coordinates to Zone
    # @param [Integer] level the level
    # @return [GeoHex::Zone] the coordinates
    def to_zone(level)
      Zone.normalize(easting, northing, level)
    end

  end

end