module GeoHex

  # Mercator projection
  class Projection < Struct.new(:easting, :northing)

    # @return [Float] longitude
    def lon
      @lon ||= LL.normalize(easting / H_BASE * 180.0)
    end

    # @return [Float] latitude
    def lat
      @lat ||= 180.0 / Math::PI * (2 * Math.atan(Math.exp(northing / H_BASE * 180.0 * H_D2R)) - Math::PI / 2.0)
    end

  end
end